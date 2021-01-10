require "application_system_test_case"

class PaymentGatewayTest < ApplicationSystemTestCase
  def setup

  end

  test "visit payment_gateway" do

    visit "/payment_gateway/wechat_pay"
    #
    # fill_in 'phone', with: @user.phone
    #
    # click_link '发送验证码'
    # # countDown test
    # assert_content '再次发送验证码'
    # assert find('#send_verification_code', class: 'disabled')
    #
    # using_wait_time 5 do
    #   fill_in 'verification_code', with: @fake_verification_code
    # end
    # click_button '登录'
    #


    # assert_current_path
    # assert_content '用户登录成功'
    # assert_content @user.phone
  end


end
