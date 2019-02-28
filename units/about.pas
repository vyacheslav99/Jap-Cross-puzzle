unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ShellApi, jsCommon;

type
  TfAbout = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    lblVersion: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel2: TBevel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure Label5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfAbout.FormClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfAbout.FormShow(Sender: TObject);
begin
  lblVersion.Caption := GetVersion;
end;

procedure TfAbout.Label5Click(Sender: TObject);
begin
  ShellExecute(0, pchar('open'), pchar('mailto: warlock999@mail.ru'), '', '', SW_SHOWNORMAL);
end;

procedure TfAbout.Label5MouseEnter(Sender: TObject);
begin
  Label5.Font.Style := Label5.Font.Style + [fsUnderline];
end;

procedure TfAbout.Label5MouseLeave(Sender: TObject);
begin
  Label5.Font.Style := Label5.Font.Style - [fsUnderline];
end;

end.
