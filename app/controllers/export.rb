Wkanki::App.controllers :export do
  before do
    set_api_key(session[:wanikani_api_key])
  end

  get :index do
    redirect url(:home, :index) if session[:wanikani_api_key].blank?
    @wanikani_user = Wanikani::User.information
    render 'export/index'
  end

  post :generate do
    generator = AnkiDeck.new(params[:deck_type], optional_argument(params))
    deck = generator.generate_deck

    if deck.nil?
      flash[:error] = "There were no items to export! Try changing the parameters for the deck, or try exporting a different deck."
      redirect url(:export, :index)
    else
      content_type 'text/plain', charset: 'utf-8'
      attachment "#{params[:deck_type]}.txt"
      deck
    end
  end
end
