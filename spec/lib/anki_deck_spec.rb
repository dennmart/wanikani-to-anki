require 'spec_helper'

describe AnkiDeck do
  describe "#generate_deck" do
    it "should call the approriate method according to the object's type" do
      deck = AnkiDeck.new("deck_type")
      deck.should_receive(:deck_type)
      deck.generate_deck
    end
  end

  describe "deck generation" do
    subject { AnkiDeck.new("critical") }

    context "#critical" do
      context "setting percentage" do
        it "sets the max percentage for fetching critical items if the object has its optional argument set" do
          subject.argument = 60
          Wanikani::CriticalItems.should_receive(:critical).with(60).and_return([])
          subject.generate_deck
        end

        it "uses a default max percentage of 75 if the object doesn't have optional arguments set" do
          Wanikani::CriticalItems.should_receive(:critical).with(75).and_return([])
          subject.generate_deck
        end
      end

      context "user's critical items list is empty" do
        before(:each) do
          Wanikani::CriticalItems.stub(:critical).and_return([])
        end

        it "doesn't call AnkiDeck::Converter#critical_items_to_text if the user's critical items list is empty" do
          AnkiDeck::Converter.any_instance.should_not_receive(:critical_items_to_text)
          subject.generate_deck
        end

        it "returns nil if the user's critical items list is empty" do
          subject.generate_deck.should be_nil
        end
      end

      context "user has critical items" do
        let(:critical_items) { [{ type: "vocabulary", character: "結果", kana: "けっか", meaning: "result", level: 17, percentage: "73" }] }

        before(:each) do
          Wanikani::CriticalItems.stub(:critical).and_return(critical_items)
        end

        it "calls AnkiDeck::Converter#critical_items_to_text with the user's critical items" do
          AnkiDeck::Converter.any_instance.should_receive(:critical_items_to_text).with(critical_items)
          subject.generate_deck
        end

        it "returns the output from AnkiDeck::Converter#critical_items_to_text" do
          AnkiDeck::Converter.stub(:new).and_return(double(critical_items_to_text: "anki deck output"))
          subject.generate_deck.should == "anki deck output"
        end
      end
    end
  end
end
