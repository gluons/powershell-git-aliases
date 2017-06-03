function Get-Git-CurrentBranch {
	return git rev-parse --abbrev-ref HEAD
}
