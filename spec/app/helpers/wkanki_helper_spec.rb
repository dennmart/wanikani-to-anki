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
      expect(subject.wanikani_user).to be_nil
    end

    it 'should hit the cache if the API key is set' do
      Wanikani.api_key = 'valid-api-key'
      returned_user = { "user_information" => { "username" => "dennmart" } }
      expect(subject).to receive(:cache_object).with('wanikani/user/valid-api-key', expires: 300).and_return(returned_user)
      expect(subject.wanikani_user).to eq(returned_user)
    end
  end

  describe '#generate_anki_deck' do
    let(:card_data) {
      [
        { "type" => "vocabulary",
          "character" => "了",
          "kana" => "りょう",
          "meaning" => "finish, complete, end",
          "level" => "2"
        }
      ]
    }

    context "critical" do
      let(:deck_type) { "critical" }

      it 'generates a correct deck' do
        generated_deck = subject.generate_anki_deck(deck_type, card_data)
        deck_lines = generated_deck.split("\n");
        expect(deck_lines[0]).to eq("# WaniKani - Critical")
        expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
        expect(deck_lines[4]).to eq("vocabulary;了;finish, complete, end;;;;;りょう;2")
      end
    end

    context "recent unlocks" do
      let (:deck_type) { "recent_unlocks" }
        it 'removed any underscores from the deck type for presentability in comments' do
          generated_deck = subject.generate_anki_deck(deck_type, card_data)
          deck_lines = generated_deck.split("\n");
          expect(deck_lines[0]).to eq("# WaniKani - Recent unlocks")
          expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
          expect(deck_lines[4]).to eq("vocabulary;了;finish, complete, end;;;;;りょう;2")
          puts "Generated deck #{generated_deck}"
        end
    end
  end
end
