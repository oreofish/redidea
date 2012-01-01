# == Schema Information
#
# Table name: advises
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Advise < ActiveRecord::Base
  validates :content, :presence     => true,
                      :length       => { :maximum => 255 }
end
