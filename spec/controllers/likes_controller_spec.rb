require 'spec_helper'

describe LikesController do
  describe "access deny" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "after logged in" do 
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
    end
    
    describe "POST create" do
      before(:each) do 
        @idea = Factory(:idea, :user => @user)
        @user2 = Factory(:user, :email => Factory.next(:email))
        @idea2 = Factory(:idea, :user => @user2, :title => Factory.next(:title))
      end

      describe "with valid params" do
        it "creates a new Like to others idea" do
          expect {
            get :create, :idea_id => @idea2.id, :score => 1
          }.to change(Like, :count).by(1)
        end

        it "should not create a new Like to my idea" do
          expect {
            get :create, :idea_id => @idea.id, :score => 1
          }.to change(Like, :count).by(0)
        end

	it "should not create a Like to others idea twice" do
          get :create, :idea_id => @idea2.id, :score => 1
          expect {
            get :create, :idea_id => @idea2.id, :score => 1
          }.to change(Like, :count).by(0)
        end

     
        it "redirects to the root" do
          get :create, :idea_id => @idea2.id, :score => 1
          response.should redirect_to(root_path)
        end
      end

      describe "with invalid params" do
        it "redirects to the ideas" do
          # Trigger the behavior that occurs when invalid params are submitted
          Like.any_instance.stub(:save).and_return(false)
          post :create, :like => {}
          response.should redirect_to(root_path)
        end
      end
    end
  end
end
