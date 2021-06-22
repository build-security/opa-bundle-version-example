#!/bin/bash
echo '{"revision": "'$(./get_sha.sh)'"}' > policies/.manifest
tar -czvf bundle.tar.gz -C policies .
