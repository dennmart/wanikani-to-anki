class WanikaniApi
  def initialize(api_key)
    @client = Wanikani::Client.new(api_key: api_key)
  end

  def fetch_critical(params)
    percentage = params[:argument] || 75
    critical_items = @client.critical_items(percentage.to_i)
    add_keys(critical_items)
  end

  def fetch_kanji(params)
    kanji = @client.kanji_list(optional_argument(params))
    kanji.each { |item| item['type'] = 'kanji' }
    add_keys(kanji)
  end

  def fetch_vocabulary(params)
    vocabulary = @client.vocabulary_list(optional_argument(params))
    vocabulary.each { |item| item['type'] = 'vocabulary' }
    add_keys(vocabulary)
  end

  def fetch_radicals(params)
    radicals = @client.radicals_list(optional_argument(params))
    radicals.each { |item| item['type'] = 'radical' }
    add_keys(radicals)
  end

  def fetch_burned(_params)
    burned_items = @client.srs_items_by_type('burned')
    add_keys(burned_items)
  end

  def fetch_recent_unlocks(_params)
    recent_unlocks = @client.recent_unlocks({ limit: 100 })
    add_keys(recent_unlocks)
  end

  private

  def add_key(item)
    type = item['type']
    key1 = type[0, 1]
    key2 = if type == 'radical'
             item['meaning']
           else
             item['character']
           end
    item['key'] = "#{key1}_#{key2}"
  end

  def add_keys(items)
    return items if items.empty?
    items.each { |item| add_key(item) }
  end

  def optional_argument(params)
    return nil if params[:selected_levels] && params[:selected_levels] == 'all'
    params[:argument]
  end
end
