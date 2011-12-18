require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :password => "foobar",
      :email => "user@example.com",
    }
  end

  it "should have an ideas attribute" do
    @user = User.create(@attr)
    @user.should respond_to(:ideas)
  end

end
