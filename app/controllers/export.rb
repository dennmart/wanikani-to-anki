Wkanki::App.controllers :export do
  post :login, map: '/login' do
    Wanikani.api_key = params[:wanikani_api_key]

    if Wanikani.valid_api_key?
      session[:wanikani_api_key] = Wanikani.api_key
      redirect url(:export, :index)
    else
      flash[:error] = "Bummer... Your WaniKani key is not valid! Check your settings on WaniKani's page."
      redirect url(:home, :index)
    end
  end

  get :index, map: '/export' do
    redirect url(:home, :index) if session[:wanikani_api_key].blank?

    Wanikani.api_key = session[:wanikani_api_key]
    @wanikani_user = Wanikani::User.information
    render 'export/index'
  end

  delete :logout, map: '/logout' do
    session[:wanikani_api_key] = nil
    redirect url(:home, :index)
  end
end
