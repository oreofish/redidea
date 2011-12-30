require 'spec_helper'

describe "advises/index.html.erb" do
  before(:each) do
    assign(:advises, [
      stub_model(Advise,
        :content => "Content"
      ),
      stub_model(Advise,
        :content => "Content"
      )
    ])
  end

  it "renders a list of advises" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
end
