class WanikaniApi
  def self.fetch_critical(params)
    percentage = params || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    critical_items.map { |item| self.send("#{item["type"]}_type_to_string", item) }.compact
  end

  def self.fetch_kanji(levels)
    kanji = Wanikani::Level.kanji(levels)
    kanji.map { |item| kanji_type_to_string(item) }.compact
  end

  def self.fetch_vocabulary(levels)
    vocabulary = Wanikani::Level.vocabulary(levels)
    vocabulary.map { |item| vocabulary_type_to_string(item) }.compact
  end

  def self.fetch_radicals(levels)
    radicals = Wanikani::Level.radicals(levels)
    radicals.map { |item| radical_type_to_string(item) }.compact
  end

  private

  def self.kanji_type_to_string(item)
    reading = item["important_reading"]
    { item["character"] => "#{item[reading]} - #{item["meaning"]}" }
  end

  def self.vocabulary_type_to_string(item)
    { item["character"] => "#{item["kana"]} - #{item["meaning"]}" }
  end

  def self.radical_type_to_string(item)
    # TODO: How to deal with radicals with images
    return nil if item["character"].nil?
    { item["character"] => "#{item["meaning"]}" }
  end
end
