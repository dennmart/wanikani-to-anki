require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/array/extract_options'

module Wkanki
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Helpers
    register Padrino::Cache
    register SassInitializer
    enable :sessions
    enable :caching

    set :protect_from_csrf, false

    configure :production do
      set :cache, Padrino::Cache.new(:Memcached, backend: Dalli::Client.new(ENV['MEMCACHED_URL']))

      Airbrake.configure do |config|
        config.project_key         = ENV['WKANKI_AIRBRAKE_API'] || 'airbrake-api-key'
        config.project_id          = ENV['WKANKI_AIRBRAKE_PROJECT_ID'] || 'airbrake-project-id'
        config.host                = ENV['WKANKI_AIRBRAKE_HOST'] || 'https://test.airbrake.io/'
        config.environment         = ENV['RACK_ENV'] || 'development'
        config.ignore_environments = %w(development test)
      end

      Airbrake.add_filter do |notice|
        if notice[:errors].any? { |error| error[:type] == 'Sinatra::NotFound' }
          notice.ignore!
        end
      end

      use Airbrake::Rack::Middleware
    end
    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 505 do
    #     render 'errors/505'
    #   end
    #
  end
end
