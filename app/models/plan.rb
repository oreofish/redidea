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

class Plan < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :plan, :plan_url,
                  :remote_plan_url, :plan_cache, :remote_plan

  validates :title,   :presence     => true,
                      :length  => { :within => 3..255 }
  validates :plan,    :presence     => true
  validates :user_id, :presence => true

  belongs_to :user 

  mount_uploader :plan, PlanUploader
  
end

