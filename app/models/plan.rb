class Plan < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :user_id,
    :plan, :plan_url, :remote_plan_url, :plan_cache, :remote_plan

  validates :title,   :presence     => true
  validates :user_id, :presence => true

  belongs_to :user 

  mount_uploader :plan, PlanUploader
  
end
