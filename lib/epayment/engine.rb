module Epayment
  class Engine < ::Rails::Engine
    isolate_namespace Epayment

    initializer 'epayment.asset_precompile_paths' do |app|
      # app.config.assets.precompile += ["shared/manifests/*"]
      app.config.assets.precompile += %w( account/application.js account/application.scss )
    end

    # initializer 'epayment.assets' do |app|
    #   %w(stylesheets javascripts).each do |sub|
    #     app.config.assets.paths << root.join('assets', sub).to_s
    #   end
    # end

  end
end
