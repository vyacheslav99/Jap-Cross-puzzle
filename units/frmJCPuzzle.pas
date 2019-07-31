unit frmJCPuzzle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs, ExtCtrls, {frxClass,}
  settings, pgrid, select_puzzle, frmCommon, puzzle, jsCommon, DB, ExtDlgs, toolbox, Buttons, MemTableDataEh, MemTableEh, propertys;

type
  TFmJCrossPuzzle = class(TCommonFrame)
    pTools: TPanel;
    chbOverwriteCells: TCheckBox;
    Splitter1: TSplitter;
    Bevel1: TBevel;
    bntHidePanel: TSpeedButton;
    procedure chbOverwriteCellsClick(Sender: TObject);
    procedure bntHidePanelClick(Sender: TObject);
  private
    FPuzzle: TCrossPuzzle;
    FPuzFile: string;
    FShift: boolean;
    _ACapFontColor: integer;
    _ACapOpenColor: integer;
    _ACapBackColor: integer;
    _ACapOpenBackColor: integer;
    _AImgPaintColor: integer;
    _AImgNoPaintColor: integer;
    _AImgGrayedColor: integer;
    _ACapCellChStyle: integer;
    _AFCellChStyle: integer;
    _ACapCellStyle: TCellStyle;
    _AFCellStyle: TCellStyle;
    _AShowCellsHint: boolean;
    fblocked: boolean;
    procedure CreatePanelGrid; override;
    procedure ClearAll; override;
    procedure CreatePuzzleGrid;
    procedure RefreshGrid;
    procedure RefreshCell(ARow, ACol: integer);
    procedure SetTransparentColor(Color: TColor); override;
    function GetTransparentColor: TColor; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean = false); override;
    procedure SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean); override;
    procedure SetRangeState(State: integer); override;
    function SaveGame(filename: string; ShowDialog: boolean): boolean; override;
    procedure LoadGame; override;
    procedure GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); override;
    procedure GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); override;
    procedure GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure GridCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridCellKeyPress(Sender: TObject; var Key: Char); override;
    procedure UnSelectAll; override;
    procedure SelectAll; override;
    procedure SaveOldSettings; override;
    procedure SetSettings; override;
    function SaveCore: boolean; override;
    procedure ShowPrompt; override;
    procedure MoveToCell(Direction: TMoveDirection); override;
    procedure FillRandom(AOverwriteAll: boolean); override;
    procedure Invert(AInvertBg: boolean); override;
    procedure Undo; override;
    procedure Redo; override;
    procedure DeleteRow(RowNo: integer = -1; Count: integer = 1); override;
    procedure DeleteCol(ColNo: integer = -1; Count: integer = 1); override;
    procedure AddRow(Index: integer = -1; Count: integer = 1); override;
    procedure AddCol(Index: integer = -1; Count: integer = 1); override;
    procedure ShowTools(AShow: boolean); override;
    procedure ShowProps; override;
  end;

implementation

{$R *.dfm}

procedure TFmJCrossPuzzle.AddCol(Index, Count: integer);
begin
  if FGameState <> gsEdit then exit;
  if Index < 0 then
    if Assigned(pgPuzzle.CurrCell) then Index := pgPuzzle.CurrCell.Col
    else Index := 0;
  FPuzzle.AddCol(Index, Count);
  pgPuzzle.ColCount := FPuzzle.ColCount;
  RefreshGrid;
  RefreshGridMetrics;
  ClearLabels;
  CreateLabels;
end;

procedure TFmJCrossPuzzle.AddRow(Index: integer; Count: integer);
begin
  if FGameState <> gsEdit then exit;
  if Index < 0 then
    if Assigned(pgPuzzle.CurrCell) then Index := pgPuzzle.CurrCell.Row
    else Index := 0;
  FPuzzle.AddRow(Index, Count);
  pgPuzzle.RowCount := FPuzzle.RowCount;
  RefreshGrid;
  RefreshGridMetrics;
  ClearLabels;
  CreateLabels;
end;

procedure TFmJCrossPuzzle.bntHidePanelClick(Sender: TObject);
begin
  ShowTools(false);
end;

procedure TFmJCrossPuzzle.chbOverwriteCellsClick(Sender: TObject);
begin
  frmSettings.OverwriteCells := chbOverwriteCells.Checked;
end;

procedure TFmJCrossPuzzle.ClearAll;
begin
  inherited ClearAll;
  ShowTools(false);
  FPuzFile := '';
  Penalty := false;
  if Assigned(PSetActionButtons) then PSetActionButtons(false);
  if (FPuzzle <> nil) then
  begin
    frmSettings.APromptLeft := FPuzzle.PromptLeft;
    frmSettings.APromptTop := FPuzzle.PromptTop;
    FPuzzle.Free;
    FPuzzle := nil;
  end;
  ClearLabels;
end;

constructor TFmJCrossPuzzle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetGameState(gsNone, gaNew);
  ChildClassName := Self.ClassName;
  GameType := cgJCrossPuzzle;
end;

procedure TFmJCrossPuzzle.CreatePanelGrid;
begin
  inherited CreatePanelGrid;
  pgPuzzle.FatLinesInterval := 5;
  pgPuzzle.OnCellClick := GridCellClick;
  pgPuzzle.OnCellDblClick := GridCellDblClick;
  pgPuzzle.OnMouseUp := GridCellMouseUp;
  pgPuzzle.OnMouseDown := GridCellMouseDown;
end;

procedure TFmJCrossPuzzle.CreatePuzzleGrid;
var
  i, j, n: integer;

begin
  if (FPuzzle = nil) then
  begin
    SetGameState(gsNone, gaNew);
    exit;
  end;

  try
    pgPuzzle.RowCount := FPuzzle.RowCount;
    pgPuzzle.ColCount := FPuzzle.ColCount;
    pgPuzzle.FirstFatRow := FPuzzle.TopIndent;
    pgPuzzle.FirstFatCol := FPuzzle.LeftIndent;
    n := 1;
    if Assigned(SetProgress) then SetProgress(FPuzzle.RowCount * FPuzzle.ColCount, 0, 'Загрузка...', true);
    for i := 0 to FPuzzle.RowCount - 1 do
      for j := 0 to FPuzzle.ColCount - 1 do
      begin
        case FPuzzle.ItemType[i, j] of
          pztService: pgPuzzle.Cell[i, j].Style := csNone;
          pztCaption:
          begin
            pgPuzzle.Cell[i, j].Text := FPuzzle.ItemText[i, j];
            pgPuzzle.Cell[i, j].Font.Color := frmSettings.ACapFontColor;
            pgPuzzle.Cell[i, j].Font.Size := GetFontSize(pgPuzzle.CellsHeight);
            pgPuzzle.Cell[i, j].Color := frmSettings.ACapBackColor;
            pgPuzzle.Cell[i, j].Style := frmSettings.ACapCellStyle;
            pgPuzzle.Cell[i, j].ShowHint := frmSettings.AShowCellsHint;
          end;
          pztCell:
          begin
            pgPuzzle.Cell[i, j].Color := frmSettings.AImgGrayedColor;
            pgPuzzle.Cell[i, j].Style := frmSettings.AFCellStyle;
            pgPuzzle.Cell[i, j].ShowHint := frmSettings.AShowCellsHint;
          end;
        end;
        if Assigned(SetProgress) then SetProgress(0, n, '', true);
        Inc(n);
      end;
    if Assigned(SetProgress) then SetProgress(0, 0, '', false);
    CreateLabels;
    RefreshGridMetrics;
    pgPuzzle.RefreshCells;
  except
    on e: exception do
    begin
      SetGameState(gsNone, gaNew);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TFmJCrossPuzzle.DeleteCol(ColNo: integer; Count: integer);
begin
  if FGameState <> gsEdit then exit;
  if ColNo < 0 then
    if Assigned(pgPuzzle.CurrCell) then ColNo := pgPuzzle.CurrCell.Col
    else ColNo := 0;
  FPuzzle.DeleteCol(ColNo, Count);
  pgPuzzle.ColCount := FPuzzle.ColCount;
  RefreshGrid;
  RefreshGridMetrics;
  ClearLabels;
  CreateLabels;
end;

procedure TFmJCrossPuzzle.DeleteRow(RowNo: integer; Count: integer);
begin
  if FGameState <> gsEdit then exit;
  if RowNo < 0 then
    if Assigned(pgPuzzle.CurrCell) then RowNo := pgPuzzle.CurrCell.Row
    else RowNo := 0;
  FPuzzle.DeleteRow(RowNo, Count);
  pgPuzzle.RowCount := FPuzzle.RowCount;
  RefreshGrid;
  RefreshGridMetrics;
  ClearLabels;
  CreateLabels;
end;

destructor TFmJCrossPuzzle.Destroy;
begin
  ClearAll;
  inherited Destroy;
end;

procedure TFmJCrossPuzzle.FillRandom(AOverwriteAll: boolean);
begin
  if FGameState = gsEdit then
  begin
    AChanged := true;
    FPuzzle.GenerateRandom(AOverwriteAll);
    RefreshGrid;
  end;
end;

procedure TFmJCrossPuzzle.LoadGame;
var
  f: TFileStream;
  i, j: integer;
  b: byte;
  s: char;
  filename: string;
  pos: integer;
  _oldtext: string;
  head: TSaveFileHeader;
  OPDialog: TfrmOpenPuzzle;

begin
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(filename, cgJCrossPuzzle, true, false) then exit;

  if ExtractFileExt(filename) = '' then filename := filename + '.' + GetExt(cgJCrossPuzzle, true);
  filename := frmSettings.SaveFolder + '\' + filename;
  if not FileExists(filename) then exit;
  SetGameState(gsNone, gaNew);
  Screen.Cursor := crHourGlass;

  try
    try
      fblocked := true;
      f := TFileStream.Create(filename, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));

      //читаем имя файла ядра
      FPuzFile := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(s, 1);
        FPuzFile := FPuzFile + s;
      end;

      //читаем имя игрока
      frmSettings.AUser := '';
      for i := 1 to head.sz_user do
      begin
        f.Read(s, 1);
        frmSettings.AUser := frmSettings.AUser + s;
      end;

      //_olddiff := frmSettings.ADifficulty;
      frmSettings.ADifficulty := TDifficulty(head.Difficulty);
      SetGameState(gsGame, gaCurrent);
      //frmSettings.ADifficulty := _olddiff;
      if Assigned(GetStatus) then _oldtext := GetStatus(2);
      SetProgress((FPuzzle.RowCount) * (FPuzzle.ColCount), 0, 'Загрузка...', true);
      GameTime := head.GTime;
      StartTime := Time - GameTime;
      pos := 0;

      for i := 0 to FPuzzle.RowCount - 1 do
        for j := 0 to FPuzzle.ColCount - 1 do
        begin
          Inc(pos);
          f.Read(b, SizeOf(byte));
          FPuzzle.ItemState[i, j] := b;
          SetProgress(0, Pos, '', true);
        end;
      RefreshGrid;
    except
      on e: Exception do
      begin
        SetGameState(gsNone, gaNew);
        Application.MessageBox(pchar('Не удалось загрузить игру!'#13#10 + e.Message), 'Ошибка', MB_OK + MB_ICONERROR);
        exit;
      end;
    end;
  finally
    if Assigned(f) then f.Free;
    fblocked := false;
    SetProgress(0, 0, '', false);
    SetStatus(_oldtext, 2);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmJCrossPuzzle.MoveToCell(Direction: TMoveDirection);
begin

end;

function TFmJCrossPuzzle.GetTransparentColor: TColor;
begin
  result := -1;
end;

procedure TFmJCrossPuzzle.GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  if FPuzzle = nil then exit;
  if not FShift then SetCellState(ARow, ACol, true, 0, true);
  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(pgPuzzle.CurrCell.Row - FPuzzle.TopIndent + 1) + ', ' +
      IntToStr(pgPuzzle.CurrCell.Col - FPuzzle.LeftIndent + 1) + ']', 3);
end;

procedure TFmJCrossPuzzle.GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  if FPuzzle = nil then exit;
  if not FShift then SetCellState(ARow, ACol, false, 0, true);
  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(pgPuzzle.CurrCell.Row - FPuzzle.TopIndent + 1) + ', ' +
      IntToStr(pgPuzzle.CurrCell.Col - FPuzzle.LeftIndent + 1) + ']', 3);
end;

procedure TFmJCrossPuzzle.GridCellKeyPress(Sender: TObject; var Key: Char);
begin

end;

procedure TFmJCrossPuzzle.GridCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssShift in Shift then FShift := true;
end;

procedure TFmJCrossPuzzle.GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FShift := false;
  if Button = mbRight then SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, 2, true);
end;

procedure TFmJCrossPuzzle.Invert(AInvertBg: boolean);
begin
  if FGameState = gsEdit then
  begin
    AChanged := true;
    FPuzzle.Invert;
    RefreshGrid;
  end;
end;

procedure TFmJCrossPuzzle.Redo;
var
  ud: TUndoData;
  i, c: integer;

begin
  if not CanRedo then Exit;
  c := 0;
  ud := PopLastRedo;
  if Length(ud) <= 0 then exit;
  for i := 0 to Length(ud) - 1 do
  begin
    if ud[i].p.X < 0 then continue;
    Inc(c);
    AddToUndo(ud[i].p, FPuzzle.ItemState[ud[i].p.X, ud[i].p.Y]);
    SetCellState(ud[i].p.X, ud[i].p.Y, false, ud[i].val, false);
  end;
  if c > 0 then AddToUBlocks(c);
end;

procedure TFmJCrossPuzzle.RefreshCell(ARow, ACol: integer);
begin
  pgPuzzle.Cell[ARow, ACol].ShowHint := frmSettings.AShowCellsHint;
  case FPuzzle.ItemType[ARow, ACol] of
    pztService:
    begin
      pgPuzzle.Cell[ARow, ACol].Style := csNone;
      pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ABackgroundColor;
      pgPuzzle.Cell[ARow, ACol].ShowHint := false;
    end;
    pztCaption:
      case FPuzzle.ItemState[ARow, ACol] of
        0:
        begin
          pgPuzzle.Cell[ARow, ACol].Font.Color := frmSettings.ACapFontColor;
          pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ACapBackColor;
          pgPuzzle.Cell[ARow, ACol].Style := frmSettings.ACapCellStyle;
        end;
        1:
        begin
          pgPuzzle.Cell[ARow, ACol].Font.Color := frmSettings.ACapOpenColor;
          pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ACapOpenBackColor;
          if frmSettings.ACapCellChStyle < 0 then pgPuzzle.Cell[ARow, ACol].Style := frmSettings.ACapCellStyle
          else pgPuzzle.Cell[ARow, ACol].Style := TCellStyle(frmSettings.ACapCellChStyle);
        end;
      end;
    pztCell:
      case FPuzzle.ItemState[ARow, ACol] of
      0:
      begin
        pgPuzzle.Cell[ARow, ACol].Color := frmSettings.AImgNoPaintColor;
        if frmSettings.AFCellChStyle < 0 then pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle
        else pgPuzzle.Cell[ARow, ACol].Style := TCellStyle(frmSettings.AFCellChStyle);
      end;
      1:
      begin
        pgPuzzle.Cell[ARow, ACol].Color := frmSettings.AImgPaintColor;
        if frmSettings.AFCellChStyle < 0 then pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle
        else pgPuzzle.Cell[ARow, ACol].Style := TCellStyle(frmSettings.AFCellChStyle);
      end;
      2:
      begin
        pgPuzzle.Cell[ARow, ACol].Color := frmSettings.AImgGrayedColor;
        pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle;
      end;
    end;
  end;
end;

procedure TFmJCrossPuzzle.RefreshGrid;
var
  i, j, n: integer;

begin
  if FPuzzle = nil then exit;
  n := 1;
  SetProgress(FPuzzle.RowCount * FPuzzle.ColCount, 0, '', true);
  try
    for i := 0 to FPuzzle.RowCount - 1 do
      for j := 0 to FPuzzle.ColCount - 1 do
      begin
        RefreshCell(i, j);
        SetProgress(0, n, '', true);
        Inc(n);
      end;
  finally
    SetProgress(0, 0, '', false);
  end;
end;

function TFmJCrossPuzzle.SaveCore: boolean;
var
  sname: string;
  wr: integer;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if FPuzzle = nil then exit;
  if Trim(FPuzzle.Name) = '' then raise Exception.Create('Сначала введите название кроссворда в диалоге свойств (Главное меню-Редактор-Свойства)!');
  if (FPuzFile = '.' + GetExt(cgJCrossPuzzle)) or (FPuzFile = '') then
    FPuzFile := GetDefaultFileName(cgJCrossPuzzle); //GenRandString(0, 8);
  sname := FPuzFile;
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(sname, cgJCrossPuzzle, false, true) then exit;
  if Trim(sname) = '' then exit;
  sname := frmSettings.CrossFolder + '\' + sname;
  if AnsiLowerCase(ExtractFileExt(sname)) <> '.' + GetExt(cgJCrossPuzzle) then sname := sname + '.' + GetExt(cgJCrossPuzzle);
  if FileExists(sname) then
  begin
    wr := Application.MessageBox(pchar('Файл с именем "' + ExtractFileName(sname) + '" уже существует! Вы хотите перезаписать его?'),
      'Предупреждение', MB_YESNOCANCEL + MB_ICONWARNING);
    case wr of
      ID_NO:
      begin
        result := SaveCore;
        if result then AChanged := false;
        exit;
      end;
      ID_CANCEL: exit;
    end;
  end;
  FPuzzle.Difficulty := frmSettings.ADifficulty;
  result := FPuzzle.SaveCore(sname);
  FPuzFile := FPuzzle.FileName;
  if result then AChanged := false;
end;

function TFmJCrossPuzzle.SaveGame(filename: string; ShowDialog: boolean): boolean;
var
  f: TFileStream;
  i, j: integer;
  b: byte;
  wr: integer;
  pos: integer;
  head: TSaveFileHeader;
  Mode: word;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if (FPuzzle = nil) or fblocked then exit;
  if ShowDialog then
  begin
    OPDialog := TfrmOpenPuzzle.Create(self);
    if not OPDialog.Execute(filename, cgJCrossPuzzle, true, true) then exit;
    if Trim(filename) = '' then exit;
    filename := frmSettings.SaveFolder + '\' + filename;
    if AnsiLowerCase(ExtractFileExt(filename)) <> '.' + GetExt(cgJCrossPuzzle, true) then
      filename := filename + '.' + GetExt(cgJCrossPuzzle, true);
    if FileExists(filename) then
    begin
      wr := Application.MessageBox(pchar('Сохранение с именем "' + ChangeFileExt(ExtractFileName(filename), '') +
        '" уже существует! Вы хотите перезаписать его?'), 'Предупреждение', MB_YESNOCANCEL + MB_ICONWARNING);
      case wr of
        ID_NO:
        begin
          result := SaveGame(ExtractFileName(filename), true);
          if result then AChanged := false;
          exit;
        end;
        ID_CANCEL: exit;
      end;
    end;
  end;

  Screen.Cursor := crAppStart;
  try
    SetProgress((FPuzzle.RowCount) * (FPuzzle.ColCount), 0, 'Сохранение...', true);
    if FPuzFile = '' then FPuzFile := FPuzzle.FileName;
    head._type := Ord(cgJCrossPuzzle);
    head.Difficulty := Ord(FPuzzle.Difficulty);
    head.GTime := GameTime;
    head.sz_name := Length(FPuzFile);
    head.sz_user := Length(frmSettings.AUser);
    head.sz_base := FPuzzle.RowCount * FPuzzle.ColCount;
    head.sz_extra := 0;
    head.b_top := FPuzzle.TopIndent;
    head.b_left := FPuzzle.LeftIndent;
    pos := 0;

    try
      if FileExists(filename) then Mode := fmOpenWrite
      else Mode := fmCreate;
      f := TFileStream.Create(filename, Mode);
      //пишем заголовок
      f.Write(head, SizeOf(head));
      //блок 1 - имя файла ядра
      for i := 1 to Length(FPuzFile) do f.Write(FPuzFile[i], 1);
      //блок 2 - имя игрока
      for i := 1 to Length(frmSettings.AUser) do f.Write(frmSettings.AUser[i], 1);
      //блок 3 - матрица состояния игры
      for i := 0 to FPuzzle.RowCount - 1 do
        for j := 0 to FPuzzle.ColCount - 1 do
        begin
          Inc(pos);
          b := FPuzzle.ItemState[i, j];
          f.Write(b, SizeOf(byte));
          SetProgress(0, pos, '', true);
        end;
      result := true;
    except
      on e: Exception do
      begin
        Application.MessageBox(pchar('Не удалось сохранить игру!'#13#13 + e.Message), 'Ошибка', MB_OK + MB_ICONERROR);
        exit;
      end;
    end;
  finally
    if Assigned(f) then f.Free;
    SetProgress(0, 0, '', false);
    if result then AChanged := false;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmJCrossPuzzle.SaveOldSettings;
begin
  _ACapFontColor := frmSettings.ACapFontColor;
  _ACapOpenColor := frmSettings.ACapOpenColor;
  _ACapBackColor := frmSettings.ACapBackColor;
  _ACapOpenBackColor := frmSettings.ACapOpenBackColor;
  _AImgPaintColor := frmSettings.AImgPaintColor;
  _AImgNoPaintColor := frmSettings.AImgNoPaintColor;
  _AImgGrayedColor := frmSettings.AImgGrayedColor;
  _ACapCellStyle := frmSettings.ACapCellStyle;
  _AFCellStyle := frmSettings.AFCellStyle;
  _ACapCellChStyle := frmSettings.ACapCellChStyle;
  _AFCellChStyle := frmSettings.AFCellChStyle;
  _AShowCellsHint := frmSettings.AShowCellsHint;
end;

procedure TFmJCrossPuzzle.SelectAll;
var
  r: TRect;

begin
  if Assigned(pgPuzzle) then
  begin
    r.Left := FPuzzle.LeftIndent;
    r.Top := FPuzzle.TopIndent;
    r.Right := pgPuzzle.ColCount - 1;
    r.Bottom := pgPuzzle.RowCount - 1;
    pgPuzzle.SetSelection(r);
  end;
end;

procedure TFmJCrossPuzzle.SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean);
begin
  if not (GameState in [gsGame, gsEdit]) then exit;
  if (FPuzzle = nil) or (ARow >= FPuzzle.RowCount) or (ACol >= FPuzzle.ColCount) then exit;
  case FPuzzle.ItemType[ARow, ACol] of
    pztNone, pztService: exit;
    pztCaption:
      case FPuzzle.ItemState[ARow, ACol] of
        0: state := iif(Next, 1, State);
        1: state := iif(Next, 0, State);
      end;
    pztCell:
    begin
      AChanged := true;
      case FPuzzle.ItemState[ARow, ACol] of
        0: state := iif(Next, 1, State);
        1: state := iif(Next, 0, State);
        2: state := iif(Next, 1, State);
      end;
    end;
  end;
  if ToUndo then
  begin
    AddToUndo(ARow, ACol, FPuzzle.ItemState[ARow, ACol]);
    AddToUBlocks(1);
    ClearRedo;
  end;
  FPuzzle.ItemState[ARow, ACol] := State;
  RefreshCell(ARow, ACol);
  if FPuzzle.IsCorrect then SetGameState(gsWin, gaNew);
end;

procedure TFmJCrossPuzzle.SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean);
var
  OPDialog: TfrmOpenPuzzle;
  IPDialog: TFToolBox;
  pf: string;
  props: TFProps;
  lb: byte;

begin
  Screen.Cursor := crHourGlass;
  try
    FGameState := GState;
    case FGameState of
      gsGame:
      try
        pf := FPuzFile;
        ClearAll;
        OPDialog := TfrmOpenPuzzle.Create(self);
        if (GAction = gaCurrent) or OPDialog.Execute(pf, cgJCrossPuzzle, false, false) then
          FPuzzle := TCrossPuzzle.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhAsynchro, frmSettings.ADifficulty)
        else begin
          SetGameState(gsNone, gaNew);
          exit;
        end;
        FPuzFile := FPuzzle.FileName;
        SetStatus(FPuzzle.Name + ' (' + FPuzzle.CrossSizeText + ') <' + DifficultyAsText(FPuzzle.Difficulty, lRU) + '>', 2);
        SetStatus(frmSettings.AUser, 0);
        CreatePuzzleGrid;
        pgPuzzle.Visible := true;
        StartTime := Time;
        AtmrGame.Enabled := True;
        if frmSettings.ARulerArea in [raBoth, raGame] then SetRuler;
        //AtmrAutosave.Enabled := frmSettings.Autosave;
        if frmSettings.Autosave then Autosave;
        if FPuzzle.IsCorrect then SetGameState(gsWin, gaNew);
      except
        on e: exception do
        begin
          SetGameState(gsNone, gaNew);
          raise Exception.Create(e.Message);
        end;
      end;
      gsNone: ClearAll;
      gsWin:
      begin
        AChanged := false;
        HideRuler;
        if (FPuzzle = nil) or FPuzzle.IsEmpty then
        begin
          SetGameState(gsNone, gaNew);
          exit;
        end;
        AtmrGame.Enabled := false;
        StartTime := 0;
        Application.MessageBox('УРА! ВЫ РАЗГАДАЛИ КРОССВОРД!', pchar('Победа'), MB_OK + MB_ICONEXCLAMATION);
        frmSettings.AUser := InputBox(Application.Title, 'Введите ваше имя для записи в таблицу рекордов', frmSettings.AUser);
        SetStatus(frmSettings.AUser, 0);
        SaveRecord(cgJCrossPuzzle, FPuzzle.Difficulty, FPuzzle.CoreColCount, FPuzzle.CoreRowCount, frmSettings.AUser, FPuzzle.Name, GameTime);
        //AtmrAutosave.Enabled := false;
        GameTime := 0;
        ShowRecords;
        self.Repaint;
        pgPuzzle.ClearSelection;
      end;
      gsEdit:
      try
        pf := FPuzFile;
        ClearAll;
        OPDialog := TfrmOpenPuzzle.Create(self);
        IPDialog := TFToolBox.Create(self);
        props := TFProps.Create(self);
        props.Difficulty := frmSettings.ADifficulty;
        props.AWidth := frmSettings.ACrossWidth;
        props.AHeight := frmSettings.ACrossHeight;
        case GAction of
          gaNew:
            if props.Exec then
            begin
              FPuzzle := TCrossPuzzle.CreateEmpty(props.AHeight, props.AWidth, false);
              FPuzzle.Name := props.PuzzleName;
              FPuzzle.Difficulty := props.Difficulty;
              frmSettings.ADifficulty := props.Difficulty;
              frmSettings.ACrossWidth := props.AWidth;
              frmSettings.ACrossHeight := props.AHeight;
            end;
          gaRandom:
            if props.Exec then
            begin
              FPuzzle := TCrossPuzzle.CreateEmpty(props.AHeight, props.AWidth, true);
              FPuzzle.Name := props.PuzzleName;
              FPuzzle.Difficulty := props.Difficulty;
              frmSettings.ADifficulty := props.Difficulty;
              frmSettings.ACrossWidth := props.AWidth;
              frmSettings.ACrossHeight := props.AHeight;
              AChanged := true;
            end;
          gaCurrent: FPuzzle := TCrossPuzzle.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhSynchro, frmSettings.ADifficulty);
          gaOther:
            if OPDialog.Execute(pf, cgJCrossPuzzle, false, false) then
              FPuzzle := TCrossPuzzle.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhSynchro, frmSettings.ADifficulty);
          gaImport:
          begin
            OpenPicDialog.FileName := '';
            OpenPicDialog.InitialDir := frmSettings.LastImgFolder;
            OpenPicDialog.Filter := 'Все изображения (bmp, jpg, jpeg, ico, gif, png)|*.bmp;*.jpg;*.jpeg;*.ico;*.gif;*.png' +
              '|Точечные рисунки (bmp)|*.bmp|Рисунки (jpeg)|*.jpg;*.jpeg|Иконки (ico)|*.ico|Анимированные рисунки (gif)|*.gif|' +
              'Значки (png)|*.png';
            OpenPicDialog.Title := 'Выберите картинку';
            if OpenPicDialog.Execute then
            begin
              frmSettings.LastImgFolder := ExtractFileDir(OpenPicDialog.FileName);
              IPDialog.ShowDlg(cgJCrossPuzzle, GAction);
              lb := iif(frmSettings.AUserSetLightness, frmSettings.ALightnessBorder, frmSettings.DefLightnessBorder);
              FPuzzle := TCrossPuzzle.CreateForImage(OpenPicDialog.FileName, frmSettings.AImgAnalisator, frmSettings.AImgInvert, lb,
                frmSettings.ACrossHeight, frmSettings.ACrossWidth, GAction);
              FPuzzle.Difficulty := frmSettings.ADifficulty;
            end;
            AChanged := true;
          end;
          gaImport2:
          begin
            if OPDialog.Execute(pf, cgCCrossPuzzle, false, false) then
            begin
              IPDialog.ShowDlg(cgJCrossPuzzle, GAction);
              lb := iif(frmSettings.AUserSetLightness, frmSettings.ALightnessBorder, frmSettings.DefLightnessBorder);
              FPuzzle := TCrossPuzzle.CreateForImage(frmSettings.CrossFolder + '\' + pf, frmSettings.AImgAnalisator, frmSettings.AImgInvert,
                lb, 0, 0, GAction);
            end;
            AChanged := true;
          end;
          gaImport3:
          begin
            OpenDialog.FileName := '';
            OpenDialog.InitialDir := frmSettings.LastImgFolder;
            OpenDialog.Filter := 'Текстовые файлы (TXT)|*.txt';
            OpenDialog.Title := 'Выберите файл';
            if OpenDialog.Execute then
            begin
              frmSettings.LastImgFolder := ExtractFileDir(OpenDialog.FileName);
              IPDialog.ShowDlg(cgJCrossPuzzle, GAction);
              lb := iif(frmSettings.AUserSetLightness, frmSettings.ALightnessBorder, 48);
              FPuzzle := TCrossPuzzle.CreateForImage(OpenDialog.FileName, frmSettings.AImgAnalisator, frmSettings.AImgInvert, lb,
                frmSettings.ACrossHeight, frmSettings.ACrossWidth, GAction);
              FPuzzle.Difficulty := frmSettings.ADifficulty;
            end;
            AChanged := true;
          end;
        end;
        if (FPuzzle = nil) or FPuzzle.IsEmpty then
        begin
          SetGameState(gsNone, gaNew);
          exit;
        end;
        FPuzFile := FPuzzle.FileName;
        SetStatus(FPuzzle.Name + ' (' + FPuzzle.CrossSizeText + ')', 2);
        SetStatus('Редактор', 0);
        PSetActionButtons(true);
        frmSettings.ADifficulty := FPuzzle.Difficulty;
        CreatePuzzleGrid;
        RefreshGrid;
        pgPuzzle.Visible := true;
        ShowTools(true);
        if frmSettings.ARulerArea in [raBoth, raEditor] then SetRuler;
      except
        on e: exception do
        begin
          SetGameState(gsNone, gaNew);
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    if Assigned(props) then props.Free;
    if Assigned(FPuzzle) then
    begin
      FPuzzle.PromptLeft := frmSettings.APromptLeft;
      FPuzzle.PromptTop := frmSettings.APromptTop;
    end;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmJCrossPuzzle.SetRangeState(State: integer);
var
  i, j, c: integer;

begin
  c := 0;
  for i := pgPuzzle.Selection.Top to pgPuzzle.Selection.Bottom do
    for j := pgPuzzle.Selection.Left to pgPuzzle.Selection.Right do
      if FPuzzle.ItemType[i, j] = pztCell then
      begin
        Inc(c);
        AddToUndo(i, j, FPuzzle.ItemState[i, j]);
        SetCellState(i, j, false, State, false);
      end;
  AddToUBlocks(c);
  ClearRedo;
  pgPuzzle.ClearSelection;
end;

procedure TFmJCrossPuzzle.SetSettings;
begin
  if frmSettings.AutoCellSize then tmrResize.Interval := 500
  else tmrResize.Interval := 1;
  
  if Assigned(FPuzzle) and (not FPuzzle.IsEmpty) then
  begin
    pgPuzzle.CellsFontSize := GetFontSize(pgPuzzle.CellsHeight);
    pgPuzzle.FatLinesWidth := frmSettings.AFatLinesWidth;
    pgPuzzle.GridLinesWidth := frmSettings.ALinesWidth;
    pgPuzzle.FirstFatRow := FPuzzle.TopIndent;
    pgPuzzle.FirstFatCol := FPuzzle.LeftIndent;
    pgPuzzle.DefaultShowHint := frmSettings.AShowCellsHint;
  end;
  RefreshGridMetrics;
  pgPuzzle.RefreshCells;

  if (_ACapFontColor <> frmSettings.ACapFontColor) or (_ACapOpenColor <> frmSettings.ACapOpenColor) or
    (_ACapBackColor <> frmSettings.ACapBackColor) or (_ACapOpenBackColor <> frmSettings.ACapOpenBackColor) or
    (_AImgPaintColor <> frmSettings.AImgPaintColor) or (_AImgNoPaintColor <> frmSettings.AImgNoPaintColor) or
    (_AImgGrayedColor <> frmSettings.AImgGrayedColor) or (_ACapCellStyle <> frmSettings.ACapCellStyle) or
    (_AFCellStyle <> frmSettings.AFCellStyle) or (_ACapCellChStyle <> frmSettings.ACapCellChStyle) or
    (_AFCellChStyle <> frmSettings.AFCellChStyle) or (_AShowCellsHint <> frmSettings.AShowCellsHint) then
    RefreshGrid;
  if ((GameState in [gsGame, gsEdit]) and (frmSettings.ARulerArea = raBoth)) or
    ((GameState = gsGame) and (frmSettings.ARulerArea in [raGame, raBoth])) or
    ((GameState = gsEdit) and (frmSettings.ARulerArea in [raEditor, raBoth])) then
    SetRuler
  else
    HideRuler;
end;

procedure TFmJCrossPuzzle.SetTransparentColor(Color: TColor);
begin

end;

procedure TFmJCrossPuzzle.ShowPrompt;
begin
  Penalty := true;
  if Assigned(FPuzzle) then FPuzzle.ShowPreview;
end;

procedure TFmJCrossPuzzle.ShowProps;
var
  fprops: TFProps;
  sz_diff: integer;
  
begin
  fprops := TFProps.Create(self);
  try
    fprops.Difficulty := FPuzzle.Difficulty;
    fprops.PuzzleName := FPuzzle.Name;
    fprops.AWidth := FPuzzle.ColCount;
    fprops.AHeight := FPuzzle.RowCount;
    if fprops.Exec then
    begin
      AChanged := true;
      FPuzzle.Difficulty := fprops.Difficulty;
      frmSettings.ADifficulty := FPuzzle.Difficulty;
      FPuzzle.Name := fprops.PuzzleName;
      if FPuzzle.RowCount > fprops.AHeight then DeleteRow(FPuzzle.RowCount - 1, FPuzzle.RowCount - fprops.AHeight);
      if FPuzzle.RowCount < fprops.AHeight then AddRow(FPuzzle.RowCount - 1, fprops.AHeight - FPuzzle.RowCount);
      if FPuzzle.ColCount > fprops.AWidth then DeleteCol(FPuzzle.ColCount - 1, FPuzzle.ColCount - fprops.AWidth);
      if FPuzzle.ColCount < fprops.AWidth then AddCol(FPuzzle.ColCount - 1, fprops.AWidth - FPuzzle.ColCount);
      SetStatus(FPuzzle.Name + ' (' + FPuzzle.CrossSizeText + ') <' + DifficultyAsText(FPuzzle.Difficulty, lRU) + '>', 2);
    end;
  finally
    fprops.Free;
  end;
end;

procedure TFmJCrossPuzzle.ShowTools(AShow: boolean);
begin
  chbOverwriteCells.Visible := false;
  if AShow then
  begin
    chbOverwriteCells.Checked := frmSettings.OverwriteCells;
    pTools.Height := frmSettings.ToolHeight;
    Bevel1.Height := pTools.Height;
    Splitter1.Height := 5;
    case FGameState of
      gsEdit:
      begin
        chbOverwriteCells.Visible := true;
      end;
    end;
  end else
  begin
    if pTools.Height > 0 then frmSettings.ToolHeight := pTools.Height;
    pTools.Height := 0;
    Splitter1.Height := 0;
  end;
end;

procedure TFmJCrossPuzzle.Undo;
var
  ud: TUndoData;
  i, c: integer;

begin
  if not CanUndo then Exit;
  c := 0;
  ud := PopLastUndo;
  if Length(ud) <= 0 then exit;
  for i := 0 to Length(ud) - 1 do
  begin
    if ud[i].p.X < 0 then continue;
    Inc(c);
    AddToRedo(ud[i].p, FPuzzle.ItemState[ud[i].p.X, ud[i].p.Y]);
    SetCellState(ud[i].p.X, ud[i].p.Y, false, ud[i].val, false);
  end;
  if c > 0 then AddToRBlocks(c);
end;

procedure TFmJCrossPuzzle.UnSelectAll;
begin
  pgPuzzle.ClearSelection;
end;

end.
