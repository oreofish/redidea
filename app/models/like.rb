# == Schema Information
#
# Table name: likes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  idea_id    :integer
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Like < ActiveRecord::Base
  attr_accessible :idea_id, :score
  
  belongs_to :user
  belongs_to :idea
  
  validates :user_id, :presence => true
  validates :idea_id, :presence => true
  #validates :user_id, :idea_id, :uniqueness => true # this can not work with sqlite3
  validates :score,   :presence     => true,
                      :numericality => true,
                      :inclusion    => { :in => 0..3 } # this can not work with sqlite3
  
  def getScore(user_id, idea_idn)
    like = Like.find(:first, :conditions => "user_id = #{user_id} and idea_id = #{idea_id}")
    like.score if like
  end
end
