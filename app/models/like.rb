class Like < ActiveRecord::Base
  attr_accessible :idea_id, :score
  
  belongs_to :user
  belongs_to :idea
  
  validates :user_id, :presence => true
  validates :idea_id, :presence => true
end
