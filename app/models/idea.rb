# == Schema Information
#
# Table name: ideas
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Idea < ActiveRecord::Base
  acts_as_commentable
  
  validates :content, :presence     => true,
                      :length       => { :maximum => 400 }
  validates :title,   :presence     => true,
                      :length       => { :maximum => 30 }
  validates :user_id, :presence => true

  belongs_to :user 
  attr_accessible :title, :created_at, :content

  has_many :likes, :dependent => :destroy
  has_many :liked_by, :through => :likes, :source => :user

  def liked_by?(user)
    likes.find_by_user_id(user)
  end
end
