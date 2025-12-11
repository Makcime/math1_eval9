#!/bin/bash

find src/questions -name "q[2-9]*.tex" -exec rm {} \;
find src/answers -name "a[2-9]*.tex" -exec rm {} \;
