class WanikaniApi
  def self.fetch_critical(params)
    percentage = params[:argument] || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    critical_items.map { |item| self.send("#{item["type"]}_type_to_string", item, params[:level_tags]) }.compact
  end

  def self.fetch_kanji(params)
    kanji = Wanikani::Level.kanji(optional_argument(params))
    kanji.map { |item| kanji_type_to_string(item, params[:level_tags]) }.compact
  end

  def self.fetch_vocabulary(params)
    vocabulary = Wanikani::Level.vocabulary(optional_argument(params))
    vocabulary.map { |item| vocabulary_type_to_string(item, params[:level_tags]) }.compact
  end

  def self.fetch_radicals(params)
    radicals = Wanikani::Level.radicals(optional_argument(params))
    radicals.map { |item| radical_type_to_string(item, params[:level_tags]) }.compact
  end

  def self.fetch_burned(params)
    burned_items = Wanikani::SRS.items_by_type('burned')
    burned_items.map { |item| self.send("#{item["type"]}_type_to_string", item, params[:level_tags]) }.compact
  end

  def self.fetch_recent_unlocks(params)
    recent_unlocks = Wanikani::RecentUnlocks.list(100)
    recent_unlocks.map { |item| self.send("#{item["type"]}_type_to_string", item, params[:level_tags]) }.compact
  end

  private

  def self.kanji_type_to_string(item, level_tags)
    reading = item["important_reading"]
    front = item["character"]
    back = "#{item[reading]} - #{item["meaning"]}"
    back = build_level_tags(back, item["level"]) if level_tags
    { front => back }
  end

  def self.vocabulary_type_to_string(item, level_tags)
    front = item["character"]
    back = "#{item["kana"]} - #{item["meaning"]}"
    back = build_level_tags(back, item["level"]) if level_tags
    { front => back }
  end

  def self.radical_type_to_string(item, level_tags)
    # TODO: How to deal with radicals with images
    return nil if item["character"].nil?

    front = item["character"]
    back = "#{item["meaning"]}"
    back = build_level_tags(back, item["level"]) if level_tags
    { front => back }
  end

  def self.optional_argument(params)
    if params[:selected_levels] && params[:selected_levels] == "all"
      return nil
    else
      return params[:argument]
    end
  end

  def self.build_level_tags(value, level)
    { "value" => value, "tags" => ["Level#{level}"] }
  end
end
