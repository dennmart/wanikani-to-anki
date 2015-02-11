class WanikaniApi
  def self.fetch_critical(params)
    percentage = params[:argument] || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    self.add_keys(critical_items)
  end

  def self.fetch_kanji(params)
    kanji = Wanikani::Level.kanji(optional_argument(params))
    kanji.each { |item| item["type"] = "kanji" }
    self.add_keys(kanji)
  end

  def self.fetch_vocabulary(params)
    vocabulary = Wanikani::Level.vocabulary(optional_argument(params))
    vocabulary.each { |item| item["type"] = "vocabulary" }
    self.add_keys(vocabulary)
  end

  def self.fetch_radicals(params)
    radicals = Wanikani::Level.radicals(optional_argument(params))
    radicals.each { |item| item["type"] = "radical" }
    self.add_keys(radicals)
  end

  def self.fetch_burned(params)
    burned_items = Wanikani::SRS.items_by_type('burned')
    self.add_keys(burned_items)
  end

  def self.fetch_recent_unlocks(params)
    recent_unlocks = Wanikani::RecentUnlocks.list(100)
    self.add_keys(recent_unlocks)
  end

  private

  def self.add_key(item)
    type = item["type"]
    key1 = type[0,1]
    if type == "radical"
      key2 = item["meaning"]
    else
      key2 = item["character"]
    end
    item["key"] = "#{key1}_#{key2}"
  end

  def self.add_keys(items)
    return items if items.empty?
    items.each { |item| self.add_key(item) }
  end

  def self.optional_argument(params)
    if params[:selected_levels] && params[:selected_levels] == "all"
      return nil
    else
      return params[:argument]
    end
  end

end
