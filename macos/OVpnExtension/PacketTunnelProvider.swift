//
//  PacketTunnelProvider.swift
//  VPNExtension
//

import NetworkExtension
import OpenVPNAdapter
import os.log

extension NEPacketTunnelFlow: OpenVPNAdapterPacketFlow {}

class PacketTunnelProvider: NEPacketTunnelProvider {

    static let vpnLog = OSLog(subsystem: "com.mysteriumvpn.VPNMExtension", category: "VPN")
    
    lazy var vpnAdapter: OpenVPNAdapter = {
        let adapter = OpenVPNAdapter()
        adapter.delegate = self
        return adapter
    }()
    
    let vpnReachability = OpenVPNReachability()
    var providerManager: NETunnelProviderManager!
    
    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?
    
    static var connectionIndex = 0
    static var timeOutEnabled = true
    
    func loadProviderManager(completion:@escaping (_ error: Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if let error = error {
                os_log("[VPN] Failed to load provider manager: %@", log: PacketTunnelProvider.vpnLog, type: .error, "\(error)")
                completion(error)
                return
            }
            self.providerManager = managers?.first ?? NETunnelProviderManager()
            os_log("[VPN] Loaded provider manager successfully", log: PacketTunnelProvider.vpnLog, type: .info)
            completion(nil)
        }
    }
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("[VPN] startTunnel called", log: PacketTunnelProvider.vpnLog, type: .debug)
        
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration,
            let ovpnFileContent = providerConfiguration["config"] as? Data
        else {
            fatalError("Invalid provider configuration")
        }
        
        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
        configuration.tunPersist = false
        
        // Apply OpenVPN configuration
        do {
            let evaluation = try vpnAdapter.apply(configuration: configuration)
            os_log("[VPN] Applied OpenVPN configuration. autologin=%@", log: PacketTunnelProvider.vpnLog, type: .info, "\(evaluation.autologin)")
        } catch {
            os_log("[VPN] Failed to apply OpenVPN configuration: %@", log: PacketTunnelProvider.vpnLog, type: .error, error.localizedDescription)
            completionHandler(error)
            return
        }
        
        // Start reachability tracking
        let log = PacketTunnelProvider.vpnLog
        vpnReachability.startTracking { [weak self] status in
            guard status == .reachableViaWiFi else { return }
            os_log("[VPN] WiFi reachable, reconnecting VPN in 5s...", log: log, type: .info)
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }
        
        startHandler = completionHandler
        vpnAdapter.connect(using: packetFlow)
        os_log("[VPN] OpenVPNAdapter connecting...", log: PacketTunnelProvider.vpnLog, type: .info)
    }
    
    @objc func stopVPN() {
        os_log("[VPN] stopVPN called", log: PacketTunnelProvider.vpnLog, type: .info)
        loadProviderManager { (err: Error?) in
            if err == nil {
                self.providerManager.connection.stopVPNTunnel()
            }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("[VPN] stopTunnel called with reason: %d", log: PacketTunnelProvider.vpnLog, type: .info, reason.rawValue)
        stopHandler = completionHandler
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        vpnAdapter.disconnect()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        if String(data: messageData, encoding: .utf8) == "OPENVPN_STATS" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let statsString =
                "\(UserDefaults.standard.string(forKey: "connected_on") ?? "")_" +
                "\(vpnAdapter.interfaceStatistics.packetsIn)_" +
                "\(vpnAdapter.interfaceStatistics.packetsOut)_" +
                "\(vpnAdapter.interfaceStatistics.bytesIn)_" +
                "\(vpnAdapter.interfaceStatistics.bytesOut)"
            
            os_log("[VPN] Updating connection stats: %@", log: PacketTunnelProvider.vpnLog, type: .info, statsString)
            UserDefaults.standard.setValue(statsString, forKey: "connectionUpdate")
        }
    }
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter,
                        configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?,
                        completionHandler: @escaping (Error?) -> Void) {
        os_log("[VPN] Configuring tunnel network settings", log: PacketTunnelProvider.vpnLog, type: .info)
        networkSettings?.dnsSettings?.matchDomains = [""]
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
    }
    
    func _updateEvent(_ event: OpenVPNAdapterEvent, openVPNAdapter: OpenVPNAdapter) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var stage = ""
        
        os_log("[VPN] Event received: %@", log: PacketTunnelProvider.vpnLog, type: .info, "\(event)")
        
        switch event {
        case .connected:
            stage = "CONNECTED"
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "connected_on")
        case .disconnected:
            stage = "DISCONNECTED"
        case .connecting:
            stage = "CONNECTING"
        case .reconnecting:
            stage = "RECONNECTING"
        case .info:
            stage = "CONNECTED"
        default:
            UserDefaults.standard.removeObject(forKey: "connected_on")
            stage = "INVALID"
        }
        
        UserDefaults.standard.setValue(stage, forKey: "vpnStage")
        os_log("[VPN] VPN stage updated: %@", log: PacketTunnelProvider.vpnLog, type: .info, stage)
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        PacketTunnelProvider.timeOutEnabled = true
        _updateEvent(event, openVPNAdapter: openVPNAdapter)
        
        if let message = message {
            os_log("[VPN] Event message: %@", log: PacketTunnelProvider.vpnLog, type: .info, message)
        }
        
        switch event {
        case .connected:
            PacketTunnelProvider.timeOutEnabled = false
            if reasserting { reasserting = false }
            os_log("[VPN] VPN connected successfully", log: PacketTunnelProvider.vpnLog, type: .info)
            startHandler?(nil)
            startHandler = nil
        case .disconnected:
            PacketTunnelProvider.timeOutEnabled = false
            if vpnReachability.isTracking { vpnReachability.stopTracking() }
            os_log("[VPN] VPN disconnected", log: PacketTunnelProvider.vpnLog, type: .info)
            stopHandler?()
            stopHandler = nil
        case .reconnecting:
            reasserting = true
            os_log("[VPN] VPN reconnecting...", log: PacketTunnelProvider.vpnLog, type: .info)
        default:
            break
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        os_log("[VPN] OpenVPNAdapter error: %@", log: PacketTunnelProvider.vpnLog, type: .error, "\(error)")
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal else {
            return
        }
        if vpnReachability.isTracking { vpnReachability.stopTracking() }
        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        os_log("[VPN] OpenVPN log: %@", log: PacketTunnelProvider.vpnLog, type: .info, logMessage)
    }
}
