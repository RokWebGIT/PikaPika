unit Fruit;

interface

uses
  fmx.Graphics, system.Classes, system.SysUtils;

type

  TFruit = class
  private
    fName: shortstring;
    fBitmap: TBitmap;
    fSound: TMemoryStream;
  public
    property Name: shortstring read fName write fName;
    property Bitmap: TBitmap read fBitmap write fBitmap;
    property Sound: TMemoryStream read fSound write fSound;
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

  constructor TFruit.Create;
  begin
    Sound := TMemoryStream.Create;
    Bitmap := TBitMap.Create;
  end;

  destructor TFruit.Destroy;
  begin
    FreeAndNil(Sound);
    FreeAndNil(Bitmap);
    inherited;
  end;

end.
