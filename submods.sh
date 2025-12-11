#!/bin/bash
set -e

# Initialize submodules if needed
git submodule init

# Update all submodules recursively to latest remote commits
git submodule update --remote --merge --recursive

# Optional: Pull inside each submodule to make sure it's really up-to-date
git submodule foreach --recursive '
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "HEAD")
    echo "Updating submodule $name on branch $branch..."
    git fetch origin
    git pull origin $branch
'
