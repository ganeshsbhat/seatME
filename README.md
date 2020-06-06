# seatME

A simple application built in Ruby on Rails to assign you the best seat based on the availability.

This app takes the following inputs:
 - seating_info -> JSON input that specifies the total seats available
 - booking_count -> Number of seats to be booked

## Local Setup

Install required gems:

    bundle install

### UI App

The frontend app is built in React. You will need to install it.

### Test Suite

    rake minitest

#### Developer Note: You can always check the coverage of the app by using following command:

    rake minitest COVERAGE=true

This will generate a coverage folder in the application, which contains index.html file with coverage details of the application. 

### Rails APP

Start the Rails server:

    rails server

### How to use?

When your server is up and running, go to localhost:3000, provide a JSON in the text area provided, also the seats to be booked. When submitting the request, you will be displayed the best seating position(s).

A sample JSON is provided below:

   ```{
      "venue": {
        "layout": {
            "rows": 10,
            "columns": 50
        }
       },
      "seats": {
        "a1": {
            "id": "a1",
            "row": "a",
            "column": 1,
            "status": "AVAILABLE"
        },
        "b6": {
            "id": "b6",
            "row": "b",
            "column": 5,
            "status": "AVAILABLE"
        },
        "c7": {
            "id": "c7",
            "row": "c",
            "column": 7,
            "status": "AVAILABLE"
        },
        "b8": {
            "id": "b8",
            "row": "b",
            "column": 8,
            "status": "AVAILABLE"
        }
      }
   }
   ```
