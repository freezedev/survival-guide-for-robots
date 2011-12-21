(**
  * This is a modified version of the Elysion Frameworks (ElysionKronos) library 
  * and will probably be merged into the Elysion SVN in the near future
  *
  * SDL + OpenGL support
  *
  *
  * Not suitable for public use
  *
  * (C) Johannes Stein, 2009, www.freeze-dev.de
  * Licensed under MIT license
  *  For more information see 
  *				     http://www.opensource.org/licenses/mit-license.php
  *)

unit ElysionKronos;

{$IFDEF FPC}
{$mode delphi} // TODO: ObjFPC - Compability!
{$H+}
{$ENDIF}

// Include compiler switches
{$I Elysion.inc}

interface

uses
        ElysionEnum,
        ElysionObject,
        ElysionApplication,
        ElysionWindow,
        ElysionCompat,
        ElysionTimer,
        ElysionTypes,
        ElysionLogger,

	SDL,
	{$IFDEF USE_SDL_IMAGE} SDL_image, {$ENDIF}
	{$IFDEF USE_VAMPYRE}   ImagingSDL, {$ENDIF}
    {$IFDEF USE_SDL_MIXER} SDL_mixer, {$ENDIF}
    {$IFDEF USE_SFONT}     SFont,     {$ENDIF}
    {$IFDEF USE_SDL_TTF}   SDL_ttf,   {$ENDIF}
    {$IFDEF USE_SDL_GFX}   SDL_gfx,   {$ENDIF}
    {$IFDEF USE_SDL_NET}   SDL_net,   {$ENDIF}
    SDLTextures,
	  SDLUtils,
    {$IFDEF USE_DGL_HEADER}
    dglOpenGL,
    {$ELSE}
    gl, glu, glext,
    {$ENDIF}
    SysUtils,
    Classes;

const

// Include keymap
{$I keymap.inc}

type





// See Book: iPhone Game Development
TelGameState = class(TelObject)
  public
    constructor Create; Override;
	destructor Destroy; Override;
    
	procedure Render; virtual; abstract;
	procedure Update; virtual; abstract;
	procedure HandleEvents; virtual; abstract;
end;

TelGameStateManager = class(TelObject)
  private
    fGameStateList: TList;
  public
    constructor Create; Override;
	destructor Destroy; Override;
	
	procedure Render;
	procedure Update;
	procedure HandleEvents;
	
	procedure SetState(GameState: TelGameState);
end;



// Basic graphical object
TelGraphicObject = class(TelObject)
  private
    FAlpha: Byte;
    FAngle: Single;


    FChanged: Boolean;
    FCloned: Boolean;
    FGenerated: Boolean;
    FImageType: String;

    FParent: PSDL_Surface;
    FRect: TelRect;

    // Virtual abstract to keep it as wide as possible for fonts
		function GetWidth: Integer; virtual; abstract;
		function GetHeight: Integer; virtual; abstract;

		function GetAlignVertical(): TAlignVertical;
		function GetAlignHorizontal(): TAlignHorizontal;
		procedure SetAlignVertical(VerticalAlignment: TAlignVertical);
		procedure SetAlignHorizontal(HorizontalAlignment: TAlignHorizontal);
  public
	    // Access the SDL_Surface directly if you need to
      SDL_Surface: PSDL_Surface;

		// Position of the graphic object
		Position: TelVector3i;

    // Hot Spot
    Offset: TelVector2i;

    Color: TelColor;

		// Create Object
        constructor Create; Override;
        // Destructor
        destructor Destroy; Override;

    procedure LoadFromFile(Filename: String); virtual; abstract;

    {

    }
    procedure SaveToBitmap(Filename: String);

    procedure VirtualClone(Source: TelGraphicObject); virtual; abstract;

		procedure Draw; virtual; abstract;

		// Move object
		procedure Move(Point: TelVector2i);
  published
      // Ignores Position if used
		  property AlignH: TAlignHorizontal read GetAlignHorizontal write SetAlignHorizontal;
		  property AlignV: TAlignVertical read GetAlignVertical write SetAlignVertical;
	
    // Alpha value
    property Alpha: Byte read FAlpha write FAlpha;

    // Angle
    property Angle: Single read FAngle write FAngle;
    property Cloned: Boolean read FCloned;

    property Generated: Boolean read FGenerated;
end;


{
  #############################################################################
  # TelScene                                                                  #
  #############################################################################
  # Function prototypes                                                       #

  Description:
    Allows the developer to put different graphical objects in one scene.
    Use of TelScene is encouraged, more resource-friendly and clearly arranged
    than using 100 graphical objects for example

    Can be combined with TelSpriteEngine

  Additional Notes: -

}
TelScene = class(TelGraphicObject)
  private

  public
    {

    }
    constructor Create(Width, Height: Integer); Overload;

    {

    }
    constructor Create(Width, Height: Integer; Mask: TelColor); Overload;

    {

    }
    destructor Destroy; Override;


end;


TelFontContainer = class
  private
  
  public
    //procedure TextOut(Point: TelVector2i; Text: String);
  published
  
end;


TOffset = record
	Rotation: TelVector2i;
	Position: TelVector2i;
end;

TRotation = record
	Angle: Single;
	Vector: TelVector3f;
end;





function convCol(S: TelWindow; Color: TelColor): Cardinal; Overload;
function convCol(S: TelWindow; R, G, B: Byte): Cardinal; Overload;
function convCol(Color: TelColor): TSDL_Color; Overload;
//function convCol(Color: TelColor): Cardinal; Overload;
function convCol(R, G, B: Byte): Cardinal; Overload;

function OnPoint(Coord: TelVector2i; Rect: TelRect): Boolean;


function ActiveWindow: TelWindow;







// Use operator overloading if supported


var
  Input: TelInputHelper;

  // Use Surface directly for backward compability if necessary
  // Better way: Use ActiveWindow function
  Window: TelWindow;

implementation


// Uh, those are some pretty functions



// deprecated, please use function convCol(Color: TelColor): Cardinal; instead
function convCol(S: TelWindow; Color: TelColor): Cardinal; Overload;
begin
  Result := SDL_MapRGB(S.SDL_Surface.Format, Color.R, Color.G, Color.B);
end;

// deprecated, please use function convCol(R, G, B: Byte): Cardinal; instead
function convCol(S: TelWindow; R, G, B: Byte): Cardinal; Overload;
begin
  Result := SDL_MapRGB(S.SDL_Surface.Format, R, G, B);
end;

//function convCol(Color: TelColor): Cardinal; Overload;
//begin
//  Result := SDL_MapRGB(Surface.SDL_Surface.Format, Color.R, Color.G, Color.B);
//end;

function convCol(R, G, B: Byte): Cardinal; Overload;
begin
  Result := SDL_MapRGB(Window.SDL_Surface.Format, R, G, B);
end;

function convCol(Color: TelColor): TSDL_Color; Overload;
begin
  Result.r := Color.R;
  Result.g := Color.G;
  Result.b := Color.B;
  Result.unused := 0;
end;

function OnPoint(Coord: TelVector2i; Rect: TelRect): Boolean;
begin
  if (Coord.X >= Rect.X) and
     (Coord.Y >= Rect.Y) and
     (Coord.X < (Rect.X + Rect.W)) and
     (Coord.Y < (Rect.Y + Rect.H)) then Result := true else Result := false;
end;







function ActiveWindow: TelWindow;
begin
  Result := Window;
end;





//
// TelGraphicObject
//

constructor TelGraphicObject.Create;
begin
  inherited Create;
end;

destructor TelGraphicObject.Destroy;
begin
  if not Cloned then SDL_FreeSurface(SDL_Surface);

  inherited Destroy;
end;

procedure TelGraphicObject.SaveToBitmap(Filename: string);
begin
  if LowerCase(GetFilenameExtension(Filename)) <> 'bmp' then Filename := Filename + '.bmp';
  SDL_SaveBMP(SDL_Surface, PChar(Filename));
end;

function TelGraphicObject.GetAlignVertical(): TAlignVertical;
begin

end;

function TelGraphicObject.GetAlignHorizontal(): TAlignHorizontal;
begin

end;

procedure TelGraphicObject.SetAlignVertical(VerticalAlignment: TAlignVertical);
begin

end;

procedure TelGraphicObject.SetAlignHorizontal(HorizontalAlignment: TAlignHorizontal);
begin

end;

procedure TelGraphicObject.Move(Point: TelVector2i);
begin

end;




{
  #############################################################################
  # TelGameStates                                                             #
  #############################################################################

  Description:
    Handles different states.

    Should be combinded with TelScene

  Additional Notes: -

}

constructor TelGameState.Create;
begin

end;

destructor TelGameState.Destroy;
begin

end;


constructor TelGameStateManager.Create;
begin

end;

destructor TelGameStateManager.Destroy;
begin
  //if fGameState <> nil then fGameState.Destroy;
end;

procedure TelGameStateManager.Render;
begin
  //if fGameState <> nil then fGameState.Render;
end;

procedure TelGameStateManager.Update;
begin
  //if fGameState <> nil then fGameState.Update;
end;

procedure TelGameStateManager.HandleEvents;
begin
  //if fGameState <> nil then fGameState.HandleEvents;
end;

procedure TelGameStateManager.SetState(GameState: TelGameState);
begin
  //fGameState := GameState;
end;

{
  #############################################################################
  # TelScene                                                                  #
  #############################################################################

  Description:
    Allows the developer to put different graphical objects in one scene.
    Use of TelScene is encouraged, more resource-friendly and clearly arranged
    than using 100 graphical objects for example

    Can be combined with TelSpriteEngine

  Additional Notes: -

}

constructor TelScene.Create(Width: Integer; Height: Integer);
begin
  inherited Create;
end;

constructor TelScene.Create(Width: Integer; Height: Integer; Mask: TelColor);
begin
  inherited Create;
end;

destructor TelScene.Destroy;
begin
  inherited Destroy;
end;




initialization
  Input := TelInputHelper.Create;

finalization
  //Color.Destroy;
  //Input.Destroy;
  {$IFDEF USE_LOGGER} TelLogger.GetInstance.Destroy; {$ENDIF}
  //GUI.Destroy;
  //Application.Destroy;

end.
