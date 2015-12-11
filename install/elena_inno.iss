; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{3CAA69D3-0F98-44B1-A73E-E864BA51D5BD}
AppName=ELENA Programming Language
AppVersion=1.9.23
;AppVerName=ELENA Programming Language 1.9.18
AppPublisher=Alexey Rakov
AppPublisherURL=http://github.com/ELENA-LANG/elena-lang
AppSupportURL=http://github.com/ELENA-LANG/elena-lang
AppUpdatesURL=http://github.com/ELENA-LANG/elena-lang
DefaultDirName={pf}\ELENA
DefaultGroupName=ELENA Programming Language
AllowNoIcons=yes
LicenseFile=..\license.txt
InfoAfterFile=..\whatsnew.txt
OutputBaseFilename=elena-setup
Compression=lzma
SolidCompression=yes
ChangesEnvironment=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "..\bin\*"; DestDir: "{app}\bin"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\dat\*"; DestDir: "{app}\dat"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\doc\*"; DestDir: "{app}\doc"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\elenasrc2\*"; DestDir: "{app}\elenasrc2"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\examples\*"; DestDir: "{app}\examples"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\lib30\*"; DestDir: "{app}\lib30"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\src30\*"; DestDir: "{app}\src30"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\license.txt"; DestDir: "{app}";
Source: "..\readme.txt"; DestDir: "{app}"; Flags: isreadme
Source: "..\whatsnew.txt"; DestDir: "{app}";
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\ELENA Programming Language"; Filename: "{app}\bin\elide.exe"
Name: "{commondesktop}\ELENA Programming Language"; Filename: "{app}\bin\elide.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\ELENA Programming Language"; Filename: "{app}\bin\elide.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\bin\elide.exe"; Description: "{cm:LaunchProgram,ELENA Programming Language}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\bin"; Check: NeedsAddPath('{app}\bin')

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;
