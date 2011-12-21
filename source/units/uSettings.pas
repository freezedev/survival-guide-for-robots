unit uSettings;

interface

uses
  ElysionApplication,
  ElysionTypes,
  ElysionStage,
  ElysionGraphics,
  ElysionGUI,

  uBasic,
  uGlobal,
  uConfig;

type
  TSettings = class(TelStage)
  private
    fBackground: TelSprite;
    fMenu: TelMenu;
  public
    constructor Create; Override;
    destructor Destroy; Override;
	
    procedure Render; Override;
    procedure Update(dt: Double); Override;
    procedure HandleEvents; //Override;
  published
    property Background: TelSprite read fBackground write fBackground;
    property Menu: TelMenu read fMenu write fMenu;
  end;

implementation

constructor TSettings.Create;
var
  i: Integer;
begin
  Background := TelSprite.Create;
  Background.LoadFromFile(GetResImgPath + 'background.jpg');
  Background.Scale := makeV2f(ActiveWindow.Width / Background.Width, ActiveWindow.Height / Background.Height);

  Menu := TelMenu.Create;
  Menu.setButtons(GetResImgPath + 'button.png', GetStdFont, 14, ['Music: On', 'Sound: On', 'Speed: Normal', 'Subtitles: On', 'Back']);
  Menu.Spacing := 16;
  Menu.Position := makeV3f((ActiveWindow.Width - Menu.Width) div 2, (ActiveWindow.Height - Menu.Height) div 2);
  //Menu.HoverAnimation := true;

  for i := 0 to Menu.Count - 1 do Menu.Items[i].TextLabel.Color := makeCol(0, 0, 0);

end;

destructor TSettings.Destroy;
begin
  Menu.Destroy;
end;

procedure TSettings.Render;
begin
  Background.Draw;

  GUI.RoundedBox(makeRect(Menu.Position.X - 8, Menu.Position.Y - 8, Menu.Width + 16, Menu.Height), makeCol(0, 0, 0, 128), 8);
  Menu.Draw;
end;

procedure TSettings.Update(dt: Double);
begin
  Menu.Update;

  if Music then Menu.Items[0].Caption := 'Music: On' else Menu.Items[0].Caption := 'Music: Off';
  if Sound then Menu.Items[1].Caption := 'Sound: On' else Menu.Items[1].Caption := 'Sound: Off';
end;

procedure TSettings.HandleEvents;
begin
  if Menu.OnButtonClick(0) then Music := not Music;
  if Menu.OnButtonClick(1) then Sound := not Sound;
  if Menu.OnButtonClick('Back') then GameState := gsMainMenu;
end;

end.
