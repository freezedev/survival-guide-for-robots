unit uLevel;

interface

uses
  Classes,
  SysUtils,
  ElysionTypes,
  ElysionApplication,
  ElysionGraphics,
  ElysionGUI,
  ElysionAudio,
  uBasic,
  uGlobal,
  uIsland,
  uActor;

const
  MAX_ISLANDS = MAP_TILES * 5;

type
  TLevel = class
  private
    fBackground: TelSprite;
    fIslandList: TList;
    fCurIsland: Integer;

    fActor: TActor;

    fHasShelter, fIsAtSpaceship, fHasFlashlight: Boolean;

    fSndColBattery, fSndColFuel, fSndColScrap: TelSound;

    procedure CheckActorIslandCollision();
  public
    CameraRect: TelRect;

    constructor Create;
    destructor Destroy; Override;

    procedure Render;
    procedure Update(dt: Double);

    procedure BuildShelter;
    procedure BuildMarker;
  published
    property Actor: TActor read fActor write fActor;

    property Background: TelSprite read fBackground write fBackground;

    property CurIsland: Integer read fCurIsland;

    property HasFlashlight: Boolean read fHasFlashlight write fHasFlashlight;
    property HasShelter: Boolean read fHasShelter;
    property IsAtSpaceship: Boolean read fIsAtSpaceship;
  end;

implementation


constructor TLevel.Create;
var
  Grid: array[0..MAP_TILES, 0..MAP_TILES] of Boolean;
  tempIsland: TIsland;
  tempPoint: TelVector2i;
  i, j: Integer;
begin
  Randomize; // < for purely random numbers

  fHasFlashlight := false;

  tempPoint.Clear;

  for i := 0 to MAP_TILES do
  begin
    for j := 0 to MAP_TILES do
    begin
      Grid[i, j] := false;
    end;
  end;
  // Start island
  Grid[1, 1] := true;
  Grid[2, 0] := true;
  Grid[0, 2] := true;
  Grid[3, 3] := true;

  Actor := TActor.Create;

  CameraRect := makeRect(0, 0, ActiveWindow.Width, ActiveWindow.Height);

  fBackground := TelSprite.Create;
  fBackground.LoadFromFile(GetResImgPath + 'level.png');

  fSndColBattery := TelSound.Create;
  fSndColBattery.LoadFromFile(GetResSndPath + 'battery.wav');

  fSndColFuel := TelSound.Create;
  fSndColFuel.LoadFromFile(GetResSndPath + 'fuel.wav');

  fSndColScrap := TelSound.Create;
  fSndColScrap.LoadFromFile(GetResSndPath + 'scrap.wav');

  fIslandList := TList.Create;

  for i := 0 to MAX_ISLANDS do
  begin
    tempIsland := TIsland.Create;
    tempIsland.IslandID := Random(24);

    // Initial tempPoint
    tempPoint := makeV2i(Random(MAP_TILES), Random(MAP_TILES));

    // As long as point is free (this comment makes no sense at all)
    while (Grid[tempPoint.X, tempPoint.Y] = true) do
      tempPoint := makeV2i(Random(MAP_TILES), Random(MAP_TILES));

    Grid[tempPoint.X, tempPoint.Y] := true;
    tempIsland.OrgPos := makeV3f(tempPoint.X * 256, tempPoint.Y * 256, 0.0);

    fIslandList.Add(tempIsland);
  end;

  // Startisland
  (TIsland(fIslandList.Items[0])).OrgPos := makeV3f(256, 256, 0.0);
  (TIsland(fIslandList.Items[0])).IslandTypes := (TIsland(fIslandList.Items[0])).IslandTypes + [itShuttle, itSign];

  (TIsland(fIslandList.Items[1])).OrgPos := makeV3f(512, 0, 0.0);
  (TIsland(fIslandList.Items[1])).IslandTypes := (TIsland(fIslandList.Items[1])).IslandTypes + [itWood, itAlien];

  (TIsland(fIslandList.Items[2])).OrgPos := makeV3f(0, 512, 0.0);
  (TIsland(fIslandList.Items[2])).IslandTypes := (TIsland(fIslandList.Items[2])).IslandTypes + [itBattery, itFuel];

  (TIsland(fIslandList.Items[3])).OrgPos := makeV3f(768, 768, 0.0);
  (TIsland(fIslandList.Items[3])).IslandTypes := (TIsland(fIslandList.Items[3])).IslandTypes + [itScrap, itFuel];

  for i := 4 to fIslandList.Count - 1 do
  begin


    if IsInRange(1, MAX_ISLANDS div 2, i) then (TIsland(fIslandList.Items[i])).IslandTypes := (TIsland(fIslandList.Items[i])).IslandTypes + [itBattery];
    if IsInRange(MAX_ISLANDS div 2, fIslandList.Count - 1, i) then (TIsland(fIslandList.Items[i])).IslandTypes := (TIsland(fIslandList.Items[i])).IslandTypes + [itWood];

    if IsInRange(1, MAX_ISLANDS div 3, i) then (TIsland(fIslandList.Items[i])).IslandTypes := (TIsland(fIslandList.Items[i])).IslandTypes + [itFuel];
    if IsInRange(fIslandList.Count - 1 - (MAX_ISLANDS div 7), fIslandList.Count - 1, i) then (TIsland(fIslandList.Items[i])).IslandTypes := (TIsland(fIslandList.Items[i])).IslandTypes + [itScrap];
  end;

  Actor.IsOnIsland := true;
  Actor.OrgPos := makeV3f((TIsland(fIslandList.Items[0])).OrgPos.X + Actor.Sprite.Width,
                          (TIsland(fIslandList.Items[0])).OrgPos.Y + (Actor.Sprite.Height / 2));
end;

destructor TLevel.Destroy;
begin
  Actor.Destroy;
  fBackground.Destroy;
  fIslandList.Free;

  inherited;
end;

procedure TLevel.CheckActorIslandCollision();
var
  i: Integer;
begin
  for i := 0 to fIslandList.Count - 1 do
  begin
    Actor.IsOnIsland := PixelTest((TIsland(fIslandList.Items[i])).Collider, fActor.Sprite);
    if Actor.IsOnIsland then
    begin
      fCurIsland := i;
      Exit;
    end;
  end;
end;

procedure TLevel.BuildShelter;
begin
  if ((Actor.IsOnIsland) and (Actor.Inventory.Wood >= 5) and (not (itShelter in (TIsland(fIslandList.Items[CurIsland])).IslandTypes))) then
  begin
    (TIsland(fIslandList.Items[CurIsland])).IslandTypes := (TIsland(fIslandList.Items[CurIsland])).IslandTypes + [itShelter];
    Actor.Inventory.Wood := Actor.Inventory.Wood - 5;
  end;
end;

procedure TLevel.BuildMarker;
begin
  if ((Actor.IsOnIsland) and (Actor.Inventory.Wood >= 1) and (not (itMarker in (TIsland(fIslandList.Items[CurIsland])).IslandTypes))) then
  begin
    (TIsland(fIslandList.Items[CurIsland])).IslandTypes := (TIsland(fIslandList.Items[CurIsland])).IslandTypes + [itMarker];
    Actor.Inventory.Wood := Actor.Inventory.Wood - 1;
  end;
end;

procedure TLevel.Render;

  procedure DrawBackground();
  var
    dw, dh, i, j: Integer;
  begin
    dw := ActiveWindow.Width div fBackground.Width;
    dh := ActiveWindow.Height div fBackground.Height;

    for i := 0 to dw do
    begin
      for j := 0 to dh do
      begin
        fBackground.Position := makeV3f(i * fBackground.Width, j * fBackground.Height);
        fBackground.Draw;
      end;
    end;

  end;

var
  i: Integer;
begin
  DrawBackground();

  for i := 0 to fIslandList.Count - 1 do
  begin

    if CollisionTest(makeRect((TIsland(fIslandList.Items[i])).OrgPos.X,
                              (TIsland(fIslandList.Items[i])).OrgPos.Y, 256, 256),
                     CameraRect) then
    begin
      (TIsland(fIslandList.Items[i])).Draw;
    end;

  end;

  Actor.Draw;
end;

procedure TLevel.Update(dt: Double);
var
  i: Integer;
begin

  Actor.Update(dt);

  for i := 0 to fIslandList.Count - 1 do
  begin
    (TIsland(fIslandList.Items[i])).Position.X := (TIsland(fIslandList.Items[i])).OrgPos.X - CameraRect.X;
    (TIsland(fIslandList.Items[i])).Position.Y := (TIsland(fIslandList.Items[i])).OrgPos.Y - CameraRect.Y;

    if CollisionTest(makeRect((TIsland(fIslandList.Items[i])).OrgPos.X,
                              (TIsland(fIslandList.Items[i])).OrgPos.Y, 256, 256),
                     CameraRect) then (TIsland(fIslandList.Items[i])).Update;
  end;

  CheckActorIslandCollision;

  fIsAtSpaceShip := false;
  fHasShelter := false;

  if Actor.IsOnIsland then
  begin
    case (TIsland(fIslandList.Items[CurIsland])).CheckCollisionObjects(Actor.Sprite) of
      itShuttle: fIsAtSpaceShip := true;
      itBattery:
      begin
        if Sound then fSndColBattery.Play;
        if Actor.Battery.Value + 1000 >= Actor.Battery.Max then
          Actor.Battery.Value := Actor.Battery.Max
        else
          Actor.Battery.Value := Actor.Battery.Value + 1000;
      end;
      itWood: Actor.Inventory.Wood := Actor.Inventory.Wood + 1;
      itFuel:
      begin
        if Sound then fSndColFuel.Play;
        if Actor.Fuel.Value + 500 >= Actor.Fuel.Max then
          Actor.Fuel.Value := Actor.Fuel.Max
        else
          Actor.Fuel.Value := Actor.Fuel.Value + 500;
      end;
      itScrap:
      begin
        if Sound then fSndColScrap.Play;
        Actor.Inventory.Scrap := Actor.Inventory.Scrap + 1;
      end;
      itShelter: fHasShelter := true;
      itSign:
      begin
        GUI.RoundedBox(makeRect((ActiveWindow.Width - 400) / 2,
                   Actor.Sprite.Position.Y + 80,
                   400, 50), makeCol(0, 0, 0, 192), 20);
      end;
    end;
  end;

  //Actor.Update(dt);

  if Actor.CenterMapX then CameraRect.X := Actor.OrgPos.X - (ActiveWindow.Width / 2);
  if Actor.CenterMapY then CameraRect.Y := Actor.OrgPos.Y - (ActiveWindow.Height / 2);

  //Actor.Update(dt);

  // Debug Stuff
  //TelLogger.getInstance.writeLog(Format('Actor.X: %d, Actor.Y: %d, Camera.X: %d, Camera.Y: %d', [Actor.Position.X, Actor.Position.Y, CameraRect.X, CameraRect.Y]));

  (*if Input.Mouse.LeftClick then
  begin
    if PixelTest(fStartIsland.Sprite, makeRect(ActiveWindow.Cursor.X, ActiveWindow.Cursor.Y, 1, 1)) then
    TelLogger.getInstance.writeLog('Getroffen') else TelLogger.getInstance.writeLog('nicht getroffen.');
  end;  *)

  //Actor.Update;
end;

end.
