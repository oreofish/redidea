# == Schema Information
#
# Table name: ideas
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  activity_id :integer(4)      default(1)
#

require 'spec_helper'

describe Idea do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :title => "title",
      :content => "test content"
    }
  end

  it "should not be created without user" do 
    idea = Idea.new(@attr)
    idea.should_not be_valid
  end
  
  describe "title verify" do
    it "should create a new idea with attr" do
      @user.ideas.create!(@attr)
    end
    
    it "should not create without title" do 
      no_title_idea = @user.ideas.new(@attr.merge(:title => ""))
      no_title_idea.should_not be_valid
    end
    
    it "should create with long title" do 
      long_title = "a" * 30
      long_idea = @user.ideas.new(@attr.merge(:title => long_title))
      long_idea.save
      long_idea.reload.title == long_title
    end
    
    it "should not create with too long title" do 
      long_title = "a" * 31
      long_idea = @user.ideas.new(@attr.merge(:title => long_title))
      long_idea.should_not be_valid
    end
  
  end

  describe "content verify" do
    it "should not create without content" do 
      no_content_idea = @user.ideas.new(@attr.merge(:content => ""))
      no_content_idea.should_not be_valid
    end
  
    # we allow to create short idea
  
    it "should create with long content" do 
      long_content = "a" * 400
      long_idea = @user.ideas.new(@attr.merge(:content => long_content))
      long_idea.save
      long_idea.reload.content == long_content
    end
  
    it "should not create with too long content" do 
      long_content = "a" * 401
      long_idea = @user.ideas.new(@attr.merge(:content => long_content))
      long_idea.should_not be_valid
    end
  end
  
  describe "associations" do
    before(:each) do
      @idea = @user.ideas.create(@attr)
    end
    
    describe "user associations" do
      it "should have a user attribute" do
        @idea.should respond_to(:user)
      end
    end
    
    describe "like associates" do 
      it "should have an like attribute" do
        @idea.should respond_to(:likes)
      end
    end

    describe "like_by associates" do 
      before(:each) do
        @user2 = Factory(:user, :email => Factory.next(:email))
        @user2.like!(@idea.id, 3)
      end
      
      it "should have an liked_by attribute" do
        @idea.should respond_to(:liked_by)
      end
      
      it "can get all ideas the user like" do
        @idea.liked_by.should include(@user2)
      end
    end
  end
  
  describe 'test function liked_by?' do 
    before(:each) do 
      @idea = @user.ideas.create(@attr)
      @user2 = Factory(:user, :email => Factory.next(:email))
      @user2.like!(@idea.id, 3)
    end
    
    it "can check if the idea liked by user" do
      @idea.should be_liked_by(@user2)
    end
  end
end
