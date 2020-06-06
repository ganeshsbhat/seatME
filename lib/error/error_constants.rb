# This module includes all the error constants used globally throughout the application
module Error
  module ErrorConstants
    SEATING_DETAILS_REQUIRED = 'Seating details are missing'.freeze
    BOOKING_COUNT_REQUIRED = 'Please provide the number of seats to be booked'.freeze
    INVALID_SEATING_MESSAGE = 'Invalid Seating information provided'.freeze
    INVALID_ROW_COUNT = 'Row count cannot be above 26'.freeze
    SOLD_OUT_MESSAGE = 'Sorry, we are sold out!'.freeze
  end
end
