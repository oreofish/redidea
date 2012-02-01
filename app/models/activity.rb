# == Schema Information
#
# Table name: activities
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  name       :string(255)
#  describe   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
  has_many :ideas, :dependent => :destroy
  belongs_to :user
  attr_accessible :name, :describe, :created_at
  
  validates :name,     :presence => true, :length => { :within => 3..10 }
  validates :describe, :presence => true, :length => { :within => 3..255 }
end
