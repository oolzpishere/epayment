require_dependency "epayment/application_controller"

module Epayment
  class PaymentController < ApplicationController
    before_action :get_openid, only: [:wechat_pay]

    attr_accessor :org_authorize_scope

    def wechat_pay
      current_identify = Account::Identify.find_by(user: current_user, provider: 'wechat')

      form_params = {
        total_fee: params['total_fee']
      }
      pay_params = {
        body: 'Test Wechat Pay',
        out_trade_no: "hotel-order-#{Time.now.to_i}",
        # total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: 'http://qyjiudian-customer.sflx.com.cn/wx_notify',
        trade_type: 'JSAPI',
        openid: current_identify.uid
      }.merge(form_params)

      payment = Pay::Payment.create
      create_wx_payment(payment, pay_params)

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
        # add payment_id to return.
        pay_params.merge!({payment_id: payment.id})

        logger.info pay_params
        render json: pay_params
      else
        logger.error prepay_result['return_msg']
        render json: prepay_result
      end
    end

    private

    def create_wx_payment(payment, pay_params)
      wx_payment_params = pay_params.slice(:out_trade_no, :total_fee)
      wx_payment_params.merge!(payment_id: payment.id)
      Pay::WxPayment.create(wx_payment_params)
    end

    def get_openid

    end

    def set_authorize_scope_to_base
      if OmniAuth::Strategies::Wechat.default_options.authorize_params.scope
        save_org_authorize_scope
        OmniAuth::Strategies::Wechat.default_options.authorize_params.scope = "snsapi_base"
      end
    end

    def save_org_authorize_scope
      if org_scope = OmniAuth::Strategies::Wechat.default_options.authorize_params.scope
        org_authorize_scope = org_scope
      end
    end

    def restore_org_authorize_scope
      if OmniAuth::Strategies::Wechat.default_options.authorize_params.scope
        OmniAuth::Strategies::Wechat.default_options.authorize_params.scope = org_authorize_scope
      end
    end

    def omniauth_wechat_oauth2_set?
      OmniAuth::Strategies::Wechat rescue false
      # https://stackoverflow.com/a/5758492/6256690
      # Remember in Rails, there is auto-loading in development mode, so it can be tricky when you are testing it out:
      # Object.const_defined? 'OmniAuth::Strategies::Wechat'
    end

  end
end
