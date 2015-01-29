module WkankiHelper
  @@WANIKANI_API = "1.2";

  @@HEADERS= ["type", "character", "meaning", "image", "onyomi", "kunyomi", "important_reading", "kana", "level"]

  def headers
    return @@HEADERS
  end

  def set_api_key(api_key)
    Wanikani.api_key = api_key
  end

  def wanikani_user
    return nil if Wanikani.api_key.blank?
    cache_object("wanikani/user/#{Wanikani.api_key}", expires: 300) do
      Wanikani::User.information
    end
  end

  def generate_anki_deck(type, cards)
    anki = Anki::Deck.new(card_headers: headers, card_data: cards)
    deck = deck_comments_header(type)
    deck += anki.generate_deck
  end

  private

  def deck_comments_header(type)
    deck = "# WaniKani - #{type.chomp.sub(/./, &:upcase).tr('_', ' ')}\n"
    deck += "# Generated on #{Time.now.strftime('%B %d, %Y %H:%M %p %Z')}\n"
    deck += "# WaniKani to Anki Exporter (http://wanikanitoanki.com)\n"
    deck
  end
end

Wkanki::App.helpers WkankiHelper
