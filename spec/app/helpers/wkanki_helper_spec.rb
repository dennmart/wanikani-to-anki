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
    let(:recent_unlocks) {
      [
        {
          "type" => "vocabulary",
          "character" => "魚",
          "kana" => "さかな",
          "meaning" => "fish",
          "level" => 7,
          "unlocked_date" => 1422401237
        },
        {
          "type" => "kanji",
          "character" => "失",
          "meaning" => "fault",
          "onyomi" => "しつ",
          "kunyomi" => "うしな.う",
          "important_reading" => "onyomi",
          "level" => 7,
          "unlocked_date" => 1422359898
        },
        {
          "type" => "radical",
          "character" => "卩",
          "meaning" => "stamp",
          "image" => nil,
          "level" => 7,
          "unlocked_date" => 1421558380
        }
      ]
    }
    let(:critical_items) {
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
    }
    let(:radicals) {
      [
        {
          "type" => "radical",
          "character" => nil,
          "meaning" => "gun",
          "image" => "https://s3.amazonaws.com/s3.wanikani.com/images/radicals/80fff71b321c8cee57db7224f5fe1daa331128b5.png",
          "level" => 1
        },
        {
          "type" => "radical",
          "character" => "小",
          "meaning" => "small",
          "image" => nil,
          "level" => 2
        }
      ]
    }
    let(:kanji) {
      [
        {
          "type" => "kanji",
          "character" => "入",
          "meaning" => "enter",
          "onyomi" => "にゅう",
          "kunyomi" => "はい.る, い.れる",
          "important_reading" => "onyomi",
          "level" => 1
        },
        {
          "type" => "kanji",
          "character" => "工",
          "meaning" => "industry",
          "onyomi" => "こう",
          "kunyomi" => nil,
          "important_reading" => "onyomi",
          "level" => 1
        }
      ]
    }
    let(:vocabulary) {
      [
        {
          "type" => "vocabulary",
          "character" => "二",
          "kana" => "に",
          "meaning" => "two",
          "level" => 1
        },
        {
          "type" => "vocabulary",
          "character" => "入る",
          "kana" => "はいる",
          "meaning" => "to enter",
          "level" => 1
        }
      ]
    }

    it 'Critical Deck' do
      generated_deck = subject.generate_anki_deck("critical", critical_items)
      deck_lines = generated_deck.split("\n");
      expect(deck_lines[0]).to eq("# WaniKani - Critical")
      expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
      expect(deck_lines[4]).to eq("radical;久;raptor-cage;;;;;;3")
      expect(deck_lines[5]).to eq("vocabulary;入る;to enter;;;;;はいる;1")
      expect(deck_lines[6]).to eq("kanji;九;nine;;く, きゅう;ここの.*;onyomi;;1")
      expect(deck_lines.size).to eq(7)
    end

    it 'Recent Unlocks' do
      generated_deck = subject.generate_anki_deck("recent_unlocks", recent_unlocks)
      deck_lines = generated_deck.split("\n");
      expect(deck_lines[0]).to eq("# WaniKani - Recent unlocks")
      expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
      expect(deck_lines[4]).to eq("vocabulary;魚;fish;;;;;さかな;7")
      expect(deck_lines[5]).to eq("kanji;失;fault;;しつ;うしな.う;onyomi;;7")
      expect(deck_lines[6]).to eq("radical;卩;stamp;;;;;;7")
      expect(deck_lines.size).to eq(7)
    end

    it 'Radicals List' do
      generated_deck = subject.generate_anki_deck("radicals", radicals)
      deck_lines = generated_deck.split("\n");
      expect(deck_lines[0]).to eq("# WaniKani - Radicals")
      expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
      expect(deck_lines[4]).to eq("radical;;gun;https://s3.amazonaws.com/s3.wanikani.com/images/radicals/80fff71b321c8cee57db7224f5fe1daa331128b5.png;;;;;1")
      expect(deck_lines[5]).to eq("radical;小;small;;;;;;2")
      expect(deck_lines.size).to eq(6)
    end

    it 'Kanji List' do
      generated_deck = subject.generate_anki_deck("kanji", kanji)
      deck_lines = generated_deck.split("\n");
      expect(deck_lines[0]).to eq("# WaniKani - Kanji")
      expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
      expect(deck_lines[4]).to eq("kanji;入;enter;;にゅう;はい.る, い.れる;onyomi;;1")
      expect(deck_lines[5]).to eq("kanji;工;industry;;こう;;onyomi;;1")
      expect(deck_lines.size).to eq(6)
    end

    it 'Vocabulary List' do
      generated_deck = subject.generate_anki_deck("vocabulary", vocabulary)
      deck_lines = generated_deck.split("\n");
      expect(deck_lines[0]).to eq("# WaniKani - Vocabulary")
      expect(deck_lines[3]).to eq("#type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level")
      expect(deck_lines[4]).to eq("vocabulary;二;two;;;;;に;1")
      expect(deck_lines[5]).to eq("vocabulary;入る;to enter;;;;;はいる;1")
      expect(deck_lines.size).to eq(6)
    end

  end
end
