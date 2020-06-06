require 'test_helper'

class SeatingsControllerTest < ActionController::TestCase
  test 'should return best available seats based on json input and bookable seats' do
    seating_info = JSON.parse(File.read('test/fixtures/seatings/valid_seatings_info.json'))
    post :availability, format: :json, seating_info: seating_info, booking_count: 25
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal body, available_seats_success_response_body
  end

  private

  def available_seats_success_response_body
    { 'errors' => [],
      'data' => %w[a3 a2 a4 a1 a5
                   b3 b2 b4 b1 b5
                   c3 c2 c4 c1 c5
                   d3 d2 d4 d1 d5
                   e3 e2 e4 e1 e5] }
  end
end
