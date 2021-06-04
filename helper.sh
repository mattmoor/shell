#!/bin/bash

function f() {
    test $1 = 'get' && echo password=`cat /var/run/secrets/kubernetes.io/serviceaccount/token | sha256sum | cut -d' ' -f 1`
}

f "$@"
