#define MyAppName "Claimer Control"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Rafael Caires"
#define MyAppURL "https://github.com/rafaelcairess/free-games-claimer-remaster-gui"

[Setup]
AppId={{28DAA8F0-B66F-40AB-A903-2FF4EC61A32B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases/latest
DefaultDirName={localappdata}\Programs\Claimer Control
DefaultGroupName=Claimer Control
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=output
OutputBaseFilename=Claimer-Control-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName=Claimer Control
LicenseFile=..\LICENSE
SetupIconFile=ClaimerControl.ico
UninstallDisplayIcon={app}\ClaimerControl.ico

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "security-en.txt"
Name: "ptbr"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"; InfoBeforeFile: "security-pt-BR.txt"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"; InfoBeforeFile: "security-es.txt"

[CustomMessages]
en.AutoStartTask=Start Claimer Control when I sign in to Windows
en.AutomationGroup=Automation
en.StartAfterInstall=Start Claimer Control
ptbr.AutoStartTask=Iniciar o Claimer Control ao entrar no Windows
ptbr.AutomationGroup=Automação
ptbr.StartAfterInstall=Iniciar o Claimer Control
es.AutoStartTask=Iniciar Claimer Control al entrar en Windows
es.AutomationGroup=Automatización
es.StartAfterInstall=Iniciar Claimer Control

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce
Name: "autostart"; Description: "{cm:AutoStartTask}"; GroupDescription: "{cm:AutomationGroup}"; Flags: checkedonce

[Files]
Source: "Start-ClaimerControl.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Start-ClaimerControl.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "docker-compose.yml"; DestDir: "{app}"; Flags: ignoreversion
Source: "claimer.env"; DestDir: "{app}"; Flags: ignoreversion
Source: "ClaimerControl.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Claimer Control"; Filename: "{app}\Start-ClaimerControl.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\ClaimerControl.ico"
Name: "{autodesktop}\Claimer Control"; Filename: "{app}\Start-ClaimerControl.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\ClaimerControl.ico"; Tasks: desktopicon
Name: "{userstartup}\Claimer Control"; Filename: "{app}\Start-ClaimerControl.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\ClaimerControl.ico"; Tasks: autostart
Name: "{group}\Uninstall Claimer Control"; Filename: "{uninstallexe}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\claimer-control"; ValueType: string; ValueName: ""; ValueData: "URL:Claimer Control"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\claimer-control"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\claimer-control\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """powershell.exe"" -NoLogo -NoProfile -ExecutionPolicy Bypass -File ""{app}\Start-ClaimerControl.ps1"" -Action update"; Flags: uninsdeletekey

[Run]
Filename: "{app}\Start-ClaimerControl.cmd"; Description: "{cm:StartAfterInstall}"; WorkingDir: "{app}"; Flags: postinstall nowait skipifsilent

[UninstallRun]
Filename: "powershell.exe"; Parameters: "-NoLogo -NoProfile -ExecutionPolicy Bypass -File ""{app}\Start-ClaimerControl.ps1"" -Action uninstall"; Flags: runhidden waituntilterminated; Check: KeepLocalData
Filename: "powershell.exe"; Parameters: "-NoLogo -NoProfile -ExecutionPolicy Bypass -File ""{app}\Start-ClaimerControl.ps1"" -Action uninstall -RemoveData"; Flags: runhidden waituntilterminated; Check: RemoveLocalData

[Code]
var
  DeleteLocalData: Boolean;

function LocalDataQuestion: String;
begin
  if ActiveLanguage = 'ptbr' then
    Result := 'Deseja apagar também as contas, sessões do navegador e histórico salvos localmente? O padrão seguro é Não.'
  else if ActiveLanguage = 'es' then
    Result := '¿También quieres eliminar las cuentas, sesiones del navegador y el historial guardados localmente? La opción segura predeterminada es No.'
  else
    Result := 'Also delete locally saved accounts, browser sessions and history? The safe default is No.';
end;

function InitializeUninstall(): Boolean;
begin
  DeleteLocalData := MsgBox(LocalDataQuestion, mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES;
  Result := True;
end;

function KeepLocalData(): Boolean;
begin
  Result := not DeleteLocalData;
end;

function RemoveLocalData(): Boolean;
begin
  Result := DeleteLocalData;
end;
