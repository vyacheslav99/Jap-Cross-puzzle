unit propertys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, settings, jsCommon,
  Mask, Vcl.Samples.Spin;

type
  TFProps = class(TForm)
    Label24: TLabel;
    cbDifficulty: TComboBox;
    Label4: TLabel;
    edName: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edWidth: TSpinEdit;
    Label2: TLabel;
    edHeight: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    rslt: boolean;
    function GetDifficulty: TDifficulty;
    procedure SetDifficulty(value: TDifficulty);
    function GetPuzzleName: string;
    procedure SetPuzzleName(value: string);
    function GetWidth: integer;
    procedure SetWidth(value: integer);
    function GetHeight: integer;
    procedure SetHeight(value: integer);
  public
    property Difficulty: TDifficulty read GetDifficulty write SetDifficulty;
    property PuzzleName: string read GetPuzzleName write SetPuzzleName;
    property AWidth: integer read GetWidth write SetWidth;
    property AHeight: integer read GetHeight write SetHeight;
    function Exec: boolean;
  end;

implementation

{$R *.dfm}

{ TFProps }

procedure TFProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TFProps.FormCreate(Sender: TObject);
begin
  edWidth.MaxValue := PUZZLESIZELIMIT;
  edHeight.MaxValue := PUZZLESIZELIMIT;
end;

procedure TFProps.FormShow(Sender: TObject);
begin
  rslt := false;
  edNameChange(edName);
end;

function TFProps.GetDifficulty: TDifficulty;
begin
  result := TDifficulty(cbDifficulty.ItemIndex);
end;

function TFProps.GetHeight: integer;
begin
  result := edHeight.Value;
end;

procedure TFProps.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFProps.btnOKClick(Sender: TObject);
begin
  rslt := true;
  Close;
end;

procedure TFProps.edNameChange(Sender: TObject);
begin
  btnOK.Enabled := Trim(edName.Text) <> '';
end;

function TFProps.Exec: boolean;
begin
  ShowModal;
  result := rslt;
end;

function TFProps.GetPuzzleName: string;
begin
  result := edName.Text;
end;

function TFProps.GetWidth: integer;
begin
  result := edWidth.Value;
end;

procedure TFProps.SetDifficulty(value: TDifficulty);
begin
  cbDifficulty.ItemIndex := Ord(value);
end;

procedure TFProps.SetHeight(value: integer);
begin
  edHeight.Value := value;
end;

procedure TFProps.SetPuzzleName(value: string);
begin
  edName.Text := value;
end;

procedure TFProps.SetWidth(value: integer);
begin
  edWidth.Value := value;
end;

end.
