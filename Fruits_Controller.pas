unit Fruits_Controller;

interface

uses

fmx.Graphics, fmx.types, fmx.Objects, system.Classes, system.SysUtils,
System.Generics.Collections, fmx.Layouts, system.Types, system.IOUtils,
system.Math, fruit;

type

  TFruitsController = class
  private
    fFruits: TObjectList<TFruit>;
    fCurrent: integer;
    fView: TImage;
    fGrid:  TGridPanelLayout;
  protected
    procedure ViewOnClick(Sender: TObject);
    procedure ViewOnTap(Sender: TObject; const Point: TPointF);
    procedure GridOnClick(Sender: TObject);
    procedure GridOnTap(Sender: TObject; const Point: TPointF);
    procedure SetCurrent(aIndex: integer); overload;
  public
    property Fruits: TObjectList<TFruit> read fFruits write fFruits;
    property Current: integer read fCurrent write SetCurrent;
    property View: TImage read fView write fView;
    property Grid: TGridPanelLayout read fGrid write fGrid;
    constructor Create;
    destructor Destroy(); override;
    function GetCurrent: TFruit;
    function GetNext: TFruit;
    function GetPrevious: TFruit;
    procedure AddFruitsFromFolder(aPath: string);
    procedure SetCurrent(aFruit: TFruit); overload;
    procedure SetView(aImage: TImage);
    procedure SetGrid(aGrid: TGridPanelLayout; const colcount: integer);
  end;

implementation

procedure TFruitsController.AddFruitsFromFolder(aPath: string);
  var
    Fruits: array of TFruit;
    PicPathList: TStringDynArray;
    PicPath: String;
begin
  PicPathList := TDirectory.GetFiles(aPath, '*.png');

  SetLength(Fruits, 0);

  for PicPath in PicPathList do
  begin
    SetLength(Fruits, Length(Fruits)+1);
    Fruits[Length(Fruits)-1] := TFruit.Create;
    Fruits[Length(Fruits)-1].Bitmap.LoadFromFile(PicPath);
  end;

  Self.Fruits.AddRange(Fruits);
end;

constructor TFruitsController.Create;
begin
  Fruits := TObjectList<TFruit>.Create;
  Fruits.OwnsObjects := true;
  fCurrent := 0;
end;

destructor TFruitsController.Destroy;
begin
  if assigned(grid) then
  begin
    grid.ControlCollection.Clear;
    grid.RowCollection.Clear;
    grid.ColumnCollection.Clear;
  end;

  FreeAndNil(Fruits);
  inherited;
end;

function TFruitsController.GetCurrent: TFruit;
begin
  if (Fruits.Count>0) and Assigned(Fruits.Items[Current]) then
    result := Fruits.Items[Current] else raise Exception.Create('No fruits!');
end;

function TFruitsController.GetNext: TFruit;
begin
  if (Fruits.Count=0) then
    raise Exception.Create('No fruits!');
  if (Current+1)>=Fruits.Count then
    Current := 0 else Current := Current + 1;
  result := Fruits.Items[Current];
end;

function TFruitsController.GetPrevious: TFruit;
begin
  if (Fruits.Count=0) then
    raise Exception.Create('No fruits!');
  if (Current-1)<=0 then
    Current := Fruits.Count else Current := Current - 1;
  result := Fruits.Items[Current];
end;

procedure TFruitsController.GridOnClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  SetCurrent((Sender as TImage).TagObject as TFruit);
  {$ENDIF}
end;

procedure TFruitsController.GridOnTap(Sender: TObject; const Point: TPointF);
begin
  SetCurrent((Sender as TImage).TagObject as TFruit);
end;

procedure TFruitsController.SetCurrent(aFruit: TFruit);
begin
  fCurrent := Fruits.IndexOf(aFruit);
  if Assigned(View) then View.Bitmap := aFruit.Bitmap;
end;

procedure TFruitsController.SetGrid(aGrid: TGridPanelLayout; const colcount: integer);
  var
  i: integer;
  Image: TImage;
  rowcount: integer;
begin
  fGrid := aGrid;

  Grid.RowCollection.BeginUpdate;
  Grid.ColumnCollection.BeginUpdate;

  Grid.ControlCollection.Clear;
  Grid.RowCollection.Clear;
  Grid.ColumnCollection.Clear;

  rowcount := ceil(fruits.Count/colcount);

  for i := 1 to rowcount do
    with Grid.RowCollection.Add do
    begin
      SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
      Value := 100 / rowcount;
    end;

  for i := 1 to ColCount do
    with Grid.ColumnCollection.Add do
    begin
      SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
      Value := 100 / colcount;
    end;

  for var Fruit in Fruits do
  begin
    image := TImage.Create(Grid);
    image.parent := Grid;
    image.Visible := true;
    Image.Name := Format('Fruit%d', [Fruits.IndexOf(Fruit)]);
    image.Bitmap := Fruit.Bitmap;
    image.Align := TAlignLayout.Client;
    image.TagObject := Fruit;
    image.OnClick := GridOnClick;
    image.OnTap := GridOnTap;
    Grid.ControlCollection.AddControl(Image);
  end;

  Grid.ColumnCollection.EndUpdate;
  Grid.RowCollection.EndUpdate;
end;

procedure TFruitsController.SetCurrent(aIndex: integer);
begin
  if (aIndex<0) or (aIndex>Fruits.Count) or (Fruits.Count=0) then
    raise Exception.Create('No fruits!');
  SetCurrent(Fruits.Items[aIndex]);
end;

procedure TFruitsController.SetView(aImage: TImage);
begin
  fView := aImage;
  View.Bitmap := GetCurrent.Bitmap;
  View.OnClick := ViewOnClick;
  View.OnTap := ViewOnTap;
end;

procedure TFruitsController.ViewOnClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  GetNext;
  {$ENDIF}
end;

procedure TFruitsController.ViewOnTap(Sender: TObject; const Point: TPointF);
begin
  GetNext;
end;

end.
