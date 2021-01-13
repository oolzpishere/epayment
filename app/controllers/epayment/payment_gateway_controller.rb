# require_dependency "epayment/application_controller"

# common action.
module Epayment
  class PaymentGatewayController < Epayment::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:update_wechat_pay]

    def wechat_pay
      # check whether have openid
      # first time redirect_to get openid and redirect back.
      # when have openid, then continue.
      unless ( raw_info = session.delete('wechat_snsapi_base_raw_info') )
        get_openid
        return
      end

      set_necessary_params(raw_info, params)
      check_total_fee(@total_fee, @payment_products)
    end

    def update_wechat_pay
      total_fee = wechat_pay_params["total_fee"]
      out_trade_no = wechat_pay_params["out_trade_no"]

      # redirection path set by other Apps before pay.
      redirect_to get_after_payment_path
    end

    private
    def wechat_pay_params
      params.fetch(:wechat_pay, {}).permit( :total_fee, :out_trade_no )
    end


    def get_openid
      if omniauth_strategies_wechat_set?
        # add_wechat_oauth_base_job_stack
          # session["wechat_oauth_base.job_stack"] = [{after_callback_phase: true, redirect_uri: current_url}]
        # session["after_wechat_base_callback_url"] = request.original_url
        redirect_to "/auth/wechat?scope=snsapi_base&origin=#{CGI::escape(request.original_url)}"
      end
    end

    def omniauth_strategies_wechat_set?
      OmniAuth::Strategies::Wechat rescue false
      # https://stackoverflow.com/a/5758492/6256690
      # Remember in Rails, there is auto-loading in development mode, so it can be tricky when you are testing it out:
      # Object.const_defined? 'OmniAuth::Strategies::Wechat'
    end



    def check_total_fee(total_fee, products)
      total_count = 0
      total_fee = total_fee.to_i
      products.each do |product|
        price = product["single_price"].fee
        num = product["num"].to_i
        total_count += (price * num)
      end

      unless total_fee == total_count
        raise "total_fee not equal total_count, 生成支付页面失败"
      end
    end

    def get_after_payment_path
      # redirection path set by other Apps before pay.
      session.delete("epayment.after_payment_redirection_path")  || "/"
    end

    def set_necessary_params(raw_info, params)
      if raw_info["openid"] || raw_info["unionid"]
        @openid = raw_info["openid"] if raw_info["openid"]
        @unionid = raw_info["unionid"] if raw_info["unionid"]
      end
      @total_fee = params[:total_fee]
      @money = ::Epayment::Money.new(@total_fee)
      @out_trade_no = params[:out_trade_no]
      @payment_products = get_payment_products
      @payment_products = add_money_to_products(@payment_products)

      unless @openid && @total_fee && @out_trade_no && @payment_products
        raise("@openid && @total_fee && @out_trade_no, at least one of necessary params not pass to action.")
      end
      @payment_body = params[:payment_body] || 'Test Wechat Pay'
    end

    def get_payment_products
      session.delete("epayment.products")
    end

    def add_money_to_products(products)
      products.map { |hash| hash["single_price"] = ::Epayment::Money.new(hash["single_price"]) }
      products
    end

  end
end
