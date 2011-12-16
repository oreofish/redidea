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
end
