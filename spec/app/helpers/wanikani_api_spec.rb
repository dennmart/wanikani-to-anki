require 'spec_helper'

describe WanikaniApi do
  let(:kanji_item) { { "type" => "kanji", "character" => "了", "meaning" => "finish, complete, end", "onyomi" => "りょう", "kunyomi" => nil, "important_reading" => "onyomi", "level" => 2, "percentage" => "72"} }
  let(:vocabulary_item) { {"type" => "vocabulary", "character" => "伝説", "kana" => "でんせつ", "meaning" => "legend", "level" => 17, "percentage" => "72"} }
  let(:radical_item) { {"type" => "radical", "character" => "貝", "meaning" => "clam", "image" => nil, "level" => 4, "percentage" => "75"} }
  let(:items) { [kanji_item, vocabulary_item, radical_item] }

  describe ".fetch_critical" do
    it "sets the max percentage for fetching critical items if the object has its optional argument set" do
      Wanikani::CriticalItems.should_receive(:critical).with(60).and_return([])
      WanikaniApi.fetch_critical(60)
    end

    it "uses a default max percentage of 75 if the object doesn't have optional arguments set" do
      Wanikani::CriticalItems.should_receive(:critical).with(75).and_return([])
      WanikaniApi.fetch_critical(nil)
    end

    it "iterates through critical items array and calls methods according to the type" do
      Wanikani::CriticalItems.stub(:critical).and_return(items)
      WanikaniApi.should_receive(:kanji_type_to_string).once
      WanikaniApi.should_receive(:vocabulary_type_to_string).once
      WanikaniApi.should_receive(:radical_type_to_string).once
      WanikaniApi.fetch_critical(nil)
    end
  end

  describe ".fetch_kanji" do
    it "returns the character, important reading value and meaning of the item" do
      Wanikani::Level.stub(:kanji).and_return([kanji_item])
      kanji = WanikaniApi.fetch_kanji("all").first
      kanji.keys.first.should == "了"
      kanji.values.first.should == "りょう - finish, complete, end"
    end
  end

  describe ".fetch_vocabulary" do
    it "returns the character, kana and meaning of the item" do
      Wanikani::Level.stub(:vocabulary).and_return([vocabulary_item])
      vocabulary = WanikaniApi.fetch_vocabulary("all").first
      vocabulary.keys.first.should == "伝説"
      vocabulary.values.first.should == "でんせつ - legend"
    end
  end

  describe ".fetch_radicals" do
    it "returns the character, kana and meaning of the item" do
      Wanikani::Level.stub(:radicals).and_return([radical_item])
      radicals = WanikaniApi.fetch_radicals("all").first
      radicals.keys.first.should == "貝"
      radicals.values.first.should == "clam"
    end
  end
end
