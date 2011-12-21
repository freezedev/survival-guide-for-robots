unit ElysionUtils;

interface

{$I Elysion.inc}

uses
  {$IFDEF WINDOWS}
  Windows,
  {$IFNDEF FPC} ShellAPI, {$ENDIF}
  {$ENDIF}
  {$IFDEF UNIX}
    {$IFDEF DARWIN}
    MacOSAll,
    {$ELSE}
    Process,
    {$ENDIF}
  {$ENDIF}
  SysUtils,
  Classes,
  Math,
  FileUtility;

function IntToString(aValue: Integer; LeadingZero: Boolean; Digits: Integer): String;
function BoolToString(aValue: Boolean): String;
function Split(fText: String;fSep: Char;fTrim: Boolean=false;fQuotes: Boolean=false): TStringList;

function FindDefaultBrowser(out ABrowser, AParams: String): Boolean;
function OpenURL(AURL: String): Boolean;

function GetFilenameExtension(Filename: String): String;

  
implementation

function IntToString(aValue: Integer; LeadingZero: Boolean; Digits: Integer): String;
var
  IntResult, Zeros: String;
  i: Integer;
begin
  Zeros := '';
  IntResult := SysUtils.IntToStr(aValue);
  if LeadingZero then
  begin
    for i := 1 to Digits do
    begin
      if aValue < Power(10, i) then Zeros := Zeros + '0';
    end;
    Result := Zeros + IntResult;
  end else Result := IntResult;
end;

function BoolToString(aValue: Boolean): String;
begin
  if aValue then Result := 'true'
            else Result := 'false';
end;

// See: http://www.delphi-library.de/topic_wie+kann+ich+einen+String+zerteilen_26639,0.html
function Split(fText: String;fSep: Char;fTrim: Boolean=false;fQuotes: Boolean=false): TStringList;
var vI: Integer;
    vBuffer: String;
    vOn: Boolean;
begin
  Result:=TStringList.Create;
  vBuffer:='';
  vOn:=true;
  for vI:=1 to Length(fText) do
  begin
    if (fQuotes and(fText[vI]=fSep)and vOn)or(Not(fQuotes) and (fText[vI]=fSep)) then
    begin
      if fTrim then vBuffer:=Trim(vBuffer);
      if vBuffer[1]=fSep then
        vBuffer:=Copy(vBuffer,2,Length(vBuffer));
      Result.Add(vBuffer);
      vBuffer:='';
    end;
    if fQuotes then
    begin
      if fText[vI]='"' then
      begin
        vOn:=Not(vOn);
        Continue;
      end;
      if (fText[vI]<>fSep)or((fText[vI]=fSep)and(vOn=false)) then
        vBuffer:=vBuffer+fText[vI];
    end else
      if fText[vI]<>fSep then
        vBuffer:=vBuffer+fText[vI];
  end;
  if vBuffer<>'' then
  begin
    if fTrim then vBuffer:=Trim(vBuffer);
    Result.Add(vBuffer);
  end;
end;

function FindDefaultBrowser(out ABrowser, AParams: String): Boolean;

  function Find(const ShortFilename: String; out ABrowser: String): Boolean; inline;
  begin
    {$IFDEF FPC}
    ABrowser := SearchFileInPath(ShortFilename + GetExeExt, '',
                      GetEnvironmentVariable('PATH'), PathSeparator,
                      [sffDontSearchInBasePath]);
    {$ELSE}
    ABrowser := SearchFileInPath(ShortFilename + GetExeExt, '',
                      SysUtils.GetEnvironmentVariable('PATH'), '\',
                      [sffDontSearchInBasePath]);
    {$ENDIF}

    Result := ABrowser <> '';
  end;

begin
  {$IFDEF MSWindows}
  Find('rundll32', ABrowser);
  AParams := 'url.dll,FileProtocolHandler %s';
  {$ELSE}
    {$IFDEF DARWIN}
    // open command launches url in the appropriate browser under Mac OS X
    Find('open', ABrowser);
    AParams := '%s';
    {$ELSE}
      ABrowser := '';
    {$ENDIF}
  {$ENDIF}
  if ABrowser = '' then
  begin
    AParams := '%s';
    // Then search in path. Prefer open source ;)
    if Find('xdg-open', ABrowser)  // Portland OSDL/FreeDesktop standard on Linux
    or Find('htmlview', ABrowser)  // some redhat systems
    or Find('firefox', ABrowser)
    or Find('mozilla', ABrowser)
    or Find('galeon', ABrowser)
    or Find('konqueror', ABrowser)
    or Find('safari', ABrowser)
    or Find('netscape', ABrowser)
    or Find('opera', ABrowser)
    or Find('iexplore', ABrowser) then ;// some windows systems
  end;
  Result := ABrowser <> '';
end;

function OpenURL(AURL: String): Boolean;

  {$IFDEF UNIX}
  {$IFNDEF DARWIN}
  procedure RunCmdFromPath(ProgramFilename, CmdLineParameters: string);
  var
    OldProgramFilename: String;
    BrowserProcess: TProcess;
  begin
    OldProgramFilename:=ProgramFilename;
    ProgramFilename:=FindFilenameOfCmd(ProgramFilename);

    if ProgramFilename='' then
      raise EFOpenError.Create(Format('File not found: %s', [OldProgramFilename]
        ));
    if not FileIsExecutable(ProgramFilename) then
      raise EFOpenError.Create(Format('Cannot execute: %s', [ProgramFilename]));

    // run
    BrowserProcess := TProcess.Create(nil);
    try
      // Encloses the executable with "" if it's name has spaces
      if Pos(' ',ProgramFilename)>0 then
        ProgramFilename:='"'+ProgramFilename+'"';

      BrowserProcess.CommandLine := ProgramFilename;
      if CmdLineParameters<>'' then
        BrowserProcess.CommandLine := BrowserProcess.CommandLine + ' ' + CmdLineParameters;
      BrowserProcess.Execute;
    finally
      BrowserProcess.Free;
    end;
  end;
  {$ENDIF}
  {$ENDIF}

{$IFDEF Windows}
var
{$IFDEF WinCE}
  Info: SHELLEXECUTEINFO;
{$ELSE}
  ws: WideString;
  ans: AnsiString;
{$ENDIF}
begin
  Result := False;
  if AURL = '' then Exit;

  {$IFDEF WinCE}
  FillChar(Info, SizeOf(Info), 0);
  Info.cbSize := SizeOf(Info);
  Info.fMask := SEE_MASK_FLAG_NO_UI;
  Info.lpVerb := 'open';
  Info.lpFile := PWideChar(UTF8Decode(AURL));
  Result := ShellExecuteEx(@Info);
  {$ELSE}
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    ws := UTF8Decode(AURL);
    Result := ShellExecuteW(0, 'open', PWideChar(ws), nil, nil, SW_SHOWNORMAL) > 32;
  end else
  begin
    ans := Utf8ToAnsi(AURL); // utf8 must be converted to Windows Ansi-codepage
    Result := ShellExecute(0, 'open', PAnsiChar(ans), nil, nil, SW_SHOWNORMAL) > 32;
  end;
  {$ENDIF}
end;
{$ELSE}
{$IFDEF DARWIN}
var
  cf: CFStringRef;
  url: CFURLRef;
begin
  if AURL = '' then
    Exit(False);
  cf := CFStringCreateWithCString(kCFAllocatorDefault, @AURL[1], kCFStringEncodingUTF8);
  if not Assigned(cf) then
    Exit(False);
  url := CFURLCreateWithString(nil, cf, nil);
  Result := LSOpenCFURLRef(url, nil) = 0;
  CFRelease(url);
  CFRelease(cf);
end;
{$ELSE}
var
  ABrowser, AParams: String;
begin
  Result := FindDefaultBrowser(ABrowser, AParams) and FileExists(ABrowser) and FileIsExecutable(ABrowser);
  if not Result then
    Exit;

  RunCmdFromPath(ABrowser,Format(AParams, [AURL]));
end;
{$ENDIF}
{$ENDIF}


function GetFilenameExtension(Filename: String): String;
begin
  Result := UpperCase(Copy(Filename, LastDelimiter('.', Filename) + 1, Length(Filename)));
end;


end.
