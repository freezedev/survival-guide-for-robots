unit uBasic;

interface

const
  STD_FONT = 'StarPerv.ttf';

  // Use those values if loading from XML data failed
  WIDTH = 1024;
  HEIGHT = 600;
  BITS = 32;

  // Map constants
  MAP_TILES = 24;
  MAP_SIZE = MAP_TILES * 256;
  
  
  {$IFDEF WINDOWS}
  RESPATH = '..\resources\';
  {$ELSE}
    {$IFDEF DARWIN}
    RESPATH = '../Resources/';
    {$ELSE}
    RESPATH = '../resources/';
    {$ENDIF}
  {$ENDIF}

type
  TGameState = (gsMainMenu, gsIntro, gsGame, gsInstructions, gsSettings, gsCredits);
  TLanguage = (laGerman, laEnglish);

  TIslandType = (itShuttle, itBattery, itWood, itFuel, itScrap, itShelter, itMarker, itSign, itAlien);
  TIslandTypes = set of TIslandType;

  TBar = record
    Min, Max, Value: Integer;
  end;

function GetResPath: String;
function GetResDataPath: String;
function GetResImgPath: String;
function GetResSndPath: String;
function GetResFontPath: String;
function GetStdFont: String;

function IsInRange(Min, Max, Value: Integer): Boolean;

implementation

function GetResPath: String;
begin
  Result := RESPATH;
end;

function GetResDataPath: String;
begin
  {$IFDEF WINDOWS}
    Result := GetResPath + 'data\';
  {$ELSE}
    Result := GetResPath + 'data/';
  {$ENDIF}
end;

function GetResImgPath: String;
begin
  {$IFDEF WINDOWS}
    Result := GetResPath + 'images\';
  {$ELSE}
    Result := GetResPath + 'images/';
  {$ENDIF}
end;

function GetResSndPath: String;
begin
  {$IFDEF WINDOWS}
    Result := GetResPath + 'sounds\';
  {$ELSE}
    Result := GetResPath + 'sounds/';
  {$ENDIF}
end;

function GetResFontPath: String;
begin
  {$IFDEF WINDOWS}
    Result := GetResPath + 'fonts\';
  {$ELSE}
    Result := GetResPath + 'fonts/';
  {$ENDIF}
end;

function GetStdFont: String;
begin
  Result := GetResFontPath + STD_FONT;
end;

function IsInRange(Min, Max, Value: Integer): Boolean;
begin
  if (Value >= Min) and (Value <= Max) then Result := true
  else Result := false;
end;

end.
