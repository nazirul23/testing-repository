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

read -p "Enter the pr title: " PR_TITLE

if [ -z "$PR_TITLE" ]; then
    echo "Error: PR title cannot be empty."
    exit 1
fi

read -p "Enter the pr description: " PR_BODY

# Switch to production branch and create release branch
git checkout production
git pull
git checkout -b "$RELEASE_BRANCH" production

# Merge main into release
gh pr checkout main
gh pr merge --auto

# Create an annotated tag
git tag -a "$TAG_NAME" -m "Release $TAG_NAME"

# Push branch and tag
git push --set-upstream origin "$RELEASE_BRANCH"
git push --tags

# Create pull request using GitHub CLI
gh pr create --base production --head "$RELEASE_BRANCH" --title "$PR_TITLE" --body "$PR_BODY"

echo "Run dep deploy to deploy to production."
