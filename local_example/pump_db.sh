#!/bin/bash
# Put some cars
curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/663dc85d-2455-466c-b2e5-76691b0ce14e \
    -d '{ "model": "Honda", "vehicle_id": "127482", "owner_id": "742"}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/6c018cfa-e9c2-4169-a61b-dd3bf3bc19a7 \
    -d '{"model": "Toyota", "vehicle_id": "19019", "owner_id": "742"}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/879a273c-a8dc-41a6-9c30-2bb92288e93b \
    -d '{"model": "Ford", "vehicle_id": "3784312", "owner_id": "6928"}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/fca3ab25-a151-4c76-b238-9aa6ee92c374 \
    -d '{"model": "Honda", "vehicle_id": "22781", "owner_id": "30390"}'

# Put some status updates
curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/663dc85d-2455-466c-b2e5-76691b0ce14e/status \
    -d '{"position": { "latitude": -39.91045, "longitude": -161.70716 }, "mileage": 742, "speed": 90, "fuel": 6.42}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/6c018cfa-e9c2-4169-a61b-dd3bf3bc19a7/status \
    -d '{"position": { "latitude": 12.77061, "longitude": 9.05115 }, "mileage": 17384, "speed": 62, "fuel": 8.9}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/879a273c-a8dc-41a6-9c30-2bb92288e93b/status \
    -d '{"position": { "latitude": -8.86414, "longitude": -142.5982 }, "mileage": 9347, "speed": 45, "fuel": 3.1}'

curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/fca3ab25-a151-4c76-b238-9aa6ee92c374/status \
    -d '{"position": { "latitude": 68.86632, "longitude": -92.85048 }, "mileage": 97698, "speed": 50, "fuel": 3.22}'
