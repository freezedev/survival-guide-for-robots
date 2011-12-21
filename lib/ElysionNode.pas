unit ElysionNode;

interface

{$I Elysion.inc}

uses
  Classes,
  ElysionTypes,
  ElysionApplication,
  ElysionInterfaces,
  ElysionTimer,
  ElysionObject;

type
  TelNode = class; //< forward declaration

  TelNodeEvent = procedure(aNode: TelNode) of object;

  TelNode = class(TelObject, INode)
  protected
    fAlignH: TAlignHorizontal;
    fAlignV: TAlignVertical;

    {$IFDEF FPC}
    fPosition: TelVector3f;
      fOffset: TelImageOffset;
      fRotation: TelImageRotation;
      fColor: TelColor;
      fScale: TelVector2f;
      {$ENDIF}

      fParent: INode;

      fMouseOverEvent: TelNodeEvent;
      fMouseClickEvent: TelNodeEvent;

      fVisible: Boolean;

      function GetAlpha(): Byte;
      procedure SetAlpha(anAlpha: Byte);

      procedure SetAlignH(Value: TAlignHorizontal);
      procedure SetAlignV(Value: TAlignVertical);

      function GetWidth(): Integer; virtual; abstract;
      function GetHeight(): Integer; virtual; abstract;

      function GetOnMouseOver(): Boolean; virtual; abstract;
      function GetOnClick(): Boolean; virtual; abstract;
    public
      {$IFNDEF FPC}
      // Delphi
      Position: TelVector3f;
      Offset: TelImageOffset;
      Rotation: TelImageRotation;
      Color: TelColor;
      Scale: TelVector2f;
      {$ENDIF}

      constructor Create; Override;
      destructor Destroy; Override;

      procedure AddChild(aNode: INode); {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure UpdateNodePosition(); {$IFDEF CAN_INLINE} inline; {$ENDIF}

      procedure Move(Delta: TelVector3f); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}
      procedure Move(Delta: TelVector2i); Overload; {$IFDEF CAN_INLINE} inline; {$ENDIF}

      procedure Draw; virtual; abstract;
      
      procedure Update(dt: Double = 0.0); virtual;

      //procedure WriteToXML(): TStringList;

      {$IFDEF FPC}
      property Position: TelVector3f read fPosition write fPosition;
      property Offset: TelImageOffset read fOffset write fOffset;
      property Rotation: TelImageRotation read fRotation write fRotation;
      property Color: TelColor read fColor write fColor;
      property Scale: TelVector2f read fScale write fScale;
      {$ENDIF}
    published
      property AlignH: TAlignHorizontal read fAlignH write SetAlignH;
      property AlignV: TAlignVertical read fAlignV write SetAlignV;

      property Alpha: Byte read GetAlpha write SetAlpha default 255;

      property MouseOverEvent: TelNodeEvent read fMouseOverEvent write fMouseOverEvent;
      property MouseClickEvent: TelNodeEvent read fMouseClickEvent write fMouseClickEvent;

      property Parent: INode read fParent write fParent;

      property OnMouseOver: Boolean read GetOnMouseOver;
      property OnClick: Boolean read GetOnClick;

      property Width: Integer read GetWidth;
      property Height: Integer read GetHeight;

      {$IFDEF FPC}
      property Left: Single read fPosition.X write fPosition.X;
      property Top: Single read fPosition.Y write fPosition.Y;
      {$ELSE}
      property Left: Single read Position.X write Position.X;
      property Top: Single read Position.Y write Position.Y;
      {$ENDIF}

      property Visible: Boolean read fVisible write fVisible default true;
  end;

  TelNodeArray = array of TelNode;

  TelNodeList = class(TelObject)
     private
      fNodeList: TList;

      function Get(Index: Integer): TelNode;
      function GetPos(Index: String): Integer;
      procedure Put(Index: Integer; const Item: TelNode);
      procedure PutS(Index: String; const Item: TelNode);
      function GetS(Index: String): TelNode;

      function GetCount: Integer;
    public
      constructor Create; Override;
      destructor Destroy; Override;

      procedure Insert(Index: Integer; Node: TelNode);
      function  Add(Node: TelNode): Integer;
      procedure Delete(Index: Integer);

      property Items[Index: Integer]: TelNode read Get write Put; default;
      property Find[Index: String]: TelNode read GetS write PutS;
    published
      property Count: Integer read GetCount;
  end;

  procedure CopyNodeValues(aNode, bNode: TelNode);
  procedure ForceNodeCopy(aNode, bNode: TelNode);

implementation

procedure CopyNodeValues(aNode, bNode: TelNode);
begin
  aNode.Position := bNode.Position;
  aNode.Offset := bNode.Offset;
  aNode.Rotation := bNode.Rotation;
  aNode.Color := bNode.Color;
  aNode.Scale := bNode.Scale;

  aNode.AlignH := bNode.AlignH;
  aNode.AlignV := bNode.AlignV;

  aNode.Alpha := bNode.Alpha;

  aNode.Visible := bNode.Visible;
end;

procedure ForceNodeCopy(aNode, bNode: TelNode);
begin
  aNode.Position := bNode.Position;
  aNode.Offset := bNode.Offset;
  aNode.Rotation := bNode.Rotation;
  aNode.Color := bNode.Color;
  aNode.Scale := bNode.Scale;

  aNode.AlignH := bNode.AlignH;
  aNode.AlignV := bNode.AlignV;

  aNode.Alpha := bNode.Alpha;

  aNode.MouseOverEvent := bNode.MouseOverEvent;
  aNode.MouseClickEvent := bNode.MouseClickEvent;

  aNode.Parent := bNode.Parent;

  aNode.Visible := bNode.Visible;
end;

constructor TelNode.Create;
begin
  Position.Clear;
  Offset.Position.Clear;
  Offset.Rotation.Clear;

  Rotation.Angle := 0;
  Rotation.Vector := makeV3f(0.0, 0.0, 1.0);

  Color := makeCol(255, 255, 255, 255);
  Scale := makeV2f(1.0, 1.0);
  fVisible := true;

  fAlignH := ahNone;
  fAlignV := avNone;

  fParent := nil;

  MouseOverEvent := nil;
  MouseClickEvent := nil;
end;

destructor TelNode.Destroy;
begin
  MouseOverEvent := nil;
  MouseClickEvent := nil;
end;

{$IFDEF FPC}
  {$Note Fix node alignment}
{$ENDIF}

procedure TelNode.SetAlignH(Value: TAlignHorizontal);
var
  parentWidth: Integer;
begin
  fAlignH := Value;
  parentWidth := 0;

  if fAlignH <> ahNone then
  begin

    //if (fParent = nil) then parentWidth := WindowManager.CurrentWindow.Width
      //else parentWidth := Parent.Width;

    case fAlignH of
      ahLeft: Position.X := 0;
      ahCenter: Position.X := (parentWidth - Self.Width) div 2;
      ahRight: Position.X := parentWidth - Self.Width;
    end;
  end;
end;

// I WOULD LIKE TO BE FIXED AS WELL

procedure TelNode.SetAlignV(Value: TAlignVertical);
var
  parentHeight: Integer;
begin
  fAlignV := Value;
  parentHeight := 0;

  if fAlignV <> avNone then
  begin

    //if (fParent = nil) then parentHeight := WindowManager.CurrentWindow.Height
      //else parentHeight := Parent.Height;

    case fAlignV of
      avTop: Position.Y := 0;
      avCenter: Position.Y := (parentHeight - Self.Height) div 2;
      avBottom: Position.Y := parentHeight - Self.Height;
    end;
  end;
end;

// HEY AGAIN, NEEDS TO BE FIXED TOO

procedure TelNode.AddChild(aNode: INode);
begin
  //aNode.Parent := Self;

  //aNode.UpdateNodePosition();
end;

// FIX ME ALSO

// Update position, which has to be relative to parent node
procedure TelNode.UpdateNodePosition();
begin
  //Self.Position := makeV3f(Parent.Position.X - Self.Position.X,
  //                         Parent.Position.Y - Self.Position.Y,
  //                         Parent.Position.Z - Self.Position.Z);
end;

function TelNode.GetAlpha(): Byte;
begin
  Result := Color.A;
end;

procedure TelNode.SetAlpha(anAlpha: Byte);
begin
  Color.A := anAlpha;
end;

procedure TelNode.Move(Delta: TelVector3f);
begin
  Position.X := Position.X + Delta.X;
  Position.Y := Position.Y + Delta.Y;
  Position.Z := Position.Z + Delta.Z;
end;

procedure TelNode.Move(Delta: TelVector2i);
begin
  Position.X := Position.X + Delta.X;
  Position.Y := Position.Y + Delta.Y;
end;

procedure TelNode.Update(dt: Double = 0.0);
begin
  (*if (Assigned(Parent)) then
  begin
    Self.Position.X := Parent.Position.X + Self.Position.X;
    Self.Position.Y := Parent.Position.Y + Self.Position.Y;
    Self.Position.Z := Parent.Position.Z + Self.Position.Z;
  end;*)

  if (Assigned(MouseOverEvent)) then if OnMouseOver then MouseOverEvent(Self);
  if (Assigned(MouseClickEvent)) then if OnClick then MouseClickEvent(Self);
end;

constructor TelNodeList.Create;
begin
  inherited;

  fNodeList := TList.Create;
end;

destructor TelNodeList.Destroy;
var
  i: Integer;
begin
  for i := 0 to fNodeList.Count - 1 do
  begin
    TelNode(fNodeList[i]).Destroy;
  end;
  fNodeList.Free;

  inherited;
end;

function TelNodeList.GetCount: Integer;
begin
  Result := fNodeList.Count;
end;

function TelNodeList.Get(Index: Integer): TelNode;
begin
  if ((Index >= 0) and (Index <= fNodeList.Count - 1)) then Result := TelNode(fNodeList[Index]);
end;

function TelNodeList.GetPos(Index: String): Integer;
Var a, TMP: Integer;
Begin
  Try
    For a := 0 To fNodeList.Count - 1 Do
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

procedure TelNodeList.Put(Index: Integer; const Item: TelNode);
var
  TmpNode: TelNode;
begin
  if ((Index >= 0) and (Index <= fNodeList.Count - 1)) then
  begin
    TmpNode := Get(Index);
    TmpNode.Destroy;
    Insert(Index, Item);
  end;

end;

procedure TelNodeList.PutS(Index: String; const Item: TelNode);
var
  TMP: Integer;
  TmpNode: TelNode;
Begin
  if (Index <> '') then
  begin
    TmpNode := GetS(Index);
	if TmpNode <> nil then
	begin
	  TMP := GetPos(Index);
      TmpNode.Destroy;
      Insert(TMP, Item);
	end;
   end;
end;

function TelNodeList.GetS(Index: String): TelNode;
Var TMP: Integer;
Begin
  TMP := GetPos(Index);
  if TMP >= 0 then Result := TelNode(fNodeList[TMP])
			  else Result := nil;
end;

procedure TelNodeList.Insert(Index: Integer; Node: TelNode);
begin
  if ((Index >= 0) and (Index <= fNodeList.Count - 1)) then fNodeList.Insert(Index, Node);
end;

function TelNodeList.Add(Node: TelNode): Integer;
begin
  Result := fNodeList.Add(Node);
end;

procedure TelNodeList.Delete(Index: Integer);
var
  TmpNode: TelNode;
begin
  if ((Index >= 0) and (Index <= fNodeList.Count - 1)) then
  begin
    TmpNode := Get(Index);
    TmpNode.Destroy;
    fNodeList.Delete(Index);
  end;

end;


end.
