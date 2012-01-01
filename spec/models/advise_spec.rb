# == Schema Information
#
# Table name: advises
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Advise do
  before(:each) do 
    @user = Factory(:user)
    @attr = {:content => "test content"}
  end
  
  it "should create" do 
    Advise.create!(@attr)
  end
  
  it "should reject without content" do 
    advise = Advise.new(@attr.merge(:content => nil))
    advise.should_not be_valid
  end
  
  it "should reject too long content" do 
    too_long_content = 'a' * 256
    advise = Advise.new(@attr.merge(:content => too_long_content))
    advise.should_not be_valid
  end
end
