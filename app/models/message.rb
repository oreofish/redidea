# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
class Message < ActiveRecord::Base
  attr_accessible :content
  validates :content, :presence => true
end
