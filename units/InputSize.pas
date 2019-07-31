unit InputSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, ExtCtrls, Buttons,
  jsCommon, settings, Vcl.Samples.Spin;

type
  TfrmInputSize = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    edWidth: TSpinEdit;
    edHeight: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    r_ok: boolean;
  public
    AWidth: integer;
    AHeight: integer;
  end;

implementation

{$R *.dfm}

procedure TfrmInputSize.btnOKClick(Sender: TObject);
begin
  AHeight := edHeight.Value;
  AWidth := edWidth.Value;
  r_ok := true;
  frmSettings.ACrossWidth := AWidth;
  frmSettings.ACrossHeight := AHeight;
  self.Close;
end;

procedure TfrmInputSize.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if r_ok then self.ModalResult := mrOk
  else self.ModalResult := mrCancel;
  Action := caHide;
end;

procedure TfrmInputSize.FormCreate(Sender: TObject);
begin
  r_ok := false;
  edWidth.MaxValue := PUZZLESIZELIMIT;
  edHeight.MaxValue := PUZZLESIZELIMIT;
  AWidth := frmSettings.ACrossWidth;
  AHeight := frmSettings.ACrossHeight;
end;

procedure TfrmInputSize.FormShow(Sender: TObject);
begin
  edWidth.Value := AWidth;
  edHeight.Value := AHeight;
end;

procedure TfrmInputSize.btnCancelClick(Sender: TObject);
begin
  r_ok := false;
  self.Close;
end;

end.
