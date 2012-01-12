# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  user_id          :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
