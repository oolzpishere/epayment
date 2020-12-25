# required
WxPay.appid = ENV["SFLX_APPID"]
WxPay.key = ENV["SFLX_WX_PAY_SE"]
WxPay.mch_id = ENV["SFLX_MCH_ID"].to_s # required type is String, otherwise there will be cases where JS_PAY can pay but the APP cannot pay
WxPay.debug_mode = true # default is `true`
WxPay.sandbox_mode = false # default is `false`

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12
# WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pass)

# if you want to use `generate_authorize_req` and `authenticate`
# WxPay.appsecret = 'YOUR_SECRET'

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}
