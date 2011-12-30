require 'spec_helper'

describe "advises/edit.html.erb" do
  before(:each) do
    @advise = assign(:advise, stub_model(Advise,
      :content => "MyString"
    ))
  end

  it "renders the edit advise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => advises_path(@advise), :method => "post" do
      assert_select "input#advise_content", :name => "advise[content]"
    end
  end
end
