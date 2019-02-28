unit frmCCPuzzle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs, ExtCtrls, frxClass,
  settings, pgrid, select_puzzle, frmCommon, cpuzzle, jsCommon, imgUtils, Buttons, DB, ExtDlgs, toolbox, MemTableDataEh,
  MemTableEh, propertys;

type
  TFmCCrossPuzzle = class(TCommonFrame)
    ColorDialog: TColorDialog;
    pTools: TPanel;
    ScrollBox2: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    edBrushColor: TImage;
    edTranspColor: TImage;
    bntHidepanel: TSpeedButton;
    Bevel1: TBevel;
    Splitter1: TSplitter;
    chbOverwriteCells: TCheckBox;
    chbInvertBg: TCheckBox;
    Label3: TLabel;
    procedure edTranspColorClick(Sender: TObject);
    procedure edBrushColorClick(Sender: TObject);
    procedure edTranspColorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bntHidepanelClick(Sender: TObject);
    procedure chbOverwriteCellsClick(Sender: TObject);
    procedure chbInvertBgClick(Sender: TObject);
  private
    FPuzzle: TCrossPuzzle;
    FPuzFile: string;
    FPalControls: array of TImage;
    FShift: boolean;
    _AImgGrayedColor: integer;
    _ACapBackColor: integer;
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
    procedure ImgClick(Sender: TObject);
    procedure ClearPalette;
    procedure CreatePalette(Pal: TColors);
    procedure SetBrushColor(Color: TColor); override;
    procedure SetImageColor(Img: TImage; AColor: TColor);
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
    procedure GridCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
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

procedure TFmCCrossPuzzle.AddCol(Index, Count: integer);
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

procedure TFmCCrossPuzzle.AddRow(Index, Count: integer);
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

procedure TFmCCrossPuzzle.bntHidepanelClick(Sender: TObject);
begin
  ShowTools(false);
end;

procedure TFmCCrossPuzzle.chbInvertBgClick(Sender: TObject);
begin
  frmSettings.InvertBackground := chbInvertBg.Checked;
end;

procedure TFmCCrossPuzzle.chbOverwriteCellsClick(Sender: TObject);
begin
  frmSettings.OverwriteCells := chbOverwriteCells.Checked;
end;

procedure TFmCCrossPuzzle.ClearAll;
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
  ClearPalette;
end;

procedure TFmCCrossPuzzle.ClearPalette;
var
  i: integer;

begin
  for i := 0 to Length(FPalControls) - 1 do
    if Assigned(FPalControls[i]) then FPalControls[i].Free;
  SetLength(FPalControls, 0);
end;

constructor TFmCCrossPuzzle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetGameState(gsNone, gaNew);
  ChildClassName := Self.ClassName;
  GameType := cgCCrossPuzzle;
end;

procedure TFmCCrossPuzzle.CreatePalette(Pal: TColors);
var
  i, x, y: integer;
  img: TImage;

begin
  SetLength(FPalControls, 0);
  x := 0;
  for i := 0 to Length(Pal) - 1 do
  begin
    y := Round(Int(i / 30));
    if (i mod 30) = 0 then x := 0
    else Inc(x);

    img := TImage.Create(self);
    img.Parent := ScrollBox2;
    img.Height := 15;
    img.Width := 15;
    if x = 0 then img.Left := 1
    else img.Left := img.Width * x;
    if y = 0 then img.Top := 1
    else img.Top := img.Height * y;
    img.Canvas.Brush.Color := Pal[i];
    img.Canvas.Rectangle(img.ClientRect);
    img.OnClick := ImgClick;
    img.Visible := True;
    img.Cursor := crHandPoint;
    img.Hint := 'Нажми, чтобы задать цвет кисти';
    img.ShowHint := true;
    SetLength(FPalControls, i + 1);
    FPalControls[i] := img;
  end;
end;

procedure TFmCCrossPuzzle.CreatePanelGrid;
begin
  inherited CreatePanelGrid;
  pgPuzzle.FatLinesInterval := 5;
  pgPuzzle.OnCellClick := GridCellClick;
  pgPuzzle.OnCellDblClick := GridCellDblClick;
  pgPuzzle.OnMouseUp := GridCellMouseUp;
  pgPuzzle.OnMouseDown := GridCellMouseDown;
end;

procedure TFmCCrossPuzzle.CreatePuzzleGrid;
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
            pgPuzzle.Cell[i, j].Font.Color := InvertBright(FPuzzle.ItemState[i, j]);//InvertColor(FPuzzle.ItemState[i, j]);
            pgPuzzle.Cell[i, j].Font.Size := GetFontSize(pgPuzzle.CellsHeight);
            if (FPuzzle.ItemText[i, j] = '') or (FPuzzle.ItemState[i, j] = -1) then pgPuzzle.Cell[i, j].Color := frmSettings.ACapBackColor
            else pgPuzzle.Cell[i, j].Color := FPuzzle.ItemState[i, j];
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

procedure TFmCCrossPuzzle.DeleteCol(ColNo: integer; Count: integer);
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

procedure TFmCCrossPuzzle.DeleteRow(RowNo: integer; Count: integer);
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

destructor TFmCCrossPuzzle.Destroy;
begin
  ClearAll;
  inherited Destroy;
end;

procedure TFmCCrossPuzzle.edBrushColorClick(Sender: TObject);
begin
  if FGameState = gsEdit then
  begin
    ColorDialog.Color := BrushColor;
    if ColorDialog.Execute then BrushColor := ColorDialog.Color;
  end;
end;

procedure TFmCCrossPuzzle.edTranspColorClick(Sender: TObject);
begin
  if FGameState = gsEdit then
  begin
    ColorDialog.Color := FPuzzle.TransparentColor;
    if ColorDialog.Execute then SetTransparentColor(ColorDialog.Color);
  end;
end;

procedure TFmCCrossPuzzle.edTranspColorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then BrushColor := FPuzzle.TransparentColor;
end;

procedure TFmCCrossPuzzle.FillRandom(AOverwriteAll: boolean);
begin
  if FGameState = gsEdit then
  begin
    AChanged := true;
    FPuzzle.GenerateRandom(AOverwriteAll);
    RefreshGrid;
  end;
end;

procedure TFmCCrossPuzzle.LoadGame;
var
  f: TFileStream;
  i, j: integer;
  c: TColor;
  s: char;
  filename: string;
  pos: integer;
  _oldtext: string;
  head: TSaveFileHeader;
  OPDialog: TfrmOpenPuzzle;

begin
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(filename, cgCCrossPuzzle, true, false) then exit;

  if ExtractFileExt(filename) = '' then filename := filename + '.' + GetExt(cgCCrossPuzzle, true);
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
          f.Read(c, SizeOf(integer));
          FPuzzle.ItemState[i, j] := c;
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

procedure TFmCCrossPuzzle.MoveToCell(Direction: TMoveDirection);
begin

end;

procedure TFmCCrossPuzzle.SetBrushColor(Color: TColor);
begin
  FBrushColor := Color;
  SetImageColor(edBrushColor, FBrushColor);
  if FBrushColor = FPuzzle.TransparentColor then
  begin
    edBrushColor.Canvas.Pen.Color := InvertColor(FBrushColor);
    edBrushColor.Canvas.TextOut(4, 2, 'Ф');
  end;
end;

function TFmCCrossPuzzle.GetTransparentColor: TColor;
begin
  if Assigned(FPuzzle) then result := FPuzzle.TransparentColor
  else result := $FFFFFF;
end;

procedure TFmCCrossPuzzle.GridCellClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  if FPuzzle = nil then exit;
  if not FShift then SetCellState(ARow, ACol, FPuzzle.ItemType[ARow, ACol] = pztCell, BrushColor, true);
  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(pgPuzzle.CurrCell.Row - FPuzzle.TopIndent + 1) + ', ' +
      IntToStr(pgPuzzle.CurrCell.Col - FPuzzle.LeftIndent + 1) + ']', 3);
end;

procedure TFmCCrossPuzzle.GridCellDblClick(Sender: TObject; Rect: TRect; ARow, ACol: Integer);
begin
  {if FPuzzle = nil then exit;
  SetCellState(ARow, ACol, true, FPuzzle.ItemState[ARow, ACol]);
  if Assigned(SetStatus) then
    SetStatus('Тек. яч. [' + IntToStr(pgPuzzle.CurrCell.Row - FPuzzle.TopIndent + 1) +
      ', ' + IntToStr(pgPuzzle.CurrCell.Col - FPuzzle.LeftIndent + 1) + ']', 3);}
end;

procedure TFmCCrossPuzzle.GridCellKeyPress(Sender: TObject; var Key: Char);
begin

end;

procedure TFmCCrossPuzzle.GridCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssShift in Shift then FShift := true;
end;

procedure TFmCCrossPuzzle.GridCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FShift := false;
  if (not Assigned(FPuzzle)) or (not Assigned(pgPuzzle)) or (not Assigned(pgPuzzle.CurrCell)) then exit;
  if Button = mbRight then
  begin
    if FGameState = gsEdit then
      BrushColor := FPuzzle.ItemState[pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col]
    else
      if ssShift in Shift then SetRangeState(-1)
      else begin
        if FPuzzle.ItemType[pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col] = pztCaption then
          SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, true, 0, true)
        else begin
          if FPuzzle.ItemState[pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col] = -1 then
            SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, TransparentColor, true)
          else
            SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, false, -1, true);
        end;
      end;
  end else
    if ssShift in Shift then SetRangeState(BrushColor){
    else SetCellState(pgPuzzle.CurrCell.Row, pgPuzzle.CurrCell.Col, true, BrushColor)};
end;

procedure TFmCCrossPuzzle.ImgClick(Sender: TObject);
begin
  BrushColor := TImage(Sender).Canvas.Brush.Color;
end;

procedure TFmCCrossPuzzle.Invert(AInvertBg: boolean);
begin
  if FGameState = gsEdit then
  begin
    AChanged := true;
    FPuzzle.Invert(AInvertBg);
    RefreshGrid;
  end;
end;

procedure TFmCCrossPuzzle.Redo;
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
    if FPuzzle.ItemType[ud[i].p.X, ud[i].p.Y] = pztCell then
    begin
      Inc(c);
      AddToUndo(ud[i].p, FPuzzle.ItemState[ud[i].p.X, ud[i].p.Y]);
      SetCellState(ud[i].p.X, ud[i].p.Y, false, ud[i].val, false);
    end;
  end;
  if c > 0 then AddToUBlocks(c);
end;

procedure TFmCCrossPuzzle.RefreshCell(ARow, ACol: integer);
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
    begin
      if (FPuzzle.ItemText[ARow, ACol] = '') or (FPuzzle.ItemState[ARow, ACol] = -1) then
      begin
        pgPuzzle.Cell[ARow, ACol].Font.Color := frmSettings.ACapOpenColor;
        pgPuzzle.Cell[ARow, ACol].Color := frmSettings.ACapBackColor
      end else
      begin
        pgPuzzle.Cell[ARow, ACol].Font.Color := InvertBright(FPuzzle.ItemState[ARow, ACol]);//InvertColor(FPuzzle.ItemState[ARow, ACol]);
        pgPuzzle.Cell[ARow, ACol].Color := FPuzzle.ItemState[ARow, ACol];
      end;
      pgPuzzle.Cell[ARow, ACol].Style := frmSettings.ACapCellStyle;
    end;
    pztCell:
    begin
      if FPuzzle.ItemState[ARow, ACol] > -1 then
      begin
        pgPuzzle.Cell[ARow, ACol].Color := FPuzzle.ItemState[ARow, ACol];
        if frmSettings.AFCellChStyle < 0 then
          pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle
        else
          pgPuzzle.Cell[ARow, ACol].Style := TCellStyle(frmSettings.AFCellChStyle);
      end else
      begin
        pgPuzzle.Cell[ARow, ACol].Color := frmSettings.AImgGrayedColor;
        pgPuzzle.Cell[ARow, ACol].Style := frmSettings.AFCellStyle;
      end;
    end;
  end;
end;

procedure TFmCCrossPuzzle.RefreshGrid;
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

function TFmCCrossPuzzle.SaveCore: boolean;
var
  sname: string;
  wr: integer;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if FPuzzle = nil then exit;
  if Trim(FPuzzle.Name) = '' then raise Exception.Create('Сначала введите название кроссворда в диалоге свойств (Главное меню-Редактор-Свойства)!');
  if (FPuzFile = '.' + GetExt(cgCCrossPuzzle)) or (FPuzFile = '') then
    FPuzFile := GetDefaultFileName(cgCCrossPuzzle); //GenRandString(0, 8);
  sname := FPuzFile;
  OPDialog := TfrmOpenPuzzle.Create(self);
  if not OPDialog.Execute(sname, cgCCrossPuzzle, false, true) then exit;
  if Trim(sname) = '' then exit;
  sname := frmSettings.CrossFolder + '\' + sname;
  if AnsiLowerCase(ExtractFileExt(sname)) <> '.' + GetExt(cgCCrossPuzzle) then sname := sname + '.' + GetExt(cgCCrossPuzzle);
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

function TFmCCrossPuzzle.SaveGame(filename: string; ShowDialog: boolean): boolean;
var
  f: TFileStream;
  i, j: integer;
  wr: integer;
  pos: integer;
  head: TSaveFileHeader;
  Mode: word;
  c: TColor;
  OPDialog: TfrmOpenPuzzle;

begin
  result := false;
  if (FPuzzle = nil) or fblocked then exit;
  if ShowDialog then
  begin
    OPDialog := TfrmOpenPuzzle.Create(self);
    if not OPDialog.Execute(filename, cgCCrossPuzzle, true, true) then exit;
    if Trim(filename) = '' then exit;
    filename := frmSettings.SaveFolder + '\' + filename;
    if AnsiLowerCase(ExtractFileExt(filename)) <> '.' + GetExt(cgCCrossPuzzle, true) then
      filename := filename + '.' + GetExt(cgCCrossPuzzle, true);
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
    head._type := Ord(cgCCrossPuzzle);
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
          c := FPuzzle.ItemState[i, j];
          f.Write(c, SizeOf(integer));
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

procedure TFmCCrossPuzzle.SaveOldSettings;
begin
  _AImgGrayedColor := frmSettings.AImgGrayedColor;
  _ACapCellStyle := frmSettings.ACapCellStyle;
  _AFCellStyle := frmSettings.AFCellStyle;
  _ACapCellChStyle := frmSettings.ACapCellChStyle;
  _AFCellChStyle := frmSettings.AFCellChStyle;
  _AShowCellsHint := frmSettings.AShowCellsHint;
  _ACapBackColor := frmSettings.ACapBackColor;
end;

procedure TFmCCrossPuzzle.SelectAll;
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

procedure TFmCCrossPuzzle.SetCellState(ARow, ACol: integer; Next: boolean; State: integer; ToUndo: boolean);
begin
  if not (GameState in [gsGame, gsEdit]) then exit;
  if (FPuzzle = nil) or (ARow >= FPuzzle.RowCount) or (ACol >= FPuzzle.ColCount) then exit;
  case FPuzzle.ItemType[ARow, ACol] of
    pztNone, pztService: exit;
    pztCaption:
    begin
      // Next = true - это нажата Правая кнопка мышки, иначе Левая
      if Next then
      begin
        if FPuzzle.ItemState[ARow, ACol] = -1 then FPuzzle.RestoreItemState(ARow, ACol)
        else FPuzzle.ItemState[ARow, ACol] := -1;
      end else
        if (FPuzzle.ItemText[ARow, ACol] = '') or (FPuzzle.ItemState[ARow, ACol] = -1) then BrushColor := FPuzzle.TransparentColor
        else BrushColor := FPuzzle.ItemState[ARow, ACol];
    end;
    pztCell:
    begin
      AChanged := true;
      if ToUndo then
      begin
        AddToUndo(ARow, ACol, FPuzzle.ItemState[ARow, ACol]);
        AddToUBlocks(1);
        ClearRedo;
      end;
      if Next then FPuzzle.ItemState[ARow, ACol] := BrushColor
      else FPuzzle.ItemState[ARow, ACol] := State;
    end;
  end;
  RefreshCell(ARow, ACol);
  if FPuzzle.IsCorrect then SetGameState(gsWin, gaNew);
end;

procedure TFmCCrossPuzzle.SetGameState(GState: TGameState; GAction: TGameAction; AEmpty: boolean);
var
  OPDialog: TfrmOpenPuzzle;
  IPDialog: TFToolBox;
  pf: string;
  props: TFProps;

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
        if (GAction = gaCurrent) or OPDialog.Execute(pf, cgCCrossPuzzle, false, false) then
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
        CreatePalette(FPuzzle.Palette);
        if Length(FPuzzle.Palette) > 0 then BrushColor := FPuzzle.Palette[0]
        else BrushColor := 0;
        SetImageColor(edTranspColor, FPuzzle.TransparentColor);
        ShowTools(true);
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
        SaveRecord(cgCCrossPuzzle, FPuzzle.Difficulty, FPuzzle.CoreColCount, FPuzzle.CoreRowCount, frmSettings.AUser, FPuzzle.Name, GameTime);
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
            if OPDialog.Execute(pf, cgCCrossPuzzle, false, false) then
              FPuzzle := TCrossPuzzle.CreateForFile(frmSettings.CrossFolder + '\' + pf, bhSynchro, frmSettings.ADifficulty);
          gaImport:
          begin
            OpenPicDialog.FileName := '';
            OpenPicDialog.InitialDir := frmSettings.LastImgFolder;
            OpenPicDialog.Filter := 'Изображения (bmp, jpg, jpeg, ico, gif, png)|*.bmp;*.jpg;*.jpeg;*.ico;*.gif;*.png|' +
              'Точечные рисунки (bmp)|*.bmp|Рисунки (jpeg)|*.jpg;*.jpeg|Иконки (ico)|*.ico|Анимированные рисунки (gif)|*.gif|' +
              'Значки (png)|*.png';
            OpenPicDialog.Title := 'Выберите картинку';
            if OpenPicDialog.Execute then
            begin
              IPDialog.ShowDlg(cgCCrossPuzzle, GAction);
              frmSettings.LastImgFolder := ExtractFileDir(OpenPicDialog.FileName);
              FPuzzle := TCrossPuzzle.CreateForImage(OpenPicDialog.FileName, frmSettings.AImgInvert, frmSettings.AGammaCoeff,
                frmSettings.APxFormat, frmSettings.ACrossHeight, frmSettings.ACrossWidth);
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
        CreatePalette(FPuzzle.Palette);
        BrushColor := FPuzzle.ItemState[0, 0];
        SetImageColor(edTranspColor, FPuzzle.TransparentColor);
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

procedure TFmCCrossPuzzle.SetImageColor(Img: TImage; AColor: TColor);
begin
  Img.Canvas.Brush.Color := AColor;
  Img.Canvas.Rectangle(Img.ClientRect);
end;

procedure TFmCCrossPuzzle.SetRangeState(State: integer);
var
  i, j, c: integer;

begin
  c := 0;
  for i := pgPuzzle.Selection.Top to pgPuzzle.Selection.Bottom do
    for j := pgPuzzle.Selection.Left to pgPuzzle.Selection.Right do
    begin
      Inc(c);
      AddToUndo(i, j, FPuzzle.ItemState[i, j]);
      if FPuzzle.ItemType[i, j] = pztCell then SetCellState(i, j, false, State, false);
    end;
  AddToUBlocks(c);
  ClearRedo;
  pgPuzzle.ClearSelection;
end;

procedure TFmCCrossPuzzle.SetSettings;
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

  if (_ACapBackColor <> frmSettings.ACapBackColor) or (_AImgGrayedColor <> frmSettings.AImgGrayedColor) or
    (_ACapCellStyle <> frmSettings.ACapCellStyle) or (_AFCellStyle <> frmSettings.AFCellStyle) or
    (_ACapCellChStyle <> frmSettings.ACapCellChStyle) or (_AFCellChStyle <> frmSettings.AFCellChStyle) or
    (_AShowCellsHint <> frmSettings.AShowCellsHint) then
    RefreshGrid;
  if ((GameState in [gsGame, gsEdit]) and (frmSettings.ARulerArea = raBoth)) or
    ((GameState = gsGame) and (frmSettings.ARulerArea in [raGame, raBoth])) or
    ((GameState = gsEdit) and (frmSettings.ARulerArea in [raEditor, raBoth])) then
    SetRuler
  else
    HideRuler;
end;

procedure TFmCCrossPuzzle.SetTransparentColor(Color: TColor);
begin
  FPuzzle.TransparentColor := Color;
  SetImageColor(edTranspColor, FPuzzle.TransparentColor);
  if FBrushColor = FPuzzle.TransparentColor then
  begin
    edBrushColor.Canvas.Pen.Color := InvertColor(FBrushColor);
    edBrushColor.Canvas.TextOut(4, 2, 'Ф');
  end else
    SetImageColor(edBrushColor, BrushColor);
end;

procedure TFmCCrossPuzzle.ShowPrompt;
begin
  Penalty := true;
  if Assigned(FPuzzle) then FPuzzle.ShowPreview;
end;

procedure TFmCCrossPuzzle.ShowProps;
var
  fprops: TFProps;

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

procedure TFmCCrossPuzzle.ShowTools(AShow: boolean);
begin
  chbOverwriteCells.Visible := false;
  chbInvertBg.Visible := false;
  if AShow then
  begin
    chbOverwriteCells.Checked := frmSettings.OverwriteCells;
    chbInvertBg.Checked := frmSettings.InvertBackground;
    pTools.Height := frmSettings.ToolHeight;
    Bevel1.Height := pTools.Height;
    Splitter1.Height := 5;
    case FGameState of
      gsEdit:
      begin
        chbOverwriteCells.Visible := true;
        chbInvertBg.Visible := true;
      end;
    end;
  end else
  begin
    if pTools.Height > 0 then frmSettings.ToolHeight := pTools.Height;
    pTools.Height := 0;
    Splitter1.Height := 0;
  end;
end;

procedure TFmCCrossPuzzle.Undo;
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
    if FPuzzle.ItemType[ud[i].p.X, ud[i].p.Y] = pztCell then
    begin
      Inc(c);
      AddToRedo(ud[i].p, FPuzzle.ItemState[ud[i].p.X, ud[i].p.Y]);
      SetCellState(ud[i].p.X, ud[i].p.Y, false, ud[i].val, false);
    end;
  end;
  if c > 0 then AddToRBlocks(c);
end;

procedure TFmCCrossPuzzle.UnSelectAll;
begin
  pgPuzzle.ClearSelection;
end;

end.
