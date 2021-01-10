Rails.application.routes.draw do
  # mount Epayment::Engine => "/epayment"
  get "set_fake_wechat_base_session", to: "test_wechat_base#set_fake_wechat_base_session"

  mount Epayment::Engine   => '/', as: 'epayment'
  # mount Account::Engine   => '/', as: 'account'


end
