Describe "Claimer Control launcher flow" {
    BeforeAll {
        . "$PSScriptRoot/../installer/Start-ClaimerControl.ps1" -Action start -Language en
    }

    BeforeEach {
        $script:Action = "start"
        Mock Test-Path { $true }
        Mock Wait-DockerDesktop {}
        Mock Start-Application {}
        Mock Start-SourceApplication {}
        Mock Install-DockerDesktop {}
    }

    It "starts directly when Docker is installed" {
        Mock Test-DockerCommandAvailable { $true }
        Invoke-ClaimerControl | Should Be 0
        Assert-MockCalled Install-DockerDesktop -Times 0 -Exactly -Scope It
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "waits for Docker when the command exists but the engine is stopped" {
        Mock Test-DockerCommandAvailable { $true }
        Invoke-ClaimerControl | Should Be 0
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "installs Docker before starting when Docker is absent" {
        Mock Test-DockerCommandAvailable { $false }
        Invoke-ClaimerControl | Should Be 0
        Assert-MockCalled Install-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Wait-DockerDesktop -Times 1 -Exactly -Scope It
        Assert-MockCalled Start-Application -Times 1 -Exactly -Scope It
    }

    It "uses the local source flow from a repository checkout" {
        $script:Action = "source"
        Mock Test-DockerCommandAvailable { $true }
        Invoke-ClaimerControl | Should Be 0
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
        Get-LegacyDataVolumeFromInspect $json | Should Be "fgc-remaster_fgc-data"
    }

    It "returns an empty value when the expected mount is absent" {
        Get-LegacyDataVolumeFromInspect '[{"Mounts":[]}]' | Should Be ""
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
