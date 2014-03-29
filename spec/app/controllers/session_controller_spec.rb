require 'spec_helper'

describe "SessionController" do
  describe "/login" do
    context "with valid key" do
      before(:each) do
        Wanikani.should_receive(:valid_api_key?).and_return(true)
        post '/login', wanikani_api_key: "valid-api-key"
      end

      it "sets session[:wanikani_api_key] with the specified key" do
        pending
      end

      it "redirects to /export " do
        last_response.should be_redirect
        last_response.location.should == "http://example.org/export"
      end
    end

    context "with invalid key" do
      before(:each) do
        Wanikani.should_receive(:valid_api_key?).and_return(false)
        post '/login', wanikani_api_key: "invalid-api-key"
      end

      it "redirects to the home page" do
        last_response.should be_redirect
        last_response.location.should == "http://example.org/"
      end
    end
  end

  describe '/logout' do
    before(:each) do
      delete '/logout'
    end

    it "deletes the API key from the session" do
      pending
    end

    it "redirects to the home page" do
      last_response.should be_redirect
      last_response.location.should == "http://example.org/"
    end
  end
end
