; Inno Setup script for FrameWorkz (Windows installer .exe)
; Build: flutter build windows --release  ->  then compile this script with Inno Setup 6
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer\windows\FrameWorkz.iss
; Output: installer\dist\FrameWorkz-Setup-<version>.exe

#define MyAppName "FrameWorkz"
#define MyAppPublisher "FrameWorkz"
#define MyAppURL "https://frameworkz.app"
#define MyAppExeName "frameworkz.exe"
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#define BuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{7D3A6C1E-5B2F-4C8A-9E1D-2F7A1C9B4E63}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=FrameWorkz-Setup-{#MyAppVersion}
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "startup"; Description: "Start FrameWorkz when I sign in (keeps reminders running)"; GroupDescription: "Startup:"; Flags: unchecked

[Files]
; Everything Flutter produced: exe, flutter_windows.dll, plugin DLLs and the data\ folder.
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Visual C++ runtime (required by Flutter on clean machines). Download vc_redist.x64.exe into installer\windows\redist\.
Source: "redist\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: FileExists(ExpandConstant('{src}\redist\vc_redist.x64.exe')) or FileExists('redist\vc_redist.x64.exe')

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: startup

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Visual C++ runtime…"; Flags: waituntilterminated skipifdoesntexist
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Keep the user's database (AppData) — only remove program files.
Type: filesandordirs; Name: "{app}\data"
