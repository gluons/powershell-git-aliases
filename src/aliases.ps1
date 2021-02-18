. $PSScriptRoot\utils.ps1

# Prevent conflict with built-in aliases
Remove-Alias gc -Force
Remove-Alias gcb -Force
Remove-Alias gcm -Force
Remove-Alias gcs -Force
Remove-Alias gl -Force
Remove-Alias gm -Force
Remove-Alias gp -Force
Remove-Alias gpv -Force

function g {
	git $args
}
function ga {
	git add $args
}
function gaa {
	git add --all $args
}
function gapa {
	git add --patch $args
}
function gau {
	git add --update $args
}
function gb {
	git branch $args
}
function gba {
	git branch -a $args
}
function gbda {
	$MergedBranchs = $(git branch --merged | Select-String "^(\*|\s*(master|develop|dev)\s*$)" -NotMatch).Line
	$MergedBranchs | ForEach-Object {
		if ([string]::IsNullOrEmpty($_)) {
			return
		}
		git branch -d $_.Trim()
	}
}
function gbl {
	git blame -b -w $args
}
function gbnm {
	git branch --no-merged $args
}
function gbr {
	git branch --remote $args
}
function gbs {
	git bisect $args
}
function gbsb {
	git bisect bad $args
}
function gbsg {
	git bisect good $args
}
function gbsr {
	git bisect reset $args
}
function gbss {
	git bisect start $args
}
function gc {
	git commit -v $args
}
function gc! {
	git commit -v --amend $args
}
function gca {
	git commit -v -a $args
}
function gcam {
	git commit -a -m $args
}
function gca! {
	git commit -v -a --amend $args
}
function gcan! {
	git commit -v -a -s --no-edit --amend $args
}
function gcb {
	git checkout -b $args
}
function gcf {
	git config --list $args
}
function gcl {
	git clone --recursive $args
}
function gclean {
	git clean -df $args
}
function gcfx {
	git commmit --fixup $args
}
function gcm {
	git checkout master $args
}
function gcd {
	git checkout develop $args
}
function gcmsg {
	git commit -m $args
}
function gco {
	git checkout $args
}
function gcount {
	git shortlog -sn $args
}
function gcp {
	git cherry-pick $args
}
function gcpa {
	git cherry-pick --abort $args
}
function gcpc {
	git cherry-pick --continue $args
}
function gcs {
	git commit -S $args
}
function gd {
	git diff $args
}
function gdca {
	git diff --cached $args
}
function gdt {
	git diff-tree --no-commit-id --name-only -r $args
}
function gdw {
	git diff --word-diff $args
}
function gf {
	git fetch $args
}
function gfa {
	git fetch --all --prune $args
}
function gfo {
	git fetch origin $args
}
function gg {
	git gui citool $args
}
function gga {
	git gui citool --amend $args
}
function ggf {
	$CurrentBranch = Get-Git-CurrentBranch

	git push --force origin $CurrentBranch
}
function ggfl {
	$CurrentBranch = Get-Git-CurrentBranch

	git push --force-with-lease origin $CurrentBranch
}
function ghh {
	git help $args
}
function ggsup {
	$CurrentBranch = Get-Git-CurrentBranch

	git branch --set-upstream-to=origin/$CurrentBranch
}
function gpsup {
	$CurrentBranch = Get-Git-CurrentBranch

	git push --set-upstream origin $CurrentBranch
}
function gignore {
	git update-index --assume-unchanged $args
}
function gignored {
	git ls-files -v | Select-String "^[a-z]" -CaseSensitive
}
function gl {
	git pull $args
}
function glg {
	git log --stat --color $args
}
function glgg {
	git log --graph --color $args
}
function glgga {
	git log --graph --decorate --all $args
}
function glgm {
	git log --graph --max-count=10 $args
}
function glgp {
	git log --stat --color -p $args
}
function glo {
	git log --oneline --decorate --color $args
}
function glog {
	git log --oneline --decorate --color --graph $args
}
function glol {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $args
}
function glola {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all $args
}
function glom {
	git log --oneline --decorate --color master $args
}
function gm {
	git merge $args
}
function gmom {
	git merge origin/master $args
}
function gmt {
	git mergetool --no-prompt $args
}
function gmtvim {
	git mergetool --no-prompt --tool=vimdiff $args
}
function gmum {
	git merge upstream/master $args
}
function gp {
	git push $args
}
function gpd {
	git push --dry-run $args
}
function gpf {
	git push --force-with-lease $args
}
function gpf! {
	git push --force $args
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
	git push upstream $args
}
function gpv {
	git push -v $args
}
function gr {
	git remote $args
}
function gra {
	git remote add $args
}
function grb {
	git rebase $args
}
function grba {
	git rebase --abort $args
}
function grbc {
	git rebase --continue $args
}
function grbi {
	git rebase -i $args
}
function grbm {
	git rebase master $args
}
function grbs {
	git rebase --skip $args
}
function grh {
	git reset $args
}
function grhh {
	git reset --hard $args
}
function grmv {
	git remote rename $args
}
function grrm {
	git remote remove $args
}
function grs {
	git restore $args
}
function grset {
	git remote set-url $args
}
function grt {
	try {
		$RootPath = git rev-parse --show-toplevel
	}
	catch {
		$RootPath = "."
	}
	Set-Location $RootPath
}
function gru {
	git reset -- $args
}
function grup {
	git remote update $args
}
function grv {
	git remote -v $args
}
function gsb {
	git status -sb $args
}
function gsd {
	git svn dcommit $args
}
function gsh {
	git show $args
}
function gsi {
	git submodule init $args
}
function gsps {
	git show --pretty=short --show-signature $args
}
function gsr {
	git svn rebase $args
}
function gss {
	git status -s $args
}
function gst {
	git status $args
}
function gsta {
	git stash save $args
}
function gstaa {
	git stash apply $args
}
function gstd {
	git stash drop $args
}
function gstl {
	git stash list $args
}
function gstp {
	git stash pop $args
}
function gstc {
	git stash clear $args
}
function gsts {
	git stash show --text $args
}
function gsu {
	git submodule update $args
}
function gsw {
	git switch $args
}
function gts {
	git tag -s $args
}
function gunignore {
	git update-index --no-assume-unchanged $args
}
function gunwip {
	Write-Output $(git log -n 1 | Select-String "--wip--" -Quiet).Count
	git reset HEAD~1
}
function gup {
	git pull --rebase $args
}
function gupv {
	git pull --rebase -v $args
}
function glum {
	git pull upstream master $args
}
function gvt {
	git verify-tag $args
}
function gwch {
	git whatchanged -p --abbrev-commit --pretty=medium $args
}
function gwip {
	git add -A
	git rm $(git ls-files --deleted) 2> $null
	git commit --no-verify -m "--wip-- [skip ci]"
}
function ggl {
	$CurrentBranch = Get-Git-CurrentBranch

	git pull origin $CurrentBranch
}
function ggp {
	$CurrentBranch = Get-Git-CurrentBranch

	git push origin $CurrentBranch
}
