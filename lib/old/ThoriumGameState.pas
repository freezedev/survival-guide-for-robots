// Elysion Frameworks
// Basic Game unit
// Abstract layer for games 
//
// (C) 2009, Johannes Stein
// Freeze.Dev - http://www.freeze-dev.de
//

unit ThoriumGameState;

interface

uses
  SysUtils,
  ElysionKronos,
  Classes,
  Thorium,
  ThoriumLibStd,
  ThoriumLibStdIO,
  ThoriumElysionKronos;


type
TThoriumGameState = Class(TelGameState)
  private
    fScriptEngine: TThorium;
    fModule: TThoriumModule;
  
    function GetWidth: Integer;
    function GetHeight: Integer;
  public
    // Creates TBasicGameThorium with no strings attached
    // A window needs to be created manually if not done yet
    constructor Create(Filename: String);

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

constructor TThoriumGameState.Create(Filename: String);
var
  Directory: String;
begin
  inherited Create;

  Directory := ExtractFilePath(ParamStr(0));
  
  fScriptEngine := TThorium.Create;
  fScriptEngine.LoadLibrary(TThoriumLibStd);
  fScriptEngine.LoadLibrary(TThoriumLibStdIO);
  fScriptEngine.LoadLibrary(TLibElysionKronos);
  
  fModule := fScriptEngine.LoadModuleFromFile(Directory + Filename);
  
  fScriptEngine.InitializeVirtualMachine;
end;

destructor TThoriumGameState.Destroy();
begin
  fScriptEngine.ReleaseVirtualMachine;
  fScriptEngine.Free;

  inherited;
end;

procedure TThoriumGameState.Initialize();
begin
  Module.FindPublicFunction('INITIALIZE').SafeCall([]);
end;

procedure TThoriumGameState.Render();
begin
  Module.FindPublicFunction('RENDER').SafeCall([]);
end;

procedure TThoriumGameState.Update();
begin
  Module.FindPublicFunction('UPDATE').SafeCall([ThoriumCreateFloatValue(ActiveWindow.DeltaTime)]);
end;

function TThoriumGameState.GetWidth: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Width;
end;

function TThoriumGameState.GetHeight: Integer;
begin
  if ActiveWindow <> nil then Result := ActiveWindow.Height;
end;

end.
