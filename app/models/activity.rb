# == Schema Information
#
# Table name: activities
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  name       :string(255)
#  describe   :text
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
  has_many :ideas, :dependent => :destroy
  belongs_to :user
  attr_accessible :name, :describe, :created_at
  
  validates :name,     :presence => true, :length => { :within => 3..10 }
  validates :describe, :presence => true, :length => { :within => 3..65535 }
end
