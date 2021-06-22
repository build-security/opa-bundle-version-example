package carstore.authz

default allow = false

allow {
	input.method = "GET"
	input.path = [""]
}

allow {
	input.method = "GET"
	input.path = ["cars"]
}

allow {
	input.method = "GET"
	input.path = ["cars", car_id]
}

allow {
	input.method = "PUT"
	input.path = ["cars", car_id]
	has_role("manager")
}

allow {
	input.method = "DELETE"
	input.path = ["cars", car_id]
	has_role("manager")
}

allow {
	input.method = "GET"
	input.path = ["cars", car_id, "status"]
	data.employees[input.user]
}

allow {
	input.method = "PUT"
	input.path = ["cars", car_id, "status"]
	has_role("car_admin")
}

# This is not the best example for policy evaluation performance but it's clear for this example repository
has_role(role) {
	employee := data.employees[input.user]
	employee.roles[i] == role
}