unit uActor;

interface

uses
  SysUtils,
  ElysionTypes,
  ElysionApplication,
  ElysionGraphics,
  ElysionColors,
  ElysionInput,
  ElysionAudio,
  uBasic;

type
  TInventory = class
  private
    fWood, fScrap: Integer;
    function getWeight(): Single; inline;
  public
    constructor Create;
    destructor Destroy; Override;
  published
    property Wood: Integer read fWood write fWood;
    property Scrap: Integer read fScrap write fScrap;

    property Weight: Single read getWeight;
  end;

  TActor = class
  private
    VelocityConstant: Single;

    fSprite: TelSprite;
    fAnimFrame, fAnimPos: Integer;

    fSpriteFlying: TelSprite;

    fIsOnIsland, fIsFlying, fCenterMapX, fCenterMapY: Boolean;

    fSndJump: TelSound;

    fInventory: TInventory;

    function getSprite(): TelSprite; inline;
    procedure setSprite(AValue: TelSprite); inline;
  public
    OrgPos, Position: TelVector3f;
    Velocity: TelVector2f;
    Health, Battery, Fuel: TBar;

    constructor Create;
    destructor Destroy; Override;

    procedure Draw; inline;
    procedure Update(dt: Double);
  published
    property Sprite: TelSprite read getSprite write setSprite;

    property Inventory: TInventory read fInventory write fInventory;

    property IsOnIsland: Boolean read fIsOnIsland write fIsOnIsland;
    property IsFlying: Boolean read fIsFlying;

    property CenterMapX: Boolean read fCenterMapX;
    property CenterMapY: Boolean read fCenterMapY;
  end;

implementation

constructor TInventory.Create;
begin
  fWood := 0;
  fScrap := 0;
end;

destructor TInventory.Destroy;
begin
  inherited;
end;

function TInventory.getWeight(): Single;
begin
  Result := 1.0 + (fWood * 0.10 + fScrap * 0.175);
end;

constructor TActor.Create;
begin
  fSprite := TelSprite.Create;
  fSprite.LoadFromFile(GetResImgPath + 'robot.png', makeRect(0, 0, 64, 64));
  fSprite.SetColorKey(Color.clWhite);

  Velocity.Clear;

  OrgPos.Clear;
  Position.Clear;

  Health.Min := 0;
  Health.Max := 100;
  Health.Value := Health.Max;

  Battery.Min := 0;
  Battery.Max := 3500;
  Battery.Value := Battery.Max;

  Fuel.Min := 0;
  Fuel.Max := 2000;
  Fuel.Value := Fuel.Max;

  VelocityConstant := 120.0;

  fSpriteFlying := TelSprite.Create;
  fSpriteFlying.LoadFromFile(GetResImgPath + 'robotfly.png', makeRect(0, 0, 64, 64));
  fSpriteFlying.SetColorKey(Color.clWhite);

  fSndJump := TelSound.Create;
  fSndJump.LoadFromFile(GetResSndPath + 'jump.wav');

  Inventory := TInventory.Create;

  fIsFlying := false;
  fCenterMapX := false;
  fCenterMapY := false;

  fAnimPos := 0;
  fAnimFrame := 0;
end;

destructor TActor.Destroy;
begin
  fSprite.Destroy;

  inherited;
end;

function TActor.getSprite(): TelSprite;
begin
  if IsFlying then
    Result := fSpriteFlying
  else
    Result := fSprite;
end;

procedure TActor.setSprite(AValue: TelSprite);
begin
  if IsFlying then
    fSpriteFlying := AValue
  else
    fSprite := AValue;
end;

procedure TActor.Draw;
begin
  fSpriteFlying.Position := Self.Position;
  fSprite.Position := Self.Position;

  if isFlying then
   fSpriteFlying.Draw
  else
    fSprite.Draw;

end;

procedure TActor.Update(dt: Double);
var
  tmpVelocity: TelVector2f;
begin
  tmpVelocity.Clear;

  if IsOnIsland then fIsFlying := false
  else fIsFlying := true;

  if Input.Keyboard.isKeyDown(Key.W) or Input.Keyboard.isKeyDown(Key.Up) or Input.XBox360Controller.LStick.Up then
     if (-VelocityConstant * dt) < -1 then tmpVelocity.y := -VelocityConstant * dt else tmpVelocity.y := -1;
  if Input.Keyboard.isKeyDown(Key.S) or Input.Keyboard.isKeyDown(Key.Down) or Input.XBox360Controller.LStick.Down then
     if (VelocityConstant * dt) > 1 then tmpVelocity.y := VelocityConstant * dt else tmpVelocity.y := 1;
  if Input.Keyboard.isKeyDown(Key.A) or Input.Keyboard.isKeyDown(Key.Left) or Input.XBox360Controller.LStick.Left then
     if (-VelocityConstant * dt) < -1 then tmpVelocity.x := (-VelocityConstant * dt) else tmpVelocity.x := -1;
  if Input.Keyboard.isKeyDown(Key.D) or Input.Keyboard.isKeyDown(Key.Right) or Input.XBox360Controller.LStick.Right then
     if (VelocityConstant * dt) > 1 then tmpVelocity.x := VelocityConstant * dt else tmpVelocity.x := 1;

  if (tmpVelocity.x <> 0) and (tmpVelocity.y <> 0) then
  begin
    tmpVelocity.x := tmpVelocity.x * sqrt(2);
    tmpVelocity.y := tmpVelocity.y * sqrt(2);
  end;

  if isFlying then
  begin
    tmpVelocity.x := tmpVelocity.x * 2;
    tmpVelocity.y := tmpVelocity.y * 2;

    Fuel.Value := Fuel.Value - Round(((VelocityConstant / 2) * dt) * Inventory.getWeight());
  end;


  if ((tmpVelocity.x <> 0) or (tmpVelocity.y <> 0)) then
  begin
    Battery.Value := Battery.Value - Round(((VelocityConstant / 2) * dt) * Inventory.getWeight());

    if tmpVelocity.y > 0 then fAnimPos := 2;
    if tmpVelocity.x < 0 then fAnimPos := 4;
    if tmpVelocity.y < 0 then fAnimPos := 6;
    if tmpVelocity.x > 0 then fAnimPos := 8;

    if ((tmpVelocity.x <> 0) and (tmpVelocity.y <> 0)) then fAnimPos := fAnimPos - 1;
    if ((tmpVelocity.x > 0) and (tmpVelocity.y > 0)) then fAnimPos := 1;

    fAnimFrame := fAnimFrame + 1;
    if fAnimFrame = 32 then fAnimFrame := 0;

    if isFlying then
      fSpriteFlying.ClipImage(makeRect((fAnimPos - 1) * 64, 0, 64, 64))
    else
      fSprite.ClipImage(makeRect(fAnimFrame * 64, (fAnimPos - 1) * 64, 64, 64));
  end;

  OrgPos.X := OrgPos.X + tmpVelocity.x;
  OrgPos.Y := OrgPos.Y + tmpVelocity.y;

  Velocity := tmpVelocity;

  fCenterMapX := IsInRange(ActiveWindow.Width div 2, MAP_SIZE - (ActiveWindow.Width div 2), Trunc(OrgPos.X));
  fCenterMapY := IsInRange(ActiveWindow.Height div 2, MAP_SIZE - (ActiveWindow.Height div 2), Trunc(OrgPos.Y));

  if not fCenterMapX then
  begin
    if IsInRange(0, ActiveWindow.Width div 2, Trunc(OrgPos.X)) then Position.X := OrgPos.X;
    if IsInRange(MAP_SIZE - (ActiveWindow.Height div 2), MAP_SIZE, Trunc(OrgPos.X)) then Position.X := OrgPos.X - MAP_SIZE + ActiveWindow.Width;
  end;
  if not fCenterMapY then
  begin
    if IsInRange(0, ActiveWindow.Height div 2, Trunc(OrgPos.Y)) then Position.Y := OrgPos.Y;
    if IsInRange(MAP_SIZE - (ActiveWindow.Height div 2), MAP_SIZE, Trunc(OrgPos.Y)) then Position.Y := OrgPos.Y - MAP_SIZE + ActiveWindow.Height;
  end;
end;

end.
