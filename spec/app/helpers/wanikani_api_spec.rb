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
      Wanikani::CriticalItems.should_receive(:critical).with(60).and_return([])
      WanikaniApi.fetch_critical(params)
    end

    it "uses a default max percentage of 75 if the object doesn't have optional arguments set" do
      Wanikani::CriticalItems.should_receive(:critical).with(75).and_return([])
      WanikaniApi.fetch_critical({})
    end

    it "iterates through critical items array and calls methods according to the type" do
      Wanikani::CriticalItems.stub(:critical).and_return(items)
      WanikaniApi.should_receive(:kanji_type_to_string).once
      WanikaniApi.should_receive(:vocabulary_type_to_string).once
      WanikaniApi.should_receive(:radical_type_to_string).once
      WanikaniApi.fetch_critical(params)
    end

    context "without level_tags" do
      it "doesn't include if the level_tags parameter is not set" do
        Wanikani::CriticalItems.stub(:critical).and_return(items)
        critical = WanikaniApi.fetch_critical(params)
        critical.first.values.first.should_not be_a(Hash)
      end
    end

    context "with level_tags" do
      it "includes tags if the level_tags parameter is set" do
        Wanikani::CriticalItems.stub(:critical).and_return(items)
        critical = WanikaniApi.fetch_critical(params.merge(level_tags: "on"))
        critical.first.values.first.should be_a(Hash)
        critical.first.values.first.should have_key("tags")
      end
    end
  end

  describe ".fetch_kanji" do
    before(:each) do
      Wanikani::Level.stub(:kanji).and_return([kanji_item])
    end

    it "returns the character, important reading value and meaning of the item" do
      kanji = WanikaniApi.fetch_kanji(level_params).first
      kanji.keys.first.should == "了"
      kanji.values.first.should == "りょう - finish, complete, end"
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      kanji = WanikaniApi.fetch_kanji(level_params.merge(level_tags: "on")).first
      kanji.values.first.should have_key("tags")
      kanji.values.first["tags"].should include("Level2")
    end
  end

  describe ".fetch_vocabulary" do
    before(:each) do
      Wanikani::Level.stub(:vocabulary).and_return([vocabulary_item])
    end

    it "returns the character, kana and meaning of the item" do
      vocabulary = WanikaniApi.fetch_vocabulary(level_params).first
      vocabulary.keys.first.should == "伝説"
      vocabulary.values.first.should == "でんせつ - legend"
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      vocabulary = WanikaniApi.fetch_vocabulary(level_params.merge(level_tags: "on")).first
      vocabulary.values.first.should have_key("tags")
      vocabulary.values.first["tags"].should include("Level17")
    end
  end

  describe ".fetch_radicals" do
    before(:each) do
      Wanikani::Level.stub(:radicals).and_return([radical_item])
    end

    it "returns the character, kana and meaning of the item" do
      radicals = WanikaniApi.fetch_radicals(level_params).first
      radicals.keys.first.should == "貝"
      radicals.values.first.should == "clam"
    end

    it "also includes tags with the level information if the level_tags parameter is set" do
      radicals = WanikaniApi.fetch_radicals(level_params.merge(level_tags: "on")).first
      radicals.values.first.should have_key("tags")
      radicals.values.first["tags"].should include("Level4")
    end
  end

  describe ".fetch_burned" do
    it "iterates through burned items array and calls methods according to the type" do
      Wanikani::SRS.stub(:items_by_type).with('burned').and_return(items)
      WanikaniApi.should_receive(:kanji_type_to_string).once
      WanikaniApi.should_receive(:vocabulary_type_to_string).once
      WanikaniApi.should_receive(:radical_type_to_string).once
      WanikaniApi.fetch_burned(level_tags: "on")
    end

    context "without level_tags" do
      it "doesn't include if the level_tags parameter is not set" do
        Wanikani::SRS.stub(:items_by_type).with('burned').and_return(items)
        burned = WanikaniApi.fetch_burned({})
        burned.first.values.first.should_not be_a(Hash)
      end
    end

    context "with level_tags" do
      it "includes tags if the level_tags parameter is set" do
        Wanikani::SRS.stub(:items_by_type).with('burned').and_return(items)
        burned = WanikaniApi.fetch_burned(level_tags: "on")
        burned.first.values.first.should be_a(Hash)
        burned.first.values.first.should have_key("tags")
      end
    end
  end
end
