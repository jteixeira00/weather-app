# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  elevation  :float
#  latitude   :float
#  longitude  :float
#  timezone   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_latitude_and_longitude  (latitude,longitude) UNIQUE
#
require "test_helper"

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
