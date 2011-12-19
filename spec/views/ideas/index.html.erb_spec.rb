require 'spec_helper'

describe "ideas/index.html.erb" do
  before(:each) do
    assign(:ideas, [
      stub_model(Idea,
        :title => "Title",
        :content => "Content"
      ),
      stub_model(Idea,
        :title => "Title",
        :content => "Content"
      )
    ])
    
    assign(:idea, stub_model(Idea,
      :title => "MyString",
      :content => "MyString"
    ).as_new_record)
  end

  it "renders a list of ideas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
  
  it "renders a list of ideas" do
    render
    # link to others' ideas
    rendered.should have_selector("a",   :href => ideas_path,
                                         :content => "ideas") 
    # link to mine 
    rendered.should have_selector("a",   :href => "#{ideas_path}?scope=mine",
                                         :content => "mine") 
  end
  it "has link of like for ideas" do
    # link to like

    rendered.should have_selector("a",   :href => "scope=1",
                                  :content => "tread") 

    rendered.should have_selector("a",	 :content => "like") 

    rendered.should have_selector("a",   :content => "surprise") 

    rendered.should have_selector("a",   :content => "soy") 
  end

  # case from new
  it "renders new idea form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ideas_path, :method => "post" do
      assert_select "input#idea_title", :name => "idea[title]"
      assert_select "input#idea_content", :name => "idea[content]"
    end
  end

end
