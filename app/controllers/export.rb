Wkanki::App.controllers :export do
  before do
    Wanikani.api_key = session[:wanikani_api_key]
  end

  get :index do
    redirect url(:home, :index) if api_key_missing?(session[:wanikani_api_key])
    render 'export/index'
  end

  post :generate do
    begin
      cards = WanikaniApi.send("fetch_#{params[:deck_type]}", params)
    rescue StandardError => e
      flash[:error] = "Whoops! WaniKani sent us the following error message: #{e.message}"
      redirect url(:export, :index)
    end

    if cards.empty?
      flash[:error] = 'There were no items to export! Try changing the parameters for the deck, or try exporting a different deck.'
      redirect url(:export, :index)
    else
      content_type 'text/plain', charset: 'utf-8'
      attachment "#{params[:deck_type]}.txt"
      generate_anki_deck(params[:deck_type], cards)
    end
  end
end
