#!/bin/bash

Names=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${NAMES[@]}"
do
    echo "NAME: $i"
done