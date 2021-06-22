package carstore.authz

employees = {
    "alice": {
      "roles": [
        "manager",
        "car_admin"
      ]
    },
    "james": {
      "roles": [
        "manager"
      ]
    },
    "kelly": {
      "roles": [
        "car_admin"
      ]
    }
  }

test_manager_put_allowed {
    allow with input as {"path": ["cars", "some-car-id"], "method": "PUT", "user": "alice"} with data.employees as employees
}

test_get_anonymous_allowed {
    allow with input as {"path": ["cars"], "method": "GET", "user": "non-existent-user"} with data.employees as employees
}

test_admin_delete_allowed {
    allow with input as {"path": ["cars", "some-car-id"], "method": "DELETE", "user": "alice"} with data.employees as employees
}

test_car_admin_put_status_allowed {
    allow with input as {"path": ["cars", "some-car-id", "status"], "method": "PUT", "user": "kelly"} with data.employees as employees
}

test_car_admin_put_car_denied {
    not allow with input as {"path": ["cars", "some-car-id"], "method": "PUT", "user": "kelly"} with data.employees as employees
}

test_car_admin_delete_denied {
    not allow with input as {"path": ["cars", "some-car-id"], "method": "DELETE", "user": "kelly"} with data.employees as employees
}

test_manager_put_status_denied {
    not allow with input as {"path": ["cars", "some-car-id", "status"], "method": "PUT", "user": "james"} with data.employees as employees
}

