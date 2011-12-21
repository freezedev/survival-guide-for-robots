// Elysion Frameworks
// Basic Game unit
// Abstract layer for games 
//
// (C) 2005 - 2011, Johannes Stein
// Freeze Dev - http://elysion.freeze-dev.com
//

unit ElysionStage;

{$I Elysion.inc}

interface

uses
    Classes,

    ElysionObject,
    ElysionApplication,
    ElysionNode;


type
// TODO: Merge TelGame and TelStage somehow

TelGame = class(TelObject)
  private
    function GetWidth: Integer; {$IFDEF CAN_INLINE} inline; {$ENDIF}
    function GetHeight: Integer; {$IFDEF CAN_INLINE} inline; {$ENDIF}
  public
    // Creates TelStage with no strings attached
    // A window needs to be created manually if not done yet
    constructor Create(); Overload; Override;
    
    // Creates TelStage and creates a window
    constructor Create(Width, Height, BPP: Integer; Fullscreen: Boolean); Overload;

    destructor Destroy(); Override;
  
    procedure Initialize(); virtual; abstract;
    
    procedure Render(); virtual; abstract;
    procedure Update(dt: Double); virtual; abstract;

    procedure HandleEvents(); virtual; abstract;

    function Param(aParam: String): Boolean;
  published
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
end;

TelStage = class(TelObject)
  private
    fNodeList: TelNodeList;
  public
    constructor Create; Override;
    destructor Destroy; Override;

    procedure Add(aNode: TelNode); {$IFDEF CAN_INLINE} inline; {$ENDIF}

    procedure Render(); virtual;
    procedure Update(dt: Double); virtual;

    //procedure HandleEvents(); virtual; abstract;
end;

TelStageDirector = class(TelObject)
  private
  
  public
    //constructor Create;
	//destructor Destroy;
	
  published
  
end;

implementation

constructor TelGame.Create();
begin
  inherited;
end;

constructor TelGame.Create(Width, Height, BPP: Integer; Fullscreen: Boolean);
begin
  inherited Create;

  Application.Initialize(Width, Height, BPP, Fullscreen);
end;

destructor TelGame.Destroy();
begin
  inherited;
end;

function TelGame.Param(aParam: String): Boolean;
var
  i: Integer;
begin
  Result := false;

  if ParamCount >= 1 then
  begin
    for i := 1 to ParamCount - 1 do
    begin
      if ParamStr(i) = aParam then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

function TelGame.GetWidth: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Width;
end;

function TelGame.GetHeight: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Height;
end;

constructor TelStage.Create;
begin
  inherited;

  fNodeList := TelNodeList.Create;
end;

destructor TelStage.Destroy;
begin
  inherited;
end;

procedure TelStage.Add(aNode: TelNode);
begin
  fNodeList.Add(aNode);
end;

procedure TelStage.Render();
var
  i: Integer;
begin
  for i := 0 to fNodeList.Count - 1 do
  begin
    if fNodeList.Items[i] <> nil then fNodeList.Items[i].Draw;
  end;
end;

procedure TelStage.Update(dt: Double);
var
  i: Integer;
begin
  for i := 0 to fNodeList.Count - 1 do
  begin
    if fNodeList.Items[i] <> nil then fNodeList.Items[i].Update;
  end;
end;

end.
