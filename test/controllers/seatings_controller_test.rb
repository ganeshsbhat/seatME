require 'test_helper'
require 'minitest/autorun'

class SeatingsControllerTest < ActionController::TestCase
  setup do
    @seating_info = JSON.parse(File.read('test/fixtures/seatings/valid_seatings_info.json'))
  end

  test 'should return best available seats based on json input and bookable seats' do
    post :availability, format: :json, seating_info: @seating_info, booking_count: 25
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal body, available_seats_success_response_body
  end

  test 'should throw error if no venue details provided' do
    @seating_info['venue'] = {}
    post :availability, format: :json, seating_info: @seating_info, booking_count: 5
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Invalid Seating information provided']
  end

  test 'should throw error if more than 26 rows requested' do
    @seating_info['venue']['layout']['rows'] = 27
    post :availability, format: :json, seating_info: @seating_info, booking_count: 5
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Row count cannot be above 26']
  end

  test 'should throw error if no seats are provided in the request' do
    @seating_info['seats'] = {}
    post :availability, format: :json, seating_info: @seating_info, booking_count: 5
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Sorry, we are sold out!']
  end

  test 'should throw error if no seats are available' do
    seating_info = JSON.parse(File.read('test/fixtures/seatings/seatings_info_without_availability.json'))
    post :availability, format: :json, seating_info: seating_info, booking_count: 5
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Sorry, we are sold out!'], 'data' => {}
  end

  test 'should throw error more seats requested than available count' do
    post :availability, format: :json, seating_info: @seating_info, booking_count: 100
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['We have only 25 seat(s) available!'], 'data' => {}
  end

  test 'should throw error if booking count is missing in the request' do
    post :availability, format: :json, seating_info: @seating_info
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Please provide the number of seats to be booked']
  end

  test 'should throw error if seating info is missing in the request' do
    post :availability, format: :json, booking_count: 10
    assert_response 422
    body = JSON.parse(response.body)
    assert_equal body, 'errors' => ['Seating details are missing']
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
