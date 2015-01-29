class WanikaniApi
  def self.fetch_critical(params)
    percentage = params[:argument] || 75
    critical_items = Wanikani::CriticalItems.critical(percentage.to_i)
  end

  def self.fetch_kanji(params)
    kanji = Wanikani::Level.kanji(optional_argument(params))
    kanji.each { |item| item[:type] = "kanji" }
    return kanji
  end

  def self.fetch_vocabulary(params)
    vocabulary = Wanikani::Level.vocabulary(optional_argument(params))
    vocabulary.each { |item| item[:type] = "vocabulary" }
    return vocabulary
  end

  def self.fetch_radicals(params)
    radicals = Wanikani::Level.radicals(optional_argument(params))
    radicals.each { |item| item[:type] = "radical" }
    return radicals
  end

  def self.fetch_burned(params)
    burned_items = Wanikani::SRS.items_by_type('burned')
  end

  def self.fetch_recent_unlocks(params)
    recent_unlocks = Wanikani::RecentUnlocks.list(100)
  end

  private

  def self.optional_argument(params)
    if params[:selected_levels] && params[:selected_levels] == "all"
      return nil
    else
      return params[:argument]
    end
  end

end
