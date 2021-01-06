require_dependency "epayment/application_controller"

module Epayment
  class PaymentController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:wechat_pay]

    # before_action :get_openid, only: [:wechat_pay]

    def wechat_pay
      form_params = {
        openid: params['openid'],
        total_fee: params['total_fee'],
        out_trade_no: params['out_trade_no'],
        body: params['payment_body']
      }
      pay_params = {
        # total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: 'http://qyjiudian-customer.sflx.com.cn/wx_notify',
        trade_type: 'JSAPI',
        # openid: current_identify.uid
      }.merge(form_params)

      # payment = Pay::Payment.create
      # create_wx_payment(payment, pay_params)

      # result, result_hash = Admin::Prepay.new().invoke_unifiedorder(pay_params)
      # if result
      #   # add payment_id to return.
      #   result_hash.merge!({payment_id: payment.id})
      #   render json: result_hash
      # else
      #   render json: result_hash
      # end

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

    private

    # def create_wx_payment(payment, pay_params)
    #   wx_payment_params = pay_params.slice(:out_trade_no, :total_fee)
    #   wx_payment_params.merge!(payment_id: payment.id)
    #   Pay::WxPayment.create(wx_payment_params)
    # end



  end
end
