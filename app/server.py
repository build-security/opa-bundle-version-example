#!/usr/bin/env python
"""
Car Store App
"""
import json
import logging
import os

import requests
from flask import Flask, request, jsonify, abort, url_for

__version__ = "0.1"

app = Flask(__name__, static_url_path=None, static_folder=None)

cars = {}


@app.route("/", methods=["GET"])
def list_routes():
    import urllib
    routes = set([])
    for rule in app.url_map.iter_rules():
        options = {}
        for arg in rule.arguments:
            options[arg] = '[{0}]'.format(arg)
        url = urllib.unquote(url_for(rule.endpoint, **options))
        routes.add(url)
    return jsonify(sorted(routes))


@app.route("/cars", methods=["GET"])
def list_cars():
    result = []
    for id in cars:
        result.append(cars[id])
    return jsonify({'result': result})


@app.route("/cars/<id>", methods=["GET"])
def car_detail(id):
    if id not in cars:
        abort(404)
    return jsonify({'result': cars[id]})


@app.route("/cars/<id>", methods=["PUT"])
def car_update(id):
    cars[id] = request.json
    return jsonify({'result': cars[id]})


@app.route("/cars/<id>", methods=["DELETE"])
def delete_car(id):
    if id not in cars:
        abort(404)
    car = cars[id]
    del cars[id]
    return jsonify({'result': car})


@app.before_request
def check_authorization():
    try:
        input = json.dumps({"input": {
            "method": request.method,
            "path": request.path.strip().split("/")[1:],
            "user": request.headers.get("Authorization", ""),
        }}, indent=2)
        url = os.environ.get("OPA_URL", "http://localhost:8181")
        app.logger.debug("OPA query: %s. Body: %s", url, input)
        response = requests.post(url, data=input)
    except Exception as e:
        app.logger.exception("Unexpected error querying OPA.")
        abort(500)

    if response.status_code != 200:
        app.logger.error("OPA status code: %s. Body: %s",
                         response.status_code, response.json())
        abort(500)

    body = response.json()
    app.logger.debug("OPA result: %s", body)

    if "result" not in body or "allow" not in body["result"]:
        app.logger.error("OPA result isn't formatted right.")
        abort(500)

    if not body["result"]["allow"]:
        abort(403)


def setup_logging():
    for handler in app.logger.handlers:
        handler.setLevel(logging.DEBUG)
    app.logger.setLevel(logging.DEBUG)


if __name__ == "__main__":
    setup_logging()
    app.run(host="0.0.0.0", port="8080")
