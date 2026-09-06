[CmdletBinding()]
param(
    [ValidateSet("start", "source", "update", "uninstall", "check")]
    [string]$Action = "start",
    [ValidateSet("auto", "en", "pt-BR", "es")]
    [string]$Language = "auto",
    [switch]$RemoveData
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$Messages = @{
    en = @{
        Title = "Claimer Control"
        DockerMissing = "Docker Desktop is required. Claimer Control can install it from the official source now."
        InstallPrompt = "Install Docker Desktop? [Y/n]"
        InstallCancelled = "Installation cancelled. No changes were made."
        InstallingWinget = "Installing Docker Desktop with Windows Package Manager..."
        DownloadingDocker = "Windows Package Manager is unavailable. Downloading Docker Desktop from Docker's official website..."
        InvalidSignature = "The Docker installer does not have a valid Docker Inc. digital signature. Installation was stopped."
        RestartNeeded = "Windows must restart to finish Docker setup. Claimer Control will continue automatically after sign-in."
        StartingDocker = "Starting Docker Desktop..."
        WaitingDocker = "Waiting for Docker Desktop to become ready"
        DockerTimeout = "Docker Desktop did not become ready in time. Open Docker Desktop, finish its first-run screens, then use the Claimer Control shortcut again."
        Pulling = "Downloading the Claimer Control application..."
        Starting = "Starting Claimer Control..."
        StartingSource = "Building and starting Claimer Control from this source folder..."
        WaitingPanel = "Waiting for the local dashboard"
        PanelTimeout = "The container started, but the local dashboard did not respond. Open Docker Desktop and check the claimer-control container."
        Ready = "Claimer Control is ready. Opening the local dashboard..."
        UpdateCheck = "Checking the official Claimer Control Release..."
        UpToDate = "Claimer Control is already up to date."
        UpdatePrompt = "Update from {0} to {1}? [Y/n]"
        Updating = "Installing update {0}..."
        UpdateInvalid = "GitHub returned an invalid version. The update was stopped."
        LegacyFound = "An existing Free Games Claimer installation was found. Reuse its local accounts and browser sessions? [Y/n]"
        LegacyAdopted = "Existing local data will be reused. The old container was replaced; its local data was preserved."
        CheckOk = "Launcher files are valid."
        Failed = "Claimer Control could not finish: {0}"
    }
    "pt-BR" = @{
        Title = "Claimer Control"
        DockerMissing = "O Docker Desktop é necessário. O Claimer Control pode instalá-lo agora pela fonte oficial."
        InstallPrompt = "Instalar o Docker Desktop? [S/n]"
        InstallCancelled = "Instalação cancelada. Nenhuma alteração foi feita."
        InstallingWinget = "Instalando o Docker Desktop pelo Gerenciador de Pacotes do Windows..."
        DownloadingDocker = "O Gerenciador de Pacotes não está disponível. Baixando o Docker Desktop pelo site oficial da Docker..."
        InvalidSignature = "O instalador do Docker não possui uma assinatura digital válida da Docker Inc. A instalação foi interrompida."
        RestartNeeded = "O Windows precisa reiniciar para concluir o Docker. O Claimer Control continuará automaticamente após o login."
        StartingDocker = "Iniciando o Docker Desktop..."
        WaitingDocker = "Aguardando o Docker Desktop ficar pronto"
        DockerTimeout = "O Docker Desktop não ficou pronto a tempo. Abra o Docker Desktop, conclua as telas iniciais e use novamente o atalho do Claimer Control."
        Pulling = "Baixando o aplicativo Claimer Control..."
        Starting = "Iniciando o Claimer Control..."
        StartingSource = "Preparando e iniciando o Claimer Control a partir desta pasta..."
        WaitingPanel = "Aguardando o painel local"
        PanelTimeout = "O container iniciou, mas o painel local não respondeu. Abra o Docker Desktop e verifique o container claimer-control."
        Ready = "Claimer Control pronto. Abrindo o painel local..."
        UpdateCheck = "Consultando a Release oficial do Claimer Control..."
        UpToDate = "O Claimer Control já está atualizado."
        UpdatePrompt = "Atualizar da versão {0} para {1}? [S/n]"
        Updating = "Instalando a atualização {0}..."
        UpdateInvalid = "O GitHub retornou uma versão inválida. A atualização foi interrompida."
        LegacyFound = "Uma instalação anterior do Free Games Claimer foi encontrada. Reutilizar contas e sessões locais? [S/n]"
        LegacyAdopted = "Os dados locais existentes serão reutilizados. O container antigo foi substituído; os dados locais foram preservados."
        CheckOk = "Os arquivos do inicializador são válidos."
        Failed = "O Claimer Control não conseguiu concluir: {0}"
    }
    es = @{
        Title = "Claimer Control"
        DockerMissing = "Docker Desktop es necesario. Claimer Control puede instalarlo ahora desde la fuente oficial."
        InstallPrompt = "¿Instalar Docker Desktop? [S/n]"
        InstallCancelled = "Instalación cancelada. No se realizó ningún cambio."
        InstallingWinget = "Instalando Docker Desktop con el Administrador de paquetes de Windows..."
        DownloadingDocker = "El Administrador de paquetes no está disponible. Descargando Docker Desktop desde el sitio oficial de Docker..."
        InvalidSignature = "El instalador de Docker no tiene una firma digital válida de Docker Inc. La instalación se detuvo."
        RestartNeeded = "Windows debe reiniciarse para completar Docker. Claimer Control continuará automáticamente después de iniciar sesión."
        StartingDocker = "Iniciando Docker Desktop..."
        WaitingDocker = "Esperando a que Docker Desktop esté listo"
        DockerTimeout = "Docker Desktop no estuvo listo a tiempo. Ábrelo, completa sus pantallas iniciales y vuelve a usar el acceso directo de Claimer Control."
        Pulling = "Descargando la aplicación Claimer Control..."
        Starting = "Iniciando Claimer Control..."
        StartingSource = "Preparando e iniciando Claimer Control desde esta carpeta..."
        WaitingPanel = "Esperando el panel local"
        PanelTimeout = "El contenedor se inició, pero el panel local no respondió. Abre Docker Desktop y comprueba el contenedor claimer-control."
        Ready = "Claimer Control está listo. Abriendo el panel local..."
        UpdateCheck = "Consultando la Release oficial de Claimer Control..."
        UpToDate = "Claimer Control ya está actualizado."
        UpdatePrompt = "¿Actualizar de la versión {0} a {1}? [S/n]"
        Updating = "Instalando la actualización {0}..."
        UpdateInvalid = "GitHub devolvió una versión no válida. La actualización se detuvo."
        LegacyFound = "Se encontró una instalación anterior de Free Games Claimer. ¿Reutilizar sus cuentas y sesiones locales? [S/n]"
        LegacyAdopted = "Se reutilizarán los datos locales existentes. Se reemplazó el contenedor anterior y se conservaron sus datos locales."
        CheckOk = "Los archivos del iniciador son válidos."
        Failed = "Claimer Control no pudo finalizar: {0}"
    }
}

function Resolve-Language {
    if ($Language -ne "auto") { return $Language }
    $culture = [System.Globalization.CultureInfo]::CurrentUICulture.Name.ToLowerInvariant()
    if ($culture.StartsWith("pt")) { return "pt-BR" }
    if ($culture.StartsWith("es")) { return "es" }
    return "en"
}

$Script:Locale = Resolve-Language
$Script:Text = $Messages[$Script:Locale]
$ComposeFile = Join-Path $PSScriptRoot "docker-compose.yml"
$EnvironmentFile = Join-Path $PSScriptRoot "claimer.env"
if ($Action -eq "source") {
    $sourceRoot = Split-Path -Parent $PSScriptRoot
    $ComposeFile = Join-Path $sourceRoot "docker-compose.yml"
    $EnvironmentFile = Join-Path $sourceRoot ".env"
}
$PanelUrl = "http://127.0.0.1:8080"
$ReleaseApi = "https://api.github.com/repos/rafaelcairess/free-games-claimer-remaster-gui/releases/latest"

function Write-Step([string]$Message) {
    Write-Host "`n> $Message" -ForegroundColor Cyan
}

function Confirm-DefaultYes([string]$Prompt) {
    $answer = Read-Host $Prompt
    return [string]::IsNullOrWhiteSpace($answer) -or $answer -match "^(y|yes|s|sim|sí|si)$"
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-DockerReady {
    try {
        & docker info *> $null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Test-DockerCommandAvailable {
    return $null -ne (Get-Command docker.exe -ErrorAction SilentlyContinue)
}

function Set-ResumeAfterRestart {
    $runOnce = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    New-Item -Path $runOnce -Force | Out-Null
    $command = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "{0}" -Action start -Language {1}' -f $PSCommandPath, $Script:Locale
    New-ItemProperty -Path $runOnce -Name "ClaimerControlResume" -Value $command -PropertyType String -Force | Out-Null
}

function Install-DockerDesktop {
    Write-Host $Script:Text.DockerMissing -ForegroundColor Yellow
    if (-not (Confirm-DefaultYes $Script:Text.InstallPrompt)) {
        Write-Host $Script:Text.InstallCancelled
        exit 2
    }

    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($winget) {
        Write-Step $Script:Text.InstallingWinget
        $process = Start-Process -FilePath $winget.Source -ArgumentList @(
            "install", "--id", "Docker.DockerDesktop", "--exact",
            "--accept-package-agreements", "--accept-source-agreements"
        ) -Wait -PassThru
        if ($process.ExitCode -notin @(0, 3010, 1641)) {
            throw "winget exit code $($process.ExitCode)"
        }
        if ($process.ExitCode -in @(3010, 1641)) {
            Set-ResumeAfterRestart
            Write-Host $Script:Text.RestartNeeded -ForegroundColor Yellow
            exit 3010
        }
    } else {
        Write-Step $Script:Text.DownloadingDocker
        $download = Join-Path $env:TEMP "DockerDesktopInstaller-ClaimerControl.exe"
        if (Test-Path -LiteralPath $download) { Remove-Item -LiteralPath $download -Force }
        Invoke-WebRequest -UseBasicParsing -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -OutFile $download
        $signature = Get-AuthenticodeSignature -LiteralPath $download
        if ($signature.Status -ne "Valid" -or $signature.SignerCertificate.Subject -notmatch "Docker Inc") {
            Remove-Item -LiteralPath $download -Force
            throw $Script:Text.InvalidSignature
        }
        $process = Start-Process -FilePath $download -ArgumentList @("install", "--accept-license") -Wait -PassThru
        Remove-Item -LiteralPath $download -Force
        if ($process.ExitCode -notin @(0, 3010, 1641)) { throw "Docker installer exit code $($process.ExitCode)" }
        if ($process.ExitCode -in @(3010, 1641)) {
            Set-ResumeAfterRestart
            Write-Host $Script:Text.RestartNeeded -ForegroundColor Yellow
            exit 3010
        }
    }
    Refresh-Path
}

function Wait-DockerDesktop {
    if (Test-DockerReady) { return }
    Write-Step $Script:Text.StartingDocker
    $desktop = Join-Path $env:ProgramFiles "Docker\Docker\Docker Desktop.exe"
    if (-not (Test-Path -LiteralPath $desktop)) { throw "Docker Desktop executable not found" }
    Start-Process -FilePath $desktop -WindowStyle Hidden | Out-Null
    Write-Step $Script:Text.WaitingDocker
    for ($attempt = 1; $attempt -le 120; $attempt++) {
        if (Test-DockerReady) { Write-Host " OK" -ForegroundColor Green; return }
        if (($attempt % 5) -eq 0) { Write-Host "." -NoNewline }
        Start-Sleep -Seconds 3
    }
    throw $Script:Text.DockerTimeout
}

function Set-EnvironmentValue([string]$Name, [string]$Value) {
    if ($Name -notmatch "^[A-Z_]+$" -or $Value -match "[`r`n]") { throw "Invalid environment value" }
    $content = Get-Content -LiteralPath $EnvironmentFile -Encoding UTF8
    $pattern = "^$([regex]::Escape($Name))="
    $found = $false
    $updated = foreach ($line in $content) {
        if ($line -match $pattern) { $found = $true; "$Name=$Value" } else { $line }
    }
    if (-not $found) { $updated += "$Name=$Value" }
    Set-Content -LiteralPath $EnvironmentFile -Value $updated -Encoding UTF8
}

function Get-EnvironmentValue([string]$Name) {
    $line = Get-Content -LiteralPath $EnvironmentFile -Encoding UTF8 | Where-Object { $_ -match "^$([regex]::Escape($Name))=" } | Select-Object -First 1
    if ($line) { return ($line -split "=", 2)[1].Trim() }
    return ""
}

function Get-LegacyDataVolumeFromInspect([string]$Json) {
    if ([string]::IsNullOrWhiteSpace($Json)) { return "" }
    try {
        $containers = @(ConvertFrom-Json -InputObject $Json)
        $mount = @($containers[0].Mounts | Where-Object { $_.Destination -eq "/fgc/data" })[0]
        if ($null -eq $mount) { return "" }
        return [string]$mount.Name
    } catch {
        return ""
    }
}

function Adopt-LegacyData {
    $inspect = & docker inspect fgc-remaster 2>$null
    if ($LASTEXITCODE -ne 0) { return }
    $legacy = (Get-LegacyDataVolumeFromInspect ($inspect -join [Environment]::NewLine)).Trim()
    if ($legacy -notmatch "^[A-Za-z0-9][A-Za-z0-9_.-]+$") { return }
    if ($legacy -eq (Get-EnvironmentValue "CLAIMER_DATA_VOLUME")) { return }
    if (Confirm-DefaultYes $Script:Text.LegacyFound) {
        & docker stop fgc-remaster *> $null
        if ($LASTEXITCODE -ne 0) { throw "Could not stop the existing fgc-remaster container" }
        & docker rm fgc-remaster *> $null
        if ($LASTEXITCODE -ne 0) { throw "Could not replace the existing fgc-remaster container" }
        Set-EnvironmentValue "CLAIMER_DATA_VOLUME" $legacy
        Write-Host $Script:Text.LegacyAdopted -ForegroundColor Green
    }
}

function Invoke-Compose([string[]]$Arguments) {
    if ($Action -eq "source") {
        & docker compose --env-file $EnvironmentFile -f $ComposeFile @Arguments
    } else {
        & docker compose --project-name claimer-control --env-file $EnvironmentFile -f $ComposeFile @Arguments
    }
    if ($LASTEXITCODE -ne 0) { throw "docker compose $($Arguments -join ' ') failed" }
}

function Wait-Panel {
    Write-Step $Script:Text.WaitingPanel
    for ($attempt = 1; $attempt -le 90; $attempt++) {
        try {
            $response = Invoke-WebRequest -UseBasicParsing -Uri "$PanelUrl/api/status" -TimeoutSec 2
            if ($response.StatusCode -eq 200) { return }
        } catch { }
        if (($attempt % 5) -eq 0) { Write-Host "." -NoNewline }
        Start-Sleep -Seconds 2
    }
    throw $Script:Text.PanelTimeout
}

function Get-LatestReleaseTag {
    Write-Step $Script:Text.UpdateCheck
    $release = Invoke-RestMethod -Uri $ReleaseApi -Headers @{Accept = "application/vnd.github+json"; "User-Agent" = "claimer-control-launcher/1.0.0"} -TimeoutSec 15
    $tag = [string]$release.tag_name
    if ($tag -notmatch "^v\d+\.\d+\.\d+$") { throw $Script:Text.UpdateInvalid }
    return $tag
}

function Start-Application {
    Adopt-LegacyData
    Write-Step $Script:Text.Pulling
    Invoke-Compose @("pull", "app")
    Write-Step $Script:Text.Starting
    Invoke-Compose @("up", "-d", "app")
    Wait-Panel
    Write-Host $Script:Text.Ready -ForegroundColor Green
    Start-Process $PanelUrl | Out-Null
}

function Start-SourceApplication {
    Write-Step $Script:Text.StartingSource
    Invoke-Compose @("up", "-d", "--build", "app")
    Wait-Panel
    Write-Host $Script:Text.Ready -ForegroundColor Green
    Start-Process $PanelUrl | Out-Null
}

function Update-Application {
    $latest = Get-LatestReleaseTag
    $current = Get-EnvironmentValue "CLAIMER_TAG"
    if ($current -eq $latest) { Write-Host $Script:Text.UpToDate -ForegroundColor Green; return }
    if (-not (Confirm-DefaultYes ($Script:Text.UpdatePrompt -f $current, $latest))) { return }
    Write-Step ($Script:Text.Updating -f $latest)
    Set-EnvironmentValue "CLAIMER_TAG" $latest
    Invoke-Compose @("pull", "app")
    Invoke-Compose @("up", "-d", "app")
    Wait-Panel
    Start-Process $PanelUrl | Out-Null
}

function Invoke-ClaimerControl(
    [ValidateSet("start", "source", "update", "uninstall", "check")]
    [string]$RequestedAction = $Action
) {
    try {
        $host.UI.RawUI.WindowTitle = $Script:Text.Title
        if (-not (Test-Path -LiteralPath $ComposeFile) -or -not (Test-Path -LiteralPath $EnvironmentFile)) {
            throw "Required launcher files are missing"
        }
        if ($RequestedAction -eq "check") { Write-Host $Script:Text.CheckOk -ForegroundColor Green; return 0 }
        if (-not (Test-DockerCommandAvailable)) { Install-DockerDesktop }
        Wait-DockerDesktop
        if ($RequestedAction -eq "update") { Update-Application }
        elseif ($RequestedAction -eq "source") { Start-SourceApplication }
        elseif ($RequestedAction -eq "uninstall") {
            Invoke-Compose @("down")
            if ($RemoveData) {
                $volume = Get-EnvironmentValue "CLAIMER_DATA_VOLUME"
                if ($volume -notmatch "^[A-Za-z0-9][A-Za-z0-9_.-]+$") { throw "Invalid data volume name" }
                & docker volume rm $volume
                if ($LASTEXITCODE -ne 0) { throw "Could not remove data volume $volume" }
            }
        } else { Start-Application }
        return 0
    } catch {
        Write-Host ($Script:Text.Failed -f $_.Exception.Message) -ForegroundColor Red
        return 1
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    exit (Invoke-ClaimerControl)
}
