# This controller is responsible for serving the best available seat
class SeatingsController < ApplicationController
  before_filter :validate_availability_request

  # Find the best seat available to book based on the input seating information.
  # * *Params*    :
  # - +booking_count -> (integer) - Number of seats to be booked
  # - +seating_info+ -> (string) - JSON input (in string format) which holds the seating information.
  # * *Returns* :
  #   - Returns available seats
  def availability
    booking_count = params[:booking_count].to_i
    # Call Availability Module to find the best available seats based on the request
    available_seats = Seating::Availability.find(@seating_info, booking_count)
    # Render output json
    render json: { errors: available_seats[:errors],
                   data: available_seats[:data] }
  end

  private

  # Check the complete validation of the request:
  # - Request should have a valid seating information as shown in 'valid_seating_info?'
  # - Rown count should not go above 26 - As we are assigning alphabets to the row
  def validate_availability_request
    return render json: { errors: [SEATING_DETAILS_REQUIRED] }, status: 200 unless params.key?(:seating_info)
    @seating_info = params[:seating_info]
    return render json: { errors: [BOOKING_COUNT_REQUIRED] }, status: 200 unless valid_booking_count?
    return render json: { errors: [INVALID_SEATING_MESSAGE] }, status: 200 unless valid_seating_info?
    return render json: { errors: [INVALID_ROW_COUNT] }, status: 200 unless valid_row_count?
    return render json: { errors: [SOLD_OUT_MESSAGE] }, status: 200 unless seats_present?
  end

  # Venue Layout information is mandatory
  # return false (Invalid) in the following cases:
  # -> if venue layout is not provided
  # -> if rows are missing or if it is negative or zero
  # -> if columns are missing or if it is negative or zero
  def valid_seating_info?
    @seating_info['venue'].present? && @seating_info['venue'].try(:[], 'layout').present? &&
      @seating_info['venue']['layout']['rows'].present? && @seating_info['venue']['layout']['columns'].present? &&
      @seating_info['venue']['layout']['rows'].to_i > 0 && @seating_info['venue']['layout']['columns'].to_i > 0
  end

  # Check if row count is less than 27
  def valid_row_count?
    @seating_info['venue']['layout']['rows'].to_i < 27
  end

  # Check if seats are provided in the request
  def seats_present?
    @seating_info['seats'].present?
  end

  # Check if booking count is valid.
  def valid_booking_count?
    params.key?(:booking_count) && params[:booking_count].to_i > 0
  end
end
