unit uGame;

interface

uses
  ElysionTypes,
  ElysionApplication,
  ElysionStage,
  ElysionLogger,
  ElysionColors,
  ElysionGraphics,
  ElysionTrueTypeFonts,
  ElysionAudio,
  ElysionInput,
  ElysionUtils,

  SysUtils,
  uBasic,
  uGlobal,
  uConfig,
  uMainMenu,
  uGameScreen,
  uSettings;

type
  TGame = class(TelGame)
  private
    fMainMenu: TMainMenu;
    fGameScreen: TGameScreen;
    fLoadScreen: TelSprite;
    fSettings: TSettings;
    fMusic: TelMusic;

    fFont: TelTrueTypeFont;
    fShowFPS, fDebug: Boolean;
    fForceFullscreen, fForceWindow: Boolean;

    //fCredits, fInstructions: TelStage;
  public
    constructor Create(); Override;
    destructor Destroy; Override;
    
    procedure Initialize(); Override;

    procedure Render(); Override;
    procedure Update(dt: Double); Override;
    procedure HandleEvents(); Override;
  published
    property Debug: Boolean read fDebug write fDebug;
    property ForceFullscreen: Boolean read fForceFullscreen write fForceFullscreen;
    property ForceWindow: Boolean read fForceWindow write fForceWindow;

    property Font: TelTrueTypeFont read fFont write fFont;

    property MainMenu: TMainMenu read fMainMenu write fMainMenu;
    property GameScreen: TGameScreen read fGameScreen write fGameScreen;
    //property Credits: TelStage read fCredits write fCredits;
    //property Instructions: TelStage read fInstructions write fInstructions;
    property Settings: TSettings read fSettings write fSettings;

    property ShowFPS: Boolean read fShowFPS write fShowFPS;
  end;

implementation

constructor TGame.Create;
var
  tmpFullscreen: Boolean;
begin
  Debug := true;
  fForceFullscreen := false;
  fForceWindow := false;

  fShowFPS := false;
  GameState := gsMainMenu;

  // Check for commandline parameters
  if Self.Param('-debug') then Debug := true;
  if Self.Param('-fullscreen') then ForceFullscreen := true;
  if Self.Param('-window') then ForceWindow := true;

  // Get ya priorities straight
  if Debug then
  begin
    TelLogger.getInstance.Priorities := [ltNote, ltWarning, ltError];
    tmpFullscreen := false
  end else tmpFullscreen := true;

  if (ForceWindow) and (not ForceFullscreen) then tmpFullscreen := false
    else tmpFullscreen := true;

  // Super
  if Debug then
    inherited Create(AppConfig.Width, AppConfig.Height, AppConfig.Bits, false)
  else
    inherited Create(Desktop.Width, Desktop.Height, AppConfig.Bits, tmpFullscreen);

  fLoadScreen := TelSprite.Create;
  fLoadScreen.LoadFromFile(GetResImgPath + 'loadscreen.jpg');

end;

destructor TGame.Destroy;
begin
  inherited;

  fLoadScreen.Destroy;

  MainMenu.Destroy;
  if GameScreen <> nil then GameScreen.Destroy;
end;

procedure TGame.Initialize;
var
  newRatio: Single;
begin
  Audio.Initialize();

  if fLoadScreen.AspectRatio = ActiveWindow.AspectRatio then
    fLoadScreen.Scale := makeV2f(ActiveWindow.Width / fLoadScreen.Width, ActiveWindow.Height / fLoadScreen.Height)
  else begin
    if (fLoadScreen.AspectRatio * ActiveWindow.Width) > ActiveWindow.Width then
      fLoadScreen.Left := - (((fLoadScreen.AspectRatio * ActiveWindow.Height) - ActiveWindow.Width) / 2)
    else
      fLoadScreen.Left := (((fLoadScreen.AspectRatio * ActiveWindow.Height) - ActiveWindow.Width) / 2);

    newRatio := ActiveWindow.Height / fLoadScreen.Height;
    fLoadScreen.Scale := makeV2f(newRatio, newRatio);
  end;

  ActiveWindow.BeginScene;
  fLoadScreen.Draw;
  ActiveWindow.EndScene;

  ActiveWindow.Caption := 'A Practical Survival Guide for Robots';
  ActiveWindow.ShowCursor();


  fFont := TelTrueTypeFont.Create;
  fFont.LoadFromFile(GetStdFont, 14);
  fFont.Color := Color.clWhite;
  fFont.RenderStyle := rtBlended;



  //Application.LogDriverInfo();


  MainMenu := TMainMenu.Create;
  Settings := TSettings.Create;


  MainMenu.Background.Scale := fLoadScreen.Scale;
  MainMenu.Background.Left := fLoadScreen.Left;
  Settings.Background.Scale := fLoadScreen.Scale;
  Settings.Background.Left := fLoadScreen.Left;


  //Credits := TelStage.Create();
  //Instructions := TelStage.Create();

  //Credits.Initialize;
  //Instructions.Initialize;

  fMusic := TelMusic.Create;
  fMusic.LoadFromFile(GetResSndPath + 'music.ogg');
  if uGlobal.Music then fMusic.Play(-1);
end;

procedure TGame.Render;
begin
  if MainMenu.NewGameClick then
  begin
    fLoadScreen.Draw;
    ActiveWindow.EndScene;

    ActiveWindow.HideCursor;
    if fGameScreen <> nil then FreeAndNil(fGameScreen);
    fGameScreen := TGameScreen.Create;
    ActiveWindow.ShowCursor;

    MainMenu.NewGameClick := false;
  end;



  case GameState of
    gsMainMenu: MainMenu.Render();
    //gsInstructions: Instructions.Render;
    gsSettings: Settings.Render;
    gsIntro:
	begin
	  
	end;
    //gsCredits: Credits.Render;
    gsGame: GameScreen.Render;
  end;
  
end;

procedure TGame.Update(dt: Double);
begin
  if ShowFPS then
    fFont.TextOut(makeV3f(8, 8, 0), 'FPS: ' + FloatToStr(ActiveWindow.FPS) + ' Delta: ' + FloatToStr(dt));


  case GameState of
    gsCredits:
    begin
      //Credits.Update(dt);
    end;
    gsInstructions:
    begin
      //Instructions.Update(dt);
    end;
    gsSettings:
    begin
      Settings.Update(dt);
    end;
    gsMainMenu:
    begin
      MainMenu.Update(dt);
    end;
    gsGame:
    begin
      GameScreen.Update(dt);
    end;
  end;

  // Update music if necessary
  if uGlobal.Music then
  begin
    if (not fMusic.isPlaying) then fMusic.Play(-1)
  end else
  begin
    if (fMusic.isPlaying) then fMusic.Stop
  end;

end;

procedure TGame.HandleEvents();
begin
  case GameState of
    gsCredits:
    begin
      //Credits.Update(dt);
    end;
    gsInstructions:
    begin
      //Instructions.Update(dt);
    end;
    gsSettings:
    begin
      Settings.HandleEvents;
    end;
    gsMainMenu:
    begin
      MainMenu.HandleEvents;
    end;
    gsGame:
    begin
      GameScreen.HandleEvents;
    end;
  end;

  // Keyboard Inputs
  if GameState <> gsMainMenu then
  begin
    if Input.Keyboard.isKeyHit(Key.Escape) or Input.XBox360Controller.Back then GameState := gsMainMenu;
  end else
  begin
    if Input.Keyboard.isKeyHit(Key.Escape) or Input.XBox360Controller.Back then Application.Quit();
  end;

  // Fullscreen not working at the moment, needs fixing
  if Input.Keyboard.isKeyHit(Key.F) then
  begin
    ShowFPS := not ShowFPS;
  end;

  if Input.Keyboard.isKeyHit(Key.T) then
  begin
    ActiveWindow.TakeScreenShot('screenshot');
  end;

end;

end.
