unit ElysionInterfaces;

{$I Elysion.inc}

interface

uses
  ElysionTypes;

type
  IModuleContainer = interface
    function Initialize(): Boolean;
    procedure Finalize();
  end;

  INode = interface
    procedure AddChild(aNode: INode);

    procedure Move(Delta: TelVector3f); Overload;
    procedure Move(Delta: TelVector2i); Overload;

    procedure Draw;
    procedure Update(dt: Double = 0.0);
  end;

  ITimer = interface
    procedure Start();

    procedure Pause();
    procedure UnPause();

    procedure Stop();

    procedure Update();
  end;

implementation

end.
