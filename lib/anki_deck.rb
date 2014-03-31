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

  def current_user_level
    Wanikani::User.information["level"]
  end

  def critical
    percentage = self.argument || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    return nil if critical_items.empty?
    converter.critical_items_to_text(critical_items)
  end

  def kanji
    level = if self.argument.blank?
              (1..current_user_level).to_a.join(",")
            else
              self.argument
            end

    puts "Level: #{level}"
    kanji = Wanikani::Level.kanji(level)
    return nil if kanji.empty?
    converter.kanji_to_text(kanji)
  end

  def method_missing(method)
    return nil
  end
end
