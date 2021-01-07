require_dependency "epayment/application_controller"
# common handling.
module Epayment
  class PaymentController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:wechat_pay_unifiedorder]

    def wechat_pay_unifiedorder
      form_params = {
        openid: params['openid'],
        total_fee: params['total_fee'],
        out_trade_no: params['out_trade_no'],
        body: params['payment_body']
      }
      pay_params = {
        # total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: Epayment.wechat_pay_notify_url,
        trade_type: 'JSAPI',
        # openid: current_identify.uid
      }.merge(form_params)

      prepay_result = WxPay::Service.invoke_unifiedorder(pay_params)
      if prepay_result.success?
        js_pay_params = {
          prepayid: prepay_result['prepay_id'],
          noncestr: prepay_result['nonce_str']
        }
        pay_params = WxPay::Service.generate_js_pay_req js_pay_params

        logger.info pay_params
        render json: pay_params
      else
        logger.error prepay_result['return_msg']
        render json: prepay_result
      end
    end



  end
end
