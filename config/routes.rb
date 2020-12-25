Epayment::Engine.routes.draw do
  # generate: GET  /payment_gateway/:action(.:format) epayment/payment_gateway#:action
  # eg. 'payment_gateway/wechat_pay', controller: '/epayment/payment_gateway#wechat_pay'
  get 'payment_gateway/:action', controller: '/epayment/payment_gateway'

  # call wx union pay action
  post 'wx_pay', to: '/epayment/payment#wx_pay'
  
  # wx pay callback
  post 'wx_notify', to: '/epayment/payment_callback#wx_notify'
end
