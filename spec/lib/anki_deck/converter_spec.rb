require 'spec_helper'

describe AnkiDeck::Converter do
  describe "#critical_items_to_text" do
    let(:kanji_item) { { "type" => "kanji", "character" => "了", "meaning" => "finish, complete, end", "onyomi" => "りょう", "kunyomi" => nil, "important_reading" => "onyomi", "level" => 2, "percentage" => "72"} }
    let(:vocabulary_item) { {"type" => "vocabulary", "character" => "伝説", "kana" => "でんせつ", "meaning" => "legend", "level" => 17, "percentage" => "72"} }
    let(:radical_item) { {"type" => "radical", "character" => "貝", "meaning" => "clam", "image" => nil, "level" => 4, "percentage" => "75"} }
    let(:items) { [kanji_item, vocabulary_item, radical_item] }

    subject { AnkiDeck::Converter.new }

    it "iterates through critical items array and calls methods according to the type" do
      subject.should_receive(:kanji_type_to_string).once
      subject.should_receive(:vocabulary_type_to_string).once
      subject.should_receive(:radical_type_to_string).once
      subject.critical_items_to_text(items)
    end

    context "#kanji_type_to_string" do
      it "returns the character, important reading value and meaning of the item" do
        kanji_string = subject.send(:kanji_type_to_string, kanji_item)
        kanji_string.should match /了/
        kanji_string.should match /りょう/
        kanji_string.should match /finish, complete, end/
      end
    end

    context "#vocabulary_type_to_string" do
      it "returns the character, kana and meaning of the item" do
        vocabulary_string = subject.send(:vocabulary_type_to_string, vocabulary_item)
        vocabulary_string.should match /伝説/
        vocabulary_string.should match /でんせつ/
        vocabulary_string.should match /legend/
      end
    end

    context "#radical_type_to_string" do
      it "returns nil if the character is nil" do
        radical = {"type" => "radical", "character" => nil, "meaning" => "leaf", "image" => "https://s3.amazonaws.com/s3.wanikani.com/images/radicals/ca386aec7915ab74e52ec506ed2e532d4631bb06.png", "level" => 1, "percentage" => "76"}
        radical_string = subject.send(:radical_type_to_string, radical)
        radical_string.should be_nil
      end

      it "returns the character and the meaning" do
        radical_string = subject.send(:radical_type_to_string, radical_item)
        radical_string.should match /貝/
        radical_string.should match /clam/
      end
    end
  end
end
