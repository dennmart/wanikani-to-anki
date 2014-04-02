Wkanki::App.helpers do
  def set_api_key(api_key)
    Wanikani.api_key = api_key
  end

  def optional_argument(params)
    if params[:selected_levels] && params[:selected_levels] == "all"
      return nil
    else
      return params[:argument]
    end
  end
end
