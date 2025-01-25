#!/bin/bash
if which swiftformat >/dev/null; then
    echo "Running SwiftFormat..."
    swiftformat .
else
    echo "SwiftFormat not installed. Install it using 'brew install swiftformat'."
    exit 1
fi