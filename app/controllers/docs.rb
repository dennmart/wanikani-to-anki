Wkanki::App.controllers :docs do
  get :index do
    @docs = [ 
      { "file" => "how_to_import_into_anki" }
    ]
    render 'docs/index'
  end

  get :show, :with => :id do
    @doc = { "file" => "how_to_import_into_anki" }
    render 'docs/show'
  end
end
