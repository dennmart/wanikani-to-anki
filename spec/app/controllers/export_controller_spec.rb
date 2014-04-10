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

  describe "/export/generate" do
    it "calls WanikaniApi.fetch_* using the deck type and argument" do
      WanikaniApi.should_receive(:send).with("fetch_critical", "85")
      post "/export/generate", deck_type: "critical", argument: "85"
    end

    it "redirects to /export if the deck is nil" do
      WanikaniApi.stub(:send).and_return([])
      post "/export/generate", deck_type: "critical"
      last_response.should be_redirect
      last_response.location.should == "http://example.org/export"
    end

    it "prepares a plain text file ready to download" do
      WanikaniApi.stub(:send).and_return([{ "了" => "りょう - finish, complete, end" }])
      post "/export/generate", deck_type: "critical"
      last_response["Content-Type"].should == "text/plain;charset=utf-8"
    end
  end
end
