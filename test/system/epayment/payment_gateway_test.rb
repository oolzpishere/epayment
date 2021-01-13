require "application_system_test_case"

class PaymentGatewayTest < ApplicationSystemTestCase
  def setup
    # test instance:
    @openid = "fake_openid"
    @total_fee = "2"
    @out_trade_no = "fake_out_trade_no"
    @payment_products = [{name: "product_name", single_price: 2, num: 1}].map {|h| h.transform_keys(&:to_s)}

    @invoke_pay_url="/payment_gateway/wechat_pay?total_fee=#{@total_fee}&out_trade_no=#{@out_trade_no}"
  end

  teardown do
    Capybara.reset_sessions!
    # Capybara.use_default_driver
  end

  test "visit payment_gateway" do
    # WebMock.allow_net_connect!
    # set fake openid and products
    visit "/set_fake_wechat_base_session"
    visit "/set_fake_products"

    visit @invoke_pay_url

    # host_and_port = current_url.match(/#{current_host}:\d+/)[0]
    # stub = stub_request(:post, "#{host_and_port}/wechat_pay_unifiedorder")

    click_button "pay button"
    wait_for_ajax

    assert_content 'product_name'
    assert_content "￥0.02 x 1"
    assert_content "应付:￥0.02"
    assert_content "invoke wechat pay unifiedorder and generate package fail."
  end



end
