#!/bin/bash

base_date="2025-01-03T11:45:00"
base_epoch=$(date -d "$base_date" +%s)

FOLDER_OFFSET=$((1 * 24 * 60 * 60))  # 2 days
FILE_OFFSET=$((5 * 60))              # 5 minutes

base_folder="./"

# Loop over top-level entries in f1/
for top in "$base_folder"/*; do
  if [ -e "$top" ]; then
    echo "Processing $top"
    folder_epoch=$base_epoch

    # Find all files inside this folder (recursively)
    files=$(find "$top" -type f | sort)

    for file in $files; do
      timestamp=$(date -d "@$folder_epoch" --iso-8601=seconds)

      GIT_AUTHOR_DATE="$timestamp" GIT_COMMITTER_DATE="$timestamp" git add "$file"
      GIT_AUTHOR_DATE="$timestamp" GIT_COMMITTER_DATE="$timestamp" git commit -m "Add $file"

      folder_epoch=$((folder_epoch + FILE_OFFSET))
    done

    base_epoch=$((base_epoch + FOLDER_OFFSET))
  fi
done

