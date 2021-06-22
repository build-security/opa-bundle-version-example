package carstore.authz

employees = {
    "alice": {
      "roles": [
        "manager",
      ]
    },
    "james": {
      "roles": [
        "manager"
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
