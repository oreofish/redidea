require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :password => "foobar",
      :email => "user@example.com",
    }
    @user = User.create(@attr)
    @user2 = Factory(:user)
  end

  it "should have an ideas attribute" do
    @user.should respond_to(:ideas)
  end

  it "should have an like attribute" do
    @user.should respond_to(:likes)
  end
  
  describe 'like' do 
    it "should have a like method" do
      @user.should respond_to(:likes)
    end

    # no unlike case here

    it "should have a liking method" do
      @user.should respond_to(:liking)
    end
    
    it "should have a is_liking? method" do
      @user.should respond_to(:liking?)
    end

    describe 'create like' do 
      before(:each) do 
        @idea2 = Factory(:idea, :user => @user2)
        @user.like!(@idea2, 3)
      end
      
      it "should can like others" do
        @user.should be_liking(@idea2)
      end
      
      it "can check if i like the idea" do
        @user.should be_liking(@idea2)
      end
      
      it "can get all ideas i like" do
        @user.liking.should include(@idea2)
      end
    end
  end
end
