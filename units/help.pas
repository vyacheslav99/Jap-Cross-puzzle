unit help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, OleCtrls, SHDocVw, settings, ActnList;

type
  TfrmHelp = class(TForm)
    WBrouser: TWebBrowser;
    ActionList1: TActionList;
    aExit: TAction;
    procedure aExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmHelp.aExitExecute(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmHelp.FormCreate(Sender: TObject);
begin
  self.Height := 700;
  self.Width := 850;
end;

procedure TfrmHelp.FormShow(Sender: TObject);
begin
  WBrouser.Navigate(frmSettings.HelpFile);
end;

end.
