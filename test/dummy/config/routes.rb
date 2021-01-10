Rails.application.routes.draw do
  # mount Epayment::Engine => "/epayment"
  get "set_fake_wechat_base_session", to: "test_wechat_base#set_fake_wechat_base_session"
  get "set_fake_products", to: "test_stub#set_fake_products"
  get "set_after_payment_redirection_path", to: "test_stub#set_after_payment_redirection_path"

  mount Epayment::Engine   => '/', as: 'epayment'
  # mount Account::Engine   => '/', as: 'account'


end
