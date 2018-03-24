function Get-Git-CurrentBranch {
	return git rev-parse --abbrev-ref HEAD
}

function Test-CommandExists ([string] $Command) {
	return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Remove-Alias ([string] $AliasName) {
	if (Test-CommandExists $AliasName) {
		Remove-Item Alias:$AliasName -Force 2> $null
	}
}
