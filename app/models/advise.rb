class Advise < ActiveRecord::Base
  validates :content, :presence     => true
end
