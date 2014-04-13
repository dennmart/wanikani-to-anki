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
    it 'returns nil if the Wanikani.api_key is not set' do
      Wanikani.api_key = nil
      subject.wanikani_user.should be_nil
    end

    it 'returns Wanikani::User.information when the API key is set' do
      pending
    end
  end

  describe '#optional_argument' do
    it 'returns :argument from the params if the :selected_levels param is not set' do
      params = { argument: 50 }
      subject.optional_argument(params).should == 50
    end

    it 'returns :argument from the params if the :selected_levels param is not "all"' do
      params = { argument: 80, selected_levels: "1,2,3" }
      subject.optional_argument(params).should == 80
    end

    it 'returns nil if the :selected_levels param is "all"' do
      params = { argument: 100, selected_levels: "all" }
      subject.optional_argument(params).should be_nil
    end
  end

  describe '#generate_anki_deck' do
    let(:card_data) { [{ "了" => "りょう - finish, complete, end" }] }

    it 'instantiates an Anki::Deck object with the specified card data and generates a deck' do
      deck = double(generate_deck: "了;りょう - finish, complete, end")
      Anki::Deck.should_receive(:new).with(card_data: card_data).and_return(deck)
      deck.should_receive(:generate_deck)
      generated_deck = subject.generate_anki_deck(card_data)
      generated_deck.should match(/#{card_data}/)
    end
  end
end
