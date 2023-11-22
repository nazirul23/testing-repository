#!/bin/bash

set -e

# Prompt user for release branch name
read -p "Enter the release branch name: " RELEASE_BRANCH

if [ -z "$RELEASE_BRANCH" ]; then
    echo "Error: Release branch name cannot be empty."
    exit 1
fi

# Prompt user for tag name
read -p "Enter the tag name (e.g., v3.3.3): " TAG_NAME

if [ -z "$TAG_NAME" ]; then
    echo "Error: Tag name cannot be empty."
    exit 1
fi

# Switch to production branch and create release branch
git checkout production
git pull
git checkout -b "$RELEASE_BRANCH" production

# Merge master into release
git merge --strategy-option=theirs main

# Create an annotated tag
git tag -a "$TAG_NAME" -m "Release $TAG_NAME"

# Push branch and tag
git push origin "$RELEASE_BRANCH"
git push --tags

# Create pull request
PR_URL="https://github.com/nazirul23/testing-repository/compare/production...$RELEASE_BRANCH?expand=1"
echo "Create a pull request at: $PR_URL"

echo "Run dep deploy to deploy to production."
