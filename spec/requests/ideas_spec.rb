require 'spec_helper'

describe "Ideas" do
  describe "GET /ideas" do
    it "should have sign_in/sign_up links" do
      get ideas_path
      response.should have_selector("a", :href => new_user_session_path,
                                    :content => "Sign in")
      response.should have_selector("a", :href => new_user_registration_path,
                                    :content => "Sign up")
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
