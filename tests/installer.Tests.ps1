Describe "Lontrium Control launcher flow" {
    BeforeAll {
        . "$PSScriptRoot/../installer/Start-ClaimerControl.ps1" -Action start -Language en
    }

    BeforeEach {
        Mock Test-Path { $true }
        Mock Wait-DockerDesktop {}
        Mock Start-Application {}
        Mock Start-SourceApplication {}
        Mock Install-DockerDesktop {}
    }

    It "starts directly when Docker is installed" {
        Mock Test-DockerCommandAvailable { $true }
        $result = Invoke-ClaimerControl
        if ($result -ne 0) { throw "Expected launcher exit code 0, got $result" }
        Assert-MockCalled Install-DockerDesktop -Times 0 -Exactly -Scope It
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "waits for Docker when the command exists but the engine is stopped" {
        Mock Test-DockerCommandAvailable { $true }
        $result = Invoke-ClaimerControl
        if ($result -ne 0) { throw "Expected launcher exit code 0, got $result" }
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "installs Docker before starting when Docker is absent" {
        Mock Test-DockerCommandAvailable { $false }
        $result = Invoke-ClaimerControl
        if ($result -ne 0) { throw "Expected launcher exit code 0, got $result" }
        Assert-MockCalled Install-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "uses the local source flow from a repository checkout" {
        Mock Test-DockerCommandAvailable { $true }
        $result = Invoke-ClaimerControl -RequestedAction source
        if ($result -ne 0) { throw "Expected launcher exit code 0, got $result" }
        Assert-MockCalled Start-SourceApplication -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 0 -Exactly -Scope It
    }
}

Describe "Legacy Docker data discovery" {
    BeforeAll {
        . "$PSScriptRoot/../installer/Start-ClaimerControl.ps1" -Action start -Language en
    }

    It "finds the named data volume without using a Docker format template" {
        $json = @'
[
  {
    "Mounts": [
      {"Type": "volume", "Name": "fgc-remaster_fgc-data", "Destination": "/fgc/data"},
      {"Type": "bind", "Source": "C:\\example", "Destination": "/tmp/example"}
    ]
  }
]
'@
        $volume = Get-LegacyDataVolumeFromInspect $json
        if ($volume -ne "fgc-remaster_fgc-data") { throw "Unexpected legacy volume: $volume" }
    }

    It "returns an empty value when the expected mount is absent" {
        [string]$volume = Get-LegacyDataVolumeFromInspect '[{"Mounts":[]}]'
        if ($volume -ne "") { throw "Expected no legacy volume, got $volume" }
    }

    It "treats a missing legacy container as a clean installation" {
        Mock docker {
            $global:LASTEXITCODE = 1
            Write-Error "Error: No such object: fgc-remaster"
        } -ParameterFilter { $args[0] -eq "inspect" }
        Mock Confirm-DefaultYes { throw "The migration prompt must not be shown" }

        $threw = $false
        try { Adopt-LegacyData } catch { $threw = $true }
        if ($threw) { throw "A missing legacy container must not stop the launcher" }
        Assert-MockCalled Confirm-DefaultYes -Times 0 -Exactly -Scope It
    }

    It "replaces the legacy container while preserving its named data volume" {
        $launcher = Get-Content -LiteralPath "$PSScriptRoot/../installer/Start-ClaimerControl.ps1" -Raw
        if ($launcher -notmatch '& docker stop fgc-remaster') { throw "Legacy container is not stopped" }
        if ($launcher -notmatch '& docker rm fgc-remaster') { throw "Legacy container is not replaced" }
        if ($launcher -notmatch 'Set-EnvironmentValue "CLAIMER_DATA_VOLUME"') { throw "Legacy volume is not adopted" }
    }
}

Describe "Local dashboard readiness" {
    BeforeAll {
        . "$PSScriptRoot/../installer/Start-ClaimerControl.ps1" -Action start -Language en
    }

    It "uses the explicit IPv4 loopback address" {
        Mock Invoke-WebRequest { [pscustomobject]@{StatusCode = 200} }
        Wait-Panel
        Assert-MockCalled Invoke-WebRequest -Times 1 -Exactly -ParameterFilter {
            $Uri -eq "http://127.0.0.1:8080/api/status"
        }
    }
}

Describe "Application identity" {
    It "uses the Lontrium Control icon for setup and shortcuts" {
        $installer = Get-Content -LiteralPath "$PSScriptRoot/../installer/ClaimerControl.iss" -Raw
        if ($installer -notmatch 'SetupIconFile=Lontrium\.ico') { throw "Setup icon is not configured" }
        if ($installer -notmatch 'IconFilename: "\{app\}\\Lontrium\.ico"') { throw "Shortcut icon is not configured" }
        if (-not (Test-Path -LiteralPath "$PSScriptRoot/../installer/Lontrium.ico")) { throw "Installer icon is missing" }
    }

    It "registers Lontrium updates and preserves the former protocol alias" {
        $installer = Get-Content -LiteralPath "$PSScriptRoot/../installer/ClaimerControl.iss" -Raw
        if ($installer -notmatch 'Software\\Classes\\lontrium') { throw "Lontrium update protocol is not configured" }
        if ($installer -notmatch 'Software\\Classes\\claimer-control') { throw "Legacy update protocol alias is missing" }
    }

    It "does not overwrite the local data-volume configuration during upgrades" {
        $installer = Get-Content -LiteralPath "$PSScriptRoot/../installer/ClaimerControl.iss" -Raw
        if ($installer -notmatch 'Source: "claimer\.env";[^\r\n]+onlyifdoesntexist') {
            throw "Installer upgrades could replace the user's persistent volume configuration"
        }
    }
}
