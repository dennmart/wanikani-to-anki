require 'spec_helper'

describe WanikaniApi do
  let(:kanji_item) { { "type" => "kanji", "character" => "了", "meaning" => "finish, complete, end", "onyomi" => "りょう", "kunyomi" => nil, "important_reading" => "onyomi", "level" => 2, "percentage" => "72"} }
  let(:vocabulary_item) { {"type" => "vocabulary", "character" => "伝説", "kana" => "でんせつ", "meaning" => "legend", "level" => 17, "percentage" => "72"} }
  let(:radical_item) { {"type" => "radical", "character" => "貝", "meaning" => "clam", "image" => nil, "level" => 4, "percentage" => "75"} }
  let(:items) { [kanji_item, vocabulary_item, radical_item] }
  let(:level_params) { { selected_levels: "all" } }

  describe ".fetch_critical" do
    let(:params) { { argument: 60 } }

    it "sets the max percentage for fetching critical items if the object has its optional argument set" do
      expect(Wanikani::CriticalItems).to receive(:critical).with(60).and_return([])
      WanikaniApi.fetch_critical(params)
    end

    it "uses a default max percentage of 75 if the object doesn't have optional arguments set" do
      expect(Wanikani::CriticalItems).to receive(:critical).with(75).and_return([])
      WanikaniApi.fetch_critical({})
    end

    it "iterates through critical items array and calls methods according to the type" do
      allow(Wanikani::CriticalItems).to receive(:critical).and_return(items)
      expect(WanikaniApi).to receive(:kanji_type_to_string).once
      expect(WanikaniApi).to receive(:vocabulary_type_to_string).once
      expect(WanikaniApi).to receive(:radical_type_to_string).once
      WanikaniApi.fetch_critical(params)
    end

    context "without level_tags" do
      it "doesn't include if the level_tags parameter is not set" do
        allow(Wanikani::CriticalItems).to receive(:critical).and_return(items)
        critical = WanikaniApi.fetch_critical(params)
        expect(critical.first.values.first).not_to be_a(Hash)
      end
    end

    context "with level_tags" do
      it "includes tags if the level_tags parameter is set" do
        allow(Wanikani::CriticalItems).to receive(:critical).and_return(items)
        critical = WanikaniApi.fetch_critical(params.merge(level_tags: "on"))
        expect(critical.first.values.first).to be_a(Hash)
        expect(critical.first.values.first).to have_key("tags")
      end
    end
  end

  describe ".fetch_kanji" do
    before(:each) do
      allow(Wanikani::Level).to receive(:kanji).and_return([kanji_item])
    end

    it "returns the character, important reading value and meaning of the item" do
      kanji = WanikaniApi.fetch_kanji(level_params).first
      expect(kanji.keys.first).to eq("了")
      expect(kanji.values.first).to eq("りょう - finish, complete, end")
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      kanji = WanikaniApi.fetch_kanji(level_params.merge(level_tags: "on")).first
      expect(kanji.values.first).to have_key("tags")
      expect(kanji.values.first["tags"]).to include("Level2")
    end
  end

  describe ".fetch_vocabulary" do
    before(:each) do
      allow(Wanikani::Level).to receive(:vocabulary).and_return([vocabulary_item])
    end

    it "returns the character, kana and meaning of the item" do
      vocabulary = WanikaniApi.fetch_vocabulary(level_params).first
      expect(vocabulary.keys.first).to eq("伝説")
      expect(vocabulary.values.first).to eq("でんせつ - legend")
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      vocabulary = WanikaniApi.fetch_vocabulary(level_params.merge(level_tags: "on")).first
      expect(vocabulary.values.first).to have_key("tags")
      expect(vocabulary.values.first["tags"]).to include("Level17")
    end
  end

  describe ".fetch_radicals" do
    before(:each) do
      allow(Wanikani::Level).to receive(:radicals).and_return([radical_item])
    end

    it "returns the character, kana and meaning of the item" do
      radicals = WanikaniApi.fetch_radicals(level_params).first
      expect(radicals.keys.first).to eq("貝")
      expect(radicals.values.first).to eq("clam")
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      radicals = WanikaniApi.fetch_radicals(level_params.merge(level_tags: "on")).first
      expect(radicals.values.first).to have_key("tags")
      expect(radicals.values.first["tags"]).to include("Level4")
    end
  end

  describe ".fetch_burned" do
    it "iterates through burned items array and calls methods according to the type" do
      allow(Wanikani::SRS).to receive(:items_by_type).with('burned').and_return(items)
      expect(WanikaniApi).to receive(:kanji_type_to_string).once
      expect(WanikaniApi).to receive(:vocabulary_type_to_string).once
      expect(WanikaniApi).to receive(:radical_type_to_string).once
      WanikaniApi.fetch_burned(level_tags: "on")
    end

    context "without level_tags" do
      it "doesn't include if the level_tags parameter is not set" do
        allow(Wanikani::SRS).to receive(:items_by_type).with('burned').and_return(items)
        burned = WanikaniApi.fetch_burned({})
        expect(burned.first.values.first).not_to be_a(Hash)
      end
    end

    context "with level_tags" do
      it "includes tags if the level_tags parameter is set" do
        allow(Wanikani::SRS).to receive(:items_by_type).with('burned').and_return(items)
        burned = WanikaniApi.fetch_burned(level_tags: "on")
        expect(burned.first.values.first).to be_a(Hash)
        expect(burned.first.values.first).to have_key("tags")
      end
    end
  end

  describe ".fetch_recent_unlocks" do
    it "iterates through burned items array and calls methods according to the type" do
      allow(Wanikani::RecentUnlocks).to receive(:list).with(100).and_return(items)
      expect(WanikaniApi).to receive(:kanji_type_to_string).once
      expect(WanikaniApi).to receive(:vocabulary_type_to_string).once
      expect(WanikaniApi).to receive(:radical_type_to_string).once
      WanikaniApi.fetch_recent_unlocks(level_tags: "on")
    end

    context "without level_tags" do
      it "doesn't include if the level_tags parameter is not set" do
        allow(Wanikani::RecentUnlocks).to receive(:list).with(100).and_return(items)
        recent_unlocks = WanikaniApi.fetch_recent_unlocks({})
        expect(recent_unlocks.first.values.first).not_to be_a(Hash)
      end
    end

    context "with level_tags" do
      it "includes tags if the level_tags parameter is set" do
        allow(Wanikani::RecentUnlocks).to receive(:list).with(100).and_return(items)
        recent_unlocks = WanikaniApi.fetch_recent_unlocks(level_tags: "on")
        expect(recent_unlocks.first.values.first).to be_a(Hash)
        expect(recent_unlocks.first.values.first).to have_key("tags")
      end
    end
  end
end
