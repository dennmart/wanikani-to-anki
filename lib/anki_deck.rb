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

  def converter
    @converter ||= AnkiDeck::Converter.new
  end

  def current_user
    @current_user ||= Wanikani::User.information
  end

  def levels_to_fetch
    if self.argument.blank?
      (1..current_user["level"]).to_a.join(",")
    else
      self.argument
    end
  end

  def critical
    percentage = self.argument || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    return nil if critical_items.empty?
    converter.critical_items_to_text(critical_items)
  end

  def kanji
    levels = levels_to_fetch
    kanji = Wanikani::Level.kanji(levels)
    return nil if kanji.empty?
    converter.kanji_to_text(kanji)
  end

  def vocabulary
    levels = levels_to_fetch
    vocabulary = Wanikani::Level.vocabulary(levels)
    return nil if vocabulary.empty?
    converter.vocabulary_to_text(vocabulary)
  end

  def radicals
    levels = levels_to_fetch
    radicals = Wanikani::Level.radicals(levels)
    return nil if radicals.empty?
    converter.radicals_to_text(radicals)
  end

  def method_missing(method)
    return nil
  end
end