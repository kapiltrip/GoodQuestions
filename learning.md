# Git Push Fix Notes

## Issue Faced
- `git push -u origin main` failed with:
  - `non-fast-forward`
  - Meaning: remote `main` had commits that local `main` did not have.

## Commands Used (in order)
```powershell
git rev-parse --is-inside-work-tree
git status --short --branch
git remote -v
git branch -vv
git push -u origin main
git fetch origin
git log --oneline --decorate --graph --max-count=10 --all
git rev-list --left-right --count main...origin/main
git pull --rebase origin main
git push -u origin main
```

## Meaning of the Fix
- `git pull --rebase origin main`
  - Gets latest remote commits.
  - Re-applies your local commits on top of remote history.
  - Avoids unnecessary merge commit for this case.
- `git push -u origin main`
  - Pushes updated local `main` to GitHub.
  - Sets upstream tracking so later `git push` works directly.

## Quick Reuse (if this happens again)
```powershell
git pull --rebase origin main
git push -u origin main
```
