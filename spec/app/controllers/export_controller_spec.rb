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
    let(:empty_deck) { double(generate_deck: nil) }
    let(:populated_deck) { double(generate_deck: "了; りょう - finish, complete, end") }

    it "creates a new instance of AnkiDeck with the deck_type parameters and percentage" do
      AnkiDeck.should_receive(:new).with("critical", "50").and_return(empty_deck)
      post "/export/generate", deck_type: "critical", percentage: 50
    end

    it "calls AnkiDeck#generate_deck with the created AnkiDeck object" do
      AnkiDeck.stub(:new).and_return(empty_deck)
      empty_deck.should_receive(:generate_deck)
      post "/export/generate", deck_type: "critical"
    end

    it "redirects to /export if the deck is nil" do
      AnkiDeck.stub(:new).and_return(empty_deck)
      post "/export/generate", deck_type: "critical"
      last_response.should be_redirect
      last_response.location.should == "http://example.org/export"
    end

    it "prepares a plain text file ready to download" do
      AnkiDeck.stub(:new).and_return(populated_deck)
      post "/export/generate", deck_type: "critical"
      last_response["Content-Type"].should == "text/plain;charset=utf-8"
    end
  end
end
