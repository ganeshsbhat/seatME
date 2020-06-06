Seatme::Application.routes.draw do
  # The reason we use POST method instead of GET even though it is a data fetch is because:
  # There is a chance we will receive huge payload in the request.
  # GET doesn't support large payload
  post 'seatings/availability', to: 'seatings#availability'
end
