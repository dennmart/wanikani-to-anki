require 'spec_helper'

describe "HomeController" do
  it "should render" do
    get '/'
    expect(last_response).to be_ok
  end
end
