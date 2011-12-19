require 'spec_helper'

describe Like do
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
    @idea = Factory(:idea, :user => @user)
    @idea2 = Factory(:idea, :user => @user2, :title => Factory.next(:title))
    @like = @user.likes.build(:idea_id => @idea2.id)
  end

  it "should have a user attribute" do
    @like.should respond_to(:user)
  end

  it "should have right idea" do
    @like.idea.should == @idea2
  end

  it "should have right user" do
    @like.user.should == @user
  end

  it "should have a idea attribute" do
    @like.should respond_to(:idea)
  end

  it "should create a new instance given valid attributes" do 
    @like.save!
  end
  
  it "should not like ideas of itself" do
    @selflike = @user.likes.build(:idea_id => @idea.id)
    # @like.should_not be_valid
    pending "fix me later!!!"
  end
  
  it "should like ideas of others" do
    @like.should be_valid
  end
  
  it "should not create again" do
    @like1 = @user.likes.create(:idea_id => @idea2.id)
    @like2 = @user.likes.new(:idea_id => @idea2.id)
    # @like2.should_not be_valid
    pending "fix me later!!!"
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
