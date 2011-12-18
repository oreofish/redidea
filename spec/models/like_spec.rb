require 'spec_helper'

describe Like do
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
    @idea = Factory(:idea, :user => @user)
    @idea2 = Factory(:idea, :user => @user2, :title => Factory.next(:title))
  end

  it "should have a user attribute" do
    @like = @user.likes.build(:idea_id => @idea2.id)
    @like.should respond_to(:user)
  end
  
  it "should have a idea attribute" do
    @like = @user.likes.build(:idea_id => @idea2.id)
    @like.should respond_to(:idea)
  end

  it "should create a new instance given valid attributes" do 
    @like = @user.likes.build(:idea_id => @idea2.id)
    @like.save!
  end
  
  it "should not create like to ideas of itself" do
    @like = @user.likes.build(:idea_id => @idea.id)
    @like.should_not be_valid
  end
  
  it "should create like to ideas of others" do
    @like = @user.likes.build(:idea_id => @idea2.id)
    @like.should be_valid
  end
  
  it "should not create again" do
    @like = @user.likes.build(:idea_id => @idea2.id)
    @like.save!
    @like2 = @user.likes.build(:idea_id => @idea2.id)
    @like2.should_not be_valid
  end
end
