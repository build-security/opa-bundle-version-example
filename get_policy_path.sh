#!/bin/bash
grep -h -m 1 package policies/*.rego | sed "s/package \(.*\)/\1/" | tr '.' '/'
