# == Schema Information
#
# Table name: ideas
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  title      :string(255)
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
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

  describe "title verify" do
    it "should create a new idea with attr" do
      @user.ideas.create!(@attr)
    end
    
    it "should not create without title" do 
      no_title_idea = @user.ideas.new(@attr.merge(:title => ""))
      no_title_idea.should_not be_valid
    end
  
    it "should not create with long title" do 
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
    #it "should not create with too short content" do 
    #  short_content = "a" * 5
    #  short_idea = @user.ideas.new(@attr.merge(:content => short_content))
    #  short_idea.should_not be_valid
    #end
  
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
 
  describe "has attributes" do
    before(:each) do
      idea = @user.ideas.new(@attr)
    end

    it "shoulde respond to likes" do
      idea.should respond_to(:likes)
    end

    it "shoulde belong to user" do
      idea.should respond_to(:user)
    end
  end
  
  describe "idea associations" do
    before(:each) do
      @idea1 = Factory(:idea, :user => @user, :created_at => 1.day.ago)
      @idea2 = Factory(:idea, :user => @user, :title => Factory.next(:title), :created_at => 1.hour.ago)
    end

    it "should have the right ideas in the right order" do
      @user.ideas.should == [@idea1, @idea2]
    end
  end

  describe "user associations" do
    it "should have a user attribute" do
      @idea.should respond_to(:user)
    end
  end
  
  describe "like associated" do 
    before(:each) do
      @idea = @user.ideas.create(@attr)
    end

    it "should have an like attribute" do
      @idea.should respond_to(:likes)
    end
    
    it "should have an liked_by attribute" do
      @idea.should respond_to(:liked_by)
    end
  end
    
  describe 'test function like! and liked_by' do 
    before(:each) do 
      @user2 = Factory(:user, :email => Factory.next(:email))
      @user2.like!(@idea.id, 3)
    end
    
    it "should save right score" do
      Like.score(@user2.id, @idea.id) == 3
    end
    
    it "can check if the idea liked by user" do
      @idea.should be_liked_by(@user2)
    end
    
    it "can get all ideas the user like" do
      @idea.liked_by.should include(@user2)
    end
  end
end
