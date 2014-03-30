class AnkiDeck
  attr_accessor :type, :argument

  def initialize(type, argument = nil)
    @type = type
    @argument = argument
  end

  def generate_deck
    self.send(self.type.to_sym)
  end

  private

  def critical
    percentage = self.argument || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    return nil if critical_items.empty?

    converter = AnkiDeck::Converter.new
    converter.critical_items_to_text(critical_items)
  end

  def kanji
    level = 18
    kanji = Wanikani::Level.kanji(level)
    return nil if kanji.empty?

    converter = AnkiDeck::Converter.new
    converter.kanji_to_text(kanji)
  end

  def method_missing(method)
    return nil
  end
end
