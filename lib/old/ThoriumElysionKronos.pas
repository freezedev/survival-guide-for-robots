(*******************************************************************************
ThoriumElysionKronos
Connector between ElysionKronos and Thorium scripting language
*******************************************************************************)
unit ThoriumElysionKronos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Thorium, Thorium_Globals, ElysionKronos;

type

  { elPoint }

  elPoint = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fX, fY: Integer;
  protected
    class function Construct(aX, aY: Integer): elPoint;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  published
    property X: Integer read fX write fX;
    property Y: Integer read fY write fY;
  end;

  { elfPoint }

  elfPoint = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fX, fY: Single;
  protected
    class function Construct(aX, aY: Single): elfPoint;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  published
    property X: Single read fX write fX;
    property Y: Single read fY write fY;
  end;

  { elVector }

  elVector = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fX, fY, fZ: Integer;
  protected
    class function Construct(aX, aY, aZ: Integer): elVector;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  published
    property X: Integer read fX write fX;
    property Y: Integer read fY write fY;
    property Z: Integer read fZ write fZ;
  end;

  { elColor }

  elColor = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fR, fG, fB: Byte;
  protected
    class function Construct(aR, aG, aB: Byte): elColor;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  published
    property R: Byte read fR write fR;
    property G: Byte read fG write fG;
    property B: Byte read fB write fB;
  end;

  { elSprite -> Connection to TelSprite }

  elSprite = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fSprite: TelSprite;
    fPosition: elVector;
    fOffset, fOffsetRot: elPoint;
    fScale: elfPoint;

    fColor: elColor;

    function getRotation(): Single;
    procedure setRotation(AValue: Single);
    function getAlpha(): Integer;
    procedure setAlpha(AValue: Integer);

    function getVisible: Boolean;
    procedure setVisible(AValue: Boolean);

    function getOnMouseOver: Boolean;
    function getOnClick: Boolean;
  protected
    class function Construct(): elSprite;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure LoadFromFile(Filename: String);
    procedure LoadFromFileCI(Filename: String; aX, aY, aW, aH: Integer);

    procedure ClipImage(aX, aY, aW, aH: Integer);
    procedure setTransparencyColor(r, g, b: Byte);
    procedure setTransparencyPoint(x, y: Integer);

    procedure Move(deltaX, deltaY: Integer);
    procedure Draw;
  published
    property Color: elColor read fColor write fColor;

    property Offset: elPoint read fOffset write fOffset;
    property OffsetRot: elPoint read fOffsetRot write fOffsetRot;

    property Position: elVector read fPosition write fPosition;

    property Scale: elfPoint read fScale write fScale;

    property Rotation: Single read getRotation write setRotation;
    property Alpha: Integer read getAlpha write setAlpha;
    property Visible: Boolean read getVisible write setVisible;

    property OnMouseOver: Boolean read getOnMouseOver;
    property OnClick: Boolean read getOnClick;
  end;

  { Connection to -> TelTimer }

  elTimer = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fTimer: TelTimer;

    function getActive(): Boolean;

    function getInterval(): Integer;
    procedure setInterval(AValue: Integer);

    function getOnEvent: Boolean;
  protected
    class function Construct(): elTimer;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure Start();
    procedure Stop();

    procedure Pause();
    procedure UnPause();

    function getTicks(): Integer;
  published
    property Interval: Integer read getInterval write setInterval;

    property OnEvent: Boolean read getOnEvent;
    property Active: Boolean read getActive;
  end;

  { Connection to -> TelTrueTypeFont }

  elTrueTypeFont = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fTrueTypeFont: TelTrueTypeFont;

  protected
    class function Construct(): elTrueTypeFont;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure LoadFromFile(Filename: String);
    procedure LoadFromFileS(Filename: String; PtSize: Integer);

    procedure TextOut(aX, aY: Integer; Text: String);
  published
    //
  end;

  elMusic = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fMusic: TelMusic;

    function getIsPlaying: Boolean;
    function getPaused: Boolean;
    function getVolume: ShortInt;
    procedure setVolume(AValue: ShortInt);
  protected
    class function Construct(): elMusic;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure SetPosition(Position: Double);
    procedure LoadFromFile(Filename: String);
    procedure Play(Loop: Integer);
    procedure Pause();
    procedure Stop();
  published
    property isPlaying: Boolean read getIsPlaying;
    property Paused: Boolean read getPaused;
    property Volume: ShortInt read getVolume write setVolume;
  end;

  elSound = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fSound: TelSound;
  protected
    class function Construct(): elSound;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure LoadFromFile(Filename: String);
    procedure Play();
    procedure Stop();
  end;

  { Connection to general functions, like changing perspective, caption, etc }

  TAppLayer = class (TThoriumPersistent)
  public
    constructor Create;
  private
    function getCaption: String;
    procedure setCaption(AValue: String);

    function getWidth: Integer;
    function getHeight: Integer;
    function getBits: Integer;
    function getFullscreen: Boolean;
  protected
    class function Construct(): TAppLayer;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    procedure ShowCursor();
    procedure HideCursor();

    procedure TakeScreenshot(Filename: String);

    function SetVideoMode(_Width, _Height, _ColorBits: Integer; _Fullscreen: Boolean): Boolean;

    // Switches between windowed mode and fullscreen mode
    procedure ToggleFullscreen();

    procedure Quit();
  published
    property Caption: String read getCaption write setCaption;

    property Width: Integer read getWidth;
    property Height: Integer read getHeight;
    property Bits: Integer read getBits;
    property Fullscreen: Boolean read getFullscreen;
  end;

  TMouseLayer = class (TThoriumPersistent)
  public
    constructor Create;
  protected
    class function Construct(): TMouseLayer;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    function isButtonDown(Button: LongWord): Boolean;
    function isButtonHit(Button: LongWord): Boolean;
    function isButtonUp(Button: LongWord): Boolean;

    function LeftClick(): Boolean;
    function RightClick(): Boolean;

    function WheelDown(): Boolean;
    function WheelUp(): Boolean;
  end;

  TKeyboardLayer = class (TThoriumPersistent)
  public
    constructor Create;
  protected
    class function Construct(): TKeyboardLayer;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  public
    function isKeyDown(Key: Cardinal): Boolean;
    function isKeyHit(Key: Cardinal): Boolean;
    function isKeyUp(Key: Cardinal): Boolean;
  end;

  TInputLayer = class (TThoriumPersistent)
  public
    constructor Create;
  private
    fMouseLayer: TMouseLayer;
    fKeyboardLayer: TKeyboardLayer;
  protected
    class function Construct(): TInputLayer;
    class procedure GetMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIMethods); override;
    class procedure GetStaticMethodList(Sender: TThoriumRTTIObjectType;
       var Methods: TThoriumRTTIStaticMethods); override;
  published
    property Mouse: TMouseLayer read fMouseLayer write fMouseLayer;
    property Keyboard: TKeyboardLayer read fKeyboardLayer write fKeyboardLayer;
  end;

  { TLibElysionKronos }

  TLibElysionKronos = class (TThoriumLibrary)
  protected
    procedure InitializeLibrary; override;
    class function GetName: String; override;
  end;

implementation

var
  AppLayer: TAppLayer;
  InputLayer: TInputLayer;

{ elPoint }

constructor elPoint.Create;
begin
  inherited;
  fX := 0;
  fY := 0;
end;

class function elPoint.Construct(aX, aY: Integer): elPoint;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elPoint(elPoint.Create.ThoriumReference.GetReference);
  Result.fX := aX;
  Result.fY := aY;
  // And do not (!) disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure elPoint.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 0);

end;

class procedure elPoint.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elPoint.Construct, elPoint,
    [htLongInt, htLongInt],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elPoint.Construct, elPoint,
    [htLongInt, htLongInt],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

{ elfPoint }

constructor elfPoint.Create;
begin
  inherited;
  fX := 0.0;
  fY := 0.0;
end;

class function elfPoint.Construct(aX, aY: Single): elfPoint;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elfPoint(elfPoint.Create.ThoriumReference.GetReference);
  Result.fX := aX;
  Result.fY := aY;
  // And do not (!) disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure elfPoint.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 0);

end;

class procedure elfPoint.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elfPoint.Construct, elfPoint,
    [htSingle, htSingle],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elfPoint.Construct, elfPoint,
    [htSingle, htSingle],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

{ elVector }

constructor elVector.Create;
begin
  inherited;
  fX := 0;
  fY := 0;
  fZ := 0;
end;

class function elVector.Construct(aX, aY, aZ: Integer): elVector;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elVector(elVector.Create.ThoriumReference.GetReference);
  Result.fX := aX;
  Result.fY := aY;
  Result.fZ := aZ;
  // And do not (!) disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure elVector.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 0);

end;

class procedure elVector.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elVector.Construct, elVector,
    [htLongInt, htLongInt, htLongInt],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elVector.Construct, elVector,
    [htLongInt, htLongInt, htLongInt],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

{ elColor }

constructor elColor.Create;
begin
  inherited;
  fR := 0;
  fG := 0;
  fB := 0;
end;

class function elColor.Construct(aR, aG, aB: Byte): elColor;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elColor(elColor.Create.ThoriumReference.GetReference);
  Result.fR := aR;
  Result.fG := aG;
  Result.fB := aB;
  // And do not (!) disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure elColor.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 0);

end;

class procedure elColor.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elColor.Construct, elColor,
    [htByte, htByte, htByte],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elColor.Construct, elColor,
    [htByte, htByte, htByte],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

{ elSprite }

constructor elSprite.Create;
begin
  inherited;
  fSprite := TelSprite.Create;
  fPosition := elVector.Create;
  fOffset := elPoint.Create;
  fOffsetRot := elPoint.Create;
  fColor := elColor.Create;
  fScale := elfPoint.Create;

  fColor.R := 255;
  fColor.G := 255;
  fColor.B := 255;

  fScale.X := 1.0;
  fScale.Y := 1.0;
end;

class function elSprite.Construct(): elSprite;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elSprite(elSprite.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure elSprite.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 7);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfile',
    @elSprite.LoadFromFile,
    [htString],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfileci',
    @elSprite.LoadFromFileCI,
    [htString, htLongInt, htLongInt, htLongInt, htLongInt],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'clipimage',
    @elSprite.ClipImage,
    [htLongInt, htLongInt, htLongInt, htLongInt],
    htNone,
    ncRegister
  );

  Methods[3] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'move',
    @elSprite.Move,
    [htLongInt, htLongInt],
    htNone,
    ncRegister
  );

  Methods[4] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'settransparencycolor',
    @elSprite.setTransparencyColor,
    [htByte, htByte, htByte],
    htNone,
    ncRegister
  );

  Methods[5] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'settransparencypoint',
    @elSprite.setTransparencyPoint,
    [htLongInt, htLongInt],
    htNone,
    ncRegister
  );

  Methods[6] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'draw',
    @elSprite.Draw,
    [],
    htNone,
    ncRegister
  );
end;

class procedure elSprite.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elSprite.Construct, elSprite,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elSprite.Construct, elSprite,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

procedure elSprite.LoadFromFile(Filename: String); inline;
begin
  fSprite.LoadFromFile(Filename);
end;

procedure elSprite.LoadFromFileCI(Filename: String; aX, aY, aW, aH: Integer); inline;
begin
  fSprite.LoadFromFile(Filename, makeRect(aX, aY, aW, aH));
end;

procedure elSprite.Move(deltaX, deltaY: Integer); inline;
begin
  fSprite.Move(makeP2D(deltaX, deltaY));
end;

procedure elSprite.ClipImage(aX, aY, aW, aH: Integer); inline;
begin
  fSprite.ClipImage(makeRect(aX, aY, aW, aH));
end;

procedure elSprite.setTransparencyColor(r, g, b: Byte); inline;
begin
  fSprite.setTransparency(makeCol(r, g, b));
end;

procedure elSprite.setTransparencyPoint(x, y: Integer); inline;
begin
  fSprite.setTransparency(makeP2D(x, y));
end;

function elSprite.getOnMouseOver(): Boolean; inline;
begin
  Result := fSprite.OnMouseOver;
end;

function elSprite.getOnClick(): Boolean; inline;
begin
  Result := fSprite.OnClick;
end;

// Inline - yes or no - that is the question?
procedure elSprite.Draw;
begin
  fSprite.Position.X := fPosition.X;
  fSprite.Position.Y := fPosition.Y;
  fSprite.Position.Z := fPosition.Z;

  fSprite.Offset.Position.X := fOffset.X;
  fSprite.Offset.Position.Y := fOffset.Y;

  fSprite.Offset.Rotation.X := fOffsetRot.X;
  fSprite.Offset.Rotation.Y := fOffsetRot.Y;

  fSprite.Color.R := fColor.R;
  fSprite.Color.G := fColor.G;
  fSprite.Color.B := fColor.B;

  fSprite.Scale.X := fScale.X;
  fSprite.Scale.Y := fScale.Y;

  fSprite.Draw;
end;

function elSprite.getRotation(): Single; inline;
begin
  Result := fSprite.Rotation.Angle;
end;

procedure elSprite.setRotation(AValue: Single); inline;
begin
  fSprite.Rotation.Angle := AValue;
end;

function elSprite.getAlpha(): Integer; inline;
begin
  Result := fSprite.Alpha;
end;

procedure elSprite.setAlpha(AValue: Integer); inline;
begin
  fSprite.Alpha := AValue;
end;

procedure elSprite.setVisible(AValue: Boolean); inline;
begin
  fSprite.Visible := AValue;
end;

function elSprite.getVisible: Boolean; inline;
begin
  Result := fSprite.Visible;
end;

{ elTimer }

constructor elTimer.Create;
begin
  inherited;
  fTimer := TelTimer.Create;
end;

class function elTimer.Construct(): elTimer;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elTimer(elTimer.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure elTimer.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 5);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'start',
    @elTimer.Start,
    [],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'pause',
    @elTimer.Pause,
    [],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'unpause',
    @elTimer.UnPause,
    [],
    htNone,
    ncRegister
  );

  Methods[3] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'stop',
    @elTimer.Stop,
    [],
    htNone,
    ncRegister
  );

  Methods[4] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'getticks',
    @elTimer.getTicks,
    [],
    htLongInt,
    ncRegister
  );
end;

class procedure elTimer.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elTimer.Construct, elTimer,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elTimer.Construct, elTimer,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

function elTimer.getOnEvent(): Boolean; inline;
begin
  Result := fTimer.Event;
end;

function elTimer.getActive(): Boolean; inline;
begin
  Result := fTimer.Active;
end;

function elTimer.getInterval(): Integer; inline;
begin
  Result := fTimer.Interval;
end;

procedure elTimer.setInterval(AValue: Integer); inline;
begin
  fTimer.Interval := AValue;
end;

procedure elTimer.Start(); inline;
begin
  fTimer.Start();
end;

procedure elTimer.Pause(); inline;
begin
  fTimer.Pause();
end;

procedure elTimer.UnPause(); inline;
begin
  fTimer.UnPause();
end;

procedure elTimer.Stop(); inline;
begin
  fTimer.Stop();
end;

function elTimer.getTicks(): Integer; inline;
begin
  Result := fTimer.getTicks();
end;

{ elTrueTypeFont }

constructor elTrueTypeFont.Create;
begin
  inherited;
  fTrueTypeFont := TelTrueTypeFont.Create;
end;

class function elTrueTypeFont.Construct(): elTrueTypeFont;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elTrueTypeFont(elTrueTypeFont.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure elTrueTypeFont.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 3);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfile',
    @elTrueTypeFont.LoadFromFile,
    [htString],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfiles',
    @elTrueTypeFont.LoadFromFileS,
    [htString, htLongInt],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'textout',
    @elTrueTypeFont.TextOut,
    [htLongInt, htLongInt, htString],
    htNone,
    ncRegister
  );

end;

class procedure elTrueTypeFont.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elTrueTypeFont.Construct, elTrueTypeFont,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elTrueTypeFont.Construct, elTrueTypeFont,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

procedure elTrueTypeFont.LoadFromFile(Filename: String); inline;
begin
  fTrueTypeFont.LoadFromFile(Filename);
end;

procedure elTrueTypeFont.LoadFromFileS(Filename: String; PtSize: Integer); inline;
begin
  fTrueTypeFont.LoadFromFile(Filename, PtSize);
end;

procedure elTrueTypeFont.TextOut(aX, aY: Integer; Text: String); inline;
begin
  fTrueTypeFont.TextOut(makeP3D(aX, aY, 0), Text);
end;

{ elMusic }

constructor elMusic.Create;
begin
  inherited;
  fMusic := TelMusic.Create;
end;

class function elMusic.Construct(): elMusic;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elMusic(elMusic.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure elMusic.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 5);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'setposition',
    @elMusic.SetPosition,
    [htDouble],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfile',
    @elMusic.LoadFromFile,
    [htString],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'play',
    @elMusic.Play,
    [htLongInt],
    htNone,
    ncRegister
  );

  Methods[3] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'stop',
    @elMusic.Stop,
    [],
    htNone,
    ncRegister
  );

  Methods[4] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'pause',
    @elMusic.Pause,
    [],
    htNone,
    ncRegister
  );
end;

class procedure elMusic.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elMusic.Construct, elMusic,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elMusic.Construct, elMusic,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

function elMusic.getIsPlaying(): Boolean; inline;
begin
  Result := fMusic.isPlaying;
end;

function elMusic.getPaused(): Boolean; inline;
begin
  Result := fMusic.Paused;
end;

function elMusic.getVolume(): ShortInt; inline;
begin
  Result := fMusic.Volume;
end;

procedure elMusic.setVolume(AValue: ShortInt); inline;
begin
  fMusic.Volume := AValue;
end;

procedure elMusic.SetPosition(Position: Double); inline;
begin
  fMusic.SetPosition(Position);
end;

procedure elMusic.LoadFromFile(Filename: String); inline;
begin
  fMusic.LoadFromFile(Filename);
end;

procedure elMusic.Play(Loop: Integer); inline;
begin
  fMusic.Play(Loop);
end;

procedure elMusic.Pause(); inline;
begin
  fMusic.Pause();
end;

procedure elMusic.Stop(); inline;
begin
  fMusic.Stop();
end;

{ elSound }

constructor elSound.Create;
begin
  inherited;
  fSound := TelSound.Create;
end;

class function elSound.Construct(): elSound;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := elSound(elSound.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure elSound.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 3);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'loadfromfile',
    @elSound.LoadFromFile,
    [htString],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'play',
    @elSound.Play,
    [],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'stop',
    @elSound.Stop,
    [],
    htNone,
    ncRegister
  );

end;

class procedure elSound.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @elSound.Construct, elSound,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @elSound.Construct, elSound,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

procedure elSound.LoadFromFile(Filename: String); inline;
begin
  fSound.LoadFromFile(Filename);
end;

procedure elSound.Play(); inline;
begin
  fSound.Play();
end;

procedure elSound.Stop(); inline;
begin
  fSound.Stop();
end;

{ TAppLayer }

constructor TAppLayer.Create;
begin
  inherited;
end;

class function TAppLayer.Construct(): TAppLayer;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := TAppLayer(TAppLayer.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure TAppLayer.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 5);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'quit',
    @TAppLayer.Quit,
    [],
    htNone,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'showcursor',
    @TAppLayer.ShowCursor,
    [],
    htNone,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'hidecursor',
    @TAppLayer.HideCursor,
    [],
    htNone,
    ncRegister
  );

  Methods[3] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'takescreenshot',
    @TAppLayer.TakeScreenshot,
    [htString],
    htNone,
    ncRegister
  );

  Methods[4] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'setvideomode',
    @TAppLayer.SetVideoMode,
    [htLongInt, htLongInt, htLongInt, htPtrInt],
    htPtrInt,
    ncRegister
  );

end;

class procedure TAppLayer.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @TAppLayer.Construct, TAppLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @TAppLayer.Construct, TAppLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

procedure TAppLayer.ShowCursor(); inline;
begin
  ActiveWindow.ShowCursor();
end;

procedure TAppLayer.HideCursor(); inline;
begin
  ActiveWindow.HideCursor;
end;

procedure TAppLayer.TakeScreenshot(Filename: String); inline;
begin
  ActiveWindow.TakeScreenshot(Filename);
end;

function TAppLayer.SetVideoMode(_Width, _Height, _ColorBits: Integer; _Fullscreen: Boolean): Boolean; inline;
begin
  Result := SetVideoMode(_Width, _Height, _ColorBits, _Fullscreen);
end;

procedure TAppLayer.ToggleFullscreen(); inline;
begin
  ActiveWindow.ToggleFullscreen();
end;

function TAppLayer.getWidth: Integer; inline;
begin
  Result := ActiveWindow.Width;
end;

function TAppLayer.getHeight: Integer; inline;
begin
  Result := ActiveWindow.Height;
end;

function TAppLayer.getBits: Integer; inline;
begin
  Result := ActiveWindow.Bits;
end;

function TAppLayer.getFullscreen: Boolean; inline;
begin
  Result := ActiveWindow.Fullscreen;
end;

function TAppLayer.getCaption: String; inline;
begin
  Result := ActiveWindow.Caption;
end;

procedure TAppLayer.setCaption(AValue: String); inline;
begin
  ActiveWindow.Caption := AValue;
end;

procedure TAppLayer.Quit(); inline;
begin
  Application.Quit();
end;

constructor TInputLayer.Create;
begin
  inherited;
  fMouseLayer := TMouseLayer.Create;
  fKeyboardLayer := TKeyboardLayer.Create;
end;

class function TInputLayer.Construct(): TInputLayer;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := TInputLayer(TInputLayer.Create.ThoriumReference.GetReference);
  // And disable the host control.
  Result.ThoriumReference.DisableHostControl;
end;

class procedure TInputLayer.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 0);

end;

class procedure TInputLayer.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @TInputLayer.Construct, TInputLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @TInputLayer.Construct, TInputLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

constructor TMouseLayer.Create;
begin
  inherited;
end;

class function TMouseLayer.Construct(): TMouseLayer;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := TMouseLayer(TMouseLayer.Create.ThoriumReference.GetReference);
  // And disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure TMouseLayer.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 7);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'isbuttondown',
    @TMouseLayer.isButtonDown,
    [htLongInt],
    htPtrInt,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'isbuttonhit',
    @TMouseLayer.isButtonHit,
    [htLongInt],
    htPtrInt,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'isbuttonup',
    @TMouseLayer.isButtonUp,
    [htLongInt],
    htPtrInt,
    ncRegister
  );

  Methods[3] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'leftclick',
    @TMouseLayer.LeftClick,
    [],
    htPtrInt,
    ncRegister
  );

  Methods[4] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'rightclick',
    @TMouseLayer.RightClick,
    [],
    htPtrInt,
    ncRegister
  );

  Methods[5] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'wheeldown',
    @TMouseLayer.WheelDown,
    [],
    htPtrInt,
    ncRegister
  );

  Methods[6] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'wheelup',
    @TMouseLayer.WheelUp,
    [],
    htPtrInt,
    ncRegister
  );
end;

class procedure TMouseLayer.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @TMouseLayer.Construct, TMouseLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @TMouseLayer.Construct, TMouseLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

function TMouseLayer.isButtonDown(Button: LongWord): Boolean; inline;
begin
  Result := Input.Mouse.isButtonDown(Button);
end;

function TMouseLayer.isButtonHit(Button: LongWord): Boolean; inline;
begin
  Result := Input.Mouse.isButtonHit(Button);
end;

function TMouseLayer.isButtonUp(Button: LongWord): Boolean; inline;
begin
  Result := Input.Mouse.isButtonUp(Button);
end;

function TMouseLayer.LeftClick(): Boolean; inline;
begin
  Result := Input.Mouse.LeftClick();
end;

function TMouseLayer.RightClick(): Boolean; inline;
begin
  Result := Input.Mouse.RightClick();
end;

function TMouseLayer.WheelDown(): Boolean; inline;
begin
  Result := Input.Mouse.WheelDown();
end;

function TMouseLayer.WheelUp(): Boolean; inline;
begin
  Result := Input.Mouse.WheelUp();
end;


constructor TKeyboardLayer.Create;
begin
  inherited;
end;

class function TKeyboardLayer.Construct(): TKeyboardLayer;
// A note about this function. It is *neccessary* to use a static (class) method
// instead of the direct call to a constructor. This is due to pascal internas
// which seem to happen at constructor call. Maybe there will be an alternative
// for this later. A special type for constructors for example ;).
begin
  // The API of 1.0.3.0 forces you to separate host and script references. The
  // script references are counted, the host reference is a boolean which
  // indicates whether the host controls the object or not. To create an object
  // for the script only, you would call the constructor and get a new
  // reference:
  Result := TKeyboardLayer(TKeyboardLayer.Create.ThoriumReference.GetReference);
  // And disable the host control.
  //Result.ThoriumReference.DisableHostControl;
end;

class procedure TKeyboardLayer.GetMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIMethods);
begin
  SetLength(Methods, 3);

  Methods[0] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'iskeydown',
    @TKeyboardLayer.isKeyDown,
    [htLongInt],
    htPtrInt,
    ncRegister
  );

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'iskeyhit',
    @TKeyboardLayer.isKeyHit,
    [htLongInt],
    htPtrInt,
    ncRegister
  );

  Methods[2] := TThoriumRTTIObjectType.NewNativeCallMethod(
    'iskeyup',
    @TKeyboardLayer.isKeyUp,
    [htLongInt],
    htPtrInt,
    ncRegister
  );
end;

class procedure TKeyboardLayer.GetStaticMethodList(Sender: TThoriumRTTIObjectType;
  var Methods: TThoriumRTTIStaticMethods);
begin
  SetLength(Methods, 2);
  Methods[0] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'create',
    @TKeyboardLayer.Construct, TKeyboardLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[0].ReturnTypeExtended := Sender;

  Methods[1] := TThoriumRTTIObjectType.NewNativeCallStaticMethod(
    'new',
    @TKeyboardLayer.Construct, TKeyboardLayer,
    [],
    htExt,
    ncRegister
  );
  Methods[1].ReturnTypeExtended := Sender;
end;

function TKeyboardLayer.isKeyDown(Key: Cardinal): Boolean; inline;
begin
  Result := Input.Keyboard.isKeyDown(Key);
end;

function TKeyboardLayer.isKeyHit(Key: Cardinal): Boolean; inline;
begin
  Result := Input.Keyboard.isKeyHit(Key);
end;

function TKeyboardLayer.isKeyUp(Key: Cardinal): Boolean; inline;
begin
  Result := Input.Keyboard.isKeyUp(Key);
end;

{ TLibElysionKronos }

procedure TLibElysionKronos.InitializeLibrary;
var
  TypeSpecApp, TypeSpecInput: TThoriumType;
  ValueApp, ValueInput: TThoriumValue;
  AppObject, InputObject: TThoriumRTTIObjectType;
begin
  // Register keyboard & mouse constants
  RegisterConstant('K_UNKNOWN', ThoriumCreateIntegerValue(K_UNKNOWN));
  RegisterConstant('K_FIRST', ThoriumCreateIntegerValue(K_FIRST));
  RegisterConstant('K_BACKSPACE', ThoriumCreateIntegerValue(K_BACKSPACE));
  RegisterConstant('K_TAB', ThoriumCreateIntegerValue(K_TAB));
  RegisterConstant('K_CLEAR', ThoriumCreateIntegerValue(K_CLEAR));
  RegisterConstant('K_RETURN', ThoriumCreateIntegerValue(K_RETURN));
  RegisterConstant('K_PAUSE', ThoriumCreateIntegerValue(K_PAUSE));
  RegisterConstant('K_ESCAPE', ThoriumCreateIntegerValue(K_ESCAPE));
  RegisterConstant('K_SPACE', ThoriumCreateIntegerValue(K_SPACE));
  RegisterConstant('K_EXCLAIM', ThoriumCreateIntegerValue(K_EXCLAIM));
  RegisterConstant('K_QUOTEDBL', ThoriumCreateIntegerValue(K_QUOTEDBL));
  RegisterConstant('K_HASH', ThoriumCreateIntegerValue(K_HASH));
  RegisterConstant('K_DOLLAR', ThoriumCreateIntegerValue(K_DOLLAR));
  RegisterConstant('K_AMPERSAND', ThoriumCreateIntegerValue(K_AMPERSAND));
  RegisterConstant('K_QUOTE', ThoriumCreateIntegerValue(K_QUOTE));
  RegisterConstant('K_LEFTPAREN', ThoriumCreateIntegerValue(K_LEFTPAREN));
  RegisterConstant('K_RIGHTPAREN', ThoriumCreateIntegerValue(K_RIGHTPAREN));
  RegisterConstant('K_ASTERISK', ThoriumCreateIntegerValue(K_ASTERISK));
  RegisterConstant('K_PLUS', ThoriumCreateIntegerValue(K_PLUS));
  RegisterConstant('K_COMMA', ThoriumCreateIntegerValue(K_COMMA));
  RegisterConstant('K_MINUS', ThoriumCreateIntegerValue(K_MINUS));
  RegisterConstant('K_PERIOD', ThoriumCreateIntegerValue(K_PERIOD));
  RegisterConstant('K_SLASH', ThoriumCreateIntegerValue(K_SLASH));
  RegisterConstant('K_0', ThoriumCreateIntegerValue(K_0));
  RegisterConstant('K_1', ThoriumCreateIntegerValue(K_1));
  RegisterConstant('K_2', ThoriumCreateIntegerValue(K_2));
  RegisterConstant('K_3', ThoriumCreateIntegerValue(K_3));
  RegisterConstant('K_4', ThoriumCreateIntegerValue(K_4));
  RegisterConstant('K_5', ThoriumCreateIntegerValue(K_5));
  RegisterConstant('K_6', ThoriumCreateIntegerValue(K_6));
  RegisterConstant('K_7', ThoriumCreateIntegerValue(K_7));
  RegisterConstant('K_8', ThoriumCreateIntegerValue(K_8));
  RegisterConstant('K_9', ThoriumCreateIntegerValue(K_9));
  RegisterConstant('K_COLON', ThoriumCreateIntegerValue(K_COLON));
  RegisterConstant('K_SEMICOLON', ThoriumCreateIntegerValue(K_SEMICOLON));
  RegisterConstant('K_LESS', ThoriumCreateIntegerValue(K_LESS));
  RegisterConstant('K_EQUALS', ThoriumCreateIntegerValue(K_EQUALS));
  RegisterConstant('K_GREATER', ThoriumCreateIntegerValue(K_GREATER));
  RegisterConstant('K_QUESTION', ThoriumCreateIntegerValue(K_QUESTION));
  RegisterConstant('K_AT', ThoriumCreateIntegerValue(K_AT));
  RegisterConstant('K_LEFTBRACKET', ThoriumCreateIntegerValue(K_LEFTBRACKET));
  RegisterConstant('K_BACKSLASH', ThoriumCreateIntegerValue(K_BACKSLASH));
  RegisterConstant('K_RIGHTBRACKET', ThoriumCreateIntegerValue(K_RIGHTBRACKET));
  RegisterConstant('K_CARET', ThoriumCreateIntegerValue(K_CARET));
  RegisterConstant('K_UNDERSCORE', ThoriumCreateIntegerValue(K_UNDERSCORE));
  RegisterConstant('K_BACKQUOTE', ThoriumCreateIntegerValue(K_BACKQUOTE));
  RegisterConstant('K_a', ThoriumCreateIntegerValue(K_a));
  RegisterConstant('K_b', ThoriumCreateIntegerValue(K_b));
  RegisterConstant('K_c', ThoriumCreateIntegerValue(K_c));
  RegisterConstant('K_d', ThoriumCreateIntegerValue(K_d));
  RegisterConstant('K_e', ThoriumCreateIntegerValue(K_e));
  RegisterConstant('K_f', ThoriumCreateIntegerValue(K_f));
  RegisterConstant('K_g', ThoriumCreateIntegerValue(K_g));
  RegisterConstant('K_h', ThoriumCreateIntegerValue(K_h));
  RegisterConstant('K_i', ThoriumCreateIntegerValue(K_i));
  RegisterConstant('K_j', ThoriumCreateIntegerValue(K_j));
  RegisterConstant('K_k', ThoriumCreateIntegerValue(K_k));
  RegisterConstant('K_l', ThoriumCreateIntegerValue(K_l));
  RegisterConstant('K_m', ThoriumCreateIntegerValue(K_m));
  RegisterConstant('K_n', ThoriumCreateIntegerValue(K_n));
  RegisterConstant('K_o', ThoriumCreateIntegerValue(K_o));
  RegisterConstant('K_p', ThoriumCreateIntegerValue(K_p));
  RegisterConstant('K_q', ThoriumCreateIntegerValue(K_q));
  RegisterConstant('K_r', ThoriumCreateIntegerValue(K_r));
  RegisterConstant('K_s', ThoriumCreateIntegerValue(K_s));
  RegisterConstant('K_t', ThoriumCreateIntegerValue(K_t));
  RegisterConstant('K_u', ThoriumCreateIntegerValue(K_u));
  RegisterConstant('K_v', ThoriumCreateIntegerValue(K_v));
  RegisterConstant('K_w', ThoriumCreateIntegerValue(K_w));
  RegisterConstant('K_x', ThoriumCreateIntegerValue(K_x));
  RegisterConstant('K_y', ThoriumCreateIntegerValue(K_y));
  RegisterConstant('K_z', ThoriumCreateIntegerValue(K_z));
  RegisterConstant('K_DELETE', ThoriumCreateIntegerValue(K_DELETE));
  RegisterConstant('K_WORLD_0', ThoriumCreateIntegerValue(K_WORLD_0));
  RegisterConstant('K_WORLD_1', ThoriumCreateIntegerValue(K_WORLD_1));
  RegisterConstant('K_WORLD_2', ThoriumCreateIntegerValue(K_WORLD_2));
  RegisterConstant('K_WORLD_3', ThoriumCreateIntegerValue(K_WORLD_3));
  RegisterConstant('K_WORLD_4', ThoriumCreateIntegerValue(K_WORLD_4));
  RegisterConstant('K_WORLD_5', ThoriumCreateIntegerValue(K_WORLD_5));
  RegisterConstant('K_WORLD_6', ThoriumCreateIntegerValue(K_WORLD_6));
  RegisterConstant('K_WORLD_7', ThoriumCreateIntegerValue(K_WORLD_7));
  RegisterConstant('K_WORLD_8', ThoriumCreateIntegerValue(K_WORLD_8));
  RegisterConstant('K_WORLD_9', ThoriumCreateIntegerValue(K_WORLD_9));
  RegisterConstant('K_WORLD_10', ThoriumCreateIntegerValue(K_WORLD_10));
  RegisterConstant('K_WORLD_11', ThoriumCreateIntegerValue(K_WORLD_11));
  RegisterConstant('K_WORLD_12', ThoriumCreateIntegerValue(K_WORLD_12));
  RegisterConstant('K_WORLD_13', ThoriumCreateIntegerValue(K_WORLD_13));
  RegisterConstant('K_WORLD_14', ThoriumCreateIntegerValue(K_WORLD_14));
  RegisterConstant('K_WORLD_15', ThoriumCreateIntegerValue(K_WORLD_15));
  RegisterConstant('K_WORLD_16', ThoriumCreateIntegerValue(K_WORLD_16));
  RegisterConstant('K_WORLD_17', ThoriumCreateIntegerValue(K_WORLD_17));
  RegisterConstant('K_WORLD_18', ThoriumCreateIntegerValue(K_WORLD_18));
  RegisterConstant('K_WORLD_19', ThoriumCreateIntegerValue(K_WORLD_19));
  RegisterConstant('K_WORLD_20', ThoriumCreateIntegerValue(K_WORLD_20));
  RegisterConstant('K_WORLD_21', ThoriumCreateIntegerValue(K_WORLD_21));
  RegisterConstant('K_WORLD_22', ThoriumCreateIntegerValue(K_WORLD_22));
  RegisterConstant('K_WORLD_23', ThoriumCreateIntegerValue(K_WORLD_23));
  RegisterConstant('K_WORLD_24', ThoriumCreateIntegerValue(K_WORLD_24));
  RegisterConstant('K_WORLD_25', ThoriumCreateIntegerValue(K_WORLD_25));
  RegisterConstant('K_WORLD_26', ThoriumCreateIntegerValue(K_WORLD_26));
  RegisterConstant('K_WORLD_27', ThoriumCreateIntegerValue(K_WORLD_27));
  RegisterConstant('K_WORLD_28', ThoriumCreateIntegerValue(K_WORLD_28));
  RegisterConstant('K_WORLD_29', ThoriumCreateIntegerValue(K_WORLD_29));
  RegisterConstant('K_WORLD_30', ThoriumCreateIntegerValue(K_WORLD_30));
  RegisterConstant('K_WORLD_31', ThoriumCreateIntegerValue(K_WORLD_31));
  RegisterConstant('K_WORLD_32', ThoriumCreateIntegerValue(K_WORLD_32));
  RegisterConstant('K_WORLD_33', ThoriumCreateIntegerValue(K_WORLD_33));
  RegisterConstant('K_WORLD_34', ThoriumCreateIntegerValue(K_WORLD_34));
  RegisterConstant('K_WORLD_35', ThoriumCreateIntegerValue(K_WORLD_35));
  RegisterConstant('K_WORLD_36', ThoriumCreateIntegerValue(K_WORLD_36));
  RegisterConstant('K_WORLD_37', ThoriumCreateIntegerValue(K_WORLD_37));
  RegisterConstant('K_WORLD_38', ThoriumCreateIntegerValue(K_WORLD_38));
  RegisterConstant('K_WORLD_39', ThoriumCreateIntegerValue(K_WORLD_39));
  RegisterConstant('K_WORLD_40', ThoriumCreateIntegerValue(K_WORLD_40));
  RegisterConstant('K_WORLD_41', ThoriumCreateIntegerValue(K_WORLD_41));
  RegisterConstant('K_WORLD_42', ThoriumCreateIntegerValue(K_WORLD_42));
  RegisterConstant('K_WORLD_43', ThoriumCreateIntegerValue(K_WORLD_43));
  RegisterConstant('K_WORLD_44', ThoriumCreateIntegerValue(K_WORLD_44));
  RegisterConstant('K_WORLD_45', ThoriumCreateIntegerValue(K_WORLD_45));
  RegisterConstant('K_WORLD_46', ThoriumCreateIntegerValue(K_WORLD_46));
  RegisterConstant('K_WORLD_47', ThoriumCreateIntegerValue(K_WORLD_47));
  RegisterConstant('K_WORLD_48', ThoriumCreateIntegerValue(K_WORLD_48));
  RegisterConstant('K_WORLD_49', ThoriumCreateIntegerValue(K_WORLD_49));
  RegisterConstant('K_WORLD_50', ThoriumCreateIntegerValue(K_WORLD_50));
  RegisterConstant('K_WORLD_51', ThoriumCreateIntegerValue(K_WORLD_51));
  RegisterConstant('K_WORLD_52', ThoriumCreateIntegerValue(K_WORLD_52));
  RegisterConstant('K_WORLD_53', ThoriumCreateIntegerValue(K_WORLD_53));
  RegisterConstant('K_WORLD_54', ThoriumCreateIntegerValue(K_WORLD_54));
  RegisterConstant('K_WORLD_55', ThoriumCreateIntegerValue(K_WORLD_55));
  RegisterConstant('K_WORLD_56', ThoriumCreateIntegerValue(K_WORLD_56));
  RegisterConstant('K_WORLD_57', ThoriumCreateIntegerValue(K_WORLD_57));
  RegisterConstant('K_WORLD_58', ThoriumCreateIntegerValue(K_WORLD_58));
  RegisterConstant('K_WORLD_59', ThoriumCreateIntegerValue(K_WORLD_59));
  RegisterConstant('K_WORLD_60', ThoriumCreateIntegerValue(K_WORLD_60));
  RegisterConstant('K_WORLD_61', ThoriumCreateIntegerValue(K_WORLD_61));
  RegisterConstant('K_WORLD_62', ThoriumCreateIntegerValue(K_WORLD_62));
  RegisterConstant('K_WORLD_63', ThoriumCreateIntegerValue(K_WORLD_63));
  RegisterConstant('K_WORLD_64', ThoriumCreateIntegerValue(K_WORLD_64));
  RegisterConstant('K_WORLD_65', ThoriumCreateIntegerValue(K_WORLD_65));
  RegisterConstant('K_WORLD_66', ThoriumCreateIntegerValue(K_WORLD_66));
  RegisterConstant('K_WORLD_67', ThoriumCreateIntegerValue(K_WORLD_67));
  RegisterConstant('K_WORLD_68', ThoriumCreateIntegerValue(K_WORLD_68));
  RegisterConstant('K_WORLD_69', ThoriumCreateIntegerValue(K_WORLD_69));
  RegisterConstant('K_WORLD_70', ThoriumCreateIntegerValue(K_WORLD_70));
  RegisterConstant('K_WORLD_71', ThoriumCreateIntegerValue(K_WORLD_71));
  RegisterConstant('K_WORLD_72', ThoriumCreateIntegerValue(K_WORLD_72));
  RegisterConstant('K_WORLD_73', ThoriumCreateIntegerValue(K_WORLD_73));
  RegisterConstant('K_WORLD_74', ThoriumCreateIntegerValue(K_WORLD_74));
  RegisterConstant('K_WORLD_75', ThoriumCreateIntegerValue(K_WORLD_75));
  RegisterConstant('K_WORLD_76', ThoriumCreateIntegerValue(K_WORLD_76));
  RegisterConstant('K_WORLD_77', ThoriumCreateIntegerValue(K_WORLD_77));
  RegisterConstant('K_WORLD_78', ThoriumCreateIntegerValue(K_WORLD_78));
  RegisterConstant('K_WORLD_79', ThoriumCreateIntegerValue(K_WORLD_79));
  RegisterConstant('K_WORLD_80', ThoriumCreateIntegerValue(K_WORLD_80));
  RegisterConstant('K_WORLD_81', ThoriumCreateIntegerValue(K_WORLD_81));
  RegisterConstant('K_WORLD_82', ThoriumCreateIntegerValue(K_WORLD_82));
  RegisterConstant('K_WORLD_83', ThoriumCreateIntegerValue(K_WORLD_83));
  RegisterConstant('K_WORLD_84', ThoriumCreateIntegerValue(K_WORLD_84));
  RegisterConstant('K_WORLD_85', ThoriumCreateIntegerValue(K_WORLD_85));
  RegisterConstant('K_WORLD_86', ThoriumCreateIntegerValue(K_WORLD_86));
  RegisterConstant('K_WORLD_87', ThoriumCreateIntegerValue(K_WORLD_87));
  RegisterConstant('K_WORLD_88', ThoriumCreateIntegerValue(K_WORLD_88));
  RegisterConstant('K_WORLD_89', ThoriumCreateIntegerValue(K_WORLD_89));
  RegisterConstant('K_WORLD_90', ThoriumCreateIntegerValue(K_WORLD_90));
  RegisterConstant('K_WORLD_91', ThoriumCreateIntegerValue(K_WORLD_91));
  RegisterConstant('K_WORLD_92', ThoriumCreateIntegerValue(K_WORLD_92));
  RegisterConstant('K_WORLD_93', ThoriumCreateIntegerValue(K_WORLD_93));
  RegisterConstant('K_WORLD_94', ThoriumCreateIntegerValue(K_WORLD_94));
  RegisterConstant('K_WORLD_95', ThoriumCreateIntegerValue(K_WORLD_95));
  RegisterConstant('K_KP0', ThoriumCreateIntegerValue(K_KP0));
  RegisterConstant('K_KP1', ThoriumCreateIntegerValue(K_KP1));
  RegisterConstant('K_KP2', ThoriumCreateIntegerValue(K_KP2));
  RegisterConstant('K_KP3', ThoriumCreateIntegerValue(K_KP3));
  RegisterConstant('K_KP4', ThoriumCreateIntegerValue(K_KP4));
  RegisterConstant('K_KP5', ThoriumCreateIntegerValue(K_KP5));
  RegisterConstant('K_KP6', ThoriumCreateIntegerValue(K_KP6));
  RegisterConstant('K_KP7', ThoriumCreateIntegerValue(K_KP7));
  RegisterConstant('K_KP8', ThoriumCreateIntegerValue(K_KP8));
  RegisterConstant('K_KP9', ThoriumCreateIntegerValue(K_KP9));
  RegisterConstant('K_KP_PERIOD', ThoriumCreateIntegerValue(K_KP_PERIOD));
  RegisterConstant('K_KP_DIVIDE', ThoriumCreateIntegerValue(K_KP_DIVIDE));
  RegisterConstant('K_KP_MULTIPLY', ThoriumCreateIntegerValue(K_KP_MULTIPLY));
  RegisterConstant('K_KP_MINUS', ThoriumCreateIntegerValue(K_KP_MINUS));
  RegisterConstant('K_KP_PLUS', ThoriumCreateIntegerValue(K_KP_PLUS));
  RegisterConstant('K_KP_ENTER', ThoriumCreateIntegerValue(K_KP_ENTER));
  RegisterConstant('K_KP_EQUALS', ThoriumCreateIntegerValue(K_KP_EQUALS));
  RegisterConstant('K_UP', ThoriumCreateIntegerValue(K_UP));
  RegisterConstant('K_DOWN', ThoriumCreateIntegerValue(K_DOWN));
  RegisterConstant('K_RIGHT', ThoriumCreateIntegerValue(K_RIGHT));
  RegisterConstant('K_LEFT', ThoriumCreateIntegerValue(K_LEFT));
  RegisterConstant('K_INSERT', ThoriumCreateIntegerValue(K_INSERT));
  RegisterConstant('K_HOME', ThoriumCreateIntegerValue(K_HOME));
  RegisterConstant('K_END', ThoriumCreateIntegerValue(K_END));
  RegisterConstant('K_PAGEUP', ThoriumCreateIntegerValue(K_PAGEUP));
  RegisterConstant('K_PAGEDOWN', ThoriumCreateIntegerValue(K_PAGEDOWN));
  RegisterConstant('K_F1', ThoriumCreateIntegerValue(K_F1));
  RegisterConstant('K_F2', ThoriumCreateIntegerValue(K_F2));
  RegisterConstant('K_F3', ThoriumCreateIntegerValue(K_F3));
  RegisterConstant('K_F4', ThoriumCreateIntegerValue(K_F4));
  RegisterConstant('K_F5', ThoriumCreateIntegerValue(K_F5));
  RegisterConstant('K_F6', ThoriumCreateIntegerValue(K_F6));
  RegisterConstant('K_F7', ThoriumCreateIntegerValue(K_F7));
  RegisterConstant('K_F8', ThoriumCreateIntegerValue(K_F8));
  RegisterConstant('K_F9', ThoriumCreateIntegerValue(K_F9));
  RegisterConstant('K_F10', ThoriumCreateIntegerValue(K_F10));
  RegisterConstant('K_F11', ThoriumCreateIntegerValue(K_F11));
  RegisterConstant('K_F12', ThoriumCreateIntegerValue(K_F12));
  RegisterConstant('K_F13', ThoriumCreateIntegerValue(K_F13));
  RegisterConstant('K_F14', ThoriumCreateIntegerValue(K_F14));
  RegisterConstant('K_F15', ThoriumCreateIntegerValue(K_F15));
  RegisterConstant('K_NUMLOCK', ThoriumCreateIntegerValue(K_NUMLOCK));
  RegisterConstant('K_CAPSLOCK', ThoriumCreateIntegerValue(K_CAPSLOCK));
  RegisterConstant('K_SCROLLOCK', ThoriumCreateIntegerValue(K_SCROLLOCK));
  RegisterConstant('K_RSHIFT', ThoriumCreateIntegerValue(K_RSHIFT));
  RegisterConstant('K_RCTRL', ThoriumCreateIntegerValue(K_RCTRL));
  RegisterConstant('K_LCTRL', ThoriumCreateIntegerValue(K_LCTRL));
  RegisterConstant('K_RALT', ThoriumCreateIntegerValue(K_RALT));
  RegisterConstant('K_LALT', ThoriumCreateIntegerValue(K_LALT));
  RegisterConstant('K_RMETA', ThoriumCreateIntegerValue(K_RMETA));
  RegisterConstant('K_LMETA', ThoriumCreateIntegerValue(K_LMETA));
  RegisterConstant('K_LSUPER', ThoriumCreateIntegerValue(K_LSUPER));
  RegisterConstant('K_RSUPER', ThoriumCreateIntegerValue(K_RSUPER));
  RegisterConstant('K_MODE', ThoriumCreateIntegerValue(K_MODE));
  RegisterConstant('K_COMPOSE', ThoriumCreateIntegerValue(K_COMPOSE));
  RegisterConstant('K_HELP', ThoriumCreateIntegerValue(K_HELP));
  RegisterConstant('K_PRINT', ThoriumCreateIntegerValue(K_PRINT));
  RegisterConstant('K_SYSREQ', ThoriumCreateIntegerValue(K_SYSREQ));
  RegisterConstant('K_BREAK', ThoriumCreateIntegerValue(K_BREAK));
  RegisterConstant('K_MENU', ThoriumCreateIntegerValue(K_MENU));
  RegisterConstant('K_POWER', ThoriumCreateIntegerValue(K_POWER));
  RegisterConstant('K_EURO', ThoriumCreateIntegerValue(K_EURO));

  RegisterConstant('BUTTON_LEFT', ThoriumCreateIntegerValue(BUTTON_LEFT));
  RegisterConstant('BUTTON_MIDDLE', ThoriumCreateIntegerValue(BUTTON_MIDDLE));
  RegisterConstant('BUTTON_RIGHT', ThoriumCreateIntegerValue(BUTTON_RIGHT));
  RegisterConstant('BUTTON_WHEELUP', ThoriumCreateIntegerValue(BUTTON_WHEELUP));
  RegisterConstant('BUTTON_WHEELDOWN', ThoriumCreateIntegerValue(BUTTON_WHEELDOWN));

  // Register functions



  // Register classes

  // Basic classes
  RegisterRTTIType(elPoint, False);
  RegisterRTTIType(elfPoint, False);
  RegisterRTTIType(elVector, False);
  RegisterRTTIType(elColor, False);

  // Helper classes
  RegisterRTTIType(TMouseLayer, False);
  RegisterRTTIType(TKeyboardLayer, False);

  // Engine-specific classes
  RegisterRTTIType(elSprite, False);
  RegisterRTTIType(elTimer, False);
  RegisterRTTIType(elTrueTypeFont, False);
  RegisterRTTIType(elMusic, False);
  RegisterRTTIType(elSound, False);


  // Library Properties

  AppLayer := TAppLayer.Create;
  InputLayer := TInputLayer.Create;

  AppObject := RegisterRTTIType(TAppLayer, False);

  TypeSpecApp.ValueType := vtExtendedType;
  TypeSpecApp.Extended := AppObject;
  ValueApp := ThoriumCreateExtendedTypeValue(AppObject);

  ValueApp.Extended.Value := AppLayer;
  RegisterPropertyDirect('application', TypeSpecApp, True).Value := ThoriumDuplicateValue(ValueApp);

  InputObject := RegisterRTTIType(TInputLayer, False);

  TypeSpecInput.ValueType := vtExtendedType;
  TypeSpecInput.Extended := InputObject;
  ValueInput := ThoriumCreateExtendedTypeValue(InputObject);

  ValueInput.Extended.Value := InputLayer;
  RegisterPropertyDirect('input', TypeSpecInput, True).Value := ThoriumDuplicateValue(ValueInput);

end;


class function TLibElysionKronos.GetName: String;
begin
  Result := 'elysion.kronos';
end;


end.

