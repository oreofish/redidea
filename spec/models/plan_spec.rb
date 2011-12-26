# == Schema Information
#
# Table name: plans
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  title      :string(255)
#  plan       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Plan do
  pending "add some examples to (or delete) #{__FILE__}"
end
