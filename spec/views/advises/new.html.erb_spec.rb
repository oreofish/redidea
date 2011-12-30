require 'spec_helper'

describe "advises/new.html.erb" do
  before(:each) do
    assign(:advise, stub_model(Advise,
      :content => "MyString"
    ).as_new_record)
  end

  it "renders new advise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => advises_path, :method => "post" do
      assert_select "input#advise_content", :name => "advise[content]"
    end
  end
end
