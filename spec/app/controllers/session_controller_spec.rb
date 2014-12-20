require 'spec_helper'

describe "SessionController" do
  describe "/login" do
    context "with invalid string" do
      it "redirects to the home page if the string is invalid" do
        post '/login', wanikani_api_key: "this key is invalid because it has spaces"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("http://example.org/")
      end
    end

    context "with valid key" do
      before(:each) do
        expect(Wanikani).to receive(:valid_api_key?).and_return(true)
        post '/login', wanikani_api_key: "valid-api-key"
      end

      it "sets session[:wanikani_api_key] with the specified key" do
        decoded_session = decode_session_cookie(last_response.header["Set-Cookie"])
        expect(decoded_session["wanikani_api_key"]).to eq("valid-api-key")
      end

      it "redirects to /export " do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("http://example.org/export")
      end
    end

    context "with invalid key" do
      before(:each) do
        expect(Wanikani).to receive(:valid_api_key?).and_return(false)
        post '/login', wanikani_api_key: "invalid-api-key"
      end

      it "redirects to the home page" do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("http://example.org/")
      end
    end
  end

  describe '/logout' do
    before(:each) do
      delete '/logout'
    end

    it "deletes the API key from the session" do
      decoded_session = decode_session_cookie(last_response.header["Set-Cookie"])
      expect(decoded_session).not_to have_key("wanikani_api_key")
    end

    it "redirects to the home page" do
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://example.org/")
    end
  end
end
