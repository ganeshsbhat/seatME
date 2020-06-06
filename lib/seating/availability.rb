# This module will find the best available seats based on the seating info and booking count
module Seating
  module Availability
    class << self
      require 'matrix'

      include Error::ErrorConstants

      # This method will handle the business logic to find the best seats
      def find(seating_info, requested_booking_count)
        errors = []
        # Throw error if seating information is not valid

        # Find number of rows and columns based on the input
        no_of_rows = seating_info['venue']['layout']['rows'].to_i
        no_of_columns = seating_info['venue']['layout']['columns'].to_i

        # Build seating arrangement using MATRIX
        # Eg: 3x3 Seating looks like
        # a1 a2 a3
        # b1 b2 b3
        # c1 c2 c3
        seating_arrangement = Matrix.build(no_of_rows, no_of_columns) { |row, col| rows_info[row] + (col + 1).to_s }

        available_seats = find_available_seats(seating_info)
        # For even number of columns we will have two middle indices
        # This is because, our requirement needs only one of the middle element to be chosen at first
        # For both odd and even number of columns, we find the middle index this way -> (Total Columns / 2)
        middle_index = no_of_columns / 2

        # Call method to find the best seats based on the request.
        bookable_seats = find_best_available_seats(seating_arrangement, available_seats, middle_index, requested_booking_count)

        errors << "We have only #{bookable_seats.count} seat(s) available!" if bookable_seats.count < requested_booking_count &&
                                                                               !bookable_seats.count.zero?
        errors << SOLD_OUT_MESSAGE if bookable_seats.count.zero?

        { status: errors.empty?, data: errors.empty? ? bookable_seats : {}, errors: errors }
      end

      private

      def find_best_available_seats(seating_arrangement, available_seats, middle_index, requested_booking_count)
        bookable_seats = []
        seating_arrangement.each_with_index do |_value, row, column|
          # To elimimate repetition of the elements, we need to break if column is greater than middle index
          next if (middle_index - column) < 0

          # Middle element will be the best seat available
          # Following logic is used to calculate the best seat:
          # 1. Check for the possible seat in the middle, if it is available push it to an array that stores the available seats
          # 2. We need to perform this only once, so return if column index is 0
          # 3. Look up for the adjacent index on the left of the middle element
          # 4. Look up for the adjacent index on the right of the middle element
          # 5. Scan the whole matrix with this approach
          # 6. If bookable seats counts hit the target, break from the loop
          seat = seating_arrangement[row, middle_index - column]
          bookable_seats << seat if available_seats.include?(seat)
          break if bookable_seats.count == requested_booking_count
          next if column.zero?

          seat = seating_arrangement[row, middle_index + column]
          bookable_seats << seat if available_seats.include?(seat)
          break if bookable_seats.count == requested_booking_count
        end
        bookable_seats
      end

      # Each alphabet will represent the seating information
      # for Eg: { 0 => "a", 1 => "b", 2 => "c" }
      # Each index will be assigned an alphabet.
      # You might be wondering what if there are more than 26 rows in the request!!!
      # Well, we should throw error saying that we don't support it!
      def rows_info
        @rows ||= assign_alphabet_to_rows
      end

      def assign_alphabet_to_rows
        rows = {}.tap do |row_hash|
          ('a'..'z').to_a.each_with_index do |alphabet, index|
            row_hash[index] = alphabet
          end
        end
        rows
      end

      # Find out all the available seats from the seats provided in the input
      def find_available_seats(seating_info)
        available_seats = []
        seating_info['seats'].each do |seat, details|
          next unless details['status'] == 'AVAILABLE'
          available_seats << seat
        end
        available_seats
      end
    end
  end
end
