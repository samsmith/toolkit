# == Schema Information
#
# Table name: group_profiles
#
#  id                   :integer          not null, primary key
#  group_id             :integer          not null
#  description          :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  location             :spatial({:srid=>
#  joining_instructions :text
#

class GroupProfile < ActiveRecord::Base
  include Locatable

  attr_accessible :description, :joining_instructions, :loc_json

  belongs_to :group
end
