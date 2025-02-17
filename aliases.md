# Git Alias Documentation

| Alias  | Definition  |
|--------|-------------|
| `g`    | `git $args` |
| `ga`   | `git add $args` |
| `gaa`  | `git add --all $args` |
| `gapa` | `git add --patch $args` |
| `gau`  | `git add --update $args` |
| `gb`   | `git branch $args` |
| `gba`  | `git branch -a $args` |
| `gbda` | Script to delete merged branches except main branches. |
| `gbl`  | `git blame -b -w $args` |
| `gbnm` | `git branch --no-merged $args` |
| `gbr`  | `git branch --remote $args` |
| `gbs`  | `git bisect $args` |
| `gbsb` | `git bisect bad $args` |
| `gbsg` | `git bisect good $args` |
| `gbsr` | `git bisect reset $args` |
| `gbss` | `git bisect start $args` |
| `gc`   | `git commit -v $args` |
| `gc!`  | `git commit -v --amend $args` |
| `gca`  | `git commit -v -a $args` |
| `gca!` | `git commit -v -a --amend $args` |
| `gcam` | `git commit -a -m $args` |
| `gcan!`| `git commit -v -a --no-edit --amend $args` |
| `gcans!`| `git commit -v -a -s --no-edit --amend $args` |
| `gcb`  | `git checkout -b $args` |
| `gcd`  | `git checkout develop $args` |
| `gcf`  | `git config --list $args` |
| `gcl`  | `git clone --recursive $args` |
| `gclean`| `git clean -df $args` |
| `gcm`  | Script to checkout the main branch. |
| `gcmsg`| `git commit -m $args` |
| `gcn!` | `git commit -v --no-edit --amend $args` |
| `gco`  | `git checkout $args` |
| `gcount`| `git shortlog -sn $args` |
| `gcp`  | `git cherry-pick $args` |
| `gcpa` | `git cherry-pick --abort $args` |
| `gcpc` | `git cherry-pick --continue $args` |
| `gcs`  | `git commit -S $args` |
| `gd`   | `git diff $args` |
| `gdca` | `git diff --cached $args` |
| `gdt`  | `git diff-tree --no-commit-id --name-only -r $args` |
| `gdw`  | `git diff --word-diff $args` |
| `Get-Git-MainBranch`| Script to determine the main branch of the repository. |
| `gf`   | `git fetch $args` |
| `gfa`  | `git fetch --all --prune $args` |
| `gfo`  | `git fetch origin $args` |
| `gg`   | `git gui citool $args` |
| `gga`  | `git gui citool --amend $args` |
| `ggf`  | Script to force-push the current branch. |
| `ggfl` | Script to force-push with lease the current branch. |
| `ggl`  | Script to pull changes from origin for the current branch. |
| `ggp`  | Script to push the current branch to origin. |
| `ggsup`| Script to set upstream for the current branch. |
| `ghh`  | `git help $args` |
| `gignore`| `git update-index --assume-unchanged $args` |
| `gignored`| Script to list ignored files. |
| `gl`   | `git pull $args` |
| `glg`  | `git log --stat --color $args` |
| `glgg` | `git log --graph --color $args` |
| `glgga`| `git log --graph --decorate --all $args` |
| `glgm` | `git log --graph --max-count=10 $args` |
| `glgp` | `git log --stat --color -p $args` |
| `glo`  | `git log --oneline --decorate --color $args` |
| `glog` | `git log --oneline --decorate --color --graph $args` |
| `gloga`| `git log --oneline --decorate --color --graph --all $args` |
| `glol` | `git log --graph --pretty=format:... $args` |
| `glola`| `git log --graph --pretty=format:... --all $args` |
| `glum` | Script to pull upstream changes for the main branch. |
| `gm`   | `git merge $args` |
| `gmom` | Script to merge origin/main branch. |
| `gmt`  | `git mergetool --no-prompt $args` |
| `gmtvim`| `git mergetool --no-prompt --tool=vimdiff $args` |
| `gmum` | Script to merge upstream/main branch. |
| `gp`   | `git push $args` |
| `gpd`  | `git push --dry-run $args` |
| `gpf`  | `git push --force-with-lease $args` |
| `gpf!` | `git push --force $args` |
| `gpoat`| Script to push all branches and tags to origin. |
| `gpristine`| Script to reset and clean the repository. |
| `gpsup`| Script to push the current branch and set upstream. |
| `gpu`  | `git push upstream $args` |
| `gpv`  | `git push -v $args` |
| `gr`   | `git remote $args` |
| `gra`  | `git remote add $args` |
| `grb`  | `git rebase $args` |
| `grba` | `git rebase --abort $args` |
| `grbc` | `git rebase --continue $args` |
| `grbi` | `git rebase -i $args` |
| `grbm` | Script to rebase the main branch. |
| `grbs` | `git rebase --skip $args` |
| `grh`  | `git reset $args` |
| `grhh` | `git reset --hard $args` |
| `grmv` | `git remote rename $args` |
| `grrm` | `git remote remove $args` |
| `grs`  | `git restore $args` |
| `grset`| `git remote set-url $args` |
| `grt`  | Script to change directory to the repository root. |
| `gru`  | `git reset -- $args` |
| `grup` | `git remote update $args` |
| `grv`  | `git remote -v $args` |
| `gsb`  | `git status -sb $args` |
| `gsd`  | `git svn dcommit $args` |
| `gsh`  | `git show $args` |
| `gsi`  | `git submodule init $args` |
| `gsps` | `git show --pretty=short --show-signature $args` |
| `gsr`  | `git svn rebase $args` |
| `gss`  | `git status -s $args` |
| `gst`  | `git status $args` |
| `gsta` | `git stash save $args` |
| `gstaa`| `git stash apply $args` |
| `gstc` | `git stash clear $args` |
| `gstd` | `git stash drop $args` |
| `gstl` | `git stash list $args` |
| `gstp` | `git stash pop $args` |
| `gsts` | `git stash show --text $args` |
| `gsu`  | `git submodule update $args` |
| `gsw`  | `git switch $args` |
| `gswc` | `git switch --create $args` |
| `gts`  | `git tag -s $args` |
| `gunignore`| `git update-index --no-assume-unchanged $args` |
| `gunwip`| Script to remove a WIP commit. |
| `gup`  | `git pull --rebase $args` |
| `gupv` | `git pull --rebase -v $args` |
| `gvt`  | `git verify-tag $args` |
| `gwch` | `git whatchanged -p --abbrev-commit --pretty=medium $args` |
| `gwip` | Script to create a WIP commit. |
