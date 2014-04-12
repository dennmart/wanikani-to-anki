Wkanki::App.helpers do
  def set_api_key(api_key)
    Wanikani.api_key = api_key
  end

  def wanikani_user
    return nil if Wanikani.api_key.blank?
    cache_object("wanikani/user/#{Wanikani.api_key}", expires: 300) do
      Wanikani::User.information
    end
  end

  def optional_argument(params)
    if params[:selected_levels] && params[:selected_levels] == "all"
      return nil
    else
      return params[:argument]
    end
  end
end
