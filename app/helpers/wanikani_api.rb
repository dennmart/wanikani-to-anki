class WanikaniApi
  def self.fetch_critical(params)
    percentage = params[:argument] || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
    add_keys(critical_items)
  end

  def self.fetch_kanji(params)
    kanji = Wanikani::Level.kanji(optional_argument(params))
    kanji.each { |item| item['type'] = 'kanji' }
    add_keys(kanji)
  end

  def self.fetch_vocabulary(params)
    vocabulary = Wanikani::Level.vocabulary(optional_argument(params))
    vocabulary.each { |item| item['type'] = 'vocabulary' }
    add_keys(vocabulary)
  end

  def self.fetch_radicals(params)
    radicals = Wanikani::Level.radicals(optional_argument(params))
    radicals.each { |item| item['type'] = 'radical' }
    add_keys(radicals)
  end

  def self.fetch_burned(_params)
    burned_items = Wanikani::SRS.items_by_type('burned')
    add_keys(burned_items)
  end

  def self.fetch_recent_unlocks(_params)
    recent_unlocks = Wanikani::RecentUnlocks.list(100)
    add_keys(recent_unlocks)
  end

  private_class_method

  def self.add_key(item)
    type = item['type']
    key1 = type[0, 1]
    key2 = if type == 'radical'
             item['meaning']
           else
             item['character']
           end
    item['key'] = "#{key1}_#{key2}"
  end

  def self.add_keys(items)
    return items if items.empty?
    items.each { |item| add_key(item) }
  end

  def self.optional_argument(params)
    return nil if params[:selected_levels] && params[:selected_levels] == 'all'
    params[:argument]
  end
end
