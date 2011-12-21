unit ElysionUsers;

interface

uses
  ElysionObject,
  ElysionAchievements;

type
  TelUser = class(TelObject)
  private

  public
    constructor Create;
    destructor Destroy;
  end;

  TelUserManagement = class(TelObject)
  private

  public
    constructor Create;
    destructor Destroy;

    procedure Add(anUser: TelUser);
    procedure Delete(anIndex: Integer);
  published

  end;

var
  UserManagement: TelUserManagement;

implementation

initialization
  UserManagement := TelUserManagement.Create();

finalization
  UserManagement.Destroy();

end.
