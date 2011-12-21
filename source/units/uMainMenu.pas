unit uMainMenu;

interface

uses
  ElysionColors,
  ElysionTypes,
  ElysionStage,
  ElysionGraphics,
  ElysionApplication,
  ElysionGUI,
  ElysionInput,
  ElysionAnimator,

  SysUtils,
  uBasic,
  uGlobal,
  uConfig;

type
  TMainMenu = class(TelStage)
  private
    fBackground: TelSprite;
    fMenu: TelMenu;
    fLogo: TelSprite;
    fLabel: TelLabel;
    fFocusIndex: Integer;
    fAlphaAction, fPosAction, fColAction, fRotAnim: TelAnimator;
    ComboAnim: TelAnimatorCombo;

    fNewGameClick: Boolean;
  public
    constructor Create; Override;
    destructor Destroy; Override;
	
    procedure Render; Override;
    procedure Update(dt: Double); Override;
    procedure HandleEvents; //Override;
  published
    property Background: TelSprite read fBackground write fBackground;
    
    property FocusIndex: Integer read fFocusIndex write fFocusIndex;

    property Logo: TelSprite read fLogo write fLogo;
    property Menu: TelMenu read fMenu write fMenu;

    property NewGameClick: Boolean read fNewGameClick write fNewGameClick;
  end;

implementation

constructor TMainMenu.Create;
var
  i: Integer;
  tmpHeight: Single;
begin
  inherited;

  tmpHeight := 0;
  FocusIndex := 0;


  Background := TelSprite.Create;
  Background.LoadFromFile(GetResImgPath + 'background.jpg');
  Background.Scale := makeV2f(ActiveWindow.Width / Background.Width, ActiveWindow.Height / Background.Height);


  Logo := TelSprite.Create;
  Logo.LoadFromFile(GetResImgPath + 'logo.png');
  Logo.Position.Make((ActiveWindow.Width - Logo.Width) div 2, 16, 0);

  //Self.Add(Logo);

  Menu := TelMenu.Create;
  Menu.setButtons(GetResImgPath + 'button.png', GetStdFont, 15, ['New game', 'How to play', 'Credits', 'Settings', 'Quit']);
  Menu.Spacing := 16;

  if ((ActiveWindow.Height - Menu.Height) div 2) > Logo.Position.Y + Logo.Height + 32 then
     tmpHeight := (ActiveWindow.Height - Menu.Height) div 2
  else
     tmpHeight := Logo.Position.Y + Logo.Height + 32;

  Menu.Position := makeV3f((ActiveWindow.Width - Menu.Width) div 2, tmpHeight);
  //Menu.HoverAnimation := true;

  for i := 0 to Menu.Count - 1 do
    Menu.Items[i].TextLabel.Color := makeCol(0, 0, 0);


  fLabel := TelLabel.Create;
  fLabel.LoadFromFile(GetStdFont);
  fLabel.Caption := '(C) 2010 Johannes Stein, www.freeze-dev.com';
  fLabel.Size := 14;
  fLabel.Color := makeCol(255, 255, 255);
  fLabel.HyperLink := 'http://www.freeze-dev.com';
  fLabel.Position := makeV3f(8, ActiveWindow.Height - 25, 0);

  fAlphaAction := TelAnimator.Create(Background);
  fAlphaAction.FadeOutEffect(5000);

  fPosAction := TelAnimator.Create(Logo);
  fPosAction.AnimProperty.AnimType := atPosition;
  fPosAction.AnimProperty.StartPosition := makeV3f(600, 300);
  fPosAction.AnimProperty.EndPosition := makeV3f(10, 10);

  //fPosAction.LoopCount := 1;

  fPosAction.Duration := 2500;

  fColAction := TelAnimator.Create(Logo);
  fColAction.AnimProperty.AnimType := atColor;
  fColAction.AnimProperty.StartColor := makeCol(255, 0, 0);
  fColAction.AnimProperty.EndColor := makeCol(0, 64, 128);
  fColAction.Duration := 5000;

  fRotAnim := TelAnimator.Create(Logo);

  fRotAnim.RotationEffect(0.0, 360.0, 500);
  fRotAnim.LoopCount := 5;


  ComboAnim := TelAnimatorCombo.Create;
  ComboAnim.Add(fPosAction);
  ComboAnim.Add(fColAction);
  ComboAnim.Add(fRotAnim);
  ComboAnim.Sequential := true;

  Logo.Offset.Rotation.X := 160;
  Logo.Offset.Rotation.Y := 80;

  fAlphaAction.Start();
  ComboAnim.Start();


end;

destructor TMainMenu.Destroy;
begin
  Menu.Destroy;

  inherited;
end;

procedure TMainMenu.Render;
begin
  inherited;

  Background.Draw;

  Logo.Draw;

  GUI.RoundedBox(makeRect(4, fLabel.Position.Y - 4, fLabel.Width + 8, fLabel.Height + 8), makeCol(0, 0, 0, 128), 4);

  fLabel.Draw;

  GUI.RoundedBox(makeRect(Menu.Position.X - 8, Menu.Position.Y - 8, Menu.Width + 16, Menu.Height), makeCol(0, 0, 0, 128), 8);
  Menu.Draw;

end;

procedure TMainMenu.Update(dt: Double);
var
  i: Integer;
begin
  inherited;

  if fPosAction.Finished then
     Logo.Position := fPosAction.AnimProperty.EndPosition;


  if fLabel.OnMouseOver then fLabel.Color := makeCol(128, 200, 200)
     else fLabel.Color := makeCol(255, 255, 255);

  fLabel.Update();

  //if Input.JoystickCount > 0 then
    //Menu.Items[FocusIndex].Focus := true;
    
  (*fAlphaAction.Update(dt);
  fPosAction.Update(dt);
  fColAction.Update(dt);
  fRotAnim.Update();*)
  ComboAnim.Update();

  fAlphaAction.Update(dt);

  Menu.Update(dt);
  
end;

procedure TMainMenu.HandleEvents;
var
  deltaPos, deltaPos2: TelVector2f;
  i: Integer;
begin
  deltaPos.Clear();
  deltaPos2.Clear();

  if Menu.OnButtonClick('New game') then
  begin
    GameState := gsGame;
    fNewGameClick := true;
  end;


  if Menu.OnButtonClick('How to play') then GameState := gsInstructions;
  if Menu.OnButtonClick('Credits') then GameState := gsCredits;
  if Menu.OnButtonClick('Settings') then GameState := gsSettings;
  if Menu.OnButtonClick('Quit') then Application.Quit;

  (*if Input.XBox360Controller.LStick.Up then
  begin
    if FocusIndex = 0 then
      FocusIndex := Menu.Count - 1
    else 
      FocusIndex := FocusIndex - 1;
  end;
  
  if Input.XBox360Controller.LStick.Down then
  begin
    if FocusIndex < Menu.Count then 
      FocusIndex := FocusIndex + 1
    else 
      FocusIndex := 0;
  end;

  if Input.XBox360Controller.A then
  begin
    //case FocusIndex 
  end;   *)

  if Input.Mouse.WheelDown or Input.Mouse.WheelUp then
  begin
    if Input.Mouse.WheelDown then
      Logo.Rotation.Angle := Logo.Rotation.Angle - 0.75;

    if Input.Mouse.WheelUp then
      Logo.Rotation.Angle := Logo.Rotation.Angle + 0.75;

  end;



  if Input.Keyboard.isKeyHit(Key.Space) then
  begin
    //fPosAction.MoveEffect(Logo.Position, Logo.Rotation.Angle, 50);
    //fPosAction.Start();

    //ComboAnim.Start();
    //Menu.Animator.Start();

    //fAlphaAction.Start();

    (*fAlphaAction.Start();
    fColAction.Start();
    fPosAction.Start();
    fRotAnim.Start();*)
  end;

  

  (*if Input.XBox360Controller.LStick.Motion then 
  begin
    if Input.XBox360Controller.LStick.Left then 
      deltaPos.X := Input.XBox360Controller.LStick.AxisH * 500 * fDT;
    if Input.XBox360Controller.LStick.Right then
      deltaPos.X := Input.XBox360Controller.LStick.AxisH * 500 * fDT;
    if Input.XBox360Controller.LStick.Up then 
      deltaPos.Y := Input.XBox360Controller.LStick.AxisV * 500 * fDT;
    if Input.XBox360Controller.LStick.Down then
      deltaPos.Y := Input.XBox360Controller.LStick.AxisV * 500 * fDT;
  end;

  Logo.Move(deltaPos);



  if Input.XBox360Controller.RStick.Motion then 
  begin
    if Input.XBox360Controller.RStick.Left then 
      deltaPos2.X := Input.XBox360Controller.RStick.AxisH * 500 * fDT;
    if Input.XBox360Controller.RStick.Right then
      deltaPos2.X := Input.XBox360Controller.RStick.AxisH * 500 * fDT;
    if Input.XBox360Controller.RStick.Up then 
      deltaPos2.Y := Input.XBox360Controller.RStick.AxisV * 500 * fDT;
    if Input.XBox360Controller.RStick.Down then
      deltaPos2.Y := Input.XBox360Controller.RStick.AxisV * 500 * fDT;
  end;

  Menu.Bounds.X := Menu.Bounds.X + deltaPos2.X;
  Menu.Bounds.Y := Menu.Bounds.Y + deltaPos2.Y;*)



  (*if Input.XBox360Controller.RTrigger then Menu.Left := 800;
  if Input.XBox360Controller.LTrigger then Menu.Left := 10;*)
end;

end.
