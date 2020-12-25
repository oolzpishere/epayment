module Epayment
  class Engine < ::Rails::Engine
    isolate_namespace Epayment

    initializer 'epayment.assets' do |app|
      %w(stylesheets javascripts).each do |sub|
        app.config.assets.paths << root.join('assets', sub).to_s
      end
    end

  end
end
