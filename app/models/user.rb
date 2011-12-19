class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :ideas, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  
  has_many :liking, :through => :likes, :source => :idea
  
  def liking?(idea)
    likes.find_by_idea_id(idea)
  end
  
  def like!(idea, score)
    likes.create!(:idea_id => idea, :score => score)
  end
end
