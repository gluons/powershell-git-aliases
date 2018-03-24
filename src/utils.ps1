function Get-Git-CurrentBranch {
	git symbolic-ref --quiet HEAD *> $null
	if ($LASTEXITCODE -eq 0) {
		return git rev-parse --abbrev-ref HEAD
	} else {
		return
	}
}

function Test-CommandExists ([string] $Command) {
	return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Remove-Alias ([string] $AliasName) {
	if (Test-CommandExists $AliasName) {
		Remove-Item Alias:$AliasName -Force 2> $null
	}
}
