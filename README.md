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
--data-raw '{ "email": "sheetal4@example.com", "password": "password123", "password_confirmation": "password123", "usertype": "customer", "firstname": "sheetal4", "lastname": "jadhav", "mobile": "7765676593" }'
```
#### User login
```sh
curl --location 'localhost:3000/auth/sign_in' \
--header 'Content-Type: application/json' \
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