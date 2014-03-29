Wkanki::App.controllers :export do
  before do
    set_api_key(session[:wanikani_api_key])
  end

  get :index do
    redirect url(:home, :index) if session[:wanikani_api_key].blank?
    @wanikani_user = Wanikani::User.information
    render 'export/index'
  end
end
