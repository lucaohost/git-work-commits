#!/bin/bash

echo "-------------------" >> git-work-commits-report.txt

# Loop through each line of the file
while IFS="|" read -r hascommit author date branch commitMsg repository; do
    # Print the variables (you can remove these or use them as needed)
    echo "Commit: $hascommit" >> git-work-commits-report.txt
    echo "Author: $author" >> git-work-commits-report.txt
    echo "Date: $date" >> git-work-commits-report.txt
    echo "Branch: $branch" >> git-work-commits-report.txt
    echo "Commit Message: $commitMsg" >> git-work-commits-report.txt
    echo "Repository: $repository" >> git-work-commits-report.txt
    echo "-------------------" >> git-work-commits-report.txt
done < git-work-commits-data.txt
