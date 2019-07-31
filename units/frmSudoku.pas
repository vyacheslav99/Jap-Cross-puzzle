unit frmSudoku;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, {frxClass,} frmCommon, sudoku, pgrid,
  NewSudoku, select_puzzle, settings, jsCommon, ExtCtrls, ExtDlgs, StdCtrls, Buttons, MemTableDataEh, MemTableEh, Db, propertys;

type
  TFmSudoku = class(TCommonFrame)
    pTools: TPanel;
    Bevel1: TBevel;
    bntHidePanel: TSpeedButton;
    chbOverwriteCells: TCheckBox;
    Splitter1: TSplitter;
    procedure bntHidePanelClick(Sender: TObject);
    procedure chbOverwriteCellsClick(Sender: TObject);
  private
    FPuzzle: TSudoku;
    FPuzFile: string;
    _ACapFontColor: integer;
    _ACapBackColor: integer;
    _ACapOpenColor: integer;
    _ACapOpenBackColor: integer;
    _AFCellStyle: TCellStyle;
    _AFCellChStyle: integer;
    _AShowCellsHint: boolean;
    _ACellFontSize: integer;
    _ACellFontName: string;
    _ACellFontStyle: TFontStyles;
    fblocked: boolean;
    procedure CreatePanelGrid; override;
    procedure ClearAll; override;
    procedure CreatePuzzleGrid;
    procedure RefreshGrid;
    procedure RefreshCell(ARow, ACol: integer);
    function GetNextNumber(num: integer; up: boolean = true): integer;
    function GetRandomSudoku: string;
    procedure SetTransparentColor(Color: TColor); override;
    function GetTransparentColor: TColor; override;
  protected
    procedure RefreshLabels; override;
    procedure CreateLabels; override;
    procedure ClearLabels; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetRangeState(State: integer); override;
    procedure SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean = false); override;
    procedure SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean); override;
    function SaveGame(filename: string; ShowDialog: boolean): boolean; override;
    procedure LoadGame; override;
    procedure GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); override;
    procedure GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer); override;
    procedure GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure GridCellKeyPress(Sender: TObject; var Key: Char); override;
    procedure UnSelectAll; override;
    procedure SelectAll; override;
    procedure SaveOldSettings; override;
    procedure SetSettings; override;
    function SaveCore: boolean; override;
    procedure ShowPrompt; override;
    procedure MoveToCell(Direction: TMoveDirection); override;
    function CheckSudoku(var ARow, ACol: integer): boolean;
    procedure FillRandom(AOverwriteAll: boolean); override;
    procedure Invert(AInvertBg: boolean); override;
    procedure DeleteRow(RowNo: integer; Count: integer = 1); override;
    procedure DeleteCol(ColNo: integer; Count: integer = 1); override;
    procedure AddRow(Index: integer = -1; Count: integer = 1); override;
    procedure AddCol(Index: integer = -1; Count: integer = 1); override;
    procedure Undo; override;
    procedure Redo; override;
    procedure ShowTools(AShow: boolean); override;
    procedure ShowProps; override;
  end;

implementation

{$R *.dfm}

{ TFmSudoku }

procedure TFmSudoku.AddCol(Index, Count: integer);
begin

end;

procedure TFmSudoku.AddRow(Index, Count: integer);
begin

end;

procedure TFmSudoku.bntHidePanelClick(Sender: TObject);
begin
  ShowTools(false);
end;

procedure TFmSudoku.chbOverwriteCellsClick(Sender: TObject);
begin
  frmSettings.OverwriteCells := chbOverwriteCells.Checked;
end;

function TFmSudoku.CheckSudoku(var ARow, ACol: integer): boolean;
begin
  result := FPuzzle.IsCorrect(ARow, ACol, true);
end;

procedure TFmSudoku.ClearAll;
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
end;

procedure TFmSudoku.ClearLabels;
begin

end;

constructor TFmSudoku.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetGameState(gsNone, gaNew);
  ChildClassName := Self.ClassName;
  GameType := cgSudoku;
end;

procedure TFmSudoku.CreateLabels;
begin
  // метки в судоку не используются
end;

procedure TFmSudoku.CreatePanelGrid;
begin
  inherited CreatePanelGrid; 
  pgPuzzle.FatLinesInterval := 3;
  pgPuzzle.OnCellClick := GridCellClick;
  pgPuzzle.OnCellDblClick := GridCellDblClick;
  pgPuzzle.OnMouseUp := GridCellMouseUp;
//  pgPuzzle.OnCellKeyPress := GridCellKeyPress;
end;

procedure TFmSudoku.CreatePuzzleGrid;
var
  i, j, n: integer;

begin
  if (FPuzzle = nil) then
  begin
    SetGameState(gsNone, gaNew);
    exit;
  end;

  try
    pgPuzzle.RowCount := 9;
    pgPuzzle.ColCount := 9;
    pgPuzzle.FirstFatRow := 0;
    pgPuzzle.FirstFatCol := 0;
    n := 1;
    if Assigned(SetProgress) then SetProgress(81, 0, 'Загрузка...', true);
    for i := 0 to 8 do
      for j := 0 to 8 do
      begin
        if FPuzzle.ItemState[i, j] in [1..9] then pgPuzzle.Cell[i, j].Text := FPuzzle.ItemText[i, j]
        else pgPuzzle.Cell[i, j].Text := '';
        if FPuzzle.ItemType[i, j] = 0 then pgPuzzle.Cell[i, j].Font.Color := frmSettings.ACapFontColor
        else pgPuzzle.Cell[i, j].Font.Color := frmSettings.ACapOpenColor;
        pgPuzzle.Cell[i, j].Font.Size := frmSettings.ACellFontSize;
        pgPuzzle.Cell[i, j].Font.Name := frmSettings.ACellFontName;
        pgPuzzle.Cell[i, j].Font.Style := frmSettings.ACellFontStyle;
        if (pgPuzzle.CurrCell <> nil) and (pgPuzzle.CurrCell = pgPuzzle.Cell[i, j]) then
        begin
          pgPuzzle.Cell[i, j].Style := TCellStyle(frmSettings.AFCellChStyle);
          pgPuzzle.Cell[i, j].Color := frmSettings.ACapOpenBackColor;
        end else
        begin
          pgPuzzle.Cell[i, j].Style := frmSettings.AFCellStyle;
          pgPuzzle.Cell[i, j].Color := frmSettings.ACapBackColor;
        end;
        pgPuzzle.Cell[i, j].ShowHint := frmSettings.AShowCellsHint;
        if Assigned(SetProgress) then SetProgress(0, n, '', true);
        Inc(n);
      end;
    if Assigned(SetProgress) then SetProgress(0, 0, '', false);
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

procedure TFmSudoku.DeleteCol(ColNo: integer; Count: integer);
begin

end;

procedure TFmSudoku.DeleteRow(RowNo: integer; Count: integer);
begin

end;

destructor TFmSudoku.Destroy;
begin
  ClearAll;
  inherited Destroy;
end;

procedure TFmSudoku.FillRandom(AOverwriteAll: boolean);
begin
  if FGameState = gsEdit then
  begin
    AChanged := true;
    FPuzzle.GenerateRandom(AOverwriteAll);
    RefreshGrid;
  end;
end;

function TFmSudoku.GetNextNumber(num: integer; up: boolean): integer;
begin
  if up then
    if num = 9 then result := 0
    else result := num + 1
  else
    if num = 0 then result := 9
    else result := num - 1;
  if result < 0 then result := 0;
  if result > 9 then result := 9;
end;

function TFmSudoku.GetRandomSudoku: string;
var
  sList: TStringList;
  sr: TSearchRec;
  fr: integer;

begin
  sList := TStringList.Create;
  try
    if not DirectoryExists(frmSettings.CrossFolder) then exit;
    fr := FindFirst(frmSettings.CrossFolder + '\*.' + GetExt(cgSudoku), faAnyFile, sr);
    while fr = 0 do
    begin
      sList.Add(sr.Name);
      fr := FindNext(sr);
    end;
    FindClose(sr);
    Randomize;
    result := sList.Strings[Random(sList.Count - 1)];
  finally
    sList.Free;
  end;
end;

function TFmSudoku.GetTransparentColor: TColor;
begin
  result := -1;
end;

procedure TFmSudoku.GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  if FPuzzle = nil then exit;
//  SetCellState(ARow, ACol, false, GetNextNumber(FPuzzle.ItemState[ARow, ACol]));
{  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(ARow + 1) + ', ' + IntToStr(ACol + 1) + ']', 3);}
  RefreshGrid;
end;

procedure TFmSudoku.GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  if FPuzzle = nil then exit;
  //SetCellState(ARow, ACol, false, GetNextNumber(FPuzzle.ItemState[ARow, ACol]));
{  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(ARow + 1) + ', ' + IntToStr(ACol + 1) + ']', 3);}
  RefreshGrid;
end;

procedure TFmSudoku.GridCellKeyPress(Sender: TObject; var Key: Char);
begin
{  if Ord(Key) in [49..57] then
    SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, Ord(Key));}
end;

procedure TFmSudoku.GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, 0);
end;

procedure TFmSudoku.Invert(AInvertBg: boolean);
begin

end;

procedure TFmSudoku.LoadGame;
var
  f: TFileStream;
  i, j: integer;
  b: byte;
  s: char;
  filename: string;
  pos: integer;
  _oldtext: string;
  _blMap: TSudokuCore;
  head: TSaveFileHeader;
  OPDialog: TfrmOpenPuzzle;

begin
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(filename, cgSudoku, true, false) then exit;

  if ExtractFileExt(filename) = '' then filename := filename + '.' + GetExt(cgSudoku, true);
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
      SetGameState(gsGame, gaCurrent, true);
      //frmSettings.ADifficulty := _olddiff;
      if Assigned(GetStatus) then _oldtext := GetStatus(2);
      SetProgress(head.sz_base + head.sz_extra, 0, 'Загрузка...', true);
      GameTime := head.GTime;
      StartTime := Time - GameTime;
      pos := 0;

      //грузим текущее состояние
      for i := 0 to SUDOKUSIZELIMIT - 1 do
        for j := 0 to SUDOKUSIZELIMIT - 1 do
        begin
          Inc(pos);
          f.Read(b, SizeOf(byte));
          FPuzzle.ItemState[i, j] := b;
          SetProgress(0, Pos, '', true);
        end;

      //грузим массив блокировок
      SetLength(_blMap, SUDOKUSIZELIMIT);
      for i := 0 to SUDOKUSIZELIMIT - 1 do SetLength(_blMap[i], SUDOKUSIZELIMIT);

      for i := 0 to SUDOKUSIZELIMIT - 1 do
        for j := 0 to SUDOKUSIZELIMIT - 1 do
        begin
          Inc(pos);
          f.Read(b, SizeOf(byte));
          _blMap[i][j] := b;
          SetProgress(0, Pos, '', true);
        end;
      FPuzzle.BlockMap := _blMap;

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

procedure TFmSudoku.MoveToCell(Direction: TMoveDirection);
var
  ACol, ARow: integer;

begin
  ACol := 0;
  ARow := 0;
  if pgPuzzle.CurrCell <> nil then
    case Direction of
      mdUp:
      begin
        ARow := pgPuzzle.CurrCell.Row - 1;
        ACol := pgPuzzle.CurrCell.Col;
        if ARow < 0 then ARow := 0;
      end;
      mdDown:
      begin
        ARow := pgPuzzle.CurrCell.Row + 1;
        ACol := pgPuzzle.CurrCell.Col;
        if ARow >= pgPuzzle.RowCount then ARow := pgPuzzle.RowCount - 1;
      end;
      mdLeft:
      begin
        ARow := pgPuzzle.CurrCell.Row;
        ACol := pgPuzzle.CurrCell.Col - 1;
        if ACol < 0 then ACol := 0;
      end;
      mdRight:
      begin
        ARow := pgPuzzle.CurrCell.Row;
        ACol := pgPuzzle.CurrCell.Col + 1;
        if ACol >= pgPuzzle.ColCount then ACol := pgPuzzle.ColCount - 1;
      end;
    end;

  pgPuzzle.CurrCell := pgPuzzle.Cell[ARow, ACol];
  RefreshGrid;
end;

procedure TFmSudoku.Redo;
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

procedure TFmSudoku.RefreshCell(ARow, ACol: integer);
begin
  if FPuzzle.ItemState[ARow, ACol] in [1..9] then pgPuzzle.Cell[ARow, ACol].Text := FPuzzle.ItemText[ARow, ACol]
  else pgPuzzle.Cell[ARow, ACol].Text := '';
  if FPuzzle.ItemType[ARow, ACol] = 0 then pgPuzzle.Cell[ARow, ACol].Font.Color := frmSettings.ACapFontColor
  else pgPuzzle.Cell[ARow, ACol].Font.Color := frmSettings.ACapOpenColor;
  pgPuzzle.Cell[ARow, ACol].ShowHint := frmSettings.AShowCellsHint;
  pgPuzzle.Cell[ARow, ACol].Font.Size := frmSettings.ACellFontSize;
  pgPuzzle.Cell[ARow, ACol].Font.Name := frmSettings.ACellFontName;
  pgPuzzle.Cell[ARow, ACol].Font.Style := frmSettings.ACellFontStyle;
  if (pgPuzzle.CurrCell <> nil) and (pgPuzzle.CurrCell = pgPuzzle.Cell[ARow, ACol]) then
  begin
    pgPuzzle.Cell[ARow, ACol].Style := TCellStyle(frmSettings.AFCellChStyle);
    pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ACapOpenBackColor;
    if Assigned(SetStatus) then SetStatus('Тек. яч. [' + IntToStr(ARow + 1) + ', ' + IntToStr(ACol + 1) + ']', 3);
  end else
  begin
    pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle;
    pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ACapBackColor;
  end;
end;

procedure TFmSudoku.RefreshGrid;
var
  i, j{, n}: integer;

begin
  if FPuzzle = nil then exit;
//  n := 1;
//  SetProgress(81, 0, '', true);
  try
    for i := 0 to 8 do
      for j := 0 to 8 do
      begin
        RefreshCell(i, j);
//        SetProgress(0, n, '', true);
//        Inc(n);
      end;
  finally
//    SetProgress(0, 0, '', false);
  end;
end;

procedure TFmSudoku.RefreshLabels;
begin

end;

function TFmSudoku.SaveCore: boolean;
var
  sname: string;
  wr: integer;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if FPuzzle = nil then exit;
  if (FPuzFile = '.' + GetExt(cgSudoku)) or (FPuzFile = '') then
    FPuzFile := GetDefaultFileName(cgSudoku); //GenRandString(0, 8);
  sname := FPuzFile;
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(sname, cgSudoku, false, true) then exit;
  if Trim(sname) = '' then exit;
  sname := frmSettings.CrossFolder + '\' + sname;
  if AnsiLowerCase(ExtractFileExt(sname)) <> '.' + GetExt(cgSudoku) then sname := sname + '.' + GetExt(cgSudoku);
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
  if Trim(FPuzzle.Name) = '' then FPuzzle.Name := FPuzzle.FileName;
  result := FPuzzle.SaveCore(sname);
  FPuzFile := FPuzzle.FileName;
  if result then AChanged := false;
end;

function TFmSudoku.SaveGame(filename: string; ShowDialog: boolean): boolean;
var
  f: TFileStream;
  i, j: integer;
  wr: integer;
  pos: integer;
  b: byte;
  head: TSaveFileHeader;
  Mode: word;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if (FPuzzle = nil) or fblocked then exit;
  if ShowDialog then
  begin
    OPDialog := TfrmOpenPuzzle.Create(self);
    if not OPDialog.Execute(filename, cgSudoku, true, true) then exit;
    if Trim(filename) = '' then exit;
    filename := frmSettings.SaveFolder + '\' + filename;
    if AnsiLowerCase(ExtractFileExt(filename)) <> '.' + GetExt(cgSudoku, true) then filename := filename + '.' + GetExt(cgSudoku, true);
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
    SetProgress(SUDOKUSIZELIMIT * SUDOKUSIZELIMIT, 0, 'Сохранение...', true);
    if FPuzFile = '' then FPuzFile := FPuzzle.FileName;
    head._type := Ord(cgSudoku);
    head.Difficulty := Ord(FPuzzle.Difficulty);
    head.GTime := GameTime;
    head.sz_name := Length(FPuzFile);
    head.sz_user := Length(frmSettings.AUser);
    head.sz_base := SUDOKUSIZELIMIT * SUDOKUSIZELIMIT;
    head.sz_extra := SUDOKUSIZELIMIT * SUDOKUSIZELIMIT;
    head.b_top := 0;
    head.b_left := 0;
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
      for i := 0 to SUDOKUSIZELIMIT - 1 do
        for j := 0 to SUDOKUSIZELIMIT - 1 do
        begin
          Inc(pos);
          b := FPuzzle.ItemState[i, j];
          f.Write(b, SizeOf(byte));
          SetProgress(0, pos, '', true);
        end;

      //блок 4 - матрица блокировок
      for i := 0 to SUDOKUSIZELIMIT - 1 do
        for j := 0 to SUDOKUSIZELIMIT - 1 do
        begin
          Inc(pos);
          b := FPuzzle.BlockMap[i][j];
          f.Write(b, SizeOf(byte));
          SetProgress(0, pos, '', true);
        end;

      result := true;
    except
      on e: Exception do
      begin
        Application.MessageBox(pchar('Не удалось сохранить игру!'#13#10 + e.Message), 'Ошибка', MB_OK + MB_ICONERROR);
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

procedure TFmSudoku.SaveOldSettings;
begin
  _ACapFontColor := frmSettings.ACapFontColor;
  _ACapBackColor := frmSettings.ACapBackColor;
  _ACapOpenColor := frmSettings.ACapOpenColor;
  _ACapOpenBackColor := frmSettings.ACapOpenBackColor;
  _AFCellStyle := frmSettings.AFCellStyle;
  _AFCellChStyle := frmSettings.AFCellChStyle;
  _AShowCellsHint := frmSettings.AShowCellsHint;
  _ACellFontName := frmSettings.ACellFontName;
  _ACellFontSize := frmSettings.ACellFontSize;
  _ACellFontStyle := frmSettings.ACellFontStyle;
end;
                    
procedure TFmSudoku.SelectAll;
begin

end;

procedure TFmSudoku.SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean);
var
  r, c: integer;

begin
  if not (GameState in [gsGame, gsEdit]) then exit;
  if (FPuzzle = nil) or (ARow >= 9) or (ACol >= 9) then exit;
  if not (State in [0..9]) then State := FPuzzle.ItemState[ARow, ACol];
  AChanged := true;
  if ToUndo then
  begin
    AddToUndo(ARow, ACol, FPuzzle.ItemState[ARow, ACol]);
    AddToUBlocks(1);
    ClearRedo;
  end;
  FPuzzle.ItemState[ARow, ACol] := State;
  RefreshCell(ARow, ACol);
  if FPuzzle.IsCorrect(r, c) then SetGameState(gsWin, gaNew);
end;

procedure TFmSudoku.SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean);
var
  OPDialog: TfrmOpenPuzzle;
  pf: string;
  r, c: integer;

begin
  Screen.Cursor := crHourGlass;
  try
    FGameState := GState;
    case FGameState of
      gsGame:
      try
        if GAction = gaReload then
        begin
          AChanged := false;
          FPuzzle.ReloadMatrix;
          RefreshGrid;
        end else
        begin
          if (GAction <> gaCurrent) then pf := GetRandomSudoku
          else pf := FPuzFile;
          ClearAll;
          if (GAction = gaCurrent) or (frmSettings.AFastSudoku or StartSudoku(pf, frmSettings.ADifficulty)) then
          begin
            pf := frmSettings.CrossFolder + '\' + pf;
            FPuzzle := TSudoku.CreateForFile(pf, bhAsynchro, frmSettings.ADifficulty, AEmpty);
          end else
          begin
            SetGameState(gsNone, gaNew);
            exit;
          end;
          FPuzFile := FPuzzle.FileName;
          SetStatus(FPuzzle.Name + ' <' + DifficultyAsText(FPuzzle.Difficulty, lRU) + '>', 2);
          SetStatus(frmSettings.AUser, 0);
          CreatePuzzleGrid;
          pgPuzzle.Visible := true;
        end;
        StartTime := Time;
        AtmrGame.Enabled := True;
        //if frmSettings.ARulerArea in [raBoth, raGame] then SetRuler;
        //AtmrAutosave.Enabled := frmSettings.Autosave;
        if frmSettings.Autosave then Autosave;
        if FPuzzle.IsCorrect(r, c) then SetGameState(gsWin, gaNew);
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
        HideRuler;
        if (FPuzzle = nil) or FPuzzle.IsEmpty then
        begin
          SetGameState(gsNone, gaNew);
          exit;
        end;
        AChanged := false;
        AtmrGame.Enabled := false;
        StartTime := 0;
        Application.MessageBox('УРА! ВЫ РАЗГАДАЛИ СУДОКУ!', pchar('Победа'), MB_OK + MB_ICONEXCLAMATION);
        frmSettings.AUser := InputBox(Application.Title, 'Введите ваше имя для записи в таблицу рекордов', frmSettings.AUser);
        SetStatus(frmSettings.AUser, 0);
        SaveRecord(cgSudoku, FPuzzle.Difficulty, SUDOKUSIZELIMIT, SUDOKUSIZELIMIT, frmSettings.AUser, FPuzzle.Name, GameTime);
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
        case GAction of
          gaNew: FPuzzle := TSudoku.CreateEmpty(false);
          gaRandom:
          begin
            FPuzzle := TSudoku.CreateEmpty(true);
            AChanged := true;
          end;
          gaCurrent: FPuzzle := TSudoku.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhSynchro, frmSettings.ADifficulty);
          gaOther:
            if OPDialog.Execute(pf, cgSudoku, false, false) then
              FPuzzle := TSudoku.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhSynchro, frmSettings.ADifficulty);
          gaImport3:
          begin
            OpenDialog.FileName := '';
            OpenDialog.InitialDir := frmSettings.LastImgFolder;
            OpenDialog.Filter := 'Текстовые файлы (TXT)|*.txt';
            OpenDialog.Title := 'Выберите файл с судоку';
            if OpenDialog.Execute then
            begin
              frmSettings.LastImgFolder := ExtractFileDir(OpenDialog.FileName);
              FPuzzle := TSudoku.CreateForText(OpenDialog.FileName);
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
        if FPuzzle.Name = '' then FPuzzle.Name := FPuzzle.FileName; 
        SetStatus(iif(FPuzzle.Name = '', '', '[' + FPuzzle.Name + ']'), 2);
        SetStatus('Редактор', 0);
        PSetActionButtons(true);
        CreatePuzzleGrid;
        RefreshGrid;
        pgPuzzle.Visible := true;
        ShowTools(true);
        //if frmSettings.ARulerArea in [raBoth, raEditor] then SetRuler;
      except
        on e: exception do
        begin
          SetGameState(gsNone, gaNew);
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    RefreshGrid;
    if Assigned(FPuzzle) then
    begin
      FPuzzle.PromptLeft := frmSettings.APromptLeft;
      FPuzzle.PromptTop := frmSettings.APromptTop;
    end;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmSudoku.SetRangeState(State: integer);
begin
  if Assigned(pgPuzzle.CurrCell) and (State in [0..9]) then
    SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, State, true);
end;

procedure TFmSudoku.SetSettings;
begin
  if frmSettings.AutoCellSize then tmrResize.Interval := 500
  else tmrResize.Interval := 1;
  
  if Assigned(FPuzzle) and (not FPuzzle.IsEmpty) then
  begin
    pgPuzzle.CellsFontSize := frmSettings.ACellFontSize;
    pgPuzzle.FatLinesWidth := frmSettings.AFatLinesWidth;
    pgPuzzle.GridLinesWidth := frmSettings.ALinesWidth;
    pgPuzzle.DefaultShowHint := frmSettings.AShowCellsHint;
  end;
  RefreshGridMetrics;
  pgPuzzle.RefreshCells;

  if (_ACapFontColor <> frmSettings.ACapFontColor) or (_ACapBackColor <> frmSettings.ACapBackColor) or
    (_ACapOpenBackColor <> frmSettings.ACapOpenBackColor) or (_AFCellStyle <> frmSettings.AFCellStyle) or
    (_AShowCellsHint <> frmSettings.AShowCellsHint) or (_ACapOpenColor <> frmSettings.ACapOpenColor) or
    (_AFCellChStyle <> frmSettings.AFCellChStyle) or (_ACellFontSize <> frmSettings.ACellFontSize) or
    (_ACellFontName <> frmSettings.ACellFontName) or (_ACellFontStyle <> frmSettings.ACellFontStyle) then
    RefreshGrid;
    
  HideRuler;
end;

procedure TFmSudoku.SetTransparentColor(Color: TColor);
begin

end;

procedure TFmSudoku.ShowPrompt;
begin
  Penalty := true;
  if Assigned(FPuzzle) then FPuzzle.ShowPreview;
end;

procedure TFmSudoku.ShowProps;
var
  fprops: TFProps;

begin
  fprops := TFProps.Create(self);
  try
    //fprops.Difficulty := FPuzzle.Difficulty;
    fprops.cbDifficulty.Enabled := false;
    fprops.cbDifficulty.ItemIndex := -1;
    fprops.PuzzleName := FPuzzle.Name;
    fprops.edWidth.Enabled := false;
    fprops.edHeight.Enabled := false;
    fprops.AWidth := SUDOKUSIZELIMIT;
    fprops.AHeight := SUDOKUSIZELIMIT;
    if fprops.Exec then
    begin
      AChanged := true;
      //FPuzzle.Difficulty := fprops.Difficulty;
      //frmSettings.ADifficulty := FPuzzle.Difficulty;
      FPuzzle.Name := fprops.PuzzleName;
      SetStatus(FPuzzle.Name + ' <' + DifficultyAsText(FPuzzle.Difficulty, lRU) + '>', 2);
    end;
  finally
    fprops.Free;
  end;
end;

procedure TFmSudoku.ShowTools(AShow: boolean);
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

procedure TFmSudoku.Undo;
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

procedure TFmSudoku.UnSelectAll;
begin

end;

end.
