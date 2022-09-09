unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.Generics.Collections, System.IOUtils, FMX.Layouts, Fruits_Controller;

type

  TForm1 = class(TForm)
    Image1: TImage;
    GridPanelLayout1: TGridPanelLayout;
    VertScrollBox1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Fruits_Controller: TFruitsController;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Fruits_Controller := TFruitsController.Create;

  {$IFDEF MSWINDOWS}
  Fruits_Controller.AddFruitsFromFolder('D:\RokWeb\Work\Фарминг\SortedIcons\Icons\NoRamka\FoodIconPack\T');
  {$ELSE}
  Fruits_Controller.AddFruitsFromFolder(TPath.GetDocumentsPath);
  {$ENDIF}

  Fruits_Controller.SetView(Image1);

  Fruits_Controller.SetGrid(GridPanelLayout1, 3);
end;

end.
