. $PSScriptRoot\utils.ps1

function g {
	git
}
function ga {
	git add
}
function gaa {
	git add --all
}
function gapa {
	git add --patch
}
function gau {
	git add --update
}
function gb {
	git branch
}
function gba {
	git branch -a
}
function gbda {
	git branch --merged | command grep -vE "^(*|\smaster\s$)" | command xargs -n 1 git branch -d
}
function gbl {
	git blame -b -w
}
function gbnm {
	git branch --no-merged
}
function gbr {
	git branch --remote
}
function gbs {
	git bisect
}
function gbsb {
	git bisect bad
}
function gbsg {
	git bisect good
}
function gbsr {
	git bisect reset
}
function gbss {
	git bisect start
}
function gc {
	git commit -v
}
function gc! {
	git commit -v --amend
}
function gca {
	git commit -v -a
}
function gcam {
	git commit -a -m
}
function gca! {
	git commit -v -a --amend
}
function gcan! {
	git commit -v -a -s --no-edit --amend
}
function gcb {
	git checkout -b
}
function gcf {
	git config --list
}
function gcl {
	git clone --recursive
}
function gclean {
	git clean -df
}
function gcm {
	git checkout master
}
function gcd {
	git checkout develop
}
function gcmsg {
	git commit -m
}
function gco {
	git checkout
}
function gcount {
	git shortlog -sn
}
function gcp {
	git cherry-pick
}
function gcpa {
	git cherry-pick --abort
}
function gcpc {
	git cherry-pick --continue
}
function gcs {
	git commit -S
}
function gd {
	git diff
}
function gdca {
	git diff --cached
}
function gdt {
	git diff-tree --no-commit-id --name-only -r
}
function gdw {
	git diff --word-diff
}
function gf {
	git fetch
}
function gfa {
	git fetch --all --prune
}
function gfo {
	git fetch origin
}
function gg {
	git gui citool
}
function gga {
	git gui citool --amend
}
function ggf {
	$CurrentBranch = Get-Git-CurrentBranch

	git push --force origin $CurrentBranch
}
function ghh {
	git help
}
function ggsup {
	$CurrentBranch = Get-Git-CurrentBranch

	git branch --set-upstream-to = origin/$CurrentBranch
}
function gpsup {
	$CurrentBranch = Get-Git-CurrentBranch

	git push --set-upstream origin $CurrentBranch
}
function gignore {
	git update-index --assume-unchanged
}
function gignored {
	git ls-files -v | grep "^:lower:"
}
function gl {
	git pull
}
function glg {
	git log --stat --color
}
function glgg {
	git log --graph --color
}
function glgga {
	git log --graph --decorate --all
}
function glgm {
	git log --graph --max-count = 10
}
function glgp {
	git log --stat --color -p
}
function glo {
	git log --oneline --decorate --color
}
function glog {
	git log --oneline --decorate --color --graph
}
function glol {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}
function glola {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
}
function gm {
	git merge
}
function gmom {
	git merge origin/master
}
function gmt {
	git mergetool --no-prompt
}
function gmtvim {
	git mergetool --no-prompt --tool = vimdiff
}
function gmum {
	git merge upstream/master
}
function gp {
	git push
}
function gpd {
	git push --dry-run
}
function gpoat {
	git push origin --all
	git push origin --tags
}
function gpristine {
	git reset --hard
	git clean -dfx
}
function gpu {
	git push upstream
}
function gpv {
	git push -v
}
function gr {
	git remote
}
function gra {
	git remote add
}
function grb {
	git rebase
}
function grba {
	git rebase --abort
}
function grbc {
	git rebase --continue
}
function grbi {
	git rebase -i
}
function grbm {
	git rebase master
}
function grbs {
	git rebase --skip
}
function grh {
	git reset HEAD
}
function grhh {
	git reset HEAD --hard
}
function grmv {
	git remote rename
}
function grrm {
	git remote remove
}
function grset {
	git remote set-url
}
function grt {
	try {
		$path = git rev-parse --show-toplevel
	}
	catch {
		$path = "."
	}
	Set-Location $path
}
function gru {
	git reset --
}
function grup {
	git remote update
}
function grv {
	git remote -v
}
function gsb {
	git status -sb
}
function gsd {
	git svn dcommit
}
function gsi {
	git submodule init
}
function gsps {
	git show --pretty = short --show-signature
}
function gsr {
	git svn rebase
}
function gss {
	git status -s
}
function gst {
	git status
}
function gsta {
	git stash save
}
function gstaa {
	git stash apply
}
function gstd {
	git stash drop
}
function gstl {
	git stash list
}
function gstp {
	git stash pop
}
function gstc {
	git stash clear
}
function gsts {
	git stash show --text
}
function gsu {
	git submodule update
}
function gts {
	git tag -s
}
function gunignore {
	git update-index --no-assume-unchanged
}
function gunwip {
	git log -n 1 | grep -q -c "--wip--"
	git reset HEAD~1
}
function gup {
	git pull --rebase
}
function gupv {
	git pull --rebase -v
}
function glum {
	git pull upstream master
}
function gvt {
	git verify-tag
}
function gwch {
	git whatchanged -p --abbrev-commit --pretty = medium
}
function gwip {
	git add -A
	git rm $(git ls-files --deleted) 2> /dev/null
	git commit -m "--wip--"
}
