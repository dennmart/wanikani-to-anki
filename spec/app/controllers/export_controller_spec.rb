require 'spec_helper'

describe "ExportController" do
  describe "/export" do
    let(:api_key_session) { { "rack.session" => { wanikani_api_key: "valid-api-key" } } }

    before(:each) do
      Wanikani::User.stub(:information).and_return({ "username" => "dennmart" })
    end

    it "redirects to the home page if the session key is not set" do
      get '/export', {}, { "rack.session" => {} }
      last_response.should be_redirect
      last_response.location.should == "http://example.org/"
    end

    it "sets the Wanikani.api_key from the session" do
      get '/export', {}, api_key_session
      Wanikani.api_key.should == "valid-api-key"
    end
  end
end
