# Git Work Commits
- This repository is designed to manage and track my private Git contributions, with appropriate censorship applied when necessary.
  - Examples of situations requiring censorship include:
    - Vulnerability fixes
    - Information about used libraries
    - Development of non-public features

## Why
- Like a runner tracking their pace and distance, these metrics motivate me to keep coding hard.
- They also remind me of projects and features I developed years ago.

## How
- When I'm working in my laptop company, I always commit using the alias `gu`
- `gu` automates the process of commiting and record commits info in my personal GitHub

## gu (Git Update) 
```bash
gu() {
    local commit_msg="$*" # Need to use $* to get all words passed without quotes
    git add -A
    git commit -m "$(printf "%b" "$commit_msg")"  # Interprets \n as a new line
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
    if [ $(hostname) != "LucaS" ]; then # Prevents the script from running on my personal laptop
        reflect_commits "$commit_msg"
    fi
}
```
Or in case of sensitive information
## guc (Git Update Censored)
```bash
guc() {
    local commit_msg="$*" # Need to use $* to get all words passed without quotes
    git add -A
    git commit -m "$(printf "%b" "$commit_msg")"  # Interprets \n as a new line
    git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
    if [ $(hostname) != "LucaS" ]; then # Prevents the script from running on my personal laptop
        reflect_commits "CENSORED_COMMIT_MESSAGE"
    fi
}
```

## Commit Reflection Logic

```bash
reflect_commits() {
    local commit_msg="$1"
    commit_info=$(git log --author="professional.email@company.com" --pretty=format:"%h|%ae|%ad|$(git symbolic-ref --short HEAD)|%s|$(basename $(git rev-parse --show-toplevel))" --abbrev=8 --date=iso -n 1)
    # Save data in a format easily to traverse for shellscript
    echo $commit_info >> $HOME/git/git-work-commits/git-work-commits-data.txt

    # Extract commit info
    IFS='|' read -r hashCommit author date branch commitMsg repository <<< "$commit_info"

    # Generate a report easier to read
    echo "Commit: $hashCommit" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "Author: $author" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "Date: $date" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "Branch: $branch" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "Commit Message: $commitMsg" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "Repository: $repository" >> $HOME/git/git-work-commits/git-work-commits-report.txt
    echo "-------------------" >> $HOME/git/git-work-commits/git-work-commits-report.txt

    current_dir=$(pwd)
    cd $HOME/git/git-work-commits/
    git config --global user.email "personal.email@gmail.com"
    git add -A
    git commit -m "$(printf "%b" "$commit_msg")" # Interprets \n as a new line
    git push
    cd $current_dir
    git config --global user.email "professional.email@company.com"
}
```
