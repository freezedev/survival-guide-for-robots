unit uGlobal;

interface

uses
  uBasic;

var
  Music: Boolean = true;
  Sound: Boolean = true;
  TimeDay, TimeHour, TimeMin: Integer;

{$IFDEF GLOBAL_PROPERTY}

function getGameState: TGameState;
procedure setGameState(aGameState: TGameState);

property GameState: TGameState read getGameState write setGameState;
{$ELSE}
  GameState: TGameState;
{$ENDIF}

implementation

{$IFDEF FPC}

var
  fGameState: TGameState;

function getGameState: TGameState;
begin
  Result := fGameState;
end;

procedure setGameState(aGameState: TGameState);
begin
  fGameState := aGameState;
end;

{$ENDIF}

end.
