class Like < ActiveRecord::Base
  attr_accessible :idea_id, :score
  
  belongs_to :user
  belongs_to :idea
  
  validates :user_id, :presence => true
  validates :idea_id, :presence => true
  validates :user_id, :idea_id, :uniqueness => true
  validates :score,   :presence     => true,
                      :inclusion => { :in => 0..3 }
end
