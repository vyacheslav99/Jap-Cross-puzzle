unit Records;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, {XMLDoc, xmldom, XMLIntf,}
  ExtCtrls, Buttons, settings, jsCommon, GridsEh, DBGridEh, Math, imgUtils, MemTableDataEh, MemTableEh, Db, DBGridEhGrouping;

type
  TfrmRecords = class(TForm)
    Panel1: TPanel;
    btnClear: TBitBtn;
    btnClose: TBitBtn;
    dsoStat: TDataSource;
    Panel2: TPanel;
    dbgStat: TDBGridEh;
    rbnAllGames: TRadioButton;
    rbnCurrGame: TRadioButton;
    mtStat: TMemTableEh;
    mtStatGAME: TIntegerField;
    mtStatDIFF: TIntegerField;
    mtStatSZW: TIntegerField;
    mtStatSZH: TIntegerField;
    mtStatUSER: TStringField;
    mtStatcUser: TStringField;
    mtStatNAME: TStringField;
    mtStatcName: TStringField;
    mtStatcDiff: TStringField;
    mtStatcTime: TTimeField;
    mtStatTIME: TFloatField;
    mtStatLAST: TIntegerField;
    mtStatSCORE: TIntegerField;
    procedure rbnAllGamesClick(Sender: TObject);
    procedure dbgStatGetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure mtStatCalcFields(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fcol1, fcol2, fcol3: integer;
    CurrGame: TCurrGame;
    floading: boolean;
    procedure LoadRecords(AGame: TCurrGame);
    procedure InsertGameNames(AGame: TCurrGame);
    procedure ClearAll;
  public
  end;

implementation

uses main;

{$R *.dfm}

procedure TfrmRecords.btnClearClick(Sender: TObject);
begin
  if Application.MessageBox('Вы уверены, что надо сбросить все результаты?', pchar(Application.Title), MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
    DeleteFile(frmSettings.RecordsFile);
    ClearAll;
  end;
end;

procedure TfrmRecords.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmRecords.ClearAll;
begin
  mtStat.Close;
end;

procedure TfrmRecords.dbgStatGetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  ds: TDataSet;
  c: integer;

begin
  ds := TDBGridEh(Sender).DataSource.DataSet;
  if ds.FieldByName('LAST').AsInteger = 2 then
  begin
    AFont.Color := clMaroon;
    Background := clSkyBlue;
    AFont.Style := AFont.Style + [fsBold] + [fsUnderline];
  end else
  begin
    if ds.FieldByName('LAST').AsInteger = 1 then AFont.Style := AFont.Style + [fsBold]
    else AFont.Style := [];
    case TCurrGame(ds.FieldByName('GAME').AsInteger) of
      cgJCrossPuzzle: c := fcol1;
      cgCCrossPuzzle: c := fcol2;
      cgSudoku: c := fcol3;
      else c := clBlack;
    end;
    AFont.Color := c;
    Background := clBtnFace; //InvertColor(c);
  end;
end;

procedure TfrmRecords.mtStatCalcFields(DataSet: TDataSet);
begin
  if DataSet.FieldByName('LAST').AsInteger = 2 then
    DataSet.FieldByName('cUser').AsString := GetGameName(TCurrGame(DataSet.FieldByName('GAME').AsInteger), lRU)
  else begin
    DataSet.FieldByName('cName').AsString := DataSet.FieldByName('NAME').AsString + ' (' + IntToStr(DataSet.FieldByName('SZW').AsInteger) +
      'x' + IntToStr(DataSet.FieldByName('SZH').AsInteger) + ')';
    DataSet.FieldByName('cUser').AsString := DataSet.FieldByName('USER').AsString;
    DataSet.FieldByName('cDiff').AsString := DifficultyAsText(TDifficulty(DataSet.FieldByName('DIFF').AsInteger), lRU);
    DataSet.FieldByName('cTime').AsDateTime := DataSet.FieldByName('TIME').AsFloat;
  end;
end;

procedure TfrmRecords.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRecords.FormCreate(Sender: TObject);
begin
  Randomize;
  fcol1 := Random(RGB(64, 64, 64));
  fcol2 := Random(RGB(64, 64, 64));
  fcol3 := Random(RGB(64, 64, 64));
end;

procedure TfrmRecords.FormShow(Sender: TObject);
begin
  floading := true;
  try
    CurrGame := frmMain.CurrGame;
    rbnCurrGame.Caption := GetGameName(CurrGame, lRU);
    if CurrGame = cgNone then
    begin
      rbnCurrGame.Enabled := false;
      rbnAllGames.Checked := true;
    end;
    LoadRecords(CurrGame);
  finally
    floading := false;
  end;
end;

procedure TfrmRecords.LoadRecords(AGame: TCurrGame);
begin
  mtStat.Close;
  mtStat.CreateDataSet;
  try
    LoadStat(mtStat, frmSettings.RecordsFile, AGame, false);
  except
    on e: Exception do
      Application.MessageBox(pchar('Ошибка! Не удалось загрузить таблицу результатов!'#13#10 + e.Message), pchar(Application.Title),
        MB_OK + MB_ICONERROR);
  end;
  if not mtStat.Active then mtStat.Open;
  InsertGameNames(AGame);
  if not mtStat.Locate('LAST', 1, []) then mtStat.Locate('LAST', 0, []);
end;

procedure TfrmRecords.rbnAllGamesClick(Sender: TObject);
begin
  if floading then exit;
  if rbnAllGames.Checked then LoadRecords(cgNone)
  else if rbnCurrGame.Checked then LoadRecords(CurrGame);
end;

procedure TfrmRecords.InsertGameNames(AGame: TCurrGame);
var
  i: integer;

begin
  if (not mtStat.Active) or mtStat.IsEmpty then exit;
  mtStat.DisableControls;
  try
    if mtStat.IsEmpty then
    begin
      mtStat.Insert;
      mtStat.FieldByName('GAME').AsInteger := Ord(AGame);
      mtStat.FieldByName('LAST').AsInteger := 2;
      mtStat.Post;
    end else
    begin
      mtStat.First;
      i := mtStat.FieldByName('GAME').AsInteger;
      while not mtStat.Eof do
      begin
        if (mtStat.RecNo = 1) or (i <> mtStat.FieldByName('GAME').AsInteger) then
        begin
          i := mtStat.FieldByName('GAME').AsInteger;
          mtStat.Insert;
          mtStat.FieldByName('GAME').AsInteger := i;
          mtStat.FieldByName('LAST').AsInteger := 2;
          mtStat.Post;
          mtStat.Next;
        end;
        mtStat.Next;
      end;
    end;
  finally
    mtStat.EnableControls;
  end;
end;

{procedure TfrmRecords.LoadRecords(AGameNode: string);
var
  i, j, g: integer;
  _top: integer;
  b: TBevel;
  lbcol: TColor;
  xDoc: IXMLDocument;
  xMain, xGameNode, xDiffNode, xUserNode: IXMLNode;
  s: string;

begin
  if not FileExists(frmSettings.RecordsFile) then exit;
  xDoc := TXMLDocument.Create(frmSettings.RecordsFile) as IXMLDocument;
  xDoc.Active := true;
  xMain := xDoc.Node.ChildNodes.FindNode('Records');
  if xMain = nil then exit;
  _top := 20;
  Randomize;
  lbcol := Random(RGB(32, 32, 32));

  //игра
  for g := 0 to xMain.ChildNodes.Count - 1 do
  begin
    xGameNode := xMain.ChildNodes.Get(g);
    if xGameNode = nil then exit;
    if (AGameNode <> '') and (xGameNode.NodeName <> AGameNode) then continue;
    if (g = 0) then Bevel1.Height := 26;

    _top := _top + 20;
    Bevel1.Height := Bevel1.Height + 20;
    SetLength(aRecords, Length(aRecords) + 1);
    aRecords[High(aRecords)] := TLabel.Create(self);
    aRecords[High(aRecords)].Caption := TranslateGameName(xGameNode.NodeName);
    aRecords[High(aRecords)].Font.Style := aRecords[High(aRecords)].Font.Style + [fsBold] + [fsUnderline];
    aRecords[High(aRecords)].Font.Color := Random(RGB(32, 32, 32));
    aRecords[High(aRecords)].Top := _top;
    aRecords[High(aRecords)].Left := Label1.Left;
    aRecords[High(aRecords)].Parent := ScrollBox1;
    aRecords[High(aRecords)].Visible := true;
    if (g <> 0) then Bevel1.Height := Bevel1.Height + 20;
    _top := _top + 20;

    //переберем сложности
    for i := 0 to xGameNode.ChildNodes.Count - 1 do
    begin
      lbcol := InvertColor(lbcol);
      //lbcol := Random(RGB(255, 255, 255));
      xDiffNode := xGameNode.ChildNodes.Get(i);
      if xDiffNode = nil then continue;

      //переберем юзеров
      for j := 0 to xDiffNode.ChildNodes.Count - 1 do
      begin
        xUserNode := xDiffNode.ChildNodes.Get(j);
        if xUserNode = nil then continue;

        SetLength(aRecords, Length(aRecords) + 1);
        aRecords[High(aRecords)] := TLabel.Create(self);
        aRecords[High(aRecords)].Caption := VarToStr(xUserNode.Attributes['Name']);
        aRecords[High(aRecords)].Font.Style := aRecords[High(aRecords)].Font.Style + [fsBold];
        aRecords[High(aRecords)].Font.Color := lbcol;
        aRecords[High(aRecords)].Top := _top;
        aRecords[High(aRecords)].Left := Label1.Left;
        aRecords[High(aRecords)].Parent := ScrollBox1;
        aRecords[High(aRecords)].Visible := true;
        SetLength(aRecords, Length(aRecords) + 1);
        aRecords[High(aRecords)] := TLabel.Create(self);
        aRecords[High(aRecords)].Caption := VarToStr(xUserNode.Attributes['Game']);
        aRecords[High(aRecords)].Font.Color := lbcol;
        aRecords[High(aRecords)].Top := _top;
        aRecords[High(aRecords)].Left := Label2.Left;
        aRecords[High(aRecords)].Parent := ScrollBox1;
        aRecords[High(aRecords)].Visible := true;
        SetLength(aRecords, Length(aRecords) + 1);
        aRecords[High(aRecords)] := TLabel.Create(self);
        s := xDiffNode.NodeName;
        if s[1] = 'D' then Delete(s, 1, 1)
        else s := TranslateDifficulty(s);
        s := ReplaceEx(s, ['_'], #32, []);
        aRecords[High(aRecords)].Caption := s;
        aRecords[High(aRecords)].Font.Color := lbcol;
        aRecords[High(aRecords)].Top := _top;
        aRecords[High(aRecords)].Left := Label4.Left;
        aRecords[High(aRecords)].Parent := ScrollBox1;
        aRecords[High(aRecords)].Visible := true;
        SetLength(aRecords, Length(aRecords) + 1);
        aRecords[High(aRecords)] := TLabel.Create(self);
        aRecords[High(aRecords)].Caption := VarToStr(xUserNode.Attributes['Time']);
        aRecords[High(aRecords)].Font.Color := lbcol;
        aRecords[High(aRecords)].Top := _top;
        aRecords[High(aRecords)].Left := Label3.Left;
        aRecords[High(aRecords)].Parent := ScrollBox1;
        aRecords[High(aRecords)].Visible := true;
        _top := _top + 20;
        Bevel1.Height := aRecords[High(aRecords)].Top + aRecords[High(aRecords)].Height;
        xUserNode := nil;
      end;
      b := TBevel.Create(self);
      b.Anchors := Bevel2.Anchors;
      b.Height := Bevel2.Height;
      b.Left := Bevel2.Left;
      b.Width := Bevel2.Width;
      b.Shape := bsTopLine;
      b.Style := bsLowered;
      b.Top := aRecords[High(aRecords)].Top + aRecords[High(aRecords)].Height + 3;
      b.Parent := ScrollBox1;
      b.Visible := true;
      xDiffNode := nil;
    end;
  end;
end;
 }
end.
