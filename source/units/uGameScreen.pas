unit uGameScreen;

interface

uses
  Classes,
  SysUtils,
  ElysionApplication,
  ElysionTypes,
  ElysionInput,
  ElysionGraphics,
  ElysionGUI,
  ElysionTimer,
  ElysionStage,
  ElysionColors,
  ElysionTrueTypeFonts,
  uGlobal,
  uBasic,
  uConfig,
  uLevel;

type
  TGameScreen = class(TelStage)
  private
    fLevel: TLevel;
    fFont: TelTrueTypeFont;
    fPaused: Boolean;

    fHealthBar, fBatteryBar, fFuelBar, fGUI_Icons, fGUI_Inventory: TelSprite;
    fLight: TelSprite;
    fTips: TStringList;

    fTipsIndex: Integer;
    fTipsTimer, fDayTimer: TelTimer;

    fBtnBuildShelter, fBtnBuildMarker: TelButton;

    procedure DrawDialog(Title, Text: String);
  public
    constructor Create; Override;
    destructor Destroy; Override;

    procedure Render; Override;
    procedure Update(dt: Double); Override;
    procedure HandleEvents; //Override;

    procedure Reset;
  published
    property Level: TLevel read fLevel write fLevel;
    property Font: TelTrueTypeFont read fFont write fFont;
    property Paused: Boolean read fPaused;

    property BtnBuildShelter: TelButton read fBtnBuildShelter write fBtnBuildShelter;
    property BtnBuildMarker: TelButton read fBtnBuildMarker write fBtnBuildMarker;
  end;

implementation

constructor TGameScreen.Create;
begin
  Randomize;

  //Level := TLevel.Create;

  Font := TelTrueTypeFont.Create;
  Font.LoadFromFile(GetStdFont);

  fHealthBar := TelSprite.Create;
  fHealthBar.LoadFromFile(GetResImgPath + 'bar.png');
  fHealthBar.Color := makeCol(255, 0, 0);
  fHealthBar.Position := makeV3f(32, 8, 0.0);


  fBatteryBar := TelSprite.Create;
  fBatteryBar.LoadFromFile(GetResImgPath + 'bar.png');
  fBatteryBar.Color := makeCol(0, 255, 0);
  fBatteryBar.Position := makeV3f(32, 32, 0.0);


  fFuelBar := TelSprite.Create;
  fFuelBar.LoadFromFile(GetResImgPath + 'bar.png');
  fFuelBar.Color := makeCol(0, 0, 255);
  fFuelBar.Position := makeV3f(32, 56, 0.0);

  fLight := TelLight.Create;
  fLight.LoadFromFile(GetResImgPath + 'lightmap.png');
  fLight.Color := makeCol(128, 128, 128);


  fGUI_Icons := TelSprite.Create;
  fGUI_Icons.LoadFromFile(GetResImgPath + 'gui_icons.png');

  fGUI_Inventory := TelSprite.Create;
  fGUI_Inventory.LoadFromFile(GetResImgPath + 'inventory.png');
  fGUI_Inventory.SetColorKey(Color.clWhite);

  fTips := TStringList.Create;
  fTips.LoadFromFile(GetResDataPath + 'funfact.txt');

  fFont := TelTrueTypeFont.Create;
  fFont.LoadFromFile(GetStdFont, 15);
  fFont.Color := Color.clWhite;
  fFont.RenderStyle := rtBlended;

  fTipsTimer := TelTimer.Create;
  fTipsTimer.Interval := 17500;
  fTipsTimer.Start();

  fDayTimer := TelTimer.Create;
  fDayTimer.Interval := 300;
  fDayTimer.Start();

  BtnBuildMarker := TelButton.Create;
  BtnBuildMarker.LoadFromFile(GetResImgPath + 'button.png', GetStdFont);
  BtnBuildMarker.TextLabel.Color := makeCol(0, 0, 0);
  BtnBuildMarker.Caption := 'Build Marker \n (1 Wood)';
  BtnBuildMarker.Position := makeV3f(ActiveWindow.Width - BtnBuildMarker.Width - 16, ActiveWindow.Height - 64 + 8);

  BtnBuildShelter := TelButton.Create;
  BtnBuildShelter.LoadFromFile(GetResImgPath + 'button.png', GetStdFont);
  BtnBuildShelter.TextLabel.Color := makeCol(0, 0, 0);
  BtnBuildShelter.Caption := 'Build Shelter \n (5 Wood)';
  BtnBuildShelter.Position := makeV3f(ActiveWindow.Width - BtnBuildMarker.Width - BtnBuildShelter.Width - 32, ActiveWindow.Height - 64 + 8);

  fTipsIndex := Random(fTips.Count - 1);

  Reset;
end;

destructor TGameScreen.Destroy;
begin
  Level.Destroy;
end;

procedure TGameScreen.DrawDialog(Title, Text: String);
var
  DialogWidth, DialogHeight: Integer;
begin
  DialogWidth := 400;
  DialogHeight := 300;

  GUI.RoundedBox(makeRect((ActiveWindow.Width - DialogWidth) / 2,
                   (ActiveWindow.Height - DialogHeight) / 2,
                   DialogWidth, DialogHeight), makeCol(0, 0, 0, 192), 20);

  fFont.TextOut(makeV3f((ActiveWindow.Width - fFont.getWidth_Text(Title)) / 2,
                         (ActiveWindow.Height - DialogHeight) / 2 + 30), Title);

  fFont.TextOut(makeV3f((ActiveWindow.Width - DialogWidth) / 2 + 20,
                        (ActiveWindow.Height - DialogHeight) / 2 + 60), Text);
end;

procedure TGameScreen.Reset;
begin
  fPaused := false;

  TimeDay := 1;
  TimeHour := 10;
  TimeMin := 0;

  fTipsTimer.Stop();
  fTipsTimer.Start();

  fDayTimer.Stop();
  fDayTimer.Start();

  Level := TLevel.Create;
end;

procedure TGameScreen.Render;

  procedure DrawNightTime;
  var
    tempColA, tempColR: Byte;
  begin
    if (TimeHour >= 6) and (TimeHour < 8) then
    begin
      tempColA := ((TimeHour - 6) * 60) + (TimeMin div 2);
      GUI.Box(makeRect(0, 0, ActiveWindow.Width, ActiveWindow.Height), makeCol(220, 130, 0, 100 - tempColA));
    end;

    if TimeHour >= 17 then
    begin
      if ((TimeHour = 17) or (TimeHour = 18)) then
        tempColR := ((TimeHour - 17) * 60) + TimeMin
      else tempColR := 150;

      if TimeHour = 22 then tempColA := 240
      else tempColA := ((TimeHour - 17) * 60) + TimeMin;

      GUI.Box(makeRect(0, 0, ActiveWindow.Width, ActiveWindow.Height), makeCol(150 - tempColR, 0, 0, tempColA));
    end;
  end;

  function getTime(): String;
  var
    DayString, HourString, MinString: String;
  begin
    DayString := Format('Day: %d \n', [TimeDay]);

    if TimeHour < 10 then HourString := Format('0%d:', [TimeHour])
    else HourString := Format('%d:', [TimeHour]);

    if TimeMin < 10 then MinString := Format('0%d', [TimeMin])
    else MinString := Format('%d', [TimeMin]);

    Result := DayString + HourString + MinString;
  end;

begin
  // Draw level
  Level.Render;

  fLight.Position := makeV3f(Level.Actor.Position.X - ((fLight.Width - Level.Actor.Sprite.Width) / 2),
                             Level.Actor.Position.Y - ((fLight.Height - Level.Actor.Sprite.Height) / 2), Level.Actor.Position.Z);


  DrawNightTime;

  if Level.HasFlashlight then if TimeHour >= 19 then fLight.Draw;

  // Draw GUI

  // Healthbar and stuff
  GUI.Box(makeRect(0, 0, ActiveWindow.Width, 80), makeCol(0, 0, 0, 160));

  fGUI_Icons.ClipImage(makeRect(0, 0, 16, 16));
  fGUI_Icons.Position := makeV3f(8, 8, 0.0);
  fGUI_Icons.Draw;

  fHealthBar.Draw;

  fGUI_Icons.ClipImage(makeRect(16, 0, 16, 16));
  fGUI_Icons.Position := makeV3f(8, 32, 0.0);
  fGUI_Icons.Draw;

  fBatteryBar.Draw;

  fGUI_Icons.ClipImage(makeRect(32, 0, 16, 16));
  fGUI_Icons.Position := makeV3f(8, 56, 0.0);
  fGUI_Icons.Draw;

  fFuelBar.Draw;

  fFont.TextOut(makeV3f(560, 8), getTime());

  GUI.RoundedBox(makeRect(ActiveWindow.Width - 388 - 16, 8, 388, 64), makeCol(64, 64, 64, 128));
  fFont.TextOut(makeV3f(ActiveWindow.Width - 388 - 16 + ((396 - fFont.getWidth_Text('Inventory')) / 2) - 128, 32), 'Inventory');

  GUI.RoundedBox(makeRect(ActiveWindow.Width - 388 - 16 + 300 - 8 - 64, 8, 64, 64), makeCol(128, 128, 128, 128));

  fGUI_Inventory.ClipImage(makeRect(0, 0, 64, 64));
  fGUI_Inventory.Position := makeV3f(ActiveWindow.Width - 388 - 16 + 300 - 8 - 64, 8, 0.0);
  fGUI_Inventory.Draw;

  fFont.TextOut(makeV3f(ActiveWindow.Width - 388 - 16 + 300 - 8 - 64 + 4, 12), Format('x %d', [Level.Actor.Inventory.Wood]));

  GUI.RoundedBox(makeRect(ActiveWindow.Width - 388 - 16 + 300, 8, 64, 64), makeCol(128, 128, 128, 128));

  fGUI_Inventory.ClipImage(makeRect(64, 0, 64, 64));
  fGUI_Inventory.Position := makeV3f(ActiveWindow.Width - 388 - 16 + 300, 8, 0.0);
  fGUI_Inventory.Draw;

  fFont.TextOut(makeV3f(ActiveWindow.Width - 388 - 16 + 300 + 4, 12), Format('x %d', [Level.Actor.Inventory.Scrap]));

  // Controls
  GUI.Box(makeRect(0, ActiveWindow.Height - 64, ActiveWindow.Width, 64), makeCol(0, 0, 0, 160));

  fFont.TextOut(makeV3f(8, ActiveWindow.Height - 64 + 8), Format('Fun Fact #%d', [fTipsIndex + 1]));
  fFont.TextOut(makeV3f(8, ActiveWindow.Height - 64 + 8 + 16), fTips.Strings[fTipsIndex]);

  BtnBuildShelter.Draw;
  BtnBuildMarker.Draw;
end;

procedure TGameScreen.Update(dt: Double);

  procedure DayNightSwitch;
  begin
    if TimeHour = 21 then
    begin
      TimeDay := TimeDay + 1;
      TimeHour := 6;
      TimeMin := 0;

      if (not Level.HasShelter) then Level.Actor.Health.Value := Level.Actor.Health.Value - 20;
    end;
  end;

begin
  if not Paused then
  begin
    Level.Update(dt);

    fHealthBar.Scale.X := Level.Actor.Health.Value / Level.Actor.Health.Max;
    fBatteryBar.Scale.X := Level.Actor.Battery.Value / Level.Actor.Battery.Max;
    fFuelBar.Scale.X := Level.Actor.Fuel.Value / Level.Actor.Fuel.Max;

    if fTipsTimer.OnEvent then fTipsIndex := Random(fTips.Count - 1);

    if fDayTimer.OnEvent then TimeMin := TimeMin + 1;
    if TimeMin = 60 then
    begin
      TimeMin := 0;
      TimeHour := TimeHour + 1;
    end;

    DayNightSwitch;
  end;

  // Check for important events
  // Game Over
  if (fHealthBar.Scale.X <= 0) or (fBatteryBar.Scale.X <= 0) or (fFuelBar.Scale.X <= 0) then
  begin
    fPaused := true;
    DrawDialog('Game Over', 'Press R to restart \n or \n ESC to return to the main menu.');
  end else
  begin
    // Game won
    // Game won
    // Oh, you can't have enough "Game won" comments
    if ((Level.IsAtSpaceShip) and (Level.Actor.Inventory.Scrap >= 7)) then
    begin
    fPaused := true;
    DrawDialog('You win', 'You fly away and live happily \n ever after. \n Press ESC to return to the main menu.');
    end else
    begin

      // Paused
      if Paused then
      begin
        DrawDialog('Game Paused', 'Press P to unpause.');
      end;

    end;
  end;

end;

procedure TGameScreen.HandleEvents;
begin
  if BtnBuildShelter.OnClick then Level.BuildShelter;
  if BtnBuildMarker.OnClick then Level.BuildMarker;

  if Input.Keyboard.isKeyHit(Key.P) then fPaused := not fPaused;
  if Input.Keyboard.isKeyHit(Key.R) then Self.Reset;

  if Input.Keyboard.isKeyHit(Key.Y) or Input.Keyboard.isKeyHit(Key.Z) then
  begin
    fTipsTimer.Stop();
    if fTipsIndex = 0 then fTipsIndex := fTips.Count - 1
    else fTipsIndex := fTipsIndex - 1;
    fTipsTimer.Start();
  end;

  if Input.Keyboard.isKeyHit(Key.X) then
  begin
    fTipsTimer.Stop();
    if fTipsIndex = fTips.Count - 1 then fTipsIndex := 0
    else fTipsIndex := fTipsIndex + 1;
    fTipsTimer.Start();
  end;
end;

end.

