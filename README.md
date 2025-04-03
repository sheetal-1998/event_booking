# Event booking system

## Versions Used
* Ruby - 3.4
* Rails - 8.0.2
* Mysql - 8.0.41

## Table Structure
* User - Includes both organizer and customer identified by usertype field, have additional fields firstname, lastname, mobile
* Event - Includes Events created by organizer, have fields event_name, venue, date, etc
* EventTicket - Include types of event_tickets each Event will have with attributes ticket_type, price and available_seats. currently ticket_type is added as enum with values VIP and general, We can also create another table to store the TicketTypes and associate it with EventTickets
* Booking - Includes all the booking made by customer. Includes fields event_ticket_id, amout and number_of_seats

## API and Code Explanation

* Used devise and devise_auth_token gem for authentication. Both organizer and customer can signup and login using auth API's. usertype param should be passed to indentify user.
* Event can be only created,viewed, updated and deleted by organizer. customer can View all the Event available details (Index API). Authorization is added in controller
* While creating and updating the events, organizer can also add event_tickets along with by passing event_tickets_attributes in payload.
* Customer can create the bookings for any event with available seats for required ticket type. while booking, the amount will be calculated for number_of_seats booked and available_seats will be updated from event_tickets table.
* Customer can only view all the bookings created by him using customer_bookings API. organizer can view all the bookings
* If the booking is deleted, available_seats of event_tickets will be updated again.
* sidekiq gem is used for background jobs while creating booking to send email to customer and also upon updating the event.


## API Curl
#### User signup
```sh
  curl --location 'localhost:3000/auth' \
--header 'Content-Type: application/json' \
--header 'Cookie: _interslice_session=w0icSWtSOSMapxhYBK13eXxGnRQhg%2FOZfD2LUEJqsRzQYyfagczGRr2Pn%2BJBdprvw7NAXMJFKksIOaBA5tElg5mU7DyExGWkKHtsxqAzD744x48ITEtZNSJD96Hhde%2B3Lz7K%2FX84wsBr2px7kk%2FCtIFOdednK3SnXe6ku6WO9BMfCWBLAOukXBXVyEZ%2BxLeGoZ5J3t5lni7JP1uyo4Oo2ByJw7XoqC0pOzw5lKkgGPooZWu0NID7bZ%2FslhJrfVraXBib6gTtRd01j8MPLavkTdmLApwrZ5LYVxu7--J4VNn8BKbTWWGLES--l3UkF3IG4M4336mTvzwDig%3D%3D' \
--data-raw '{ "email": "sheetal4@example.com", "password": "password123", "password_confirmation": "password123", "usertype": "customer", "firstname": "sheetal4", "lastname": "jadhav", "mobile": "7765676593" }'
```
#### User login
```sh
curl --location 'localhost:3000/auth/sign_in' \
--header 'Content-Type: application/json' \
--header 'Cookie: _interslice_session=HrSbHl06cepDTXu2wSS%2FtrJl02g6q0uS8Sg9mRvQ24XOG8BqIHXVXrJs%2BQZQsmYuZww45jrVpob5i1J0c8HrA%2BFLhwOv2QLNdWcW1qw%2F%2F6qxzMlMb7ThCW4C%2F6b%2BJeEkblhYgLB%2BhDyyLxOHWl9EQ900Nt0JS4vZpj%2FzX5B93wo4DTHgpwtjP7TkjMm2I9q%2F%2BL%2B8Pq0kJvD1w1qToSNRa%2BVbKmKi%2FefCFoRddQxG4xLlgDSK5bbCPJOMwjEcSvV1uv5ZVL6gogeILQLUm%2BACw4%2FvI7oylBWzu4n%2F--RxC5fUe%2FDSMtQ9Dw--cmDh0US3MJpE1nbbR%2F710A%3D%3D' \
--data-raw '{ "email": "sheetal4@example.com", "password": "password123" }'
```

#### Event creation, updating and index
```sh 
  curl --location 'http://localhost:3000/api/v1/events' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=OcwIN9cZwrQyzansIUp7J4yGuLfzS03gMqmfl1mBSnPMbhKUMc2uUC%2FaFJ9bYKx2rzhDey3iI2KcKSgkc7Ve9yWs%2Bi4GszMmDE5Wl%2F6xdcDEXhLcJTlLsz%2FKKXshzJMFTEd4yMd1Bmg%2B1APy5DUh2a%2F6tsK%2BxLwKqjigcP6UViobVpUJbjL%2BUGJMhX0F%2BCI30AasyklyTdtZA4bAwLfjvA8SnfvTwBYwOb%2FmHuW9BlZDA39IZPS7EFGYjUiciRp2bAclxAwx1FPAfsBzAMd3sja4LpvwbMNsmkRk--xYViynI%2FRRZUhwfY--lK4nY%2F36I6VHqTp780vJaA%3D%3D' \
--data '{
    "event": {
      "event_name": "Tech Meetup",
      "date": "2025-06-25T10:00:00Z",
      "venue": "San Francisco",
      "event_tickets": [
        { "ticket_type": "VIP", "price": 150, "available_seats": 20 },
        { "ticket_type": "General", "price": 50, "available_seats": 100 }
      ]
    }
  }'
```

```sh 
  curl --location --request PUT 'http://localhost:3000/api/v1/events/1' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=w0icSWtSOSMapxhYBK13eXxGnRQhg%2FOZfD2LUEJqsRzQYyfagczGRr2Pn%2BJBdprvw7NAXMJFKksIOaBA5tElg5mU7DyExGWkKHtsxqAzD744x48ITEtZNSJD96Hhde%2B3Lz7K%2FX84wsBr2px7kk%2FCtIFOdednK3SnXe6ku6WO9BMfCWBLAOukXBXVyEZ%2BxLeGoZ5J3t5lni7JP1uyo4Oo2ByJw7XoqC0pOzw5lKkgGPooZWu0NID7bZ%2FslhJrfVraXBib6gTtRd01j8MPLavkTdmLApwrZ5LYVxu7--J4VNn8BKbTWWGLES--l3UkF3IG4M4336mTvzwDig%3D%3D' \
--data '{
    "event": {
      "event_name": "Tech Meetup update2",
      "date": "2025-06-25T10:00:00Z",
      "venue": "San Francisco",
      "event_tickets_attributes": [
        { "ticket_type": "VIP", "price": 150, "available_seats": 20 },
        { "ticket_type": "General", "price": 50, "available_seats": 100 }
      ]
    }
  }'
```

```sh 
  curl --location 'http://localhost:3000/api/v1/events' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=8rmqwfpD0j5DqI9A9TT3OvhBHO%2B%2BhZbP8pATNU%2BQH6ISCJU5S655PBWMHVHEoR91Q3TMVFhmTWKWG56i6TGQPpgKrw467Fmc3kVTQe4ACO0MEnA1g00OSMdsdeNmOhRdQTW5628Bxp8wqEY3vUfdCdUUjjXTkl3FHUF2WWu9pEj%2Fyx8tArBb99batMkL7BiYPI4oPFnq3%2BFAoabltAYuJ%2F1hUC3CR8kenhPjOhKJQFpzL%2BuqqjATFpB9ExQ4GAAz0s%2FBpW8OZWBJM7GfNKs%2BffuQyJdWVogzngF0--YMD2g5oH%2Bjwqf4EI--hpAL0cL8PpoV630JoGsnNA%3D%3D' \
--data ''
```

#### Booking creation, updation and deletion
```sh 
  curl --location 'http://localhost:3000/api/v1/bookings' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=OcwIN9cZwrQyzansIUp7J4yGuLfzS03gMqmfl1mBSnPMbhKUMc2uUC%2FaFJ9bYKx2rzhDey3iI2KcKSgkc7Ve9yWs%2Bi4GszMmDE5Wl%2F6xdcDEXhLcJTlLsz%2FKKXshzJMFTEd4yMd1Bmg%2B1APy5DUh2a%2F6tsK%2BxLwKqjigcP6UViobVpUJbjL%2BUGJMhX0F%2BCI30AasyklyTdtZA4bAwLfjvA8SnfvTwBYwOb%2FmHuW9BlZDA39IZPS7EFGYjUiciRp2bAclxAwx1FPAfsBzAMd3sja4LpvwbMNsmkRk--xYViynI%2FRRZUhwfY--lK4nY%2F36I6VHqTp780vJaA%3D%3D' \
--data '{
    "booking": {
      "event_ticket_id": 1,
      "number_of_seats": 9
    }
  }'
```

```sh 
  curl --location --request PUT 'http://localhost:3000/api/v1/bookings/1' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=OcwIN9cZwrQyzansIUp7J4yGuLfzS03gMqmfl1mBSnPMbhKUMc2uUC%2FaFJ9bYKx2rzhDey3iI2KcKSgkc7Ve9yWs%2Bi4GszMmDE5Wl%2F6xdcDEXhLcJTlLsz%2FKKXshzJMFTEd4yMd1Bmg%2B1APy5DUh2a%2F6tsK%2BxLwKqjigcP6UViobVpUJbjL%2BUGJMhX0F%2BCI30AasyklyTdtZA4bAwLfjvA8SnfvTwBYwOb%2FmHuW9BlZDA39IZPS7EFGYjUiciRp2bAclxAwx1FPAfsBzAMd3sja4LpvwbMNsmkRk--xYViynI%2FRRZUhwfY--lK4nY%2F36I6VHqTp780vJaA%3D%3D' \
--data '{
    "booking": {
      "event_ticket_id": 1,
      "number_of_seats": 4
    }
  }'
```

```sh 
  curl --location --request DELETE 'http://localhost:3000/api/v1/bookings/1' \
--header 'Content-Type: application/json' \
--header 'access_token: Access_token' \
--header 'uid: uid' \
--header 'client: client' \
--header 'Authorization: Bearer YourToken' \
--header 'Cookie: _interslice_session=OcwIN9cZwrQyzansIUp7J4yGuLfzS03gMqmfl1mBSnPMbhKUMc2uUC%2FaFJ9bYKx2rzhDey3iI2KcKSgkc7Ve9yWs%2Bi4GszMmDE5Wl%2F6xdcDEXhLcJTlLsz%2FKKXshzJMFTEd4yMd1Bmg%2B1APy5DUh2a%2F6tsK%2BxLwKqjigcP6UViobVpUJbjL%2BUGJMhX0F%2BCI30AasyklyTdtZA4bAwLfjvA8SnfvTwBYwOb%2FmHuW9BlZDA39IZPS7EFGYjUiciRp2bAclxAwx1FPAfsBzAMd3sja4LpvwbMNsmkRk--xYViynI%2FRRZUhwfY--lK4nY%2F36I6VHqTp780vJaA%3D%3D' \
--data ''
```
## Run the app
```
 clone app from github and navigate to app
 bundle install
 rails db:migrate
 bundle exec sidekiq # to start the sidekiq
 rails s
```