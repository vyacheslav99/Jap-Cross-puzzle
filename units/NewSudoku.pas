unit NewSudoku;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, select_puzzle,
  settings, jsCommon;

type
  TfNewSudoku = class(TForm)
    Label1: TLabel;
    lblSudoku: TLabel;
    btnSelectSudoku: TBitBtn;
    Bevel2: TBevel;
    Label24: TLabel;
    cbDifficulty: TComboBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
    chbFastSudoku: TCheckBox;
    Bevel3: TBevel;
    procedure btnSelectSudokuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FName: string;
    FDifficulty: TDifficulty;
    procedure SetSName(value: string);
    procedure SetDifficulty(value: TDifficulty);
  public
    r_ok: boolean;
    property AName: string read FName write SetSName;
    property ADifficulty: TDifficulty read FDifficulty write SetDifficulty;
  end;

function StartSudoku(var SName: string; var sDifficulty: TDifficulty): boolean;

implementation

uses main;

{$R *.dfm}

function StartSudoku(var SName: string; var sDifficulty: TDifficulty): boolean;
var
  fNewSudoku: TfNewSudoku;

begin
  fNewSudoku := TfNewSudoku.Create(frmMain);
  fNewSudoku.AName := SName;
  fNewSudoku.ADifficulty := sDifficulty;
  fNewSudoku.ShowModal;
  result := fNewSudoku.r_ok;
  if result then
  begin
    SName := fNewSudoku.AName;
    sDifficulty := fNewSudoku.ADifficulty;
  end;
  fNewSudoku.Free;
end;

procedure TfNewSudoku.btnCancelClick(Sender: TObject);
begin
  r_ok := false;
  self.Close;
end;

procedure TfNewSudoku.btnOKClick(Sender: TObject);
begin
  frmSettings.AFastSudoku := chbFastSudoku.Checked;
  frmSettings.LastSudoku := ChangeFileExt(AName, '');
  ADifficulty := TDifficulty(cbDifficulty.ItemIndex);
  r_ok := true;
  self.Close;
end;

procedure TfNewSudoku.btnSelectSudokuClick(Sender: TObject);
var
  OPDialog: TfrmOpenPuzzle;
  pf: string;

begin
  frmSettings.LastSudoku := ChangeFileExt(AName, '');
  OPDialog := TfrmOpenPuzzle.Create(self);
  if OPDialog.Execute(pf, cgSudoku, false, false) then
  begin
    AName := pf;
    ADifficulty := frmSettings.ADifficulty;
  end;
end;

procedure TfNewSudoku.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfNewSudoku.FormCreate(Sender: TObject);
begin
  r_ok := false;
end;

procedure TfNewSudoku.SetDifficulty(value: TDifficulty);
begin
  FDifficulty := value;
  cbDifficulty.ItemIndex := Ord(value);
end;

procedure TfNewSudoku.SetSName(value: string);
begin
  FName := value;
  lblSudoku.Caption := ChangeFileExt(value, '');
end;

end.
