unit selbox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, settings;

type
  TfSelectBox = class(TForm)
    lblText: TLabel;
    Image1: TImage;
    btnNew: TBitBtn;
    btnLoad: TBitBtn;
    btnCancel: TBitBtn;
    chbRemember: TCheckBox;
    Bevel1: TBevel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
  private
    rslt: integer;
  public
    { Public declarations }
  end;

function SelectBox(ACaption, AMessage: string): integer;

implementation

{$R *.dfm}

function SelectBox(ACaption, AMessage: string): integer;
var
  fSelBox: TfSelectBox;

begin
  fSelBox := TfSelectBox.Create(Application);
  fSelBox.Caption := ACaption;
  fSelBox.lblText.Caption := AMessage;
  fSelBox.ShowModal;
  result := fSelBox.rslt;
  fSelBox.Free;
end;

procedure TfSelectBox.btnCancelClick(Sender: TObject);
begin
  rslt := 0;
  self.Close;
end;

procedure TfSelectBox.btnLoadClick(Sender: TObject);
begin
  rslt := 2;
  self.Close;
end;

procedure TfSelectBox.btnNewClick(Sender: TObject);
begin
  rslt := 1;
  self.Close;
end;

procedure TfSelectBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if chbRemember.Checked then
  begin
    if rslt = 0 then frmSettings.AOnGameChange := 3;                                 
    if rslt = 1 then frmSettings.AOnGameChange := 0;
    if rslt = 2 then frmSettings.AOnGameChange := 1;
  end;
  Action := caHide;
end;

procedure TfSelectBox.FormShow(Sender: TObject);
begin
  rslt := 0;
end;

end.
