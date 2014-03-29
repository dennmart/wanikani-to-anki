Wkanki::App.controllers :home do
  get :index, map: '/'  do
    render 'home/index'
  end
end
