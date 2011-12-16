require 'spec_helper'

describe "ideas/index.html.erb" do
  before(:each) do
    assign(:ideas, [
      stub_model(Idea,
        :user_id => 1,
        :title => "Title",
        :content => "Content"
      ),
      stub_model(Idea,
        :user_id => 1,
        :title => "Title",
        :content => "Content"
      )
    ])
    
    assign(:idea, stub_model(Idea,
      :user_id => 1,
      :title => "MyString",
      :content => "MyString"
    ).as_new_record)
  end

  it "renders a list of ideas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
  
  # case from new
  it "renders new idea form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ideas_path, :method => "post" do
      assert_select "input#idea_user_id", :name => "idea[user_id]"
      assert_select "input#idea_title", :name => "idea[title]"
      assert_select "input#idea_content", :name => "idea[content]"
    end
  end

end
