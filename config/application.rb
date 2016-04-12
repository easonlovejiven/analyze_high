require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Qdaily4Analytic
  class Application < Rails::Application
    
    # 时区
    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    config.active_record.raise_in_transactional_callbacks = true
    config.paths['app/views'].unshift("#{Rails.root}/app/assets/client")
  end
end
