unit splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, jpeg;

type
  TfSplash = class(TForm)
    Image1: TImage;
    tmrClose: TTimer;
    tmrAlpha: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrCloseTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrAlphaTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    procedure IncAlphaBlend(n: integer);
  public
    { Public declarations }
  end;

var
  fSplash: TfSplash;

implementation

{$R *.dfm}

procedure TfSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfSplash.FormShow(Sender: TObject);
begin
  tmrClose.Enabled := true;
  tmrAlpha.Enabled := true;
end;

procedure TfSplash.Image1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TfSplash.IncAlphaBlend(n: integer);
var
  x: integer;

begin
  x := self.AlphaBlendValue;
  while (x <= 255) and (x >= 0) do
  begin
    self.AlphaBlendValue := x;
    x := x + n;
    sleep(30);
  end;
end;

procedure TfSplash.tmrAlphaTimer(Sender: TObject);
begin
  tmrAlpha.Enabled := false;
  IncAlphaBlend(10);
end;

procedure TfSplash.tmrCloseTimer(Sender: TObject);
begin
  tmrClose.Enabled := false;
  IncAlphaBlend(-20);
  self.Close;
end;

end.
