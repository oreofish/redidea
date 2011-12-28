# == Schema Information
#
# Table name: likes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  idea_id    :integer
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Like do
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
    @idea = Factory(:idea, :user => @user)
    @idea2 = Factory(:idea, :user => @user2, :title => Factory.next(:title))
    @like = @user.likes.build(:idea_id => @idea2.id, :score => 1)
  end

  it "should create a new instance with given valid attributes" do 
    @like.save!
  end
  
  it "should delete" do 
    @like.save
    @like.destroy
  end
  
  it "should not create with same idea and user" do
    @like.save!
    @like2 = @user.likes.new(:idea_id => @idea2.id)
    @like2.should_not be_valid
  end

  it "should not create like with score larger than 4" do
    @like.score = 4
    @like.should_not be_valid
  end

  it "should not create like with score less than 0" do
    @like.score = -1
    @like.should_not be_valid
  end
  
  it "should not create like with score string" do
    @like.score = "aa"
    @like.should_not be_valid
  end
  
  describe User do 
    it "should have a user attribute" do
      @like.should respond_to(:user)
    end
    
    it "should have right user" do
      @like.user.should == @user
    end
    
    it "should not like ideas of itself" do
      @selflike = @user.likes.build(:idea_id => @idea.id)
      # @like.should_not be_valid
      pending "fix me later!!!"
    end
    
    it "should like ideas of others" do
      @like.should be_valid
    end
  end

  describe Idea do 
    it "should have a idea attribute" do
      @like.should respond_to(:idea)
    end
    
    it "should have right idea" do
      @like.idea.should == @idea2
    end
  end

  describe "validations" do
    it "should require a user" do
      @like.user_id = nil
      @like.should_not be_valid
    end

    it "should require a idea" do
      @like.idea_id = nil
      @like.should_not be_valid
    end
  end
end
