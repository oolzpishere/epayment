Epayment::Engine.routes.draw do
  # generate: GET  /payment_gateway/:action(.:format) epayment/payment_gateway#:action
  # eg. 'payment_gateway/wechat_pay', controller: '/epayment/payment_gateway#wechat_pay'
  get '/payment_gateway/wechat_pay', to: '/epayment/payment_gateway#wechat_pay'
  post '/payment_gateway/update_wechat_pay', to: '/epayment/payment_gateway#update_wechat_pay'
  # call wx union pay action
  post 'wechat_pay', to: '/epayment/payment#wechat_pay'

  # wx pay callback
  post 'wx_notify', to: '/epayment/payment_callback#wx_notify'
end
