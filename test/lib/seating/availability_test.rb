require 'test_helper'
require 'minitest/autorun'

class Seating::AvailabilityTest < ActiveSupport::TestCase
  setup do
    @seating_info = JSON.parse(File.read('test/fixtures/seatings/valid_seatings_info.json'))
  end

  test 'should return best available seats' do
    available_seats = Seating::Availability.find(@seating_info, 5)
    assert_equal available_seats, status: true, data: %w[a3 a2 a4 a1 a6], errors: []
  end
end
