require_dependency "epayment/application_controller"

# common action.
module Epayment
  class PaymentGatewayController < ApplicationController
    before_action :init_params

    def wechat_pay
      unless (raw_info = session.delete('wechat_snsapi_base_raw_info'))
        get_openid
        return
      end
      # make session
      openid = raw_info["openid"] if raw_info["openid"]
      unionid = raw_info["unionid"] if raw_info["unionid"]
      @total_fee = params[:total_fee]
      @out_trade_no = params[:out_trade_no]
      # click pay button
      @payment_products = get_payment_products

      unless check_total_fee(@total_fee, @payment_products)
        raise "生成支付页面失败，请联系管理员处理"
      end
    end

    def update_wechat_pay
      total_fee = wechat_pay_params["total_fee"]
      out_trade_no = wechat_pay_params["out_trade_no"]
      # wx_payment = Admin::WxPayment.find_by(out_trade_no: out_trade_no)
      # wx_payment.total_fee = total_fee
      # wx_payment.save

      # redirection path set by other Apps before pay.
      redirect_to get_after_payment_path
    end

    private
    def wechat_pay_params
      params.fetch(:wechat_pay, {}).permit( :total_fee, :out_trade_no )
    end

    def init_params

    end

    def get_openid
      if omniauth_strategies_wechat_set?
        # add_wechat_oauth_base_job_stack
          # session["wechat_oauth_base.job_stack"] = [{after_callback_phase: true, redirect_uri: current_url}]
        session["after_wechat_base_callback_url"] = request.original_url
        redirect_to "/auth/wechat?scope=snsapi_base"
      end
    end

    def omniauth_strategies_wechat_set?
      OmniAuth::Strategies::Wechat rescue false
      # https://stackoverflow.com/a/5758492/6256690
      # Remember in Rails, there is auto-loading in development mode, so it can be tricky when you are testing it out:
      # Object.const_defined? 'OmniAuth::Strategies::Wechat'
    end

    def get_payment_products
      session.delete("epayment.products")
    end

    def check_total_fee(total_fee, products)
      total_count = 0
      total_fee = total_fee.to_i
      products.each do |product|
        price = product["single_price"].to_i
        num = product["num"].to_i
        total_count += (price * num)
      end
      total_fee == total_count
    end

    def get_after_payment_path
      # redirection path set by other Apps before pay.
      session.delete("epayment.after_payment_redirection_path")  || "/"
    end

  end
end
