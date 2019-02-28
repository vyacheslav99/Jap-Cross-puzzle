unit frmCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, {XMLDoc, xmldom, XMLIntf,}
  frxClass, ExtCtrls, pgrid, Records, settings, jsCommon, ExtDlgs, MemTableDataEh, MemTableEh, Db;

type
  TSetActionButtons = procedure (Val: boolean) of object;

  TCommonFrame = class(TFrame)
    ScrollBox1: TScrollBox;
    OpenDialog: TOpenDialog;
    frxPrintList: TfrxReport;
    tmrResize: TTimer;
    OpenPicDialog: TOpenPictureDialog;
    mtStat: TMemTableEh;
    mtStatGAME: TIntegerField;
    mtStatDIFF: TIntegerField;
    mtStatSZW: TIntegerField;
    mtStatSZH: TIntegerField;
    mtStatUSER: TStringField;
    mtStatNAME: TStringField;
    mtStatTIME: TFloatField;
    mtStatLAST: TIntegerField;
    mtStatSCORE: TIntegerField;
    procedure tmrResizeTimer(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  private
    _changed: boolean;
    oldWidth: integer;
    oldHeight: integer;
    FCurrNum: integer;
  protected
    AVertLabels: array of TLabel;
    AHorLabels: array of TLabel;
    UndoData: TUndoData;
    UndoBlocks: array of integer;
    RedoData: TUndoData;
    RedoBlocks: array of integer;
    pgPuzzle: TPanelGrid;
    _vertline: TImage;
    _horizline: TImage;
    FSetProgress: TProgressFunc;
    FSetStatus: TSetStatusFunc;
    FGetStatus: TGetStatusFunc;
    FReset: TResetFunc;
    FtmrGame: TTimer;
    //FtmrAutosave: TTimer;
    FGameState: TGameState;
    FBrushColor: TColor;
    ChildClassName: string;
    Penalty: boolean;
    procedure RefreshGridMetrics; virtual;
    procedure RefreshLabels; virtual;
    procedure CreateLabels; virtual;
    procedure ClearLabels; virtual;
    procedure SetChanged(value: boolean); virtual;
    procedure SetRuler(CreateOnly: boolean = false); virtual;
    procedure HideRuler; virtual;
    procedure ClearAll; virtual;
    procedure CreatePanelGrid; virtual;
    procedure SetTransparentColor(Color: TColor); virtual; abstract;
    function GetTransparentColor: TColor; virtual; abstract;
    procedure SetBrushColor(Color: TColor); virtual; abstract;
    procedure AddToUndo(Point: TPoint; Value: integer); overload; virtual;
    procedure AddToUndo(X, Y: integer; Value: integer); overload; virtual;
    procedure AddToUBlocks(val: integer); virtual;
    function GetUndoItem(idx: integer): TUndoItem; virtual;
    function PopLastUndo: TUndoData; virtual;
    procedure ClearUndo;
    procedure AddToRedo(Point: TPoint; Value: integer); overload; virtual;
    procedure AddToRedo(X, Y: integer; Value: integer); overload; virtual;
    procedure AddToRBlocks(val: integer); virtual;
    function GetRedoItem(idx: integer): TUndoItem; virtual;
    function PopLastRedo: TUndoData; virtual;
    procedure ClearRedo;
    function CalcScores(diff: TDifficulty; gt: TCurrGame; x, y: integer; time: double): integer;
    function GetCurrCol: integer;
    function GetCurrRow: integer;
    function GetDefaultFileName(cg: TCurrGame): string;
  public
    GameType: TCurrGame;
    GameTime: TTime;
    StartTime: TTime;
    PSetActionButtons: TSetActionButtons;
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; virtual;

    procedure SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean); virtual; abstract;
    procedure SetRangeState(State: integer); virtual; abstract;
    procedure SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean = false); virtual; abstract;
    procedure Autosave; virtual;
    function SaveGame(filename: string; ShowDialog: boolean): boolean; virtual; abstract;
    procedure LoadGame; virtual; abstract;
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); virtual; abstract;
    procedure GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); virtual; abstract;
    procedure GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure GridCellKeyPress(Sender: TObject; var Key: Char); virtual; abstract;
    procedure UnSelectAll; virtual; abstract;
    procedure SelectAll; virtual; abstract;
    procedure SaveOldSettings; virtual; abstract;
    procedure SetSettings; virtual; abstract;
    function SaveCore: boolean; virtual; abstract;
    procedure PrintCross; virtual;
    procedure ShowPrompt; virtual; abstract;
    procedure SaveRecord(AGame: TCurrGame; ADifficulty: TDifficulty; AWidth, AHeight: integer; AUser, AName: string; ATime: TTime); virtual;
    procedure ShowRecords; virtual;
    procedure MoveToCell(Direction: TMoveDirection); virtual; abstract;
    procedure FillRandom(AOverwriteAll: boolean); virtual; abstract;
    procedure Invert(AInvertBg: boolean); virtual; abstract;
    procedure Undo; virtual; abstract;
    function CanUndo: boolean;
    procedure Redo; virtual; abstract;
    function CanRedo: boolean;
    procedure DeleteRow(RowNo: integer = -1; Count: integer = 1); virtual; abstract;
    procedure DeleteCol(ColNo: integer = -1; Count: integer = 1); virtual; abstract;
    procedure AddRow(Index: integer = -1; Count: integer = 1); virtual; abstract;
    procedure AddCol(Index: integer = -1; Count: integer = 1); virtual; abstract;
    procedure ShowTools(AShow: boolean); virtual; abstract;
    procedure ShowProps; virtual; abstract;
    property AChanged: boolean read _changed write SetChanged;
    property SetProgress: TProgressFunc read FSetProgress write FSetProgress;
    property SetStatus: TSetStatusFunc read FSetStatus write FSetStatus;
    property GetStatus: TGetStatusFunc read FGetStatus write FGetStatus;
    property AReset: TResetFunc read FReset write FReset;
    property GameState: TGameState read FGameState;
    property ATmrGame: TTimer read FtmrGame write FtmrGame;
    //property ATmrAutosave: TTimer read FtmrAutosave write FtmrAutosave;
    property TransparentColor: TColor read GetTransparentColor write SetTransparentColor;
    property BrushColor: TColor read FBrushColor write SetBrushColor;
    property CurrCol: integer read GetCurrCol;
    property CurrRow: integer read GetCurrRow;
  end;

const
  SCROLLBOX_DELTA = 4;

implementation

{$R *.dfm}

{ TCommonFrame }

procedure TCommonFrame.AddToUndo(Point: TPoint; Value: integer);
begin
  SetLength(UndoData, Length(UndoData) + 1);
  UndoData[High(UndoData)].p := Point;
  UndoData[High(UndoData)].val := Value;
end;

procedure TCommonFrame.AddToRBlocks(val: integer);
begin
  SetLength(RedoBlocks, Length(RedoBlocks) + 1);
  RedoBlocks[High(RedoBlocks)] := val;
end;

procedure TCommonFrame.AddToRedo(X, Y, Value: integer);
var
  p: TPoint;

begin
  p.X := X;
  p.Y := Y;
  AddToRedo(p, Value);
end;

procedure TCommonFrame.AddToRedo(Point: TPoint; Value: integer);
begin
  SetLength(RedoData, Length(RedoData) + 1);
  RedoData[High(RedoData)].p := Point;
  RedoData[High(RedoData)].val := Value;
end;

procedure TCommonFrame.AddToUBlocks(val: integer);
begin
  SetLength(UndoBlocks, Length(UndoBlocks) + 1);
  UndoBlocks[High(UndoBlocks)] := val;
end;

procedure TCommonFrame.AddToUndo(X, Y, Value: integer);
var
  p: TPoint;

begin
  p.X := X;
  p.Y := Y;
  AddToUndo(p, Value);
end;

procedure TCommonFrame.Autosave;
var
  c: boolean;

begin
  c := AChanged;
  SaveGame(frmSettings.SaveFolder + '\' + frmSettings.AUser + '-' + 'auto.' + GetExt(GameType, true), false);
  AChanged := c;
end;

function TCommonFrame.CalcScores(diff: TDifficulty; gt: TCurrGame; x, y: integer; time: double): integer;
var
  n, tc: integer;
  r: double;
  
begin
  if Penalty then n := Ord(diff) + 1
  else n := Ord(diff) + 2;
  case gt of
    cgSudoku: tc := 100;
    else tc := 10;
  end;
  r := (n * x * y) - (TimeToSeconds(time) / tc);
  result := Round(r);
  if result < 0 then result := 0;
end;

function TCommonFrame.CanRedo: boolean;
begin
  result := (Length(RedoData) > 0) and (Length(RedoBlocks) > 0);
end;

function TCommonFrame.CanUndo: boolean;
begin
  result := (Length(UndoData) > 0) and (Length(UndoBlocks) > 0);
end;

procedure TCommonFrame.ClearAll;
begin
  if (ATmrGame <> nil) then ATmrGame.Enabled := false;
  //if (ATmrAutosave <> nil) then ATmrAutosave.Enabled := false;
  AChanged := false;
  StartTime := 0;
  GameTime := 0;
  if Assigned(AReset) then AReset;
  HideRuler;
  pgPuzzle.Visible := false;
  pgPuzzle.RowCount := 0;
  pgPuzzle.ColCount := 0;
  ClearUndo;
  ClearRedo;
end;

procedure TCommonFrame.ClearLabels;
var
  i: integer;

begin
  for i := 0 to Length(AVertLabels) - 1 do
    if (AVertLabels[i] <> nil) and Assigned(AVertLabels[i]) then AVertLabels[i].Free;
  for i := 0 to Length(AHorLabels) - 1 do
    if (AHorLabels[i] <> nil) and Assigned(AHorLabels[i]) then AHorLabels[i].Free;
  SetLength(AVertLabels, 0);
  SetLength(AHorLabels, 0);
end;

procedure TCommonFrame.ClearRedo;
begin
  SetLength(RedoData, 0);
  SetLength(RedoBlocks, 0);
end;

procedure TCommonFrame.ClearUndo;
begin
  SetLength(UndoData, 0);
  SetLength(UndoBlocks, 0);
end;

constructor TCommonFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrNum := 0;
  oldWidth := ScrollBox1.Width;
  oldHeight := ScrollBox1.Height;
  CreatePanelGrid;
  SetRuler(true);
  AChanged := false;
  GameType := cgNone;
end;

procedure TCommonFrame.CreateLabels;
var
  i, x: integer;
  c: TPanelCell;

begin
  ClearLabels;

  for i := 0 to pgPuzzle.RowCount - 1 do
  begin
    c := pgPuzzle.Cell[i, pgPuzzle.ColCount - 1];
    if not Assigned(c) then continue;
    //x := c.Row - FPuzzle.TopIndent + 1;
    x := c.Row - pgPuzzle.FirstFatRow + 1;
    if (x > 0) and ((x mod 5) = 0) then
    begin
      SetLength(AVertLabels, Length(AVertLabels) + 1);
      AVertLabels[High(AVertLabels)] := TLabel.Create(self);
      AVertLabels[High(AVertLabels)].Parent := ScrollBox1;
      AVertLabels[High(AVertLabels)].Caption := IntToStr(x);
      AVertLabels[High(AVertLabels)].Left := pgPuzzle.Left + pgPuzzle.Width + 2;
      AVertLabels[High(AVertLabels)].Top := pgPuzzle.Top + c.Rect.Bottom - AVertLabels[High(AVertLabels)].Height - 2;
      AVertLabels[High(AVertLabels)].Visible := true;
    end;
  end;

  for i := 0 to pgPuzzle.ColCount - 1 do
  begin
    c := pgPuzzle.Cell[pgPuzzle.RowCount - 1, i];
    if not Assigned(c) then continue;
    //x := c.Col - FPuzzle.LeftIndent + 1;
    x := c.Col - pgPuzzle.FirstFatCol + 1;
    if (x > 0) and ((x mod 5) = 0) then
    begin
      SetLength(AHorLabels, Length(AHorLabels) + 1);
      AHorLabels[High(AHorLabels)] := TLabel.Create(self);
      AHorLabels[High(AHorLabels)].Parent := ScrollBox1;
      AHorLabels[High(AHorLabels)].Caption := IntToStr(x);
      AHorLabels[High(AHorLabels)].Top := pgPuzzle.Top + pgPuzzle.Height + 2;
      AHorLabels[High(AHorLabels)].Left := pgPuzzle.Left + c.Rect.Right - AHorLabels[High(AHorLabels)].Width - 2;
      AHorLabels[High(AHorLabels)].Visible := true;
    end;
  end;
end;

procedure TCommonFrame.CreatePanelGrid;
begin
  pgPuzzle := TPanelGrid.Create(ScrollBox1);
  pgPuzzle.DefaultCellsColor := frmSettings.ABackgroundColor;
  pgPuzzle.CellsFontColor := frmSettings.ACapFontColor;
  pgPuzzle.GridLinesColor := frmSettings.AGridLinesColor;
  pgPuzzle.CellsWidth := frmSettings.ACellWidth;
  pgPuzzle.CellsHeight := frmSettings.ACellHeight;
  pgPuzzle.GridLinesWidth := frmSettings.ALinesWidth;
  pgPuzzle.FatLinesWidth := frmSettings.AFatLinesWidth;
  pgPuzzle.CellsFontSize := GetFontSize(pgPuzzle.CellsHeight);
  pgPuzzle.FirstFatRow := 0;
  pgPuzzle.FirstFatCol := 0;
  pgPuzzle.Visible := false;
  pgPuzzle.Caption := '';
  pgPuzzle.DefaultShowHint := frmSettings.AShowCellsHint;
  pgPuzzle.FPrCallBack := SetProgress;
  pgPuzzle.OnMouseMove := GridMouseMove;
end;

destructor TCommonFrame.Destroy;
begin
  ClearAll;
  if pgPuzzle <> nil then pgPuzzle.Free;
  inherited;
end;

function TCommonFrame.PopLastRedo: TUndoData;
var
  i, start, stop: integer;

begin
  SetLength(result, 0);
  if (not CanRedo) then exit;
  stop := High(RedoData);
  start := stop - (RedoBlocks[High(RedoBlocks)] - 1);
  SetLength(result, RedoBlocks[High(RedoBlocks)]);

  for i := start to stop do
    result[i - start] := GetRedoItem(i);

 SetLength(RedoData, Length(RedoData) - RedoBlocks[High(RedoBlocks)]);
 SetLength(RedoBlocks, Length(RedoBlocks) - 1);
end;

function TCommonFrame.PopLastUndo: TUndoData;
var
  i, start, stop: integer;

begin
  SetLength(result, 0);
  if (not CanUndo) then exit;
  stop := High(UndoData);
  start := stop - (UndoBlocks[High(UndoBlocks)] - 1);
//  if start < 0 then start := 0;
  SetLength(result, UndoBlocks[High(UndoBlocks)]);

  for i := start to stop do
    result[i - start] := GetUndoItem(i);

 SetLength(UndoData, Length(UndoData) - UndoBlocks[High(UndoBlocks)]);
 SetLength(UndoBlocks, Length(UndoBlocks) - 1);
end;

function TCommonFrame.GetCurrCol: integer;
begin
  result := -1;
  if (not Assigned(pgPuzzle)) or (not Assigned(pgPuzzle.CurrCell)) then exit;
  result := pgPuzzle.CurrCell.Col;
end;

function TCommonFrame.GetCurrRow: integer;
begin
  result := -1;
  if (not Assigned(pgPuzzle)) or (not Assigned(pgPuzzle.CurrCell)) then exit;
  result := pgPuzzle.CurrCell.Row;
end;

function TCommonFrame.GetDefaultFileName(cg: TCurrGame): string;
var
  sr: TSearchRec;
  si: integer;

begin
  result := '';

  if FCurrNum = 0 then
  begin
    si := FindFirst(frmSettings.CrossFolder + '\*.' + GetExt(cg), faAnyFile, sr);
    while si = 0 do
    begin
      Inc(FCurrNum);
      si := FindNext(sr);
    end;
    FindClose(sr);
  end;

  repeat
    Inc(FCurrNum);
    result := iif(cg = cgSudoku, DEFAULT_SUDOKU_FILE, DEFAULT_CROSS_FILE) + IntToStr(FCurrNum) + '.' + GetExt(cg);
  until not FileExists(frmSettings.CrossFolder + '\' + result);
end;

function TCommonFrame.GetRedoItem(idx: integer): TUndoItem;
begin
  result.p.X := -1;
  result.p.Y := -1;
  result.val := -1;
  if (not CanRedo) or (idx < 0) or (idx >= Length(RedoData)) then exit;
  result := RedoData[idx];
end;

function TCommonFrame.GetUndoItem(idx: integer): TUndoItem;
begin
  result.p.X := -1;
  result.p.Y := -1;
  result.val := -1;
  if (not CanUndo) or (idx < 0) or (idx >= Length(UndoData)) then exit;
  result := UndoData[idx];
end;

procedure TCommonFrame.GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (GameState = gsGame) or (GameState = gsEdit) then
  begin
    _vertline.Left := X{ + 7};
    _horizline.Top := Y{ + 7};
  end;
end;

procedure TCommonFrame.HideRuler;
begin
  _vertline.Visible := false;
  _vertline.Left := 0;
  _horizline.Visible := false;
  _horizline.Top := 0;
end;

procedure TCommonFrame.PrintCross;
var
  i, j: integer;
  m: TfrxMemoView;
  mp: TfrxPage;
  l: Extended;
  t: Extended;
  v, h: integer;

begin
  Screen.Cursor := crHourGlass;
  v := 0;
  h := 0;
  try
    mp := TfrxPage(frxPrintList.FindObject('Page1'));
    l := 10;
    t := 10;
    for i := 0 to pgPuzzle.RowCount - 1 do
    begin
      if i <= pgPuzzle.FirstFatRow then h := 1;
      for j := 0 to pgPuzzle.ColCount - 1 do
      begin
        if j <= pgPuzzle.FirstFatCol then v := 1;
        m := TfrxMemoView.Create(nil);
        m.AutoWidth := false;
        m.Top := t;
        m.Left := l;
        m.Height := pgPuzzle.CellsHeight;
        m.Width := pgPuzzle.CellsWidth;
        m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
        if (i = pgPuzzle.FirstFatRow - 1) or (Frac(h / pgPuzzle.FatLinesInterval) = 0) then m.Frame.BottomLine.Width := 2;
        if (j = pgPuzzle.FirstFatCol - 1) or (Frac(v / pgPuzzle.FatLinesInterval) = 0) then m.Frame.RightLine.Width := 2;
       // m.HAlign := haCenter;
       // m.VAlign := vaCenter;
        m.Font.Size := GetFontSize(pgPuzzle.CellsHeight);
        m.Text := pgPuzzle.Cell[i, j].Text;
        m.Parent := mp;
        l := l + pgPuzzle.CellsWidth;
        Inc(v);
      end;
      l := 10;
      t := t + pgPuzzle.CellsHeight;
      Inc(h);
    end;
    frxPrintList.ShowReport;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCommonFrame.RefreshGridMetrics;
var
  cw: integer;
  ch: integer;
  gl: integer;
  gt: integer;
  b: boolean;

begin
  b := false;
  ScrollBox1.Color := frmSettings.ABackgroundColor;
  pgPuzzle.GridLinesColor := frmSettings.AGridLinesColor;
  if (frmSettings.AutoCellSize) and ((pgPuzzle.ColCount > 0) and (pgPuzzle.RowCount > 0)) then
  begin
    pgPuzzle.Left := 5;
    pgPuzzle.Top := 5;
    cw := Round(ScrollBox1.Width / pgPuzzle.ColCount) + 1;
    ch := round(ScrollBox1.Height / pgPuzzle.RowCount) + 1;
    while ((cw * pgPuzzle.ColCount) + (Round(pgPuzzle.ColCount / 5) * frmSettings.AFatLinesWidth) +
      ((pgPuzzle.ColCount - Round(pgPuzzle.ColCount / 5)) * frmSettings.ALinesWidth)) > (ScrollBox1.Width - 20) do
      Dec(cw);
    while ((ch * pgPuzzle.RowCount) + (Round(pgPuzzle.RowCount / 5) * frmSettings.AFatLinesWidth) +
      ((pgPuzzle.RowCount - Round(pgPuzzle.RowCount / 5)) * frmSettings.ALinesWidth)) > (ScrollBox1.Height - 20) do
      Dec(ch);
    if cw < 5 then cw := 5;
    if ch < 5 then ch := 5;
    if (cw <> pgPuzzle.CellsWidth) or (ch <> pgPuzzle.CellsHeight) then b := true;
    pgPuzzle.CellsWidth := cw;
    pgPuzzle.CellsHeight := ch;
    pgPuzzle.Width := (cw * pgPuzzle.ColCount) + (Round(pgPuzzle.ColCount / 5) * frmSettings.AFatLinesWidth) +
      ((pgPuzzle.ColCount - Round(pgPuzzle.ColCount / 5)) * frmSettings.ALinesWidth);
    pgPuzzle.Height := (ch * pgPuzzle.RowCount) + (Round(pgPuzzle.RowCount / 5) * frmSettings.AFatLinesWidth) +
      ((pgPuzzle.RowCount - Round(pgPuzzle.RowCount / 5)) * frmSettings.ALinesWidth);
    pgPuzzle.CellsFontSize := GetFontSize(pgPuzzle.CellsHeight);
  end else
  begin
    if (frmSettings.ACellWidth <> pgPuzzle.CellsWidth) or (frmSettings.ACellHeight <> pgPuzzle.CellsHeight) then b := true;
    pgPuzzle.CellsWidth := frmSettings.ACellWidth;
    pgPuzzle.CellsHeight := frmSettings.ACellHeight;
    if pgPuzzle.Width > self.Width - 10 then gl := 5
    else gl := Round(self.Width / 2) - round(pgPuzzle.Width / 2);
    if pgPuzzle.Height > self.Height - 10 then gt := 5
    else gt := 10;//Round(self.Height / 2) - round(pgPuzzle.Height / 2);
    pgPuzzle.Left := gl;
    pgPuzzle.Top := gt;
    if ChildClassName = 'TFmSudoku' then pgPuzzle.CellsFontSize := frmSettings.ACellFontSize
    else pgPuzzle.CellsFontSize := GetFontSize(pgPuzzle.CellsHeight);
  end;
  if b then pgPuzzle.RefreshCells;
  RefreshLabels;
end;

procedure TCommonFrame.RefreshLabels;
var
  i, n, x: integer;
  c: TPanelCell;

begin
  n := 0;
  for i := 0 to pgPuzzle.RowCount - 1 do
  begin
    c := pgPuzzle.Cell[i, pgPuzzle.ColCount - 1];
    if not Assigned(c) then continue;
    x := c.Row - pgPuzzle.FirstFatRow + 1;
    if (x > 0) and ((x mod 5) = 0) then
    begin
      if n >= Length(AVertLabels) then break;
      if (AVertLabels[n] = nil) then
      begin
        Inc(n);
        continue;
      end;
      AVertLabels[n].Left := pgPuzzle.Left + pgPuzzle.Width + 2;
      AVertLabels[n].Top := pgPuzzle.Top + c.Rect.Bottom - AVertLabels[n].Height - 2;
      AVertLabels[n].Caption := IntToStr(x);
      Inc(n);
    end;
  end;

  n := 0;
  for i := 0 to pgPuzzle.ColCount - 1 do
  begin
    c := pgPuzzle.Cell[pgPuzzle.RowCount - 1, i];
    if not Assigned(c) then continue;
    x := c.Col - pgPuzzle.FirstFatCol + 1;
    if (x > 0) and ((x mod 5) = 0) then
    begin
      if n >= Length(AHorLabels) then break;
      if (AHorLabels[n] = nil) then
      begin
        Inc(n);
        continue;
      end;
      AHorLabels[n].Top := pgPuzzle.Top + pgPuzzle.Height + 2;
      AHorLabels[n].Left := pgPuzzle.Left + c.Rect.Right - AHorLabels[n].Width - 2;
      AHorLabels[n].Caption := IntToStr(x);
      Inc(n);
    end;
  end;
end;

{procedure TCommonFrame.SaveRecord(AGame, AUser, ADifficulty, AName: string; ATime: TTime);
var
  xDoc: IXMLDocument;
  xMainNode, xGameNode, xDiffNode, xUserNode: IXMLNode;
  tstr: string;
  gt: TTime;

begin
  if AUser = '' then AUser := 'Игрок';
  if AName = '' then AName := 'x';
  if (AGame = '') or (ADifficulty = '') then exit;
  if (ADifficulty[1] in ['0'..'9']) then ADifficulty := 'D' + ADifficulty;
  ADifficulty := ReplaceEx(ADifficulty, [#32], '_', []);

  if FileExists(frmSettings.RecordsFile) then
  begin
    xDoc := TXMLDocument.Create(frmSettings.RecordsFile) as IXMLDocument;
    xDoc.Active := true;
    xMainNode := xDoc.Node.ChildNodes.FindNode('Records');
  end else
  begin
    xDoc := TXMLDocument.Create(self) as IXMLDocument;
    xDoc.Active := true;
    xMainNode := xDoc.Node.AddChild('Records');
  end;
  if xMainNode = nil then exit;

  //игра
  xGameNode := xMainNode.ChildNodes.FindNode(AGame);
  if xGameNode = nil then
    xGameNode := xMainNode.AddChild(AGame, xMainNode.ChildNodes.Count);

  //сложность
  xDiffNode := xGameNode.ChildNodes.FindNode(ADifficulty);
  if xDiffNode = nil then
    xDiffNode := xGameNode.AddChild(ADifficulty, xGameNode.ChildNodes.Count);

  //игрок
  xUserNode := xDiffNode.ChildNodes.FindNode('User');
  if xUserNode = nil then
    xUserNode := xDiffNode.AddChild('User', xDiffNode.ChildNodes.Count)
  else
  begin
    while (xUserNode <> nil) and (xUserNode.Attributes['Name'] <> AUser) do
      xUserNode := xUserNode.NextSibling;
    if xUserNode = nil then
      xUserNode := xDiffNode.AddChild('User', xDiffNode.ChildNodes.Count);
  end;

  //название игры
  xUserNode.Attributes['Name'] := AUser;
  xUserNode.Attributes['Game'] := AName;
  try
    tstr := VarToStr(xUserNode.Attributes['Time']);
    gt := StrToTime(tstr);
  except
    gt := 0;
  end;
  if (gt = 0) or (ATime < gt) then
    xUserNode.Attributes['Time'] := TimeToStr(ATime);

  xDoc.SaveToFile(frmSettings.RecordsFile);
end;
}

procedure TCommonFrame.SaveRecord(AGame: TCurrGame; ADifficulty: TDifficulty; AWidth, AHeight: integer; AUser, AName: string; ATime: TTime);

  function FindRecord: boolean;
  begin
    result := false;
    if (not mtStat.Active) or mtStat.IsEmpty then exit;
    mtStat.First;
    while not mtStat.Eof do
    begin
      if (mtStat.FieldByName('GAME').AsInteger = Ord(AGame)) and
        (mtStat.FieldByName('DIFF').AsInteger = Ord(ADifficulty)) and
        (mtStat.FieldByName('SZW').AsInteger = AWidth) and
        (mtStat.FieldByName('SZH').AsInteger = AHeight) and
        (AnsiLowerCase(mtStat.FieldByName('USER').AsString) = AnsiLowerCase(AUser)) then
      begin
        result := true;
        break;
      end;
      mtStat.Next;
    end;
  end;

begin
  if AGame = cgNone then exit;
  if AUser = '' then AUser := '???';
  if AName = '' then AName := '???';

  try
    mtStat.Close;
    mtStat.CreateDataSet;
    LoadStat(mtStat, frmSettings.RecordsFile, cgNone, true);
    if not mtStat.Active then mtStat.Open;

    //ищем запись по этой игре, игроку, размеру, сложности
    if FindRecord then
    begin
      if mtStat.FieldByName('SCORE').AsInteger <= CalcScores(ADifficulty, AGame, AWidth, AHeight, ATime) then mtStat.Edit;
    end else
      mtStat.Append;

    if mtStat.State in [dsEdit, dsInsert] then
    begin
      mtStat.FieldByName('GAME').AsInteger := Ord(AGame);
      mtStat.FieldByName('DIFF').AsInteger := Ord(ADifficulty);
      mtStat.FieldByName('SZW').AsInteger := AWidth;
      mtStat.FieldByName('SZH').AsInteger := AHeight;
      mtStat.FieldByName('USER').AsString := AUser;
      mtStat.FieldByName('NAME').AsString := AName;
      mtStat.FieldByName('TIME').AsFloat := ATime;
      mtStat.FieldByName('LAST').AsInteger := 1;
      mtStat.FieldByName('SCORE').AsInteger := CalcScores(ADifficulty, AGame, AWidth, AHeight, ATime);
      mtStat.Post;
    end;

    SaveStat(mtStat, frmSettings.RecordsFile);
    mtStat.Close;
  except
    on e: Exception do
    begin
      Application.MessageBox(pchar('Ошибка! Не удалось сохранить результат игры!'#13#10 + e.Message), pchar(Application.Title), MB_OK + MB_ICONERROR);
      exit;
    end;
  end;
end;

procedure TCommonFrame.ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position + SCROLLBOX_DELTA
  else
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + SCROLLBOX_DELTA;
end;

procedure TCommonFrame.ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position - SCROLLBOX_DELTA
  else
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - SCROLLBOX_DELTA;
end;

procedure TCommonFrame.ScrollBox1Resize(Sender: TObject);
begin
  if frmSettings.AutoCellSize then tmrResize.Interval := 500
  else tmrResize.Interval := 1;
  tmrResize.Enabled := true;
end;

procedure TCommonFrame.SetChanged(value: boolean);
begin
  _changed := value;
  if GameState = gsEdit then
  begin
    if Assigned(SetStatus) then SetStatus('Изменен', 1);
    if (GameState = gsGame) and _changed and frmSettings.Autosave then Autosave;
  end;
end;

procedure TCommonFrame.SetRuler(CreateOnly: boolean);

  procedure SetVertRuler(d1, d2: integer);
  var
    r: TRect;

  begin
    r.Left := _vertline.Left;
    r.Right := _vertline.Width;
    r.Top := _vertline.Top;
    r.Bottom := r.Top + d1;
    _vertline.Canvas.Brush.Style := bsSolid;
    _vertline.Canvas.Brush.Color := frmSettings.ARulerColor;
    while r.Top <= _vertline.Height do
    begin
      _vertline.Canvas.FillRect(r);
      r.Top := r.Bottom + d2;
      r.Bottom := r.Top + d1;
    end;
    _vertline.Repaint;
  end;

  procedure SetHorizRuler(d1, d2: integer);
  var
    r: TRect;

  begin
    r.Left := _horizline.Left;
    r.Right := r.Left + d1;
    r.Top := _horizline.Top;
    r.Bottom := _horizline.Height;
    _horizline.Canvas.Brush.Style := bsSolid;
    _horizline.Canvas.Brush.Color := frmSettings.ARulerColor;
    while r.Left <= _horizline.Width do
    begin
      _horizline.Canvas.FillRect(r);
      r.Left := r.Right + d2;
      r.Right := r.Left + d1;
    end;
    _horizline.Repaint;
  end;

begin
  if _vertline <> nil then _vertline.Free;
  if _horizline <> nil then _horizline.Free;
  _vertline := TImage.Create(self);
  _horizline := TImage.Create(self);
  _vertline.Parent := ScrollBox1;
  _horizline.Parent := ScrollBox1;
  if CreateOnly then
  begin
    HideRuler;
    exit;
  end;

  _vertline.Width := 1;
  _vertline.Top := 1;
  _vertline.Height := pgPuzzle.Height - 5;
  _vertline.Visible := True;
  case frmSettings.ARulerStyle of
    rsLines: SetVertRuler(_vertline.Height, 0);
    rsStroke: SetVertRuler(5, 5);
    rsDot: SetVertRuler(1, 3);
    rsInversDot: SetVertRuler(3, 1);
  end;

  _horizline.Height := 1;
  _horizline.Left := 1;
  _horizline.Width := pgPuzzle.Width - 5;
  _horizline.Visible := true;
  case frmSettings.ARulerStyle of
    rsLines: SetHorizRuler(_horizline.Width, 0);
    rsStroke: SetHorizRuler(5, 5);
    rsDot: SetHorizRuler(1, 3);
    rsInversDot: SetHorizRuler(3, 1);
  end;
end;

procedure TCommonFrame.ShowRecords;
var
  frmRecords: TfrmRecords;

begin
  frmRecords := TfrmRecords.Create(self);
  frmRecords.ShowModal;
end;

procedure TCommonFrame.tmrResizeTimer(Sender: TObject);
begin
  if (oldWidth <> ScrollBox1.Width) or (oldHeight <> ScrollBox1.Height) then
  begin
    oldWidth := ScrollBox1.Width;
    oldHeight := ScrollBox1.Height;
  end else
  begin
    tmrResize.Enabled := false;
    RefreshGridMetrics;
  end;
end;

end.
