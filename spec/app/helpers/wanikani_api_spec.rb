require 'spec_helper'

describe WanikaniApi do
  let(:kanji_item) { { 'character' => "了", 'meaning' => 'finish, complete, end', 'onyomi' => "りょう", 'kunyomi' => nil, 'important_reading' => 'onyomi', 'level' => 2, 'percentage' => '72' } }
  let(:vocabulary_item) { { 'character' => "伝説", 'kana' => "でんせつ", 'meaning' => 'legend', 'level' => 17, 'percentage' => '72' } }
  let(:radical_item) { { 'character' => "貝", 'meaning' => 'clam', 'image' => nil, 'level' => 4, 'percentage' => '75' } }
  let(:items) do
    items = [kanji_item.clone, vocabulary_item.clone, radical_item.clone]
    items[0]['type'] = 'kanji'
    items[1]['type'] = 'vocabulary'
    items[2]['type'] = 'radical'
    return items
  end
  let(:level_params) { { selected_levels: 'all' } }
  let(:api_helper) { WanikaniApi.new("my-api-key") }

  describe '#fetch_critical' do
    let(:params) { { argument: 60 } }

    it 'sets the max percentage for fetching critical items if the object has its optional argument set' do
      expect_any_instance_of(Wanikani::Client).to receive(:critical_items).with(60).and_return([])
      api_helper.fetch_critical(params)
    end

    it "uses a default max percentage of 75 if the object doesn't have optional arguments set" do
      expect_any_instance_of(Wanikani::Client).to receive(:critical_items).with(75).and_return([])
      api_helper.fetch_critical({})
    end

    it 'iterates through critical items array and calls methods according to the type' do
      allow_any_instance_of(Wanikani::Client).to receive(:critical_items).and_return(items)
      api_helper.fetch_critical(params)
    end
  end

  describe '#fetch_kanji' do
    before(:each) do
      allow_any_instance_of(Wanikani::Client).to receive(:kanji_list).and_return([kanji_item])
    end

    it 'Adds key and type=kanji to result' do
      kanjis = api_helper.fetch_kanji(level_params)
      expect(kanjis.size).to eq(1)
      kanji = kanjis[0]
      expect(kanji['key']).to eq("k_了")
      expect(kanji['type']).to eq('kanji')
      expect(kanji['character']).to eq("了")
      expect(kanji['meaning']).to eq('finish, complete, end')
      expect(kanji['onyomi']).to eq("りょう")
      expect(kanji['kunyomi']).to be nil
      expect(kanji['important_reading']).to eq('onyomi')
      expect(kanji['level']).to eq(2)
      expect(kanji['percentage']).to eq('72')
    end
  end

  describe '#fetch_vocabulary' do
    before(:each) do
      allow_any_instance_of(Wanikani::Client).to receive(:vocabulary_list).and_return([vocabulary_item])
    end

    it 'Adds key and type=vocabulary to results' do
      vocabularys = api_helper.fetch_vocabulary(level_params)
      expect(vocabularys.size).to eq(1)
      vocabulary = vocabularys[0]
      expect(vocabulary['key']).to eq("v_伝説")
      expect(vocabulary['type']).to eq('vocabulary')
      expect(vocabulary['character']).to eq("伝説")
      expect(vocabulary['kana']).to eq("でんせつ")
      expect(vocabulary['meaning']).to eq('legend')
      expect(vocabulary['level']).to eq(17)
      expect(vocabulary['percentage']).to eq('72')
    end
  end

  describe '.fetch_radicals' do
    before(:each) do
      allow_any_instance_of(Wanikani::Client).to receive(:radicals_list).and_return([radical_item])
    end

    it 'Adds key and type=radical' do
      radicals = api_helper.fetch_radicals(level_params)
      expect(radicals.size).to eq(1)
      radical = radicals[0]
      expect(radical['key']).to eq('r_clam')
      expect(radical['type']).to eq('radical')
      expect(radical['character']).to eq("貝")
      expect(radical['meaning']).to eq('clam')
      expect(radical['image']).to be nil
      expect(radical['level']).to eq(4)
      expect(radical['percentage']).to eq('75')
    end
  end
end
