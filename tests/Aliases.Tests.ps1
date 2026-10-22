<#
.SYNOPSIS
	Unit tests for every alias function of the git-aliases module
	(src/aliases.ps1).

.DESCRIPTION
	The git command is mocked at module level, and every call is recorded
	(arguments flattened the way a real native git invocation receives
	them). Each alias is called and the recorded git arguments are compared
	against the expected ones, so any change of the arguments an alias
	passes to git fails the tests.
#>

Describe 'Alias functions' {
	BeforeAll {
		$SrcDir = Join-Path (Join-Path $PSScriptRoot '..') 'src'
		$manifestPath = Join-Path $SrcDir 'git-aliases.psd1'
		Import-Module $manifestPath -Force -DisableNameChecking

		$script:GitCalls = [System.Collections.Generic.List[object]]::new()

		# Output returned by the mocked git command. When $GitOutputFor is
		# set, the output is only returned to git calls containing all of
		# its tokens, other calls return nothing (like a real git would).
		$script:GitOutput = $null
		$script:GitOutputFor = $null

		Mock git -ModuleName git-aliases {
			# Flatten the arguments, mimicking how a native command receives them.
			$work = [System.Collections.Generic.List[object]]::new()
			foreach ($item in @($args)) { $work.Add($item) }
			$flat = [System.Collections.Generic.List[string]]::new()
			$i = 0
			while ($i -lt $work.Count) {
				$item = $work[$i]
				$i++
				if ($null -eq $item) { continue }
				if ($item -is [System.Array]) {
					foreach ($subItem in $item) { $work.Add($subItem) }
				}
				else {
					$flat.Add([string]$item)
				}
			}
			$script:GitCalls.Add($flat.ToArray())

			if (
				$null -ne $script:GitOutput -and
				($null -eq $script:GitOutputFor -or (Compare-Object $script:GitOutputFor $flat | Where-Object SideIndicator -eq '<=').Count -eq 0)
			) {
				$script:GitOutput
			}
			$global:LASTEXITCODE = 0
		}

		Mock Get-Git-MainBranch -ModuleName git-aliases { $script:MainBranch }
		Mock Get-Git-CurrentBranch -ModuleName git-aliases { $script:CurrentBranch }
		Mock Get-Git-DevelopBranch -ModuleName git-aliases { $script:DevelopBranch }
	}

	BeforeEach {
		$script:GitCalls.Clear()
		$script:GitOutput = $null
		$script:GitOutputFor = $null
		$script:MainBranch = 'main'
		$script:CurrentBranch = 'feature-x'
		$script:DevelopBranch = 'develop'
	}

	AfterAll {
		Remove-Module git-aliases -Force -ErrorAction SilentlyContinue
	}

	Context 'Aliases that pass their arguments through to git' {
		# One case per simple alias: name, fixed git arguments, and the
		# arguments the alias itself receives (empty when untouched).
		$cases = @(
			@{ Alias = 'g'; Expected = @() }
			@{ Alias = 'ga'; Expected = @('add'); Extra = @('-A', 'file.txt') }
			@{ Alias = 'gaa'; Expected = @('add', '--all') }
			@{ Alias = 'gapa'; Expected = @('add', '--patch') }
			@{ Alias = 'gau'; Expected = @('add', '--update') }
			@{ Alias = 'gb'; Expected = @('branch'); Extra = @('--all') }
			@{ Alias = 'gba'; Expected = @('branch', '-a') }
			@{ Alias = 'gbd'; Expected = @('branch', '-d') }
			@{ Alias = 'gbl'; Expected = @('blame', '-b', '-w') }
			@{ Alias = 'gbnm'; Expected = @('branch', '--no-merged') }
			@{ Alias = 'gbr'; Expected = @('branch', '--remote') }
			@{ Alias = 'gbs'; Expected = @('bisect') }
			@{ Alias = 'gbsb'; Expected = @('bisect', 'bad') }
			@{ Alias = 'gbsg'; Expected = @('bisect', 'good') }
			@{ Alias = 'gbsr'; Expected = @('bisect', 'reset') }
			@{ Alias = 'gbss'; Expected = @('bisect', 'start') }
			@{ Alias = 'gc'; Expected = @('commit', '-v'); Extra = @('-m', 'message') }
			@{ Alias = 'gc!'; Expected = @('commit', '-v', '--amend') }
			@{ Alias = 'gcn!'; Expected = @('commit', '-v', '--no-edit', '--amend') }
			@{ Alias = 'gca'; Expected = @('commit', '-v', '-a') }
			@{ Alias = 'gcam'; Expected = @('commit', '-a', '-m') }
			@{ Alias = 'gca!'; Expected = @('commit', '-v', '-a', '--amend') }
			@{ Alias = 'gcan!'; Expected = @('commit', '-v', '-a', '--no-edit', '--amend') }
			@{ Alias = 'gcans!'; Expected = @('commit', '-v', '-a', '-s', '--no-edit', '--amend') }
			@{ Alias = 'gcb'; Expected = @('checkout', '-b') }
			@{ Alias = 'gcf'; Expected = @('config', '--list') }
			@{ Alias = 'gcl'; Expected = @('clone', '--recursive') }
			@{ Alias = 'gclean'; Expected = @('clean', '-df') }
			@{ Alias = 'gcd'; Expected = @('checkout', 'develop') }
			@{ Alias = 'gcmsg'; Expected = @('commit', '-m'); Extra = @('message') }
			@{ Alias = 'gco'; Expected = @('checkout'); Extra = @('-b', 'new-branch') }
			@{ Alias = 'gcount'; Expected = @('shortlog', '-sn') }
			@{ Alias = 'gcp'; Expected = @('cherry-pick') }
			@{ Alias = 'gcpa'; Expected = @('cherry-pick', '--abort') }
			@{ Alias = 'gcpc'; Expected = @('cherry-pick', '--continue') }
			@{ Alias = 'gcs'; Expected = @('commit', '-S') }
			@{ Alias = 'gd'; Expected = @('diff'); Extra = @('HEAD~1') }
			@{ Alias = 'gds'; Expected = @('diff', '--staged') }
			@{ Alias = 'gdca'; Expected = @('diff', '--cached') }
			@{ Alias = 'gdt'; Expected = @('diff-tree', '--no-commit-id', '--name-only', '-r') }
			@{ Alias = 'gdw'; Expected = @('diff', '--word-diff') }
			@{ Alias = 'gf'; Expected = @('fetch'); Extra = @('--tags') }
			@{ Alias = 'gfa'; Expected = @('fetch', '--all', '--prune') }
			@{ Alias = 'gfo'; Expected = @('fetch', 'origin') }
			@{ Alias = 'gg'; Expected = @('gui', 'citool') }
			@{ Alias = 'gga'; Expected = @('gui', 'citool', '--amend') }
			@{ Alias = 'ghh'; Expected = @('help'); Extra = @('commit') }
			@{ Alias = 'gignore'; Expected = @('update-index', '--assume-unchanged') }
			@{ Alias = 'gl'; Expected = @('pull'); Extra = @('--ff-only') }
			@{ Alias = 'glg'; Expected = @('log', '--stat', '--color') }
			@{ Alias = 'glgg'; Expected = @('log', '--graph', '--color') }
			@{ Alias = 'glgga'; Expected = @('log', '--graph', '--decorate', '--all') }
			@{ Alias = 'glgm'; Expected = @('log', '--graph', '--max-count=10') }
			@{ Alias = 'glgp'; Expected = @('log', '--stat', '--color', '-p') }
			@{ Alias = 'glo'; Expected = @('log', '--oneline', '--decorate', '--color') }
			@{ Alias = 'glog'; Expected = @('log', '--oneline', '--decorate', '--color', '--graph') }
			@{ Alias = 'gloga'; Expected = @('log', '--oneline', '--decorate', '--color', '--graph', '--all') }
			@{ Alias = 'glol'; Expected = @('log', '--graph', '--pretty=format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset', '--abbrev-commit') }
			@{ Alias = 'glola'; Expected = @('log', '--graph', '--pretty=format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset', '--abbrev-commit', '--all') }
			@{ Alias = 'gm'; Expected = @('merge'); Extra = @('other-branch') }
			@{ Alias = 'gmtl'; Expected = @('mergetool', '--no-prompt') }
			@{ Alias = 'gmtlvim'; Expected = @('mergetool', '--no-prompt', '--tool=vimdiff') }
			@{ Alias = 'gp'; Expected = @('push'); Extra = @('--tags') }
			@{ Alias = 'gpd'; Expected = @('push', '--dry-run') }
			@{ Alias = 'gpf'; Expected = @('push', '--force-with-lease') }
			@{ Alias = 'gpf!'; Expected = @('push', '--force') }
			@{ Alias = 'gpr'; Expected = @('pull', '--rebase') }
			@{ Alias = 'gpra'; Expected = @('pull', '--rebase', '--autostash') }
			@{ Alias = 'gprv'; Expected = @('pull', '--rebase', '-v') }
			@{ Alias = 'gpu'; Expected = @('push', 'upstream') }
			@{ Alias = 'gpv'; Expected = @('push', '-v') }
			@{ Alias = 'gr'; Expected = @('remote') }
			@{ Alias = 'gra'; Expected = @('remote', 'add'); Extra = @('origin', 'https://example.com/repo.git') }
			@{ Alias = 'grb'; Expected = @('rebase') }
			@{ Alias = 'grba'; Expected = @('rebase', '--abort') }
			@{ Alias = 'grbc'; Expected = @('rebase', '--continue') }
			@{ Alias = 'grbi'; Expected = @('rebase', '-i') }
			@{ Alias = 'grbs'; Expected = @('rebase', '--skip') }
			@{ Alias = 'grh'; Expected = @('reset') }
			@{ Alias = 'grhh'; Expected = @('reset', '--hard') }
			@{ Alias = 'grm'; Expected = @('rm') }
			@{ Alias = 'grmc'; Expected = @('rm', '--cached') }
			@{ Alias = 'grmv'; Expected = @('remote', 'rename') }
			@{ Alias = 'grrm'; Expected = @('remote', 'remove') }
			@{ Alias = 'grs'; Expected = @('restore') }
			@{ Alias = 'grst'; Expected = @('restore', '--staged') }
			@{ Alias = 'grset'; Expected = @('remote', 'set-url') }
			@{ Alias = 'grup'; Expected = @('remote', 'update') }
			@{ Alias = 'grv'; Expected = @('remote', '-v') }
			@{ Alias = 'grev'; Expected = @('revert'); Extra = @('HEAD~1') }
			@{ Alias = 'gsb'; Expected = @('status', '-sb') }
			@{ Alias = 'gsd'; Expected = @('svn', 'dcommit') }
			@{ Alias = 'gsh'; Expected = @('show'); Extra = @('HEAD') }
			@{ Alias = 'gsi'; Expected = @('submodule', 'init') }
			@{ Alias = 'gsps'; Expected = @('show', '--pretty=short', '--show-signature') }
			@{ Alias = 'gsr'; Expected = @('svn', 'rebase') }
			@{ Alias = 'gss'; Expected = @('status', '-s') }
			@{ Alias = 'gst'; Expected = @('status'); Extra = @('-sb') }
			@{ Alias = 'gsta'; Expected = @('stash', 'save') }
			@{ Alias = 'gstaa'; Expected = @('stash', 'apply') }
			@{ Alias = 'gstd'; Expected = @('stash', 'drop') }
			@{ Alias = 'gstl'; Expected = @('stash', 'list') }
			@{ Alias = 'gstp'; Expected = @('stash', 'pop') }
			@{ Alias = 'gstc'; Expected = @('stash', 'clear') }
			@{ Alias = 'gsts'; Expected = @('stash', 'show', '--text') }
			@{ Alias = 'gsu'; Expected = @('submodule', 'update') }
			@{ Alias = 'gsw'; Expected = @('switch') }
			@{ Alias = 'gswc'; Expected = @('switch', '--create') }
			@{ Alias = 'gts'; Expected = @('tag', '-s') }
			@{ Alias = 'gunignore'; Expected = @('update-index', '--no-assume-unchanged') }
			@{ Alias = 'gvt'; Expected = @('verify-tag') }
			@{ Alias = 'gwch'; Expected = @('whatchanged', '-p', '--abbrev-commit', '--pretty=medium') }
			@{ Alias = 'gwt'; Expected = @('worktree') }
			@{ Alias = 'gwta'; Expected = @('worktree', 'add') }
			@{ Alias = 'gwtls'; Expected = @('worktree', 'list') }
			@{ Alias = 'gwtmv'; Expected = @('worktree', 'move') }
			@{ Alias = 'gwtrm'; Expected = @('worktree', 'remove') }
		)

		It '<Alias> runs git with the expected arguments' -TestCases $cases {
			param($Alias, $Expected, $Extra = @())

			& $Alias @Extra

			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly (@($Expected) + @($Extra))
		}
	}

	Context 'Aliases driven by the main branch (no hardcoded master/main)' {
		$cases = @(
			@{ Alias = 'gcm'; Branch = 'main'; Expected = @('checkout', 'main') }
			@{ Alias = 'gcm'; Branch = 'trunk'; Expected = @('checkout', 'trunk') }
			@{ Alias = 'gswm'; Branch = 'main'; Expected = @('switch', 'main') }
			@{ Alias = 'gswm'; Branch = 'trunk'; Expected = @('switch', 'trunk') }
			@{ Alias = 'gmom'; Branch = 'main'; Expected = @('merge', 'origin/main') }
			@{ Alias = 'gmom'; Branch = 'trunk'; Expected = @('merge', 'origin/trunk') }
			@{ Alias = 'gmum'; Branch = 'main'; Expected = @('merge', 'upstream/main') }
			@{ Alias = 'gmum'; Branch = 'trunk'; Expected = @('merge', 'upstream/trunk') }
			@{ Alias = 'glum'; Branch = 'main'; Expected = @('pull', 'upstream', 'main'); Extra = @('--ff-only') }
			@{ Alias = 'glum'; Branch = 'trunk'; Expected = @('pull', 'upstream', 'trunk') }
			@{ Alias = 'grbm'; Branch = 'main'; Expected = @('rebase', 'main'); Extra = @('-v') }
			@{ Alias = 'grbm'; Branch = 'trunk'; Expected = @('rebase', 'trunk') }
			@{ Alias = 'gprom'; Branch = 'main'; Expected = @('pull', '--rebase', 'origin', 'main') }
			@{ Alias = 'gprom'; Branch = 'trunk'; Expected = @('pull', '--rebase', 'origin', 'trunk'); Extra = @('--autostash') }
		)

		It '<Alias> delegates to the <Branch> branch' -TestCases $cases {
			param($Alias, $Branch, $Expected, $Extra = @())

			$script:MainBranch = $Branch
			& $Alias @Extra

			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly (@($Expected) + @($Extra))
		}
	}

	Context 'Aliases driven by the develop branch' {
		$cases = @(
			@{ Alias = 'gswd'; Branch = 'develop'; Expected = @('switch', 'develop') }
			@{ Alias = 'gswd'; Branch = 'dev'; Expected = @('switch', 'dev') }
		)

		It '<Alias> delegates to the <Branch> branch' -TestCases $cases {
			param($Alias, $Branch, $Expected)

			$script:DevelopBranch = $Branch
			& $Alias

			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly $Expected
		}
	}

	Context 'Aliases driven by the current branch' {
		# These aliases take no arguments of their own: anything passed to
		# them is ignored, the current branch comes from
		# Get-Git-CurrentBranch ('feature-x' here, on purpose a name that is
		# neither main nor master).
		$cases = @(
			@{ Alias = 'ggf'; Expected = @('push', '--force', 'origin', 'feature-x') }
			@{ Alias = 'ggfl'; Expected = @('push', '--force-with-lease', 'origin', 'feature-x') }
			@{ Alias = 'ggsup'; Expected = @('branch', '--set-upstream-to=origin/feature-x') }
			@{ Alias = 'gpsup'; Expected = @('push', '--set-upstream', 'origin', 'feature-x') }
			@{ Alias = 'groh'; Expected = @('reset', 'origin/feature-x', '--hard') }
			@{ Alias = 'ggl'; Expected = @('pull', 'origin', 'feature-x') }
			@{ Alias = 'ggp'; Expected = @('push', 'origin', 'feature-x') }
		)

		It '<Alias> uses the current branch and ignores extra arguments' -TestCases $cases {
			param($Alias, $Expected)

			& $Alias 'extra-argument-that-must-be-ignored'

			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly $Expected
		}

		It 'ggpnp pulls and then pushes the current branch' {
			# ggpnp forwards its arguments to ggp, which ignores them.
			ggpnp 'extra-argument-that-must-be-ignored'

			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('pull', 'origin', 'feature-x')
			$script:GitCalls[1] | Should -BeExactly @('push', 'origin', 'feature-x')
		}
	}

	Context 'Aliases running more than one git command' {
		It 'gru resets everything after the "--" separator' {
			gru file1.txt file2.txt

			# The bare "--" is swallowed by PowerShell's function argument
			# binding, so the mocked call does not record it (a native git
			# keeps receiving it). The trailing arguments do survive.
			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly @('reset', 'file1.txt', 'file2.txt')

			# The full git invocation is locked through the function body.
			(Get-Command gru).Definition | Should -Match 'git reset -- \$args'
		}

		It 'gpoat pushes all branches and all tags to origin, ignoring extra arguments' {
			gpoat 'extra-argument-that-must-be-ignored'

			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('push', 'origin', '--all')
			$script:GitCalls[1] | Should -BeExactly @('push', 'origin', '--tags')
		}

		It 'gpristine resets hard and cleans untracked files' {
			gpristine

			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('reset', '--hard')
			$script:GitCalls[1] | Should -BeExactly @('clean', '-dfx')
		}

		It 'gwip stages, removes deleted files and commits a WIP commit' {
			$script:GitOutput = @('a.txt', 'b.txt')
			$script:GitOutputFor = @('ls-files')

			gwip --allow-empty

			$script:GitCalls | Should -HaveCount 4
			$script:GitCalls[0] | Should -BeExactly @('add', '-A')
			$script:GitCalls[1] | Should -BeExactly @('ls-files', '--deleted')
			$script:GitCalls[2] | Should -BeExactly @('rm', 'a.txt', 'b.txt')
			$script:GitCalls[3] | Should -BeExactly @('commit', '--no-verify', '-m', '--wip-- [skip ci]')
		}
	}

	Context 'Aliases parsing git output' {
		It 'gbda deletes merged branches only, keeping the main branch' {
			$script:MainBranch = 'main'
			$script:GitOutput = @(
				'  main',
				'* feature-x',
				'  develop',
				'  dev',
				'  merged-a',
				'  merged-b',
				'',
				''
			)
			$script:GitOutputFor = @('branch', '--merged')

			gbda

			$script:GitCalls | Should -HaveCount 3
			$script:GitCalls[0] | Should -BeExactly @('branch', '--merged')
			$script:GitCalls[1] | Should -BeExactly @('branch', '-d', 'merged-a')
			$script:GitCalls[2] | Should -BeExactly @('branch', '-d', 'merged-b')
		}

		It 'gbda keeps the trunk branch when it is the main branch' {
			$script:MainBranch = 'trunk'
			$script:GitOutput = @(
				'  trunk',
				'* feature-x',
				'  develop',
				'  stale'
			)
			$script:GitOutputFor = @('branch', '--merged')

			gbda

			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('branch', '--merged')
			$script:GitCalls[1] | Should -BeExactly @('branch', '-d', 'stale')
		}

		It 'gignored lists lowercase prefixed files only' {
			$script:GitOutput = @('H tracked.txt', 'h assumed-unchanged.txt', 'M edited.txt')
			$script:GitOutputFor = @('ls-files')

			$result = gignored

			@($result).Count | Should -Be 1
			@($result)[0].Line | Should -BeExactly 'h assumed-unchanged.txt'
		}

		It 'gunwip outputs 1 and resets when the last commit is a WIP commit' {
			$script:GitOutput = @('commit 1234 --wip-- [skip ci]')
			$script:GitOutputFor = @('log')

			$result = gunwip

			"$result" | Should -Be '1'
			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('log', '-n', '1')
			$script:GitCalls[1] | Should -BeExactly @('reset', 'HEAD~1')
		}

		It 'gunwip outputs 0 and resets when the last commit is not a WIP commit' {
			$script:GitOutput = @('commit 1234 regular message')
			$script:GitOutputFor = @('log')

			$result = gunwip

			"$result" | Should -Be '0'
			$script:GitCalls | Should -HaveCount 2
			$script:GitCalls[0] | Should -BeExactly @('log', '-n', '1')
			$script:GitCalls[1] | Should -BeExactly @('reset', 'HEAD~1')
		}
	}

	Context 'grt navigation' {
		BeforeEach {
			Push-Location
		}

		AfterEach {
			Pop-Location
		}

		It 'grt changes to the repository root reported by git' {
			$script:GitOutput = @((Get-PSDrive TestDrive).Root)

			grt

			(Get-Location).Path | Should -Be (Get-PSDrive TestDrive).Root
		}

		It 'grt falls back to the current directory when git fails' {
			$BeforeLocation = (Get-Location).Path
			Mock git -ModuleName git-aliases { throw 'not a git repository' }

			{ grt } | Should -Not -Throw

			(Get-Location).Path | Should -Be $BeforeLocation
		}
	}

	Context 'Deprecated aliases still work and warn' {
		$cases = @(
			@{ Alias = 'gup'; Replacement = 'gpr'; Expected = @('pull', '--rebase'); Extra = @('-v') }
			@{ Alias = 'gupa'; Replacement = 'gpra'; Expected = @('pull', '--rebase', '--autostash') }
			@{ Alias = 'gupv'; Replacement = 'gprv'; Expected = @('pull', '--rebase', '-v') }
		)

		It '<Alias> prints a deprecation message pointing to <Replacement> and still runs git' -TestCases $cases {
			param($Alias, $Replacement, $Expected, $Extra = @())

			$output = (& $Alias @Extra 6>&1) | ForEach-Object { $_.ToString() }

			($output -join '') | Should -Match "$Alias is a deprecated alias, use `"$Replacement`" instead"

			$script:GitCalls | Should -HaveCount 1
			$script:GitCalls[0] | Should -BeExactly (@($Expected) + @($Extra))
		}
	}
}
