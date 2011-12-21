{

  
  Copyright (c) 2010 Johannes Stein

  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation
  files (the "Software"), to deal in the Software without
  restriction, including without limitation the rights to use,
  copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.

  info@freeze-dev.de
  www.freeze-dev.de

}

program survivalguide;

{$IFDEF WINDOWS}
  {$IFNDEF DEBUG}  
    {$APPTYPE GUI}
  {$ENDIF}
  
  // Adds icon
  //{$R main.res}
{$ELSE}
  // Maybe move linker stuff here
{$ENDIF}

{$I Elysion.inc}

uses
  ElysionApplication in '../lib/ElysionApplication.pas',
  uGame in 'units/uGame.pas';

var
  Game: TGame;

{$IFDEF WINDOWS}{$R main.rc}{$ENDIF}

//{$R main.res}

begin
  // Create game class
  Game := TGame.Create;

  // Loads images and config files and everything else
  Game.Initialize();
  
  // Game Loop
  while Application.Run do
  begin
    // Clears buffer
    ActiveWindow.BeginScene;
    
    // Render procedure
    Game.Render;
	
    // Update procedure
    Game.Update(ActiveWindow.DeltaTime);

    // Handle keyboard, mouse, joystick events
    Game.HandleEvents();
    
    // Flip surface
    ActiveWindow.EndScene;
  end;
  
end.
