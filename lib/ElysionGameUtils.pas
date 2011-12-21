unit ElysionGameUtils;

{$I Elysion.inc}

interface

uses
  SysUtils,
  Classes,

  ElysionObject,
  ElysionGraphics,
  ElysionGUI;

type
  TAchievement = class(TelObject)
    private
      fDescription, fCaption, fPoints: String;
      fIcon: TelSprite;
    public
      constructor Create; Override;
      destructor Destroy; Override;

      procedure Show();
    published
      property Caption: String read fCaption write fCaption;
      property Description: String read fDescription write fDescription;
      property Icon: TelSprite read fIcon write fIcon;
      property Points: Integer read fPoints write fPoints;
  end;

  TAchievementManager = class(TelObject)
    private
      fAchievementList: TList;
    public
      constructor Create;
      destructor Destroy;

      //procedure Add(aName: String; );
      procedure Show(aName: String);
  end;
  
  TelUser = class(TelObject)
  private

  public
    constructor Create; Override;
    destructor Destroy; Override;
  end;

  TelUserManagement = class(TelObject)
  private

  public
    constructor Create; Override;
    destructor Destroy; Override;

    procedure Add(anUser: TelUser);
    procedure Delete(anIndex: Integer);
  published

  end;
  
  TelSaveGame = class(TelObject)
    private
      fNodeArray: TelNodeArray;
      fCheckForUniqueID: Boolean;
    public
      constructor Create; Override;
      destructor Destroy; Override;

      procedure LoadFromFile(const aFilename: String);
      procedure SaveToFile(const aFilename: String);

    published
      property NodeArray: TelNodeArray read fNodeArray write fNodeArray;
      property CheckForUniqueID: Boolean read fCheckForUniqueID write fCheckForUniqueID; //< If you're not 21, you're not going to be served ;)
  end;

{$IFDEF AUTO_INIT}
var
  AchievementManager: TAchievementManager;
  UserManager: TelUserManagement;
{$ENDIF}

implementation

constructor TAchievement.Create;
begin
  inherited;
end;

destructor TAchievement.Destroy;
begin
  inherited;
end;

procedure TAchievement.Show();
begin
  inherited;
end;

constructor TelSaveGame.Create;
begin
  inherited Create;

  NodeArray := nil;
  fCheckForUniqueID := false;
end;

destructor TelSaveGame.Destroy;
begin
  inherited Destroy;
end;

procedure TelSaveGame.LoadFromFile(const aFilename: String);
var
  i: Integer;
begin
  if NodeArray = nil then Exit;

  if CheckForUniqueID then
  begin
    for i := 0 to High(NodeArray) do
    begin

    end;
  end else
  begin
    for i := 0 to High(NodeArray) do
    begin

    end;
  end;
end;

procedure TelSaveGame.SaveToFile(const aFilename: String);
begin
  if NodeArray = nil then Exit;


end;

{$IFDEF AUTO_INIT}
initialization
  AchievementManager := TAchievementManager.Create;
  UserManager := TelUserManager.Create();

finalization
  AchievementManager.Destroy;
  UserManager.Destroy();
{$ENDIF}
