require 'spec_helper'

describe WkankiHelper do
  subject do
    Class.new { include WkankiHelper }.new
  end

  describe '#wanikani_user' do
    it 'returns nil if the API key is not set' do
      Wanikani.api_key = nil
      expect(subject.wanikani_user).to be_nil
    end

    it 'should hit the cache if the API key is set' do
      Wanikani.api_key = 'valid-api-key'
      returned_user = { 'user_information' => { 'username' => 'dennmart' } }
      expect(subject).to receive(:cache_object).with('wanikani/user/valid-api-key', expires: 300).and_return(returned_user)
      expect(subject.wanikani_user).to eq(returned_user)
    end
  end

  describe '#generate_anki_deck' do
    # The following test fixtures are what the WanikaniApi will return and so need to have key and type included
    let(:recent_unlocks) do
      [
        {
          'key' => "v_魚",
          'type' => 'vocabulary',
          'character' => "魚",
          'kana' => "さかな",
          'meaning' => 'fish',
          'level' => 7,
          'unlocked_date' => 1_422_401_237
        },
        {
          'key' => "k_失",
          'type' => 'kanji',
          'character' => "失",
          'meaning' => 'fault',
          'onyomi' => "しつ",
          'kunyomi' => "うしな.う",
          'important_reading' => 'onyomi',
          'level' => 7,
          'unlocked_date' => 1_422_359_898
        },
        {
          'key' => 'r_stamp',
          'type' => 'radical',
          'character' => "卩",
          'meaning' => 'stamp',
          'image' => nil,
          'level' => 7,
          'unlocked_date' => 1_421_558_380
        }
      ]
    end
    let(:critical_items) do
      [
        {
          'key' => 'r_raptor-cage',
          'type' => 'radical',
          'character' => "久",
          'meaning' => 'raptor-cage',
          'image' => nil,
          'level' => 3,
          'percentage' => '79'
        },
        {
          'key' => "v_入る",
          'type' => 'vocabulary',
          'character' => "入る",
          'kana' => "はいる",
          'meaning' => 'to enter',
          'level' => 1,
          'percentage' => '85'
        },
        {
          'key' => "k_九",
          'type' => 'kanji',
          'character' => "九",
          'meaning' => 'nine',
          'onyomi' => "く, きゅう",
          'kunyomi' => "ここの.*",
          'important_reading' => 'onyomi',
          'level' => 1,
          'percentage' => '87'
        }
      ]
    end
    let(:radicals) do
      [
        {
          'key' => 'r_gun',
          'type' => 'radical',
          'character' => nil,
          'meaning' => 'gun',
          'image' => 'https://s3.amazonaws.com/s3.wanikani.com/images/radicals/80fff71b321c8cee57db7224f5fe1daa331128b5.png',
          'level' => 1
        },
        {
          'key' => 'r_small',
          'type' => 'radical',
          'character' => "小",
          'meaning' => 'small',
          'image' => nil,
          'level' => 2
        }
      ]
    end
    let(:kanji) do
      [
        {
          'key' => "k_入",
          'type' => 'kanji',
          'character' => "入",
          'meaning' => 'enter',
          'onyomi' => "にゅう",
          'kunyomi' => "はい.る, い.れる",
          'important_reading' => 'onyomi',
          'level' => 1
        },
        {
          'key' => "k_工",
          'type' => 'kanji',
          'character' => "工",
          'meaning' => 'industry',
          'onyomi' => "こう",
          'kunyomi' => nil,
          'important_reading' => 'onyomi',
          'level' => 1
        }
      ]
    end
    let(:vocabulary) do
      [
        {
          'key' => "v_二",
          'type' => 'vocabulary',
          'character' => "二",
          'kana' => "に",
          'meaning' => 'two',
          'level' => 1
        },
        {
          'key' => "v_入る",
          'type' => 'vocabulary',
          'character' => "入る",
          'kana' => "はいる",
          'meaning' => 'to enter',
          'level' => 1
        }
      ]
    end

    it 'Critical Deck' do
      generated_deck = subject.generate_anki_deck('critical', critical_items)
      deck_lines = generated_deck.split("\n")
      expect(deck_lines[0]).to eq('# WaniKani - Critical')
      expect(deck_lines[3]).to eq('#key;type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level')
      expect(deck_lines[4]).to eq("r_raptor-cage;radical;久;raptor-cage;;;;;;3")
      expect(deck_lines[5]).to eq("v_入る;vocabulary;入る;to enter;;;;;はいる;1")
      expect(deck_lines[6]).to eq("k_九;kanji;九;nine;;く, きゅう;ここの.*;onyomi;;1")
      expect(deck_lines.size).to eq(7)
    end

    it 'Recent Unlocks' do
      generated_deck = subject.generate_anki_deck('recent_unlocks', recent_unlocks)
      deck_lines = generated_deck.split("\n")
      expect(deck_lines[0]).to eq('# WaniKani - Recent unlocks')
      expect(deck_lines[3]).to eq('#key;type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level')
      expect(deck_lines[4]).to eq("v_魚;vocabulary;魚;fish;;;;;さかな;7")
      expect(deck_lines[5]).to eq("k_失;kanji;失;fault;;しつ;うしな.う;onyomi;;7")
      expect(deck_lines[6]).to eq("r_stamp;radical;卩;stamp;;;;;;7")
      expect(deck_lines.size).to eq(7)
    end

    it 'Radicals List' do
      generated_deck = subject.generate_anki_deck('radicals', radicals)
      deck_lines = generated_deck.split("\n")
      expect(deck_lines[0]).to eq('# WaniKani - Radicals')
      expect(deck_lines[3]).to eq('#key;type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level')
      expect(deck_lines[4]).to eq('r_gun;radical;;gun;https://s3.amazonaws.com/s3.wanikani.com/images/radicals/80fff71b321c8cee57db7224f5fe1daa331128b5.png;;;;;1')
      expect(deck_lines[5]).to eq("r_small;radical;小;small;;;;;;2")
      expect(deck_lines.size).to eq(6)
    end

    it 'Kanji List' do
      generated_deck = subject.generate_anki_deck('kanji', kanji)
      deck_lines = generated_deck.split("\n")
      expect(deck_lines[0]).to eq('# WaniKani - Kanji')
      expect(deck_lines[3]).to eq('#key;type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level')
      expect(deck_lines[4]).to eq("k_入;kanji;入;enter;;にゅう;はい.る, い.れる;onyomi;;1")
      expect(deck_lines[5]).to eq("k_工;kanji;工;industry;;こう;;onyomi;;1")
      expect(deck_lines.size).to eq(6)
    end

    it 'Vocabulary List' do
      generated_deck = subject.generate_anki_deck('vocabulary', vocabulary)
      deck_lines = generated_deck.split("\n")
      expect(deck_lines[0]).to eq('# WaniKani - Vocabulary')
      expect(deck_lines[3]).to eq('#key;type;character;meaning;image;onyomi;kunyomi;important_reading;kana;level')
      expect(deck_lines[4]).to eq("v_二;vocabulary;二;two;;;;;に;1")
      expect(deck_lines[5]).to eq("v_入る;vocabulary;入る;to enter;;;;;はいる;1")
      expect(deck_lines.size).to eq(6)
    end
  end
end
