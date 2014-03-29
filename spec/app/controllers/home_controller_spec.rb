require 'spec_helper'

describe "HomeController" do
  it "should render" do
    get '/'
    last_response.should be_ok
  end
end
