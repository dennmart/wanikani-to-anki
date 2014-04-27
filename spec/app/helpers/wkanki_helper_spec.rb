require 'spec_helper'

describe WkankiHelper do
  subject do
    Class.new { include WkankiHelper }.new
  end

  describe '#set_api_key' do
    before(:each) do
      Wanikani.api_key = nil
    end

    it 'sets Wanikani.api_key' do
      expect {
        subject.set_api_key('wanikani-api-key')
      }.to change(Wanikani, :api_key).from(nil).to('wanikani-api-key')
    end
  end

  describe '#wanikani_user' do
    it 'returns nil if the API key is not set' do
      Wanikani.api_key = nil
      subject.wanikani_user.should be_nil
    end

    it 'should hit the cache if the API key is set' do
      Wanikani.api_key = 'valid-api-key'
      returned_user = { "user_information" => { "username" => "dennmart" } }
      subject.should_receive(:cache_object).with('wanikani/user/valid-api-key', expires: 300).and_return(returned_user)
      subject.wanikani_user.should == returned_user
    end
  end

  describe '#generate_anki_deck' do
    let(:deck_type) { "critical" }
    let(:card_data) { [{ "了" => "りょう - finish, complete, end" }] }
    let(:deck) { double(generate_deck: "了;りょう - finish, complete, end") }

    it 'instantiates an Anki::Deck object with the specified card data and generates a deck' do
      Anki::Deck.should_receive(:new).with(card_data: card_data).and_return(deck)
      deck.should_receive(:generate_deck)
      generated_deck = subject.generate_anki_deck(deck_type, card_data)
      generated_deck.should match(/#{card_data}/)
    end

    it 'capitalizes the first letter of the deck type for presentability in comments' do
      Anki::Deck.stub(:new).and_return(deck)
      generated_deck = subject.generate_anki_deck(deck_type, card_data)
      generated_deck.should match(/Critical/)
    end

    it 'removed any underscores from the deck type for presentability in comments' do
      deck_type = 'recent_unlocks'
      Anki::Deck.stub(:new).and_return(deck)
      generated_deck = subject.generate_anki_deck(deck_type, card_data)
      generated_deck.should match(/Recent unlocks/)
    end
  end
end
