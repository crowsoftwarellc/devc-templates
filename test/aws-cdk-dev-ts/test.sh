#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "true" true

# Report result
reportResults
