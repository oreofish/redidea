require 'spec_helper'

describe "advises/show.html.erb" do
  before(:each) do
    @advise = assign(:advise, stub_model(Advise,
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content/)
  end
end
