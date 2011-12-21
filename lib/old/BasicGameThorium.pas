// Elysion Frameworks
// Basic Game unit
// Abstract layer for games 
//
// (C) 2009, Johannes Stein
// Freeze.Dev - http://www.freeze-dev.de
//

unit BasicGameThorium;

interface

uses
  ElysionKronos,
  Classes,
  Thorium,
  ThoriumLibStd,
  ThoriumLibStdIO,
  ThoriumLibElysionKronos;


type
TBasicGameThorium = Class(TelObject)
  private
    fScriptEngine: TThorium;
	fModule: TThoriumModule;
  
    function GetWidth: Integer;
    function GetHeight: Integer;
  public
    // Creates TBasicGameThorium with no strings attached
    // A window needs to be created manually if not done yet
    constructor Create(Filename: String); 
    
    // Creates an application window
    procedure CreateWindow(Width, Height, BPP: Integer; Fullscreen: Boolean); Overload;

    destructor Destroy(); Override;
  
    procedure Initialize();
    
    procedure Render();
    procedure Update();
  published
    property ScriptEngine: TThorium read fScriptEngine write fScriptEngine;
	property Module: TThoriumModule read fModule write fModule;
  
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
end;

implementation

constructor TBasicGameThorium.Create(Filename: String);
begin
  inherited;
  
  fScriptEngine := TThorium.Create;
  fScriptEngine.LoadLibrary(TThoriumLibStd);
  fScriptEngine.LoadLibrary(TThoriumLibStdIO);
  fScriptEngine.LoadLibrary(TLibElysionKronos);
  
  fModule := fScriptEngine.LoadModuleFromFile(Filename);
  
  fScriptEngine.InitializeVirtualMachine;
end;

procedure TBasicGameThorium.CreateWindow(Width, Height, BPP: Integer; Fullscreen: Boolean);
begin
  Application.Initialize(Width, Height, BPP, Fullscreen);
end;

destructor TBasicGameThorium.Destroy();
begin
  fScriptEngine.ReleaseVirtualMachine;
  fScriptEngine.Free;

  inherited;
end;

procedure TBasicGameThorium.Initialize();
begin
  Module.FindPublicFunction('INITIALIZE').SafeCall([]);
end;

procedure TBasicGameThorium.Render();
begin
  Module.FindPublicFunction('RENDER').SafeCall([]);
end;

procedure TBasicGameThorium.Update();
begin
  Module.FindPublicFunction('UPDATE').SafeCall([ThoriumCreateFloatValue(ActiveWindow.DeltaTime)]);
end;

function TBasicGameThorium.GetWidth: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Width;
end;

function TBasicGameThorium.GetHeight: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Height;
end;

end.
