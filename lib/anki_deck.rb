class AnkiDeck
  attr_accessor :type

  def initialize(type, argument = nil)
    @type = type
    @argument = argument
  end

  def generate_deck
    self.send(self.type.to_sym)
  end

  private

  def critical
    critical_items = Wanikani::CriticalItems.critical(85)
    return nil if critical_items.empty?

    critical_items.map do |item|
      if item["type"] == "kanji"
        "#{item["character"]}; #{item[item["important_reading"]]} - #{item["meaning"]}"
      elsif item["type"] == "vocabulary"
        "#{item["character"]}; #{item["kana"]} - #{item["meaning"]}"
      elsif item["type"] == "radical"
        # TODO: How to deal with radicals with images
        next if item["character"].nil?
        "#{item["character"]}; #{item["meaning"]}"
      end
    end.compact.join("\n")
  end
end
