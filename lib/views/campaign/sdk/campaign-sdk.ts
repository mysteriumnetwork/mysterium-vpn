export interface InitOptions {
  debug?: boolean
}

interface Message<T=Payload> {
  type: string
  requestId?: string
  payload?: T
}

type Payload = SubscribePayload | OrderSummaryRequest

interface OrderSummaryRequest {
  planId: string
  country: string
  state?: string
  couponCode?: string
}

interface OrderSummaryResponse {
  orderTotal: number
  couponError: string
}

interface SubscribePayload {
  planId: string
  couponCode: string
}

export default class CampaignSDK {
  private options: InitOptions
  private requestQueue: Map<string, (message: Message) => void> = new Map()

  constructor(options: InitOptions) {
    this.options = options

    // Register global handler for Flutter → JS responses
    if (this.isApplication()) {
      window.onCampaignBridgeMessage = this.receive.bind(this)
    }

    this.log("initialized", options)
  }

  isApplication() {
    return !!window.CampaignBridge
  }

  async orderSummary(payload: OrderSummaryRequest) {
    return this.request<OrderSummaryResponse>({ type: "order_summary", payload: payload })
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

  private request<T>(request: Message): Promise<Message<T>> {
    const requestId = this.generateRequestId()

    request.requestId = requestId
    this.send(request)

    return new Promise<Message<T>>((resolve, reject) => {
      const timeout = setTimeout(() => {
        this.requestQueue.delete(requestId)

        reject(new Error("Request timed out"))
      }, 10_000)

      this.requestQueue.set(requestId, (response) => {
        clearTimeout(timeout)

        resolve(response as Message<T>)
      })
    })
  }

  private generateRequestId() {
    return Math.random().toString(36).slice(2)
  }

  private receive(message : Message) {
    try {
      this.log("received message", message)

      if (!message.requestId) return

      const resolver = this.requestQueue.get(message.requestId)
      if (resolver) {
        resolver(message)
        this.requestQueue.delete(message.requestId)
      }
    } catch (err) {
      this.log("failed to receive message", err)
    }
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
    onCampaignBridgeMessage?: (msg: any) => void
  }
}
