require 'spec_helper'

describe "ExportController" do
  describe "/export" do
    let(:api_key_session) { { "rack.session" => { wanikani_api_key: "valid-api-key" } } }

    before(:each) do
      allow(Wanikani::User).to receive(:information).and_return({ "username" => "dennmart" })
    end

    it "redirects to the home page if the session key is not set" do
      get '/export', {}, { "rack.session" => {} }
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://example.org/")
    end

    it "sets the Wanikani.api_key from the session" do
      get '/export', {}, api_key_session
      expect(Wanikani.api_key).to eq("valid-api-key")
    end
  end

  describe "/export/generate" do
    it "calls WanikaniApi.fetch_* using the deck type and params" do
      params = { "deck_type" => "critical", "argument" => "85" }
      expect(WanikaniApi).to receive(:send).with("fetch_critical", params)
      post "/export/generate", params
    end

    it "redirects to /export if the deck is nil" do
      allow(WanikaniApi).to receive(:send).and_return([])
      post "/export/generate", deck_type: "critical"
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://example.org/export")
    end

    it "prepares a plain text file ready to download" do
      allow(WanikaniApi).to receive(:send).and_return(
        [
          {
            "type" => "radical",
            "character" => "久",
            "meaning" => "raptor-cage",
            "image" => nil,
            "level" => 3,
            "percentage" => "79"
          },
          {
            "type" => "vocabulary",
            "character" => "入る",
            "kana" => "はいる",
            "meaning" => "to enter",
            "level" => 1,
            "percentage" => "85"
          },
          {
            "type" => "kanji",
            "character" => "九",
            "meaning" => "nine",
            "onyomi" => "く, きゅう",
            "kunyomi" => "ここの.*",
            "important_reading" => "onyomi",
            "level" => 1,
            "percentage" => "87"
          }
        ]
      )
      post "/export/generate", deck_type: "critical"
      expect(last_response["Content-Type"]).to eq("text/plain;charset=utf-8")
    end
  end
end
