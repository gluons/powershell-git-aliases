function Get-Git-CurrentBranch {
	git symbolic-ref --quiet HEAD *> $null
	if ($LASTEXITCODE -eq 0) {
		return git rev-parse --abbrev-ref HEAD
	} else {
		return
	}
}

function Remove-Alias ([string] $AliasName) {
	while (Test-Path Alias:$AliasName) {
		Remove-Item Alias:$AliasName -Force 2> $null
	}
}
