unit uIsland;

interface

uses
  ElysionGraphics,
  ElysionColors,
  ElysionTypes,
  uBasic;

type
  TStaticObj = array[0..4] of TelSprite;
  TCollectibles = array[0..3] of TelSprite;

  TIsland = class
  private
    fIslandTypes: TIslandTypes;
    fIslandID: Integer;

    function getSprite(): TelSprite;
    function getCollider(): TelSprite;
  public
    StaticObject: TStaticObj;
    Collectible: TCollectibles;
    OrgPos, Position: TelVector3f;


    constructor Create;
    destructor Destroy; Override;

    function CheckCollisionObjects(Sprite: TelSprite): TIslandType;

    procedure Draw;
    procedure Update;
  published
    property Sprite: TelSprite read getSprite;
    property Collider: TelSprite read getCollider;

    property IslandID: Integer read fIslandID write fIslandID;
    property IslandTypes: TIslandTypes read fIslandTypes write fIslandTypes;
  end;

implementation

var
  TemplateSprite, MaskSprite: TelSprite;

procedure CreateTemplate();
begin
  if TemplateSprite = nil then
  begin
    TemplateSprite := TelSprite.Create;
    TemplateSprite.LoadFromFile(GetResImgPath + 'islands.png');
    TemplateSprite.Transparent := true;

    MaskSprite := TelSprite.Create;
    MaskSprite.LoadFromFile(GetResImgPath + 'islands_mask.png');
    MaskSprite.Transparent := true;
  end;
end;

procedure DestroyTemplate();
begin
  if TemplateSprite <> nil then TemplateSprite.Destroy;
end;

procedure ClipTemplate(IslandID: Integer);
var
  tempPoint: TelVector2i;
begin
  if not IsInRange(0, 24, IslandID) then IslandID := 0;

  tempPoint.Clear;
  tempPoint.X := (IslandID mod 8) * 256;
  tempPoint.Y := (IslandID div 8) * 256;

  TemplateSprite.ClipImage(makeRect(tempPoint.X, tempPoint.Y, 256, 256));
  MaskSprite.ClipImage(makeRect(tempPoint.X, tempPoint.Y, 256, 256));
end;

procedure DrawTemplate(IslandID: Integer; Position: TelVector3f);
begin
  ClipTemplate(IslandID);
  TemplateSprite.Position := Position;
  MaskSprite.Position := Position;

  TemplateSprite.Draw;
  //MaskSprite.Draw; // <-- just for DEBUG
end;

constructor TIsland.Create;
var
  i: Integer;
begin
  Randomize();
  CreateTemplate();

  OrgPos.Clear;
  Position.Clear;

  for i := 0 to 4 do
  begin
    StaticObject[i] := TelSprite.Create;
    StaticObject[i].LoadFromFile(GetResImgPath + 'staticobj.png');
    StaticObject[i].SetColorKey(Color.clWhite);

    if i <= 3 then
    begin
      Collectible[i] := TelSprite.Create;
      Collectible[i].LoadFromFile(GetResImgPath + 'collectible.png');
      Collectible[i].SetColorKey(Color.clWhite);
    end;
  end;


  StaticObject[2].Color := makeCol(Random(255), Random(255), Random(255));

  IslandID := 0;
end;

destructor TIsland.Destroy;
var
  i: Integer;
begin
  DestroyTemplate();

  for i := 0 to 4 do
  begin
    StaticObject[i].Destroy;
    if i <= 3 then Collectible[i].Destroy;
  end;

  inherited;
end;

function TIsland.getSprite: TelSprite;
begin
  ClipTemplate(IslandID);
  TemplateSprite.Position := Position;
  Result := TemplateSprite;
end;

function TIsland.getCollider: TelSprite;
begin
  ClipTemplate(IslandID);
  MaskSprite.Position := Position;
  Result := MaskSprite;
end;

procedure TIsland.Draw;
begin
  DrawTemplate(IslandID, Position);

  // StaticObjects
  if itShuttle in IslandTypes then StaticObject[0].Draw;
  if itShelter in IslandTypes then StaticObject[1].Draw;
  if itMarker in IslandTypes then StaticObject[2].Draw;
  if itSign in IslandTypes then StaticObject[3].Draw;
  if itAlien in IslandTypes then StaticObject[4].Draw;

  // Collectibles
  if itBattery in IslandTypes then Collectible[0].Draw;
  if itWood in IslandTypes then Collectible[1].Draw;
  if itFuel in IslandTypes then Collectible[2].Draw;
  if itScrap in IslandTypes then Collectible[3].Draw;
end;

// Only for Actor Sprite!!!
function TIsland.CheckCollisionObjects(Sprite: TelSprite): TIslandType;
begin
  // Check static objects
  if PixelTest(Sprite, StaticObject[0]) then Result := itShuttle;
  if PixelTest(Sprite, StaticObject[1]) then Result := itShelter;
  if PixelTest(Sprite, StaticObject[2]) then Result := itMarker;
  if PixelTest(Sprite, StaticObject[3]) then Result := itSign;
  if PixelTest(Sprite, StaticObject[4]) then Result := itAlien;

  // Check collectibles
  if PixelTest(Sprite, Collectible[0]) then
  begin
    Collectible[0].Visible := false;
    Result := itBattery;
  end;

  if PixelTest(Sprite, Collectible[1]) then
  begin
    Collectible[1].Visible := false;
    Result := itWood;
  end;

  if PixelTest(Sprite, Collectible[2]) then
  begin
    Collectible[2].Visible := false;
    Result := itFuel;
  end;

  if PixelTest(Sprite, Collectible[3]) then
  begin
    Collectible[3].Visible := false;
    Result := itScrap;
  end;
end;

procedure TIsland.Update;
begin
  // Clip images and update positions

  // StaticObjects
  if itShuttle in IslandTypes then
  begin
    StaticObject[0].ClipImage(makeRect(0, 0, 64, 64));
    StaticObject[0].Position := makeV3f(Position.X + 64, Position.Y + 64)
  end;

  if itShelter in IslandTypes then
  begin
    StaticObject[1].ClipImage(makeRect(64, 0, 64, 64));
    StaticObject[1].Position := makeV3f(Position.X + 128, Position.Y + 64)
  end;

  if itMarker in IslandTypes then
  begin
    StaticObject[2].ClipImage(makeRect(128, 0, 64, 64));
    StaticObject[2].Position := makeV3f(Position.X + 64, Position.Y + 128)
  end;

  if itSign in IslandTypes then
  begin
    StaticObject[3].ClipImage(makeRect(192, 0, 64, 64));
    StaticObject[3].Position := makeV3f(Position.X + 128, Position.Y + 128)
  end;

  if itAlien in IslandTypes then
  begin
    StaticObject[4].ClipImage(makeRect(256, 0, 64, 64));
    StaticObject[4].Position := makeV3f(Position.X + 128, Position.Y + 128)
  end;



  // Collectibles
  if itBattery in IslandTypes then
  begin
    Collectible[0].ClipImage(makeRect(0, 0, 64, 64));
    Collectible[0].Position := makeV3f(Position.X + 64, Position.Y + 64)
  end;

  if itWood in IslandTypes then
  begin
    Collectible[1].ClipImage(makeRect(64, 0, 64, 64));
    Collectible[1].Position := makeV3f(Position.X + 128, Position.Y + 64)
  end;

  if itFuel in IslandTypes then
  begin
    Collectible[2].ClipImage(makeRect(128, 0, 64, 64));
    Collectible[2].Position := makeV3f(Position.X + 64, Position.Y + 128)
  end;

  if itScrap in IslandTypes then
  begin
    Collectible[3].ClipImage(makeRect(192, 0, 64, 64));
    Collectible[3].Position := makeV3f(Position.X + 128, Position.Y + 128)
  end;
end;

end.
