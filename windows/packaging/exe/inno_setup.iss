[Setup]
AppId=B9F6E402-0CAE-4045-BDE6-14BD6C39C4EA
AppVersion=1.12.4+29
AppName=Saya Music
AppPublisher=shnwazdeveloper
AppPublisherURL=https://github.com/shnwazdeveloper/sayamusicpc
AppSupportURL=https://github.com/shnwazdeveloper/sayamusicpc
AppUpdatesURL=https://github.com/shnwazdeveloper/sayamusicpc
DefaultDirName={autopf}\sayamusic
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=sayamusic-1.12.4
Compression=lzma
SolidCompression=yes
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
WizardStyle=modern
PrivilegesRequired=lowest
LicenseFile=..\..\LICENSE
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\build\windows\x64\runner\Release\sayamusic.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\Saya Music"; Filename: "{app}\sayamusic.exe"
Name: "{autodesktop}\Saya Music"; Filename: "{app}\sayamusic.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\sayamusic.exe"; Description: "{cm:LaunchProgram,{#StringChange('Saya Music', '&', '&&')}}"; Flags: nowait postinstall skipifsilent
