
class TestWechatBaseController < ApplicationController

  def set_fake_wechat_base_session
    session['wechat_snsapi_base_raw_info'] = {"openid" => "fake_openid"}
    render :plain => "", :status => 200
  end

end
