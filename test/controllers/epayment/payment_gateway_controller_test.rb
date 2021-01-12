require 'test_helper'

module Epayment
  class PaymentGatewayControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def setup
      # test instance:
      @openid = "fake_openid"
      @total_fee = "2"
      @out_trade_no = "fake_out_trade_no"
      @payment_products = [{name: "product_name", single_price: 2, num: 1}].map {|h| h.transform_keys(&:to_s)}

      @invoke_pay_url="/payment_gateway/wechat_pay?total_fee=#{@total_fee}&out_trade_no=#{@out_trade_no}"
    end

    test "when don't have openid redirect to get_openid" do
      get @invoke_pay_url
      get_openid_path = "/auth/wechat?scope=snsapi_base&origin=#{CGI::escape(request.original_url)}"
      assert_redirected_to get_openid_path
    end

    test "when getted openid and necessary params show" do
      # set fake openid and products
      get "/set_fake_wechat_base_session"
      get "/set_fake_products"
      get @invoke_pay_url

      assert_equal(@openid, @controller.instance_variable_get("@openid") )
      assert_equal(@total_fee, @controller.instance_variable_get("@total_fee") )
      assert_equal(@out_trade_no, @controller.instance_variable_get("@out_trade_no") )
      assert_equal(@payment_products, @controller.instance_variable_get("@payment_products") )

      assert_response :success
    end

    test "post update_wechat_pay redirection correct" do
      get "/set_after_payment_redirection_path"
      post '/payment_gateway/update_wechat_pay'
      assert_redirected_to "/after_payment_redirection_path"
    end

  end
end
