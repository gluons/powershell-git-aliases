<#
.SYNOPSIS
	Unit tests for the helper functions of the git-aliases module
	(src/utils.ps1).

.DESCRIPTION
	Get-Git-CurrentBranch and Get-Git-MainBranch are tested against real
	git repositories created on the fly in the Pester TestDrive, since
	they are the functions that keep the aliases free of hardcoded
	master/main names.
#>

Describe 'utils.ps1 helpers' {
	BeforeAll {
		$SrcDir = Join-Path (Join-Path $PSScriptRoot '..') 'src'
		$manifestPath = Join-Path $SrcDir 'git-aliases.psd1'
		Import-Module $manifestPath -Force -DisableNameChecking

		function New-TestRepository {
			param([Parameter(Mandatory = $true)][string] $Branch)

			$path = Join-Path (Get-PSDrive TestDrive).Root ('repo-' + [guid]::NewGuid().ToString('N'))
			New-Item -ItemType Directory -Path $path -Force | Out-Null
			& git init --quiet --initial-branch=$Branch $path
			if ($LASTEXITCODE -ne 0) { throw 'git init failed' }
			return $path
		}

		function New-TestCommit {
			& git -c user.name=test -c user.email=test@example.com -c commit.gpgsign=false commit --allow-empty --quiet --no-verify -m 'test commit'
			if ($LASTEXITCODE -ne 0) { throw 'git commit failed' }
		}
	}

	AfterAll {
		Remove-Module git-aliases -Force -ErrorAction SilentlyContinue
	}

	Context 'Format-AliasDefinition (module internal)' {
		It 'trims surrounding whitespace' {
			InModuleScope git-aliases {
				Format-AliasDefinition "`tgit status`n`t" | Should -Be 'git status'
			}
		}

		It 'removes one tab of indentation per line' {
			InModuleScope git-aliases {
				Format-AliasDefinition "`tgit status`n`t`t--short" | Should -Be "git status`n`t--short"
			}
		}

		It 'removes four spaces of indentation per line' {
			InModuleScope git-aliases {
				Format-AliasDefinition "    git add`n        -A" | Should -Be "git add`n    -A"
			}
		}

		It 'keeps unindented lines as they are' {
			InModuleScope git-aliases {
				Format-AliasDefinition "git pull`ngit push" | Should -Be "git pull`ngit push"
			}
		}
	}

	Context 'Write-Host-Deprecated (module internal)' {
		It 'prints a deprecation message naming the old and the new alias' {
			$output = InModuleScope git-aliases { Write-Host-Deprecated 'gup' 'gpr' 6>&1 } | ForEach-Object { $_.ToString() }

			($output -join '') | Should -Match '\[git-aliases\] gup is a deprecated alias, use "gpr" instead\.'
		}
	}

	Context 'Get-Git-CurrentBranch' {
		It 'returns the current branch name' {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'feature-x')
				New-TestCommit
				Get-Git-CurrentBranch | Should -Be 'feature-x'
			}
			finally {
				Pop-Location
			}
		}

		It 'returns nothing in a detached HEAD state' {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'main')
				New-TestCommit
				& git checkout --detach --quiet
				Get-Git-CurrentBranch | Should -BeNullOrEmpty
			}
			finally {
				Pop-Location
			}
		}

		It 'returns nothing outside a git repository' {
			Push-Location
			try {
				$dir = Join-Path (Get-PSDrive TestDrive).Root ('no-repo-' + [guid]::NewGuid().ToString('N'))
				New-Item -ItemType Directory -Path $dir -Force | Out-Null
				Set-Location $dir
				Get-Git-CurrentBranch | Should -BeNullOrEmpty
			}
			finally {
				Pop-Location
			}
		}
	}

	Context 'Get-Git-MainBranch' {
		It "returns 'main' when the main branch exists" {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'main')
				New-TestCommit
				Get-Git-MainBranch | Should -Be 'main'
			}
			finally {
				Pop-Location
			}
		}

		It "returns 'trunk' when the trunk branch exists" {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'trunk')
				New-TestCommit
				Get-Git-MainBranch | Should -Be 'trunk'
			}
			finally {
				Pop-Location
			}
		}

		It "returns 'master' when neither main nor trunk exists" {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'master')
				New-TestCommit
				Get-Git-MainBranch | Should -Be 'master'
			}
			finally {
				Pop-Location
			}
		}

		It 'prefers main over trunk' {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'trunk')
				New-TestCommit
				& git branch main
				Get-Git-MainBranch | Should -Be 'main'
			}
			finally {
				Pop-Location
			}
		}

		It 'prefers trunk over master' {
			Push-Location
			try {
				Set-Location (New-TestRepository -Branch 'master')
				New-TestCommit
				& git branch trunk
				Get-Git-MainBranch | Should -Be 'trunk'
			}
			finally {
				Pop-Location
			}
		}

		It 'returns nothing outside a git repository' {
			Push-Location
			try {
				$dir = Join-Path (Get-PSDrive TestDrive).Root ('no-repo-' + [guid]::NewGuid().ToString('N'))
				New-Item -ItemType Directory -Path $dir -Force | Out-Null
				Set-Location $dir
				Get-Git-MainBranch | Should -BeNullOrEmpty
			}
			finally {
				Pop-Location
			}
		}
	}

	Context 'Get-Git-Aliases' {
		It 'returns the definition of a specific alias' {
			$definition = Get-Git-Aliases -Alias 'gst'

			$definition | Should -Match 'git status'
		}

		It 'fails for an unknown alias' {
			{ Get-Git-Aliases -Alias 'this-alias-does-not-exist' } | Should -Throw '*Definition*'
		}

		It 'lists all aliases with their definitions' {
			$list = Get-Git-Aliases | Out-String

			$list | Should -Match 'gst'
			$list | Should -Match 'git commit -v'
			$list | Should -Match 'git pull --rebase'
		}

		It 'does not list internal helper functions' {
			$list = Get-Git-Aliases | Out-String

			# The helpers may still appear inside definitions of aliases
			# that call them, so the check is anchored on the name column.
			$list | Should -Not -Match '(?m)^Get-Git-CurrentBranch\s'
			$list | Should -Not -Match '(?m)^Format-AliasDefinition\s'
			$list | Should -Not -Match '(?m)^Write-Host-Deprecated\s'
		}
	}
}
