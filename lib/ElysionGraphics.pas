unit ElysionGraphics;

interface

{$I Elysion.inc}

uses
  ElysionUtils,
  ElysionObject,
  ElysionApplication,
  ElysionTypes,
  ElysionColors,
  ElysionInput,
  ElysionTimer,
  ElysionNode,
  ElysionTextures,
  ElysionContent,
  ElysionLogger,

  {$IFDEF USE_DGL_HEADER}
  dglOpenGL,
  {$ELSE}
  gl, glu, glext,
  {$ENDIF}
  SDL,
  SDLUtils,
  //SDLTextures,

  SysUtils,
  Classes;

type
  TelFrameAnimation = class(TelObject)
    private
      fMaxFrames, fFrame: Integer;
      fTimer: TelTimer;

      function GetInterval(): Integer; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure SetInterval(Value: Integer); {$IFDEF CAN_INLINE} inline; {$ENDIF}
    public
      constructor Create; Override;
      destructor Destroy; Override;

      procedure Start(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure Stop(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure Pause(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure UnPause(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
    published
      property Frame: Integer read fFrame write fFrame;

      property Interval: Integer read GetInterval write SetInterval;

      property MaxFrames: Integer read fMaxFrames write fMaxFrames;
  end;

  TelSprite = class(TelNode)
    private
      fAnimation: TelFrameAnimation;
      fHyperLink: String;
      fTexture: TelTexture;
      fClipRect: TelRect;
      fBlendMode: TelBlendMode;

      function GetFilename(): String; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      function GetTransparent(): Boolean; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure SetTransparent(Value: Boolean); {$IFDEF CAN_INLINE} inline; {$ENDIF}

      function GetOnMouseOverPixel(): Boolean; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      function GetOnClickPixel(): Boolean; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      function GetTextureWidth(): Integer; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      function GetTextureHeight(): Integer; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      function GetAspectRatio(): Single; {$IFDEF CAN_INLINE} inline; {$ENDIF}
    protected
      function GetWidth(): Integer; Override;
      function GetHeight(): Integer; Override;

      function GetOnMouseOver(): Boolean; Override;
      function GetOnClick(): Boolean; Override;
    public
      constructor Create; Override;
      destructor Destroy; Override;

      function LoadFromFile(aFilename: String): Boolean; Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      function LoadFromFile(aFilename: String; aClipRect: TelRect): Boolean; Overload;

      procedure LoadFromTexture(aTexture: TelTexture); {$IFDEF CAN_INLINE} inline; {$ENDIF}

      procedure LoadFromStream(aStream: TStream); {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure SaveToStream(aStream: TStream); {$IFDEF CAN_INLINE} inline; {$ENDIF}

      procedure ClipImage(aRect: TelRect);

      procedure SetColorKey(aColor: TelColor); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure SetColorKey(aPoint: TelVector2i); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      function OnPoint(Coord: TelVector2f): Boolean;

      procedure Move(aPoint: TelVector2f); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure Move(aPoint: TelVector2i); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure Move(aPoint: TelVector3f); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      procedure Draw; Override;
      procedure Update(dt: Double = 0.0); Override;

      property ClipRect: TelRect read fClipRect; // Use ClipImage to set ClipRect
    published
      property AspectRatio: Single read GetAspectRatio;
      property Animation: TelFrameAnimation read fAnimation write fAnimation;

      property BlendMode: TelBlendMode read fBlendMode write fBlendMode;

      property OnMouseOverPixel: Boolean read GetOnMouseOverPixel;
      property OnClickPixel: Boolean read GetOnClickPixel;

      property Filename: String read GetFilename;

      property HyperLink: String read fHyperLink write fHyperLink;

      property Texture: TelTexture read fTexture write fTexture;
      property TextureWidth: Integer read GetTextureWidth;
      property TextureHeight: Integer read GetTextureHeight;

      property Transparent: Boolean read GetTransparent write SetTransparent;

      property Width: Integer read GetWidth;
      property Height: Integer read GetHeight;
  end;

  (*TelSprite = class(TelObject)
  private
    fFilename: String; // Stores filename private
	fGenerated, fCloned, fError: Boolean;

    fLoaded: Boolean;
    fNull: Boolean;

    FTransparent: Boolean;

    fImageType: String;

    FOriginalSize: TelVector2i;

    FFrame, FMaxFrames: Integer;
    FAnim: TelRect;
    FVisible: Boolean;

    FRect: TelRect;
    FClipRect: TelRect;
    FAlpha: Byte;

	procedure SetFrame(Frame: Integer);
    function GetFrame: Integer;

	function OnPoint(Coord: TelVector2i): Boolean;

	procedure SetWidth(Width: Integer);
    function GetWidth: Integer;
    procedure SetHeight(Height: Integer);
    function GetHeight: Integer;
    function GetSurfaceHeight: Integer; // read-only
    function GetSurfaceWidth: Integer; // read-only

    procedure SetAutoTransparency(Value: Boolean);
  public
    Offset: TelImageOffset;
	Rotation: TelImageRotation;

	Scale: TelVector2f;
	Position: TelVector3i;
	Color: TelColor;

	SDL_Surface: PSDL_Surface;
	Texture: GLuInt;

    constructor Create; Override;
    destructor Destroy; Override;

    function LoadFromFile(Filename: String): Boolean; Overload;
    function LoadFromFile(Filename: String; ClipRect: TelRect): Boolean; Overload;

	procedure LoadFromStream(Stream: TStream);
	procedure SaveToStream(Stream: TStream);

	procedure VirtualClone(FromSprite: TelSprite);

	procedure Generate(GenerateMode: TGenerateMode = gmAuto);

	{

  }

    function GetImageType: String;

    procedure ClipImage(Rect: TelRect);
    function GetClipRect: TelRect;
	function GetRect: TelRect;

    procedure Move(Coord: TelVector2i); Overload;
    procedure Move(Coord: TelVector3i); Overload;

    function GetMaxFrames: Integer;

    procedure SetTransparency(aColor: TelColor); Overload;
    procedure SetTransparency(aCoord: TelVector2i); Overload;

    procedure Draw;
    //procedure Draw(TargetSprite: TelSprite); Overload;
	//procedure Draw(Target: PSDL_Surface); Overload;

    procedure Animate(aTimer: TelTimer; Loop: Boolean = true); Overload;
	procedure Animate(var Counter: Integer; Loop: Boolean = true); Overload;

    function OnMouseOver: Boolean;
    function OnMouseOverPixel: Boolean;

    function OnClick: Boolean;

  published
    property Alpha: Byte read fAlpha write fAlpha;

    property SurfaceWidth: Integer read GetSurfaceWidth;
	property SurfaceHeight: Integer read GetSurfaceHeight;
	property Width: Integer read GetWidth write SetWidth;
	property Height: Integer read GetHeight write SetHeight;

	property Filename: String read fFilename;

	property Frame: Integer read GetFrame write SetFrame;

	property Transparent: Boolean read FTransparent write SetAutoTransparency;

	property Visible: Boolean read fVisible write fVisible;

    property Null: Boolean read fNull write fNull;


	property Generated: Boolean read fGenerated;
	property Cloned: Boolean read fCloned;
	property Error: Boolean read fError;
end;    *)

TelSpriteList = class(TelObject)
  private
    FSpriteList: TList;
	Head: String[13];

    function Get(Index: Integer): TelSprite;
	function GetPos(Index: String): Integer;
    procedure Put(Index: Integer; const Item: TelSprite);
	procedure PutS(Index: String; const Item: TelSprite);
    function GetS(Index: String): TelSprite;
    function GetCount: integer;
  public
    constructor Create; Override;
	destructor Destroy; Override;

	procedure Insert(Index: Integer; Sprite: TelSprite);
    function  Add(Sprite: TelSprite): Integer;
    procedure Delete(Index: Integer);
    procedure LoadFromStream(Stream : TFileStream);
    procedure SaveToStream(Stream : TFileStream);

    procedure LoadFromFile(Filename: String);
	procedure SaveToFile(Filename: String);

	property Items[Index: Integer]: TelSprite read Get write Put; default;
	property Find[Index: String]: TelSprite read GetS write PutS;
  published
    property Count: Integer read GetCount;
end;

TelLight = class(TelSprite)
  public
    constructor Create; Override;
    destructor Destroy; Override;
end;

TelParticle = class(TelSprite)
  protected
    fTimer: TelTimer;
    fVelocity: Single;

    fStartPoint, fEndPoint: TelVector3f;

    fDead: Boolean;
    fLife, fMaxLife: Integer;

    procedure SetLife(Value: Integer);
  public
    constructor Create; Override;
    destructor Destroy; Override;

    procedure Draw; Override;
    procedure Update(dt: Double = 0.0); Override;

    procedure Start(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
    procedure Pause(); {$IFDEF CAN_INLINE} inline; {$ENDIF}
    procedure Stop(); {$IFDEF CAN_INLINE} inline; {$ENDIF}

    property StartPoint: TelVector3f read fStartPoint write fStartPoint;
    property EndPoint: TelVector3f read fEndPoint write fEndPoint;

    property Velocity: Single read fVelocity write fVelocity;
  published
    property Dead: Boolean read fDead write fDead;

    property Life: Integer read fLife write SetLife;

end;

TelParticleEmitter = class
  protected
    fLoop, fIsActive, fIsPaused: Boolean;
  public

  published
    property Loop: Boolean read fLoop write fLoop;

    property IsActive: Boolean read fIsActive;
    property IsPaused: Boolean read fIsPaused;
end;

TelCamera = class(TelNode)
    private
      fWidth, fHeight: Integer;
    public

        constructor Create;

        //procedure Draw; Override;
        //procedure Update; Override;

	published

    //property ViewPort: TelRect read GetViewPort write SetViewPort;
      property Width: Integer read fWidth write fWidth;
      property Height: Integer read fHeight write fHeight;

end;

  function convCol(S: TelWindow; Color: TelColor): Cardinal; Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
  function convCol(S: TelWindow; R, G, B: Byte): Cardinal; Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
  function convCol(Color: TelColor): TSDL_Color; Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
  //function convCol(Color: TelColor): Cardinal; Overload;
  function convCol(R, G, B: Byte): Cardinal; Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}

  procedure DrawQuad(pX, pY, pW, pH, pZ: Single); Overload;
  procedure DrawQuad(pX, pY, pW, pH, pZ: Single; Vertices: TColorVertices); Overload;
  procedure DrawQuad(OrgX, OrgY, ClipX, ClipY, ClipW, ClipH, DrawX, DrawY, DrawW, DrawH, Z: Single); Overload;

  procedure DrawLine(Src, Dst: TelVector2i; Color: TelColor); Overload;
  procedure DrawLine(Points: array of TelVector2i; Color: TelColor); Overload;

  function CollisionTest(RectOne, RectTwo: TelRect): Boolean; Overload;
  function CollisionTest(SpriteOne, SpriteTwo: TelSprite): Boolean; Overload;
  function PixelTest(SpriteOne, SpriteTwo: TelSprite): Boolean; Overload;
  function PixelTest(Sprite: TelSprite; Rect: TelRect): Boolean; Overload;



implementation

// deprecated, please use function convCol(Color: TelColor): Cardinal; instead
function convCol(S: TelWindow; Color: TelColor): Cardinal; Overload;
begin
  Result := SDL_MapRGB(S.SDL_Surface^.Format, Color.R, Color.G, Color.B);
end;

// deprecated, please use function convCol(R, G, B: Byte): Cardinal; instead
function convCol(S: TelWindow; R, G, B: Byte): Cardinal; Overload;
begin
  Result := SDL_MapRGB(S.SDL_Surface^.Format, R, G, B);
end;

//function convCol(Color: TelColor): Cardinal; Overload;
//begin
//  Result := SDL_MapRGB(Surface.SDL_Surface.Format, Color.R, Color.G, Color.B);
//end;

function convCol(R, G, B: Byte): Cardinal; Overload;
begin
  Result := SDL_MapRGB(ActiveWindow.SDL_Surface^.Format, R, G, B);
end;

function convCol(Color: TelColor): TSDL_Color; Overload;
begin
  Result.r := Color.R;
  Result.g := Color.G;
  Result.b := Color.B;
  Result.unused := 0;
end;

// TODO: Use VBOs instead of glBegin/glEnd calls
procedure DrawQuad(pX, pY, pW, pH, pZ: Single);
begin
  glBegin(GL_QUADS);
    glTexCoord2f(1, 0); glVertex3f(pX + pW, pY, -pZ);
    glTexCoord2f(0, 0); glVertex3f(pX	  , pY, -pZ);
    glTexCoord2f(0, 1); glVertex3f(pX	  , pY + pH, -pZ);
    glTexCoord2f(1, 1); glVertex3f(pX + pW, pY + pH, -pZ);
  glEnd();
end;

procedure DrawQuad(pX, pY, pW, pH, pZ: Single; Vertices: TColorVertices);
begin
  glBegin(GL_QUADS);
    glColor4f(Vertices[0].R / 255, Vertices[0].G / 255, Vertices[0].B / 255, Vertices[0].A / 255); glTexCoord2f(1, 0); glVertex3f(pX + pW, pY, -pZ);
    glColor4f(Vertices[1].R / 255, Vertices[1].G / 255, Vertices[1].B / 255, Vertices[1].A / 255); glTexCoord2f(0, 0); glVertex3f(pX	  , pY, -pZ);
    glColor4f(Vertices[2].R / 255, Vertices[2].G / 255, Vertices[2].B / 255, Vertices[2].A / 255); glTexCoord2f(0, 1); glVertex3f(pX	  , pY + pH, -pZ);
    glColor4f(Vertices[3].R / 255, Vertices[3].G / 255, Vertices[3].B / 255, Vertices[3].A / 255); glTexCoord2f(1, 1); glVertex3f(pX + pW, pY + pH, -pZ);
  glEnd();
end;

procedure DrawQuad(OrgX, OrgY, ClipX, ClipY, ClipW, ClipH, DrawX, DrawY, DrawW, DrawH, Z: Single);
//var tposx, tposy, row, col: single;
var tposx, tposy, tposw, tposh: Single;
begin
  if (OrgX > 0) and (OrgY > 0) then
  begin
    if ClipX > 0 then tposx := ClipX / OrgX else tposx := 0;
    if ClipY > 0 then tposy := ClipY / OrgY else tposy := 0;

    tposw := ClipW / OrgX;
    tposh := ClipH / OrgY;
  end;

  {row := OriginalSize.X / ClipRect.W;
  col := OriginalSize.Y / ClipRect.H;

  tposx := OriginalSize.X / ClipRect.X;
  tposy := OriginalSize.Y / ClipRect.Y;}

  // Use VBOs if OpenGL >= 1.5, else glBegin/glEnd

  {$IFDEF USE_DGL_HEADER}
  if (GL_VERSION_1_5) then
  {$ELSE}
  if (Load_GL_version_2_0) then
  {$ENDIF}
  begin

  end else
  begin

  end;

  glBegin(GL_QUADS);
    glTexCoord2f(0 + tposx		  , 0 + tposy); 		glVertex3f(DrawX, DrawY, -Z);
    glTexCoord2f(0 + tposx		  , 0 + tposy + tposh); glVertex3f(DrawX, DrawY + DrawH, -Z);
    glTexCoord2f(0 + tposx + tposw, 0 + tposy + tposh); glVertex3f(DrawX + DrawW, DrawY + DrawH, -Z);
    glTexCoord2f(0 + tposx + tposw, 0 + tposy); 		glVertex3f(DrawX + DrawW, DrawY, -Z);
  glEnd;

  {glBegin(GL_QUADS);
    glTexCoord2f(0+1/tposx+1/row, 1-1/tposy);       glTexCoord2f(1, 0); glVertex3f(DrawRect.X + DrawRect.W, DrawRect.Y, -Z);
    glTexCoord2f(0+1/tposx      , 1-1/tposy);       glTexCoord2f(0 + tposx, 0 + tposy); glVertex3f(DrawRect.X, DrawRect.Y, -Z);
    glTexCoord2f(0+1/tposx      , 1-1/tposy-1/col); glTexCoord2f(0, 1); glVertex3f(DrawRect.X, DrawRect.Y + DrawRect.H, -Z);
    glTexCoord2f(0+1/tposx+1/row, 1-1/tposy-1/col); glTexCoord2f(1, 1); glVertex3f(DrawRect.X + DrawRect.W, DrawRect.Y + DrawRect.H, -Z);
  glEnd;}
end;



procedure DrawLine(Src, Dst: TelVector2i; Color: TelColor);
begin
  glColor3f(Color.R / 255, Color.G / 255, Color.B / 255);

  // GL_LINE_STRIP instead of GL_LINES -> http://wiki.delphigl.com/index.php/glBegin
  glBegin(GL_LINE_STRIP);
    glVertex3f(Src.X * ActiveWindow.ResScale.X, Src.Y * ActiveWindow.ResScale.Y, 0);
    glVertex3f(Dst.X * ActiveWindow.ResScale.X, Dst.Y * ActiveWindow.ResScale.Y, 0);
  glEnd;
end;

procedure DrawLine(Points: array of TelVector2i; Color: TelColor);
var
  i: Integer;
begin
  glColor3f(Color.R / 255, Color.G / 255, Color.B / 255);

  // GL_LINE_STRIP instead of GL_LINES -> http://wiki.delphigl.com/index.php/glBegin
  glBegin(GL_LINE_STRIP);
    for i := 0 to High(Points) - 1 do
    begin
      glVertex3f(Points[i].X * ActiveWindow.ResScale.X, Points[i].Y * ActiveWindow.ResScale.Y, 0);
      glVertex3f(Points[i+1].X * ActiveWindow.ResScale.X, Points[i+1].Y * ActiveWindow.ResScale.Y, 0);
    end;
  glEnd;
end;

function CollisionTest(RectOne, RectTwo: TelRect): Boolean;

  function OnPoint(Rect: TelRect; Coord: TelVector2f): Boolean;
  begin
    if (Coord.X >= Rect.X) and
       (Coord.Y >= Rect.Y) and
       (Coord.X < (Rect.X + Rect.W)) and
       (Coord.Y < (Rect.Y + Rect.H)) then Result := true else Result := false;
  end;

begin
  Result := False;
  if OnPoint(RectOne, makeV2f(RectTwo.X, RectTwo.Y)) Or
     OnPoint(RectTwo, makeV2f(RectOne.X, RectOne.Y)) Or
     OnPoint(RectOne, makeV2f(RectTwo.X + RectTwo.W, RectTwo.Y)) Or
     OnPoint(RectTwo, makeV2f(RectOne.X + RectOne.W, RectOne.Y)) Or
     OnPoint(RectOne, makeV2f(RectTwo.X,                   RectTwo.Y + RectTwo.H)) Or
     OnPoint(RectTwo, makeV2f(RectOne.X,                   RectOne.Y + RectOne.H)) Or
     OnPoint(RectOne, makeV2f(RectTwo.X + RectTwo.W, RectTwo.Y + RectTwo.H)) Or
     OnPoint(RectTwo, makeV2f(RectOne.X + RectOne.W, RectOne.Y + RectOne.H)) Then Result := True;
end;

function CollisionTest(SpriteOne, SpriteTwo: TelSprite): Boolean;
begin
  Result := False;
  if ((SpriteOne.Visible) and (SpriteTwo.Visible)) then
  begin
    If SpriteOne.OnPoint(makeV2f(SpriteTwo.Position.X, SpriteTwo.Position.Y)) Or
       SpriteTwo.OnPoint(makeV2f(SpriteOne.Position.X, SpriteOne.Position.Y)) Or
       SpriteOne.OnPoint(makeV2f(SpriteTwo.Position.X + SpriteTwo.Width, SpriteTwo.Position.Y)) Or
       SpriteTwo.OnPoint(makeV2f(SpriteOne.Position.X + SpriteOne.Width, SpriteOne.Position.Y)) Or
       SpriteOne.OnPoint(makeV2f(SpriteTwo.Position.X,                   SpriteTwo.Position.Y + SpriteTwo.Height)) Or
       SpriteTwo.OnPoint(makeV2f(SpriteOne.Position.X,                   SpriteOne.Position.Y + SpriteOne.Height)) Or
       SpriteOne.OnPoint(makeV2f(SpriteTwo.Position.X + SpriteTwo.Width, SpriteTwo.Position.Y + SpriteTwo.Height)) Or
       SpriteTwo.OnPoint(makeV2f(SpriteOne.Position.X + SpriteOne.Width, SpriteOne.Position.Y + SpriteOne.Height)) Then Result := True;
  end;
end;

function PixelTest(SpriteOne, SpriteTwo: TelSprite): Boolean;
var
  SpriteOneRect, SpriteTwoRect: TSDL_Rect;
begin
  Result := false;
  if ((SpriteOne.Visible) and (SpriteTwo.Visible)) then
  begin
    if (not SpriteOne.Transparent) then SpriteOne.Transparent := true;
    if (not SpriteTwo.Transparent) then SpriteTwo.Transparent := true;

    SpriteOneRect.x := Trunc(SpriteOne.ClipRect.X);
	SpriteOneRect.y := Trunc(SpriteOne.ClipRect.Y);
	SpriteOneRect.w := Trunc(SpriteOne.ClipRect.W);
	SpriteOneRect.h := Trunc(SpriteOne.ClipRect.H);

	SpriteTwoRect.x := Trunc(SpriteTwo.ClipRect.X);
	SpriteTwoRect.y := Trunc(SpriteTwo.ClipRect.Y);
	SpriteTwoRect.w := Trunc(SpriteTwo.ClipRect.W);
	SpriteTwoRect.h := Trunc(SpriteTwo.ClipRect.H);

    if SDL_PixelTest(SpriteOne.Texture.TextureSurface, @SpriteOneRect,
					 SpriteTwo.Texture.TextureSurface, @SpriteTwoRect,
					 Trunc(SpriteOne.Position.X), Trunc(SpriteOne.Position.Y), Trunc(SpriteTwo.Position.X), Trunc(SpriteTwo.Position.Y)) then Result := true;
  end;
end;

function PixelTest(Sprite: TelSprite; Rect: TelRect): Boolean;
var
  SpriteRect, CRect: TSDL_Rect;
begin
  Result := false;

  if (Sprite.Visible) then
  begin
    if (not Sprite.Transparent) then Sprite.Transparent := true;

    SpriteRect.x := Trunc(Sprite.ClipRect.X);
    SpriteRect.y := Trunc(Sprite.ClipRect.Y);
    SpriteRect.w := Trunc(Sprite.ClipRect.W);
    SpriteRect.h := Trunc(Sprite.ClipRect.H);

    CRect.x := Trunc(Rect.X);
    CRect.y := Trunc(Rect.Y);
    CRect.w := Trunc(Rect.W);
    CRect.h := Trunc(Rect.H);

    if SDL_PixelTestSurfaceVsRect(Sprite.Texture.TextureSurface, @SpriteRect, @CRect, Trunc(Sprite.Position.X), Trunc(Sprite.Position.Y), Trunc(Rect.X), Trunc(Rect.Y)) then Result := true;
  end;
end;

constructor TelFrameAnimation.Create;
begin
  inherited;

  fTimer := TelTimer.Create;
  fFrame := -1;
end;

destructor TelFrameAnimation.Destroy;
begin
  fTimer.Destroy;

  inherited;
end;

function TelFrameAnimation.GetInterval(): Integer; 
begin
  Result := fTimer.Interval;
end;

procedure TelFrameAnimation.SetInterval(Value: Integer); 
begin
  fTimer.Interval := Value;
end;

procedure TelFrameAnimation.Start(); 
begin
  fTimer.Start();
end;

procedure TelFrameAnimation.Stop(); 
begin
  fTimer.Stop();
end;

procedure TelFrameAnimation.Pause(); 
begin
  fTimer.Pause();
end;

procedure TelFrameAnimation.UnPause(); 
begin
  fTimer.UnPause();
end;

constructor TelSprite.Create;
begin
  inherited;

  Animation := TelFrameAnimation.Create;
  Texture := TelTexture.Create;
  BlendMode := bmNormal;

  //fDrawable := true;

end;

destructor TelSprite.Destroy;
begin
  Animation.Destroy;
  Texture.Destroy;

  inherited;
end;

function TelSprite.GetFilename(): String; 
begin
  Result := Texture.Filename;
end;

function TelSprite.GetTransparent(): Boolean; 
begin
  Result := Texture.Transparent;
end;

procedure TelSprite.SetTransparent(Value: Boolean); 
begin
  Texture.Transparent := Value;
end;

function TelSprite.GetOnMouseOver(): Boolean; 
begin
  {$IFDEF CAN_METHODS}
  Result := fClipRect.ContainsVector(ActiveWindow.Cursor);
  {$ELSE}
  Rect := RectContainsVector(fClipRect, ActiveWindow.Cursor);
  {$ENDIF}
end;

function TelSprite.GetOnClick(): Boolean; 
begin
  if ((OnMouseOver) and (Input.Mouse.LeftClick)) then
    Result := true
  else Result := false;
end;

function TelSprite.GetOnMouseOverPixel(): Boolean; 
begin
  Result := PixelTest(Self, makeRect(ActiveWindow.Cursor.X, ActiveWindow.Cursor.Y, 1, 1));
end;

function TelSprite.GetOnClickPixel(): Boolean; 
begin
  if ((OnMouseOverPixel) and (Input.Mouse.LeftClick)) then Result := true
     else Result := false;
end;

function TelSprite.GetTextureWidth(): Integer; 
begin
  Result := Texture.Width;
end;

function TelSprite.GetTextureHeight(): Integer; 
begin
  Result := Texture.Height;
end;

function TelSprite.GetAspectRatio(): Single;
begin
  Result := Texture.AspectRatio;
end;

function TelSprite.GetWidth(): Integer; 
begin
  Result := Trunc(ClipRect.W);
end;

function TelSprite.GetHeight(): Integer; 
begin
  Result := Trunc(ClipRect.H);
end;

function TelSprite.LoadFromFile(aFilename: String): Boolean; 
begin
  Result := Self.LoadFromFile(aFilename, makeRect(0, 0, -1, -1));
end;

function TelSprite.LoadFromFile(aFilename: String; aClipRect: TelRect): Boolean;
var
  Directory: String;
begin

  if ({(aFilename <> (Directory + Content.RootDirectory + Self.Filename)) and} (aFilename <> '')) then
  begin
    Directory := ExtractFilePath(ParamStr(0));

    if FileExists(Directory + Content.RootDirectory + aFilename) then
    begin

      Self.Texture := TextureManager.CreateNewTexture(Directory + Content.RootDirectory + aFilename);



      if aClipRect.X < 0 then aClipRect.X := 0;
      if aClipRect.Y < 0 then aClipRect.Y := 0;
      if aClipRect.W <= 0 then aClipRect.W := TextureWidth;
      if aClipRect.H <= 0 then aClipRect.H := TextureHeight;

      // TODO: Fix the next line
      //Offset.Rotation := makeV2i(Texture.Width div 2, Texture.Height div 2);

      ClipImage(aClipRect);

      //FAnim.W := GetSurfaceWidth div Trunc(FClipRect.W);
      //FAnim.H := GetSurfaceHeight div Trunc(FClipRect.H);

      //FMaxFrames := Trunc(FAnim.W) * Trunc(FAnim.H);

      Result := true;
    end else if isLoggerActive then Self.Log('File not found: ' + Directory + Content.RootDirectory + aFilename);

  end;
end;

procedure TelSprite.LoadFromTexture(aTexture: TelTexture); 
begin
  fTexture := aTexture;
end;

procedure TelSprite.LoadFromStream(aStream: TStream); 
begin
  Texture.LoadFromStream(aStream);
end;

procedure TelSprite.SaveToStream(aStream: TStream); 
begin
  Texture.SaveToStream(aStream);
end;

procedure TelSprite.ClipImage(aRect: TelRect); 
begin
  if (fClipRect.X <> aRect.X) then fClipRect.X := aRect.X;
  if (fClipRect.Y <> aRect.Y) then fClipRect.Y := aRect.Y;

  if (fClipRect.W <> aRect.W) then
  begin
    fClipRect.W := aRect.W;
  end;

  if (fClipRect.H <> aRect.H) then
  begin
    fClipRect.H := aRect.H;
  end;
end;

procedure TelSprite.SetColorKey(aColor: TelColor); 
begin
  Texture.SetColorKey(aColor);
end;

procedure TelSprite.SetColorKey(aPoint: TelVector2i); 
begin
  Texture.SetColorKey(aPoint);
end;

function TelSprite.OnPoint(Coord: TelVector2f): Boolean;
begin
  if (Coord.X >= (Position.X - Offset.Rotation.X - Offset.Position.X) * Scale.X * ActiveWindow.ResScale.X) and
     (Coord.Y >= (Position.Y - Offset.Rotation.Y - Offset.Position.Y) * Scale.Y * ActiveWindow.ResScale.Y) and
     (Coord.X < (Position.X - Offset.Rotation.X - Offset.Position.X + ClipRect.W) * Scale.X * ActiveWindow.ResScale.X) and
     (Coord.Y < (Position.Y - Offset.Rotation.Y - Offset.Position.Y + ClipRect.H) * Scale.Y * ActiveWindow.ResScale.Y) then Result := true else Result := false;
end;

procedure TelSprite.Move(aPoint: TelVector2f); 
begin
  Position.Add(makeV3f(aPoint.X, aPoint.Y, 0.0));
end;

procedure TelSprite.Move(aPoint: TelVector2i); 
begin
  Position.Add(makeV3f(aPoint.X, aPoint.Y, 0.0));
end;

procedure TelSprite.Move(aPoint: TelVector3f);
begin
  Position.Add(aPoint);
end;

procedure TelSprite.Draw;
var
  IsTexture: Boolean;
begin
  IsTexture := False;

  {$IFNDEF USE_DGL_HEADER}
    if glIsTexture(Self.Texture.TextureID) = GL_TRUE then IsTexture := true;
  {$ELSE}
    IsTexture := glIsTexture(Self.Texture.TextureID);
  {$ENDIF}

  if ((Visible) and (IsTexture)) then
  begin
    glColor4f(1.0, 1.0, 1.0, 1.0);
    glEnable(GL_TEXTURE_2D);

    glPushMatrix;
      glColor3f(1, 1, 1);
      glBindTexture(GL_TEXTURE_2D, Self.Texture.TextureID);
      if Transparent then
      begin
        glEnable(GL_ALPHA_TEST);
        glAlphaFunc(GL_GREATER, 0.1);
      end;

  	glTranslatef((Position.X - Offset.Position.X + Offset.Rotation.X) * ActiveWindow.ResScale.X,
                     (Position.Y - Offset.Position.Y + Offset.Rotation.Y) * ActiveWindow.ResScale.Y, 0);
  	if Abs(Rotation.Angle) >= 360.0 then Rotation.Angle := 0.0;

  	if Rotation.Angle <> 0.0 then glRotatef(Rotation.Angle, Rotation.Vector.X, Rotation.Vector.Y, Rotation.Vector.Z);

      case BlendMode of
        bmAdd: glBlendFunc(GL_ONE, GL_ONE);
        bmNormal: glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        bmSub: glBlendFunc(GL_ZERO, GL_ZERO);
      end;
      glEnable(GL_BLEND);

  	glColor4f(Color.R / 255, Color.G / 255, Color.B / 255, Alpha / 255);
  	glScalef(Scale.X * ActiveWindow.ResScale.X, Scale.Y * ActiveWindow.ResScale.Y, 1);
        DrawQuad(Texture.Width, Texture.Height,
                 fClipRect.X, fClipRect.Y, fClipRect.W, fClipRect.H,
                 -Offset.Rotation.X, -Offset.Rotation.Y, Self.Width, Self.Height,
                 Position.Z);
      //DrawQuad(TelVector2i.Create(TextureWidth, TextureHeight), FClipRect, TelRect.Create(-Offset.Rotation.X, -Offset.Rotation.Y, Width, Height), Position.Z);

      //DrawQuad(200, 200, 200, 200, 0);

      glDisable(GL_BLEND);
      if Transparent then glDisable(GL_ALPHA_TEST);
    glPopMatrix;

    glBindTexture(GL_TEXTURE_2D, 0);

    glDisable(GL_TEXTURE_2D);
  end;
end;

procedure TelSprite.Update(dt: Double = 0.0);
begin
  inherited;

  if (HyperLink <> '') and GetOnClick then OpenURL(HyperLink);

  // Add animation update
end;

(*constructor TelSprite.Create;
begin
  inherited Create;

  fLoaded := false;
  fNull := true;
  fFilename := '';

  FClipRect.X := 0;
  FClipRect.Y := 0;
  FClipRect.W := 0;
  FClipRect.H := 0;

  FRect.X := 0;
  FRect.Y := 0;
  FRect.W := 0;
  FRect.H := 0;

  FAlpha := 255;
  FFrame := 0;
  FVisible := true;

  Scale := makeP2D(1.0, 1.0);

  Color := makeCol(255, 255, 255);

  fGenerated := false;
  fCloned := false;
  fError := false;

  Rotation.Angle := 0.0;
  Rotation.Vector := makeP3D(0.0, 0.0, 1.0);

  Offset.Rotation := makeP2D(0, 0);
  Offset.Position := makeP2D(0, 0);
end;

destructor TelSprite.Destroy;
begin
  if SDL_Surface <> Nil then
  begin
    SDL_FreeSurface(SDL_Surface);
    glDeleteTextures(1, @Texture);
  end;

  inherited Destroy;
end;

function TelSprite.LoadFromFile(Filename: String): Boolean;
begin
  Result := LoadFromFile(Filename, makeRect(0, 0, -1, -1));
end;

function TelSprite.LoadFromFile(Filename: String; ClipRect: TelRect): Boolean;
var Directory: String;
    tmp_ClipRect: TelRect;
begin
  Result := false;

  FAnim.X := 0;
  FAnim.Y := 0;

  if Filename <> fFilename then
  begin
    fFilename := Filename;
    Directory := ExtractFilePath(ParamStr(0));
    if Filename <> '' then
    begin
	  fImageType := GetFilenameExtension(Filename);

      if FileExists(Directory+Content.RootDirectory+FileName) then
      begin
	    {$IFDEF USE_SDL_IMAGE}
        SDL_Surface := IMG_Load(PChar(Directory+Content.RootDirectory+FileName));
		{$ENDIF}
		{$IFDEF USE_VAMPYRE}
		SDL_Surface := LoadSDLSurfaceFromFile(Directory+Content.RootDirectory+FileName);
		{$ENDIF}

        tmp_ClipRect.X := ClipRect.X;
        tmp_ClipRect.Y := ClipRect.Y;

        if ClipRect.W <= 0 then tmp_ClipRect.W := SDL_Surface^.w else tmp_ClipRect.W := ClipRect.W;
        if ClipRect.H <= 0 then tmp_ClipRect.H := SDL_Surface^.h else tmp_ClipRect.H := ClipRect.H;

		FOriginalSize.X := SDL_Surface^.w;
		FOriginalSize.Y := SDL_Surface^.h;

        ClipImage(tmp_ClipRect);

        FAnim.W := GetSurfaceWidth div Trunc(FClipRect.W);
        FAnim.H := GetSurfaceHeight div Trunc(FClipRect.H);

        FMaxFrames := Trunc(FAnim.W) * Trunc(FAnim.H);

        fGenerated := false;
        fNull := false;
		Result := true;

      {$IFNDEF USE_LOGGER}
	  end;
    {$ELSE}
    end else TelLogger.GetInstance.WriteLog('File not found: '+Directory+Content.RootDirectory+FileName, ltError);
    {$ENDIF}
  {$IFNDEF USE_LOGGER}
  end;
  {$ELSE}
  end else TelLogger.GetInstance.WriteLog('No filename specifies.', ltError);
  {$ENDIF}
  end;
end;

procedure TelSprite.LoadFromStream(Stream: TStream);
begin
  {$IFDEF USE_VAMPYRE}
    SDL_Surface := LoadSDLSurfaceFromStream(Stream);
  {$ENDIF}
  fGenerated := false;
end;

function TelSprite.SaveToStream(): TStream;
begin
  {$IFDEF USE_VAMPYRE}
    SaveSDLSurfaceToStream('png', Result, SDL_Surface);
  {$ENDIF}
end;

procedure TelSprite.Generate( GenerateMode: TGenerateMode = gmAuto );
begin
  fGenerated := true;
  LoadTexture(SDL_ConvertSurface(SDL_Surface, SDL_Surface^.format, SDL_Surface^.flags), Texture);
end;

procedure TelSprite.SetAutoTransparency(Value: Boolean);
begin
  FTransparent := Value;
  if FTransparent then SetTransparency(makeP2D(0, 0));
end;

procedure TelSprite.SetTransparency(aColor: TelColor);
begin
  if SDL_Surface <> Nil then
  begin
    SDL_SetColorKey(SDL_Surface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL,
      SDL_MapRGB(SDL_Surface^.Format, Color.R, Color.G, Color.B));

    fGenerated := false;
  end;
end;

procedure TelSprite.SetTransparency(aCoord: TelVector2i);
begin
  if SDL_Surface <> Nil then
  begin
    SDL_SetColorKey(SDL_Surface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL,
      SDL_GetPixel(SDL_Surface, aCoord.X, aCoord.Y));

    fGenerated := false;
  end;
end;

// Clone
procedure TelSprite.VirtualClone(FromSprite: TelSprite);
begin
  {
  // This is the correct but doesn't work all the time <- Needs optimizing
  if (FromSprite.SDL_Surface <> nil) then
  begin
    fCloned := true;

    Self.SDL_Surface := SDL_ConvertSurface(FromSprite.SDL_Surface,
                                           FromSprite.SDL_Surface^.format,
                                           FromSprite.SDL_Surface^.flags);
    Self.Alpha := FromSprite.Alpha;
    Self.FOriginalSize := makeP2D(FromSprite.SurfaceWidth, FromSprite.SurfaceHeight);
  end;
  }
  // Quick workaround for Play The City (Dude, it's like 3:00 AM, I don't have the time to debug)
  fCloned := true;
  Self.LoadFromFile(FromSprite.Filename, FromSprite.GetClipRect);
  //Self.Texture := FromSprite.Texture;
  Self.Alpha := FromSprite.Alpha;
  Self.FOriginalSize := makeP2D(FromSprite.SurfaceWidth, FromSprite.SurfaceHeight);
  Self.Transparent := FromSprite.Transparent;
end;

function TelSprite.GetImageType: String;
begin
  Result := fImageType;
end;

procedure TelSprite.ClipImage(Rect: TelRect);
begin
    if (fClipRect.X <> Rect.X) then fClipRect.X := Rect.X;
    if (fClipRect.Y <> Rect.Y) then fClipRect.Y := Rect.Y;
    if (fClipRect.W <> Rect.W) then
    begin
        fClipRect.W := Rect.W;
        fRect.W := fClipRect.W;
    end;
    if (fClipRect.H <> Rect.H) then
    begin
        fClipRect.H := Rect.H;
        fRect.H := fClipRect.H;
    end;
end;

function TelSprite.GetClipRect: TelRect;
begin
  Result := FClipRect;
end;

function TelSprite.GetRect: TelRect;
begin
  Result := FRect;
end;

procedure TelSprite.Move(Coord: TelVector2i);
begin
  Position.X := Position.X + Coord.X;
  Position.Y := Position.Y + Coord.Y;
end;

procedure TelSprite.Move(Coord: TelVector3i);
begin
  Position.X := Position.X + Coord.X;
  Position.Y := Position.Y + Coord.Y;
  Position.Z := Position.Z + Coord.Z;
end;

procedure TelSprite.SetWidth(Width: Integer);
begin
  FRect.W := Width;
end;

function TelSprite.GetWidth: Integer;
begin
  Result := Trunc(FRect.W);
end;

procedure TelSprite.SetHeight(Height: Integer);
begin
  FRect.H := Height;
end;

function TelSprite.GetHeight: Integer;
begin
  Result := Trunc(FRect.H);
end;

function TelSprite.GetSurfaceWidth: Integer;
begin
  Result := FOriginalSize.X;
end;

function TelSprite.GetSurfaceHeight: Integer;
begin
  Result := FOriginalSize.Y;
end;

procedure TelSprite.SetFrame(Frame: Integer);
begin
   if Frame <= FMaxFrames then
   begin
     FFrame := Frame - 1;
     if FFrame < 0 then FFrame := 0;


     if FAnim.H = 1 then FAnim.X := FFrame
     else
     begin
       FAnim.Y := FAnim.H - 1;
       FAnim.X := FFrame - FAnim.H;
     end;

     ClipImage(makeRect(FAnim.X * FClipRect.W, FAnim.Y * FClipRect.H, FClipRect.W, FClipRect.H));
   end;
end;

function TelSprite.GetFrame: Integer;
begin
  Result := FFrame;
end;

function TelSprite.GetMaxFrames: Integer;
begin
  Result := FMaxFrames;
end;

procedure TelSprite.Draw();
begin
  if fNull then
  begin
    {$IFDEF USE_LOGGER}
    TelLogger.GetInstance.WriteLog(Self.UniqueID + ' @ Filename: ' + Self.Filename + ' is Null');
    {$ENDIF}
    Exit;
  end;


  if Visible then
  begin
    if not Generated then Generate;

    glColor4f(1.0, 1.0, 1.0, 1.0);
    glEnable(GL_TEXTURE_2D);

    glPushMatrix;
      glColor3f(1, 1, 1);
      Bind(Texture);
      if Transparent then
      begin
        glEnable(GL_ALPHA_TEST);
        glAlphaFunc(GL_GREATER, 0.1);
      end;

  	glTranslatef((Position.X - Offset.Position.X + Offset.Rotation.X) * ActiveWindow.ResScale.X,
                     (Position.Y - Offset.Position.Y + Offset.Rotation.Y) * ActiveWindow.ResScale.Y, 0);
  	if Abs(Rotation.Angle) >= 360.0 then Rotation.Angle := 0.0;

  	if Rotation.Angle <> 0.0 then glRotatef(Rotation.Angle, Rotation.Vector.X, Rotation.Vector.Y, Rotation.Vector.Z);

      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glEnable(GL_BLEND);

  	glColor4f(Color.R / 255, Color.G / 255, Color.B / 255, Alpha / 255);
  	glScalef(Scale.X * ActiveWindow.ResScale.X, Scale.Y * ActiveWindow.ResScale.Y, 1);
      DrawQuad(FOriginalSize, FClipRect, makeRect(-Offset.Rotation.X, -Offset.Rotation.Y, FRect.W, FRect.H), Position.Z);
      glDisable(GL_BLEND);
      if Transparent then glDisable(GL_ALPHA_TEST);
    glPopMatrix;

    glDisable(GL_TEXTURE_2D);
  end;
end;

procedure TelSprite.Animate(var Counter: Integer; Loop: Boolean = True);
begin
  Counter := Counter + 1;
  FFrame := Counter;
  if Loop then if GetFrame = GetMaxFrames then Counter := 0;

  Self.SetFrame(FFrame);
end;

procedure TelSprite.Animate(aTimer: TelTimer; Loop: Boolean = True);
begin
  //if Timer.SingleAction then FFrame := FFrame + 1;
  if Loop then if GetFrame = GetMaxFrames then FFrame := 0;

  Self.SetFrame(FFrame);
end;

function TelSprite.OnPoint(Coord: TelVector2i): Boolean;
begin
  if (Coord.X >= (Position.X - Offset.Rotation.X - Offset.Position.X) * Scale.X * ActiveWindow.ResScale.X) and
     (Coord.Y >= (Position.Y - Offset.Rotation.Y - Offset.Position.Y) * Scale.Y * ActiveWindow.ResScale.Y) and
     (Coord.X < (Position.X - Offset.Rotation.X - Offset.Position.X + FRect.W) * Scale.X * ActiveWindow.ResScale.X) and
     (Coord.Y < (Position.Y - Offset.Rotation.Y - Offset.Position.Y + FRect.H) * Scale.Y * ActiveWindow.ResScale.Y) then Result := true else Result := false;
end;

function TelSprite.OnMouseOver: Boolean;
begin

    {if SDL_Surface <> nil then} Result := Self.OnPoint(ActiveWindow.Cursor);

end;

function TelSprite.OnMouseOverPixel: Boolean;
begin
  Result := PixelTest(Self, makeRect(ActiveWindow.Cursor.X, ActiveWindow.Cursor.Y, 1, 1));
end;

function TelSprite.OnClick: Boolean;
begin
  if OnMouseOver and Input.Mouse.LeftClick then Result := true
  else Result := false;
end;    *)

//
// TelSpriteList
//

constructor TelSpriteList.Create;
begin
  inherited;

  FSpriteList := TList.Create;
  Head := 'TelSpriteList';
end;

destructor TelSpriteList.Destroy;
var
  Counter : integer;
begin

  for Counter := 0 to FSpriteList.Count - 1 do
  begin
    TelSprite(FSpriteList[Counter]).Destroy;
  end;
  FSpriteList.Free;

  inherited Destroy;

end;

function TelSpriteList.GetCount: Integer;
begin
  Result := FSpriteList.Count;
end;

procedure TelSpriteList.Insert(Index: Integer; Sprite: TelSprite);
begin
  if ((Index >= 0) and (Index <= FSpriteList.Count - 1)) then FSpriteList.Insert(Index, Sprite)
  {$IFDEF USE_LOGGER}
  else begin
    if Index > FSpriteList.Count - 1 then TelLogger.GetInstance.WriteLog('SpriteList: Index > Count');
    if Index < 0 then TelLogger.GetInstance.WriteLog('SpriteList : Index < Count');
  end;
  {$ENDIF}
end;

function TelSpriteList.Add(Sprite: TelSprite): Integer;
begin
  Result := FSpriteList.Add(Sprite);
end;

procedure TelSpriteList.Delete(Index: Integer);
var
  TmpSprite: TelSprite;
begin
  if ((Index >= 0) and (Index <= FSpriteList.Count - 1)) then
  begin
    TmpSprite := Get(Index);
    TmpSprite.Destroy;
    FSpriteList.Delete(Index);
  end
  {$IFDEF USE_LOGGER}
  else begin
    if Index > FSpriteList.Count - 1 then TelLogger.GetInstance.WriteLog('SpriteList: Index > Count');
    if Index < 0 then TelLogger.GetInstance.WriteLog('SpriteList : Index < Count');
  end;
  {$ENDIF}

end;

function TelSpriteList.Get(Index: Integer): TelSprite;
begin
  if ((Index >= 0) and (Index <= FSpriteList.Count - 1)) then Result := TelSprite(FSpritelist[Index])
  {$IFDEF USE_LOGGER}
  else begin
    if Index > FSpriteList.Count - 1 then TelLogger.GetInstance.WriteLog('SpriteList: Index > Count');
    if Index < 0 then TelLogger.GetInstance.WriteLog('SpriteList : Index < Count');
  end;
  {$ENDIF}

end;

function TelSpriteList.GetPos(Index: String): Integer;
Var a, TMP: Integer;
Begin
  Try
    For a := 0 To FSpriteList.Count - 1 Do
    Begin
      if Items[a].Name <> Index then TMP := -1
      else begin
        TMP := a;
        Break;
      end;
    End;
  Finally
    Result := TMP;
  End;

end;

procedure TelSpriteList.Put(Index: Integer; const Item: TelSprite);
var
  TmpSprite: TelSprite;
begin
  if ((Index >= 0) and (Index <= FSpriteList.Count - 1)) then
  begin
    TmpSprite := Get(Index);
    TmpSprite.Destroy;
    Insert(Index, Item);
  end
  {$IFDEF USE_LOGGER}
  else begin
    if Index > FSpriteList.Count - 1 then TelLogger.GetInstance.WriteLog('SpriteList: Index > Count');
    if Index < 0 then TelLogger.GetInstance.WriteLog('SpriteList : Index < Count');
  end;
  {$ENDIF}

end;

Function TelSpriteList.GetS(Index: String): TelSprite;
Var TMP: Integer;
Begin
  TMP := GetPos(Index);
  if TMP >= 0 then Result := TelSprite(FSpriteList[TMP])
			  else Result := nil;
End;

Procedure TelSpriteList.PutS(Index: String; const Item: TelSprite);
var
  TMP: Integer;
  TmpSprite: TelSprite;
Begin
  if (Index <> '') then
  begin
    TmpSprite := GetS(Index);
	if TmpSprite <> nil then
	begin
	  TMP := GetPos(Index);
      TmpSprite.Destroy;
      Insert(TMP, Item);
	end
    {$IFDEF USE_LOGGER}
    else TelLogger.GetInstance.WriteLog('SpriteList: Index does not exist');
    {$ENDIF}
  end
  {$IFDEF USE_LOGGER}
  else TelLogger.GetInstance.WriteLog('SpriteList: Index string is empty');
  {$ENDIF}
End;

procedure TelSpriteList.LoadFromStream(Stream: TFileStream);
var
  TmpHead: String[13];
  loop : integer;
  ImgBuf : TelSprite;
begin
  TmpHead := '';
  loop := 0;

  Stream.Read(TmpHead, SizeOf(TmpHead));

  if TmpHead <> Head then
  begin
    {$IFDEF USE_LOGGER}
    TelLogger.GetInstance.WriteLog('Could not load file: Wrong file');
    {$ENDIF}
  end else
  begin
    Stream.Read(loop, SizeOf(Integer));

    FSpriteList.Count := loop;

    for loop := 0 to FSpriteList.Count - 1 do
    begin
      ImgBuf := TelSprite.Create;
      ImgBuf.LoadFromStream(Stream);
      FSpriteList.Insert(0, ImgBuf);
    end;
  end;

end;


procedure TelSpriteList.SaveToStream( Stream : TFileStream );
var
  loop : integer;
begin
  Stream.Write(Head, SizeOf(Head));
  Stream.Write(FSpriteList.Count, SizeOf(Integer));

  for loop := 0 to FSpriteList.Count - 1 do
  begin
    TelSprite(FSpriteList[loop]).SaveToStream(Stream);
  end;

end;

procedure TelSpriteList.SaveToFile(Filename: String);
var
  FileHndl: TFileStream;
begin
  FileHndl := TFileStream.Create( Filename, fmCreate );

  SaveToStream(FileHndl);

  FileHndl.Free;
end;

procedure TelSpriteList.LoadFromFile(Filename: String);
var
  FileHndl: TFileStream;
  Counter: integer;
begin

  for Counter := 0 to FSpriteList.Count - 1 do
  begin
    TelSprite(FSpriteList[Counter]).Destroy;
  end;

  FileHndl := TFileStream.Create(FileName, fmOpenRead);

  loadFromStream(FileHndl);

  FileHndl.Free;
end;

{
  #############################################################################
  # TelLight                                                                  #
  #############################################################################

  Description:
    TelLight is essentially a sprite with additative blending

  Additional Notes: -

}

constructor TelLight.Create;
begin
  inherited;

  Self.BlendMode := bmAdd;
  Self.Transparent := true;
end;

destructor TelLight.Destroy;
begin
  inherited;
end;

constructor TelParticle.Create;
begin
  inherited;

  fDead := false;
  //fLoop := false;
  //fIsPaused := false;
  //fIsActive := true;

  fMaxLife := 1500;
  fLife := fMaxLife;

  fTimer := TelTimer.Create;
end;

destructor TelParticle.Destroy;
begin
  inherited;
end;

procedure TelParticle.SetLife(Value: Integer);
begin
  fMaxLife := Value;
  fLife := Value;
end;

procedure TelParticle.Start();
begin
  fTimer.Start();
end;

procedure TelParticle.Pause();
begin
  fTimer.Pause();
end;

procedure TelParticle.Stop();
begin
  fTimer.Stop();
end;

procedure TelParticle.Draw();
begin
  inherited;
end;

procedure TelParticle.Update(dt: Double = 0.0);
begin
  inherited;
end;

{
  #############################################################################
  # TelCamera                                                                 #
  #############################################################################

  Description:
    Inserts a camera

  Additional Notes: -

}

constructor TelCamera.Create;
begin

end;



end.
