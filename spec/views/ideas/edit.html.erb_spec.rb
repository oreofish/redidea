require 'spec_helper'

describe "ideas/edit.html.erb" do
  before(:each) do
    @idea = assign(:idea, stub_model(Idea,
      :user_id => 1,
      :title => "MyString",
      :content => "MyString"
    ))
  end

  it "renders the edit idea form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ideas_path(@idea), :method => "post" do
      assert_select "input#idea_user_id", :name => "idea[user_id]"
      assert_select "input#idea_title", :name => "idea[title]"
      assert_select "input#idea_content", :name => "idea[content]"
    end
  end
end
