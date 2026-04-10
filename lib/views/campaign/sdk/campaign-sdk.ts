export interface InitOptions {
  debug?: boolean
}

interface Message {
  type: string
  payload?: Payload
}

type Payload = SubscribePayload

interface SubscribePayload {
  planId: string
  couponCode: string
}

export default class CampaignSDK {
  private options: InitOptions

  constructor(options: InitOptions) {
    this.options = options
    this.log("initialized", options)
  }

  isApplication() {
    return !!window.CampaignBridge
  }

  subscribe(payload: SubscribePayload) {
    this.send({ type: "subscribe", payload: payload })
  }

  subscriptionUpgrade() {
    this.send({ type: "subscription_upgrade" })
  }

  private send(message : Message) {
    if (!this.isApplication()) {
      this.log("can't send message to application", message)
      return
    }

    this.log("sending message", message)
    window.CampaignBridge?.postMessage(JSON.stringify(message))
  }

  private log(...data: any[]){
    if (!this.options.debug) {
      return
    }

    console.log("[CampaignSDK]",  ...data)
  }
}

declare global {
  interface Window {
    CampaignBridge?: MessagePort
  }
}
