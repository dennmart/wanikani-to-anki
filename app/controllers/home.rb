Wkanki::App.controllers :home do
  get :index, map: '/' do
    render 'home/index'
  end

  get :raise_error, map: '/raise_error' do
    raise 'Testing raised errors!'
  end
end
