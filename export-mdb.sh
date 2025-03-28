#!/bin/bash
mkdir -p export-mdb
mdb-tables -1 "$1" | while read T; do mdb-json "$1" "$T" > "export-mdb/${T}.json"; done
