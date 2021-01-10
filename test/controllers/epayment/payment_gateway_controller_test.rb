require 'test_helper'

module Epayment
  class PaymentGatewayControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    def setup
      # test instance:
      @openid="fake_openid"
      @total_fee="1"
      @out_trade_no="fake_out_trade_no"
    end

    test "when don't have openid redirect to get_openid" do
      get '/payment_gateway/wechat_pay'
      get_openid_path = "/auth/wechat?scope=snsapi_base&origin=#{CGI::escape(request.original_url)}"
      assert_redirected_to get_openid_path
    end

    test "when getted openid and necessary params show" do
      # set openid stub
      get "/set_fake_wechat_base_session"

      get "/payment_gateway/wechat_pay?total_fee=#{@total_fee}&out_trade_no=#{@out_trade_no}"

      assert_equal(@openid, @controller.instance_variable_get("@openid") )
      assert_equal(@total_fee, @controller.instance_variable_get("@total_fee") )
      assert_equal(@out_trade_no, @controller.instance_variable_get("@out_trade_no") )
      
    end

  end
end
