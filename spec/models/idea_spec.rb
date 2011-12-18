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
  
  it "should not create without content" do 
    no_content_idea = @user.ideas.new(@attr.merge(:content => ""))
    no_content_idea.should_not be_valid
  end

  it "should not create with too short content" do 
    short_content = "a" * 5
    short_idea = @user.ideas.new(@attr.merge(:content => short_content))
    short_idea.should_not be_valid
  end

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

  it "should not create idea with same title" do 
    @user.ideas.create!(@attr)
    idea = @user.ideas.new(@attr)
    idea.should_not be_valid
  end

  it "should store right idea" do 
    long_idea = @user.ideas.create!(@attr)
    long_idea.reload.user_id == @attr[:user_id]
    long_idea.reload.title == @attr[:title]
    long_idea.reload.content == @attr[:content]
  end

  describe "idea associations" do
    before(:each) do
      @idea1 = Factory(:idea, :user => @user, :created_at => 1.day.ago)
      @idea2 = Factory(:idea, :user => @user, :title => Factory.next(:title), :created_at => 1.hour.ago)
    end

    it "should have the right ideas in the right order" do
      @user.ideas.should == [@idea1, @idea2]
    end

    it "should destroy associated ideas" do
      @user.destroy
      [@idea1, @idea2].each do |idea|
        @user.ideas.find_by_id(idea.id).should be_nil
      end
    end
  end

  describe "user associations" do
    before(:each) do
      @idea = @user.ideas.create(@attr)
    end

    it "should have a user attribute" do
      @idea.should respond_to(:user)
    end

    it "should have the right associated user" do
      @idea.user_id.should == @user.id
      @idea.user.should == @user
    end
  end
end
