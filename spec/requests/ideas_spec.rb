require 'spec_helper'

describe "Ideas" do
  describe "GET /ideas" do
    it "should be redirect_to sign_in page" do
      get ideas_path
      response.should redirect_to(new_user_session_path)
    end
    
    describe "after logged in" do
      before(:each) do
        @user = Factory(:user)
        visit new_user_session_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a signout link" do
        get ideas_path
        response.should have_selector("a", :href => destroy_user_session_path,
                                      :content => "Sign out")
      end
    end
  end
end
