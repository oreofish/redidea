# == Schema Information
#
# Table name: activities
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  name       :string(255)
#  describe   :string(255)
#  owner_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
end
