# == Schema Information
#
# Table name: plans
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  title      :string(255)
#  plan       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Plan do
  before(:each) do
    @attr = {
      :title => "foobar",
      :plan => "/file/path",
    }
    @user = Factory(:user)
  end
  
#  it "should create with user and attr" do 
#    plan = @user.plans.build(@attr)
#    plan.save!
#  end
  
  describe "attribute" do 
    before(:each) do 
      @plan = @user.plans.create(@attr)
    end
    
    it "should have a user attribute" do
      @plan.should respond_to(:user)
      @plan.should respond_to(:plan_url)
      @plan.should respond_to(:remote_plan_url)
      @plan.should respond_to(:plan_cache)
    end
  end
end
