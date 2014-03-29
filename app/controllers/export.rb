Wkanki::App.controllers :export do
  get :index, map: '/export' do
    redirect url(:home, :index) if session[:wanikani_api_key].blank?

    Wanikani.api_key = session[:wanikani_api_key]
    @wanikani_user = Wanikani::User.information
    render 'export/index'
  end
end
