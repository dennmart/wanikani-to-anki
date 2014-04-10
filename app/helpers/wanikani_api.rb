class WanikaniApi
  def self.fetch_critical(params)
    percentage = params || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    critical_items.map { |item| self.send("#{item["type"]}_type_to_string", item) }.compact
  end

  private

  def kanji_type_to_string(item)
    reading = item["important_reading"]
    { item["character"] => "#{item[reading]} - #{item["meaning"]}" }
  end

  def vocabulary_type_to_string(item)
    { item["character"] => "#{item["kana"]} - #{item["meaning"]}" }
  end

  def radical_type_to_string(item)
    # TODO: How to deal with radicals with images
    return nil if item["character"].nil?
    { item["character"] => "#{item["meaning"]}" }
  end
end
