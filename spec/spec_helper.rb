RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require File.dirname(__FILE__) + "/../app/helpers/wanikani_api"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
#   app Wkanki::App
#   app Wkanki::App.tap { |a| }
#   app(Wkanki::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end

# Decodes the Rack session from the response's cookie. This will
# allow us to get session information in our tests.
def decode_session_cookie(cookie)
  encoded_cookie_str = cookie.match(/rack\.session=(\S*);/)[1]
  data = Rack::Utils.unescape(encoded_cookie_str).unpack("m*").first
  Marshal.load(data)
end
