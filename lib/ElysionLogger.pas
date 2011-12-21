{%region '--- Unit description ---'}
(**
  *
  *
  *
  *
  *
  *
  *
  *)
{%endregion}

unit ElysionLogger;

interface

{$I Elysion.inc}

uses
  ElysionUtils,
  ElysionTypes,

  Classes,
  SysUtils;

type

{%region 'Logger priority types'}
// Logger message type
TLogMessageType = 
  (ltError,   //< Displays message as an error
   ltWarning, //< Displays message as a warning
   ltNote);   //< Displays message as a note

TLogMessagePriorities = set of TLogMessageType;
{%endregion}

{%region 'Logger class (Prototype)'}
{
  Class: TelLogger @br
  Group: Optional @br
  Description: Very simple logger class @br
  Singleton pattern -> See http://en.wikipedia.org/wiki/Singleton_pattern for more information 
}
TelLogger = class
private
  fFilename: String;
  fText: TStringList;
  fPriorities: TLogMessagePriorities;
  fLastUsedTableColor: String;
	
  procedure HTMLWriteHead;
  procedure HTMLWriteTail;
  function ReplaceSpecialChars(InputString: String): String;
protected
    {$WARNINGS OFF}
    {
      constructor TelLogger.Create @br
	  Type: Constructor @br
	  Parameters: None @br
      Description: Creates the logger class
    }
    constructor Create;
    {$WARNINGS ON}
    
  public
    {	
	  class function TelLogger.GetInstance @br
      Type: Function @br
	  Parameters: None @br
	  Description: Returns the instance of the logger class
	  
    }
    class function GetInstance: TelLogger;
	
	{
	  destructor TelLogger.Destroy @br
	  Type: Destructor @br
	  Parameters: None @br
      Description: Destroy the logger class
	}
	destructor Destroy; Override;

	{	
	  procedure TelLogger.WriteLog @br
	  Parameters: @br
		@param Msg: String - The message to be written in the log file @br
		@param LogMessageType: TLogMessageType = ltError - The logger message type @seealso TLogType (Optional) @br
	  Description: Writes a user-defined text in the log file.
	}
    procedure WriteLog(const Msg: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false); Overload;
    
    {	
	  procedure TelLogger.WriteLog @br
	  Parameters: @br
		@param Msg: String - The message to be written in the log file @br
		@param Category: Specify a category @br
		@param LogMessageType: TLogMessageType = ltError - The logger message type @seealso TLogType (Optional) @br
	  Description: Writes a user-defined text in the log file.
	}
    procedure WriteLog(const Msg: String; Category: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false); Overload;
	
	{	
	  procedure TelLogger.WriteLog @br
	  Parameters: @br
		@param Msg: String - The message to be written in the log file @br
		@param Args: Array of constants @br
		@param LogMessageType: TLogMessageType = ltError - The logger message type @seealso TLogType (Optional) @br
	  Description: Writes a user-defined text in the log file.
	}
    procedure WriteLog(const Msg: String; Args: array of const; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false); Overload;
    
    {	
	  procedure TelLogger.WriteLog @br
	  Parameters: @br
		@param Msg: String - The message to be written in the log file @br
		@param Args: Array of constants @br
		@param Category: Specify a category @br
		@param LogMessageType: TLogMessageType = ltError - The logger message type @seealso TLogType (Optional) @br
	  Description: Writes a user-defined text in the log file.
	}
    procedure WriteLog(const Msg: String; Args: array of const; Category: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false); Overload;
  
  published
    property Filename: String read fFilename;
    property Priorities: TLogMessagePriorities read fPriorities write fPriorities;
end;
{%endregion}

(**
  * 
  * @param None
  * @return True if TelLogger class has an instance, false if TelLogger is nil
  *
  *)
function isLoggerActive: Boolean;

implementation

var
  Logger: TelLogger;

function isLoggerActive: Boolean;
begin
  if (Logger = nil) then Result := false else Result := true;
end;

procedure TelLogger.HTMLWriteHead;
begin
  fText.Add('<html>');
  fText.Add('<head>');
  fText.Add('  <title>Elysion Library Log</title>');
  fText.Add('<style>');
  fText.Add('body { background:#FCFCFC; }');
  fText.Add('.row:nth-child(even) { background: #dde; text-shadow: }');
  fText.Add('.row:nth-child(odd) { background: white; }');

  fText.Add('</style>');
  fText.Add('</head>');
  fText.Add('<body>');
  fText.Add('<div style="font-size:90%; color:#000000; font-family:DejaVu Sans, Verdana, Arial">');
  fText.Add('</br>');
  fText.Add('<div style="align:center"><font size="+1"><strong><a href="http://www.elysion.freeze-dev.com">Elysion Library</a> Log</strong></font></br>');
  fText.Add('<strong>CPU:</strong> ' + IntToStr(SYS_BITS) + '-bit <br> <b>Operating system:</b> ' + SYS_NAME + '</br>');
  fText.Add('<strong>Version:</strong> ' + IntToString(VER_MAJOR, true, 1) + '-' + IntToString(VER_MINOR, true, 1) + ' "' + VER_CODENAME + '" (' + VER_CODENAME_RANDOMQUOTE + ') <strong>Stable:</strong> '+BoolToString(VER_STABLE)+'</br>');
  fText.Add('<strong>Filename:</strong> ' + fFilename + '</br>');
  fText.Add('</br></br>');
  fText.Add('<table border="1" bordercolor="#FFFFDD" cellspacing="0" cellpadding="3" width="80%">');
  fText.Add('<tr bgcolor="#C0C0C0">');
  fText.Add('  <th>Time</th>');
  fText.Add('  <th>Message type</th>');
  fText.Add('  <th>Category</th>');
  fText.Add('  <th>Message</th>');
  fText.Add('</tr>');
end;

procedure TelLogger.HTMLWriteTail;
begin
  fText.Add('</table>');
  fText.Add('</div>');
  fText.Add('</div>');
  fText.Add('</body>');
  fText.Add('</html>');
end;

function TelLogger.ReplaceSpecialChars(InputString: String): String;
var
  TempString: String;
begin
  TempString := InputString;
	
  // Line break
  if (Pos('\n', TempString) <> 0) then
    TempString := StringReplace(TempString, '\n', '</br>', [rfReplaceAll])
  else begin
    TempString := StringReplace(TempString, '<', '&lt;', [rfReplaceAll]);
    TempString := StringReplace(TempString, '>', '&gt;', [rfReplaceAll]);
  end;
    
  // Replace special chars with HTML-aquivalent chars
  TempString := StringReplace(TempString, '"', '&quot;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '^', '&circ;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '~', '&tilde;', [rfReplaceAll]);
    
  TempString := StringReplace(TempString, '¡', '&iexcl;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¢', '&cent;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '^', '&circ;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '~', '&tilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '£', '&pound;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¤', '&curren;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¥', '&yen;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¦', '&brvbar;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '§', '&sect;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¨', '&uml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '©', '&copy;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ª', '&ordf;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '«', '&laquo;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¬', '&not;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '®', '&reg;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¯', '&macr;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '°', '&deg;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '±', '&plusmn;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '²', '&sup2;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '³', '&sup3;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '´', '&acute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'µ', '&micro;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¶', '&para;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '·', '&middot;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¸', '&cedil;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¹', '&sup1;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'º', '&ordm;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '»', '&raquo;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¼', '&frac14;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '½', '&frac12;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¾', '&frac34;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '¿', '&iquest;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'À', '&Agrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Á', '&Aacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Â', '&Acirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ã', '&Atilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ä', '&Auml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Å', '&Aring;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Æ', '&AElig;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ç', '&Ccedil;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'È', '&Egrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'É', '&Eacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ê', '&Ecirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ë', '&Euml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ì', '&Igrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Í', '&Iacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Î', '&Icirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ï', '&Iuml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ð', '&ETH;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ñ', '&Ntilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ò', '&Ograve;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ó', '&Oacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ô', '&Ocirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Õ', '&Otilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ö', '&Ouml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '×', '&times;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ø', '&Oslash;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ù', '&Ugrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ú', '&Uacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Û', '&Ucirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ü', '&Uuml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Ý', '&Yacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'Þ', '&THORN;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ß', '&szlig;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'à', '&agrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'á', '&aacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'â', '&acirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ã', '&atilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ä', '&auml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'å', '&aring;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'æ', '&aelig;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ç', '&ccedil;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'è', '&egrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'é', '&eacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ê', '&ecirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ë', '&euml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ì', '&igrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'í', '&iacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'î', '&icirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ï', '&iuml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ð', '&eth;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ñ', '&ntilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ò', '&ograve;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ó', '&oacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ô', '&ocirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'õ', '&otilde;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ö', '&ouml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, '÷', '&divide;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ø', '&oslash;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ù', '&ugrave;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ú', '&uacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'û', '&ucirc;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ü', '&uuml;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ý', '&yacute;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'þ', '&thorn;', [rfReplaceAll]);
  TempString := StringReplace(TempString, 'ÿ', '&yuml;', [rfReplaceAll]);
    
	
  Result := TempString;
end;

//
// TelLogger
//

constructor TelLogger.Create;
begin
  inherited;

  fFilename := ExtractFilename(ParamStr(0));

  // Write all logger messages by default
  fPriorities := [ltError, ltWarning, ltNote];
	
  try
    fText := TStringList.Create;

    HTMLWriteHead;
    WriteLog('Start log', 'Initialization', ltNote);
  finally

  end;
end;

class function TelLogger.GetInstance: TelLogger;
begin
  if (Logger = nil) then Logger := TelLogger.Create;
  Result := Logger;
end;

destructor TelLogger.Destroy;
begin
  try
    WriteLog('End log', 'Finalization', ltNote);
    HTMLWriteTail;

    fText.SaveToFile(fFilename+'.html');
  finally
    inherited;
  end;
end;

procedure TelLogger.WriteLog(const Msg: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false);
begin
  WriteLog(Msg, [], '', LogMessageType, FormatHTML);
end;

procedure TelLogger.WriteLog(const Msg: String; Category: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false);
begin
  WriteLog(Msg, [], Category, LogMessageType, FormatHTML);
end;

procedure TelLogger.WriteLog(const Msg: String; Args: array of const; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false);
begin
  WriteLog(Msg, Args, '', LogMessageType, FormatHTML);
end;

procedure TelLogger.WriteLog(const Msg: String; Args: array of const; Category: String; LogMessageType: TLogMessageType = ltError; FormatHTML: Boolean = false);
var
  FormatString, TempString: String;
begin

  try
    if Msg = '' then FormatString := '' else FormatString := Format(Msg, Args);
    if FormatHTML then TempString := FormatString
      else TempString := ReplaceSpecialChars(FormatString);
    
    if fLastUsedTableColor = '#E8E8E8' then fLastUsedTableColor := '#D8D8D8' else fLastUsedTableColor := '#E8E8E8';
  
    if fPriorities = [] then fPriorities := fPriorities + [ltError];
  
    case LogMessageType of
      ltError:   if ltError in fPriorities then fText.Add('<tr bgcolor='+fLastUsedTableColor+'><td><center><font size="-2">'+DateTimeToStr(Now)+'</font></center></td><td><center><font color="#FF0000"><b>Error</b></font></center></td><td><center><font size="-1"><b>'+Category+'</b></font></center></td><td><center><font size="-1" color="#FF0000">'+TempString+'</font></center></td></tr>');
      ltWarning: if ltWarning in fPriorities then fText.Add('<tr bgcolor='+fLastUsedTableColor+'><td><center><font size="-2">'+DateTimeToStr(Now)+'</font></center></td><td><center><font size="-1" color="#BABA00"><b>Warning</b></font></center></td><td><center><font size="-1"><b>'+Category+'</b></font></center></td><td><center><font size="-1">'+TempString+'</font></center></td></tr>');
      ltNote:    if ltNote in fPriorities then fText.Add('<tr bgcolor='+fLastUsedTableColor+'><td><center><font size="-2">'+DateTimeToStr(Now)+'</font></center></td><td><center><font size="-1">Note</font></center></td><td><center><font size="-1"><b>'+Category+'</b></font></center></td><td><center><font size="-1">'+TempString+'</font></center></td></tr>');
    end;
  finally
  
  end;
end;

initialization
  ;

finalization
  if isLoggerActive then TelLogger.getInstance.Destroy;

end.
