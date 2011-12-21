// Compability functions
unit ElysionCompat;

interface

uses
  ElysionTypes;

function makeP2D(aX, aY: Integer): TelVector2i; Overload;
function makeP2D(aX, aY: Single): TelVector2f; Overload;

function makeP3D(aX, aY: Integer; aZ: Integer = 0): TelVector3i;
function makeP3D(aX, aY: Single; aZ: Single = 0.0): TelVector3f;

function makeCol(aR, aG, aB: Byte; anA: Byte = 255): TelColor;

function makeRect(aX, aY, aW, aH: Integer): TelRect; Overload;
function makeRect(aX, aY, aW, aH: Single): TelRect; Overload;

implementation

function makeP2D(aX, aY: Integer): TelVector2i;
begin
  Result := TelVector2i.Create(aX, aY);
end;

function makeP2D(aX, aY: Single): TelVector2f;
begin
  Result := TelVector2f.Create(aX, aY);
end;

function makeP3D(aX, aY, aZ: Integer): TelVector3i; {$ifdef fpc} Overload; {$endif}
begin
  Result := TelVector3i.Create(aX, aY, aZ);
end;

function makeP3D(aX, aY, aZ: Single): TelVector3f; {$ifdef fpc} Overload; {$endif}
begin
  Result := TelVector3f.Create(aX, aY, aZ);
end;

function makeCol(aR, aG, aB: Byte; anA: Byte = 255): TelColor;
begin
  Result := TelColor.Create(aR, aG, aB);
end;

function makeRect(aX, aY, aW, aH: Integer): TelRect;
begin
  Result := TelRect.Create(aX, aY, aW, aH);
end;

function makeRect(aX, aY, aW, aH: Single): TelRect;
begin
  Result := TelRect.Create(aX, aY, aW, aH);
end;

end.
