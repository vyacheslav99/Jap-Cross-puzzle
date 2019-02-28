unit select_puzzle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  Grids, settings, jsCommon, ImgList;

type
  TfrmOpenPuzzle = class(TForm)
    lwPuzzles: TListView;
    chbPreview: TCheckBox;
    gbJCPuzzle: TGroupBox;
    pJPreviewArea: TPanel;
    bmPreview: TImage;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    gbSudoku: TGroupBox;
    pSPreviewArea: TPanel;
    sgPreview: TStringGrid;
    ilIcons: TImageList;
    lblName: TLabel;
    edName: TEdit;
    sbDelete: TSpeedButton;
    btnRandom: TBitBtn;
    procedure lwPuzzlesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lwPuzzlesEdited(Sender: TObject; Item: TListItem; var S: string);
    procedure lwPuzzlesColumnClick(Sender: TObject; Column: TListColumn);
    procedure edNameClick(Sender: TObject);
    procedure lwPuzzlesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbDeleteClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbPreviewClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lwPuzzlesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure btnRandomClick(Sender: TObject);
  private
    getRandom: boolean;
    floading: boolean;
    r_ok: boolean;
    FSave: boolean;
    FShowPrompt: boolean;
    ResFile: string;
    pName: string;
    pFile: string;
    pColumns: integer;
    pRows: integer;
    pArray: array of array of integer;
    pType: TCurrGame;
    pDiff: TDifficulty;
    pUser: string;
    pTime: TTime;
    //cap: string;
    CurrFolder: string;
    procedure LoadItems;
    procedure LoadPuzzlePreview(f: string; OnlyInfo: boolean);
    procedure LoadSudokuPreview(f: string; OnlyInfo: boolean);
    procedure LoadCore(fName: string; OnlyInfo: boolean);
    procedure LoadSaved(fName: string; OnlyInfo: boolean);
    function GetScale(aCount: integer): integer;
    procedure ScrollListBox;
    function GetRandomFile: string;
  public
    function Execute(var filename: string; AGameType: TCurrGame; ASave, AShowPrompt: boolean): boolean;
  end;

function CompareStr(str1, str2: string; Direct: integer): integer;
function CompareDiff(str1, str2: string; Direct: integer): integer;
function CompareTime(str1, str2: string; Direct: integer): integer;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
function SaveSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;

implementation

{$R *.dfm}

var
  SortDirects: array [0..5] of integer;

function CompareStr(str1, str2: string; Direct: integer): integer;
begin
  if AnsiLowerCase(str1) > AnsiLowerCase(str2) then Result := 1
  else if AnsiLowerCase(str1) < AnsiLowerCase(str2) then Result := -1
  else result := 0;
  if Direct <> 0 then result := result * Direct;
end;

function CompareDiff(str1, str2: string; Direct: integer): integer;
begin
  if DifficultyFromText(str1, lRU) > DifficultyFromText(str2, lRU) then Result := 1
  else if DifficultyFromText(str1, lRU) < DifficultyFromText(str2, lRU) then Result := -1
  else result := 0;
  if Direct <> 0 then result := result * Direct;
end;

function CompareTime(str1, str2: string; Direct: integer): integer;
begin
  if StrToTime(str1) > StrToTime(str2) then Result := 1
  else if StrToTime(str1) < StrToTime(str2) then Result := -1
  else result := 0;
  if Direct <> 0 then result := result * Direct;
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer;
begin
  if ParamSort = 0 then // 1 столбец - название
    result := CompareStr(Item1.Caption, Item2.Caption, SortDirects[ParamSort])
  else begin
    Dec(ParamSort); // остальные столбцы (кроме 1-го) отсчитываются опять с 0
    case ParamSort of
      1: result := CompareDiff(Item1.SubItems[ParamSort], Item2.SubItems[ParamSort], SortDirects[ParamSort + 1]); // сложность
      else result := CompareStr(Item1.SubItems[ParamSort], Item2.SubItems[ParamSort], SortDirects[ParamSort + 1]);
    end;
  end;
end;

function SaveSortProc(Item1, Item2: TListItem; ParamSort: integer): integer;
begin
  if ParamSort = 0 then // 1 столбец - название
    result := CompareStr(Item1.Caption, Item2.Caption, SortDirects[ParamSort])
  else begin
    Dec(ParamSort); // остальные столбцы (кроме 1-го) отсчитываются опять с 0
    case ParamSort of
      2: result := CompareTime(Item1.SubItems[ParamSort], Item2.SubItems[ParamSort], SortDirects[ParamSort + 1]); // время игры
      4: result := CompareDiff(Item1.SubItems[ParamSort], Item2.SubItems[ParamSort], SortDirects[ParamSort + 1]); // сложность
      else result := CompareStr(Item1.SubItems[ParamSort], Item2.SubItems[ParamSort], SortDirects[ParamSort + 1]);
    end;
  end;
end;

{ TfrmOpenPuzzle }

procedure TfrmOpenPuzzle.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmOpenPuzzle.btnOKClick(Sender: TObject);
begin
  r_ok := true;
  self.Close;
end;

procedure TfrmOpenPuzzle.btnRandomClick(Sender: TObject);
begin
  getRandom := true;
  r_ok := true;
  self.Close;
end;

procedure TfrmOpenPuzzle.chbPreviewClick(Sender: TObject);
begin
  case pType of
    cgJCrossPuzzle, cgCCrossPuzzle:
    begin
      pJPreviewArea.Visible := chbPreview.Checked;
      if chbPreview.Checked then LoadPuzzlePreview(ResFile, not chbPreview.Checked);
    end;
    cgSudoku:
    begin
      pSPreviewArea.Visible := chbPreview.Checked;
      if chbPreview.Checked then LoadSudokuPreview(ResFile, not chbPreview.Checked);
    end;
  end;
  try
    if chbPreview.Focused then lwPuzzles.SetFocus;
  except
  end;
end;

procedure TfrmOpenPuzzle.edNameChange(Sender: TObject);
begin
  if FShowPrompt then btnOK.Enabled := Trim(edName.Text) <> '';
end;

procedure TfrmOpenPuzzle.edNameClick(Sender: TObject);
begin
//  edName.SelectAll;
end;

function TfrmOpenPuzzle.Execute(var filename: string; AGameType: TCurrGame; ASave, AShowPrompt: boolean): boolean;
var
  d: TDifficulty;
  
begin
  result := false;
  getRandom := false;
  FSave := ASave;
  FShowPrompt := AShowPrompt;
  pType := AGameType;
  pDiff := frmSettings.ADifficulty;
  d := pDiff;

  btnRandom.Visible := not FSave;
  
  if FSave then
  begin
    if filename = '' then
      case pType of
        cgJCrossPuzzle: ResFile := frmSettings.LastJSaved;
        cgSudoku: ResFile := frmSettings.LastSSaved;
        cgCCrossPuzzle: ResFile := frmSettings.LastCSaved;
      end
    else ResFile := filename;
    if (ResFile = '') and FShowPrompt then ResFile := frmSettings.AUser;
  end else
    ResFile := filename;

  case pType of
    cgJCrossPuzzle, cgCCrossPuzzle:
    begin
      gbJCPuzzle.Visible := true;
      gbSudoku.Visible := false;
      if FShowPrompt then self.Caption := 'Сохранить кроссворд'
      else self.Caption := 'Открыть кроссворд';
    end;
    cgSudoku:
    begin
      gbJCPuzzle.Visible := false;
      gbSudoku.Visible := true;
      if FShowPrompt then self.Caption := 'Сохранить судоку'
      else self.Caption := 'Выбрать судоку';
    end;
  end;

  edName.ReadOnly := true;
  if AShowPrompt then edName.ReadOnly := false;
  if FSave then
  begin
    if FShowPrompt then self.Caption := 'Сохранить игру'
    else self.Caption := 'Загрузить игру';
    CurrFolder := frmSettings.SaveFolder;
  end else
    CurrFolder := frmSettings.CrossFolder;

  self.ShowModal;
  if r_ok then
  begin
    if (not FSave) and AShowPrompt then pDiff := d;
    frmSettings.ADifficulty := pDiff;
    if AShowPrompt then ResFile := edName.Text;
    if FSave then
    begin
      case pType of
        cgJCrossPuzzle: frmSettings.LastJSaved := ResFile;
        cgSudoku: frmSettings.LastSSaved := ResFile;
        cgCCrossPuzzle: frmSettings.LastCSaved := ResFile;
      end
    end else
    begin
      if getRandom then ResFile := GetRandomFile;
      case pType of
        cgJCrossPuzzle: frmSettings.LastJPuzzle := ResFile;
        cgSudoku: frmSettings.LastSudoku := ResFile;
        cgCCrossPuzzle: frmSettings.LastCPuzzle := ResFile;
      end;
    end;
    filename := ResFile;
    result := true;
  end;
  self.Free;
end;

procedure TfrmOpenPuzzle.FormClose(Sender: TObject; var Action: TCloseAction);
var
  c: integer;

begin
  frmSettings.SelPuzzlePrv := chbPreview.Checked;
  c := 0;
  frmSettings.LwFileNameWidth := lwPuzzles.Column[0].Width;
  frmSettings.LwNameWidth := lwPuzzles.Column[1].Width;
  if FSave then
  begin
    c := 2;
    frmSettings.LwUserWidth := lwPuzzles.Column[2].Width;
    frmSettings.LwTimeWidth := lwPuzzles.Column[3].Width;
  end;
  frmSettings.LwSizeWidth := lwPuzzles.Column[2 + c].Width;
  frmSettings.LwDiffWidth := lwPuzzles.Column[3 + c].Width;
  Action := caHide;
end;

procedure TfrmOpenPuzzle.FormCreate(Sender: TObject);
var
  i: integer;
  
begin
  for i := 0 to Length(SortDirects) - 1 do SortDirects[i] := 0;
  SetLength(pArray, 0);
  pColumns := 0;
  pRows := 0;
  floading := false;
  chbPreview.Checked := frmSettings.SelPuzzlePrv;
  chbPreviewClick(chbPreview);
end;

procedure TfrmOpenPuzzle.FormShow(Sender: TObject);
var
  iname: string;
  lwItem: TListItem;

begin
  r_ok := false;
  LoadItems;

  if FSave then iname := ResFile
  else
    if FShowPrompt then iname := ResFile
    else
      case pType of
        cgJCrossPuzzle: iname := frmSettings.LastJPuzzle;
        cgSudoku: iname := frmSettings.LastSudoku;
        cgCCrossPuzzle: iname := frmSettings.LastCPuzzle;
      end;
      
  lwItem := lwPuzzles.FindCaption(0, iname, true, true, true);

  if (lwPuzzles.Items.Count = 0) then
  begin
    if (not FShowPrompt) then btnOK.Enabled := false;
    exit;
  end;
  
  if not Assigned(lwItem) then lwItem := lwPuzzles.Items.Item[0];
  lwPuzzles.Selected := lwItem;
  ScrollListBox;
  if FShowPrompt then
  begin
    edName.Text := iname;
    try
      edName.SetFocus;
    except
    end;
  end;
end;

function TfrmOpenPuzzle.GetRandomFile: string;
begin
  result := lwPuzzles.Items[Random(lwPuzzles.Items.Count)].Caption;
end;

function TfrmOpenPuzzle.GetScale(aCount: integer): integer;
begin
  case aCount of
    1..10: result := 30;
    11..20: result := 15;
    21..26: result := 10;
    27..50: result := 7;
    51..70: result := 5;
    else result := 3;
  end;
end;

procedure TfrmOpenPuzzle.LoadCore(fName: string; OnlyInfo: boolean);
var
  i, j: integer;
  f: TFileStream;
  head: TCoreFileHeader;
  c: char;

begin
  pRows := 0;
  pColumns := 0;
  SetLength(pArray, 0);
  if not FileExists(fName) then raise Exception.Create('Файл "' + fName + '" не существует!');
  if LowerCase(ExtractFileExt(fName)) <> '.' + GetExt(pType) then raise Exception.Create('Неверный формат файла "' + fName + '"!');

  try
    try
      f := TFileStream.Create(fName, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));
      if (head._type <> Ord(pType)) or (head.Height <= 0) or (head.Width <= 0) then
        raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [fName]));

      pRows := head.Height;
      pColumns := head.Width;
      if pType <> cgSudoku then pDiff := TDifficulty(head.diff);

      pName := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(c, 1);
        pName := pName + c;
      end;

      //читаем тело
      if not OnlyInfo then
      begin
        SetLength(pArray, pRows);
        for i := 0 to pRows - 1 do
        begin
          SetLength(pArray[i], pColumns);
          for j := 0 to pColumns - 1 do
            if pType = cgCCrossPuzzle then f.Read(pArray[i][j], SizeOf(integer))
            else f.Read(pArray[i][j], SizeOf(byte));
        end;
      end;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_READ_ERROR, [fName]) + ':'#13#10 + e.Message);
    end;
  finally
    if Assigned(f) then f.Free;
  end;
end;

procedure TfrmOpenPuzzle.LoadItems;

  procedure AddCol(lw: TListView; cap: string; w: integer);
  var
    col: TListColumn;

  begin
    col := lw.Columns.Add;
    col.Caption := cap;
    col.Width := w;
  end;

var
  sr: TSearchRec;
  fr: integer;
  i: integer;
  iidx: integer;
  ferror: boolean;
  
begin
  if not DirectoryExists(CurrFolder) then exit;
  i := 0;
  floading := true;
  Screen.Cursor := crHourGlass;
  try
    if FSave then iidx := Ord(pType) + 2
    else iidx := Ord(pType) - 1;
    lwPuzzles.Items.Clear;
    lwPuzzles.Columns.Clear;

    AddCol(lwPuzzles, 'Имя файла', frmSettings.LwFileNameWidth);
    {if pType = cgSudoku then
      AddCol(lwPuzzles, 'Судоку', frmSettings.LwNameWidth)
    else}
    AddCol(lwPuzzles, 'Название', frmSettings.LwNameWidth);
    if FSave then
    begin
      AddCol(lwPuzzles, 'Игрок', frmSettings.LwUserWidth);
      AddCol(lwPuzzles, 'Время', frmSettings.LwTimeWidth);
    end;
    AddCol(lwPuzzles, 'Размер', frmSettings.LwSizeWidth);
    AddCol(lwPuzzles, 'Сложность', frmSettings.LwDiffWidth);

    lwPuzzles.SortType := stNone;
    fr := FindFirst(CurrFolder + '\*.' + GetExt(pType, FSave), faAnyFile, sr);
    while fr = 0 do
    begin
      ferror := false;
      try
        case pType of
          cgJCrossPuzzle, cgCCrossPuzzle: LoadPuzzlePreview(sr.Name, true);
          cgSudoku: LoadSudokuPreview(sr.Name, true);
        end;
      except
        ferror := true;
      end;

      lwPuzzles.Items.AddItem(TListItem.Create(lwPuzzles.Items), i);
      lwPuzzles.Items[i].Caption := sr.Name;
      lwPuzzles.Items[i].ImageIndex := iidx;

      if not ferror then
      begin
        lwPuzzles.Items[i].SubItems.Add(pName);
        if FSave then
        begin
          lwPuzzles.Items[i].SubItems.Add(pUser);
          lwPuzzles.Items[i].SubItems.Add(TimeToStr(pTime));
        end;
        lwPuzzles.Items[i].SubItems.Add(IntToStr(pColumns) + ' x ' + IntToStr(pRows));
        lwPuzzles.Items[i].SubItems.Add(DifficultyAsText(pDiff, lRU));
      end;

      i := i + 1;
      fr := FindNext(sr);
    end;
    FindClose(sr);
    lwPuzzles.SortType := stText;
  finally
    floading := false;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmOpenPuzzle.LoadPuzzlePreview(f: string; OnlyInfo: boolean);
var
  i, j: integer;
  r: TRect;
  x1, y1, x2, y2: integer;
  xscale: integer;
  yscale: integer;

begin
  if f = '' then exit;
  r.Left := 0;
  r.Top := 0;
  r.Right := bmPreview.Width;
  r.Bottom := bmPreview.Height;
  bmPreview.Canvas.Brush.Color := clBtnFace;
  bmPreview.Canvas.FillRect(r);
  //pName := ChangeFileExt(f, '');
  if FSave then LoadSaved(CurrFolder + '\' + f, OnlyInfo)
  else LoadCore(CurrFolder + '\' + f, OnlyInfo);

  //self.Caption := cap + ' [' + pName + ']';
  if (Length(pArray) <= 0) or (Length(pArray[0]) <= 0) then
  begin
    pJPreviewArea.Caption := '<нет>';
    exit;
  end else
  begin
    if Length(pArray) > Length(pArray[0]) then yscale := GetScale(Length(pArray))
    else yscale := GetScale(Length(pArray[0]));
    xscale := yscale;
    pJPreviewArea.Caption := '';
    x1 := 5;
    x2 := x1 + xscale;
    y1 := 5;
    y2 := y1 + yscale;
    for i := 0 to Length(pArray) - 1 do
    begin
      for j := 0 to Length(pArray[i]) - 1 do
      begin
        if pType = cgJCrossPuzzle then
          case pArray[i][j] of
            0: bmPreview.Canvas.Brush.Color := clWhite;
            1: bmPreview.Canvas.Brush.Color := clBlack;
            2: bmPreview.Canvas.Brush.Color := frmSettings.AImgGrayedColor;
          end
        else if pType = cgCCrossPuzzle then
          if pArray[i][j] < 0 then bmPreview.Canvas.Brush.Color := frmSettings.AImgGrayedColor
          else bmPreview.Canvas.Brush.Color := pArray[i][j];

        bmPreview.Canvas.Rectangle(x1, y1, x2, y2);
        x1 := x2;
        x2 := x1 + xscale;
      end;
      x1 := 5;
      x2 := x1 + xscale;
      y1 := y2;
      y2 := y1 + yscale;
    end;
    bmPreview.Repaint;
  end;
end;

procedure TfrmOpenPuzzle.LoadSaved(fName: string; OnlyInfo: boolean);
var
  i, j: integer;
  f: TFileStream;
  head: TSaveFileHeader;
  s: char;

begin
  if not FileExists(fName) then raise Exception.Create('Файл "' + fName + '" не существует!');
  if LowerCase(ExtractFileExt(fName)) <> '.' + GetExt(pType, true) then raise Exception.Create('Неверный формат файла "' + fName + '"!');

  try
    try
      f := TFileStream.Create(fName, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));
      if (head._type <> Ord(pType)) then raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [fName]));

      //читаем имя файла ядра
      pFile := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(s, 1);
        pFile := pFile + s;
      end;

      //читаем имя игрока
      pUser := '';
      for i := 1 to head.sz_user do
      begin
        f.Read(s, 1);
        pUser := pUser + s;
      end;

      pTime := head.GTime;
      LoadCore(frmSettings.CrossFolder + '\' + pFile, true);
      pDiff := TDifficulty(head.Difficulty);

      //читаем тело
      if not OnlyInfo then
      begin
        SetLength(pArray, pRows + head.b_top);
        for i := 0 to pRows + head.b_top - 1 do
        begin
          SetLength(pArray[i], pColumns + head.b_left);
          for j := 0 to pColumns + head.b_left - 1 do
            if pType = cgCCrossPuzzle then f.Read(pArray[i][j], SizeOf(integer))
            else f.Read(pArray[i][j], SizeOf(byte));
        end;
      end;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_READ_ERROR, [fName]) + ':'#13#10 + e.Message);
    end;
  finally
    if Assigned(f) then f.Free;
  end;
end;

procedure TfrmOpenPuzzle.LoadSudokuPreview(f: string; OnlyInfo: boolean);
var
  i, j: integer;

begin
  if f = '' then exit;
  //pName := ChangeFileExt(f, '');
  if FSave then LoadSaved(CurrFolder + '\' + f, OnlyInfo)
  else LoadCore(CurrFolder + '\' + f, OnlyInfo);

  //self.Caption := cap + ' [' + pName + ']';
  if (Length(pArray) <= 0) or (Length(pArray[0]) <= 0) then
  begin
    pSPreviewArea.Caption := '<нет>';
    sgPreview.Visible := false;
    exit;
  end;

  pSPreviewArea.Caption := '';
  for i := 0 to Length(pArray) - 1 do
    for j := 0 to Length(pArray[i]) - 1 do
      if pArray[i][j] > 0 then sgPreview.Cells[j, i] := IntToStr(pArray[i][j]);
  sgPreview.Visible := true;
end;

procedure TfrmOpenPuzzle.lwPuzzlesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if floading then exit;
  ResFile := Item.Caption;
  edName.Text := Item.Caption;
  case pType of
    cgJCrossPuzzle, cgCCrossPuzzle: LoadPuzzlePreview(ResFile, not chbPreview.Checked);
    cgSudoku: LoadSudokuPreview(ResFile, not chbPreview.Checked);
  end;
end;

procedure TfrmOpenPuzzle.lwPuzzlesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if SortDirects[Column.Index] = 1 then SortDirects[Column.Index] := -1
  else SortDirects[Column.Index] := 1;

  if FSave then lwPuzzles.CustomSort(@SaveSortProc, Column.Index)
  else lwPuzzles.CustomSort(@CustomSortProc, Column.Index);

  ScrollListBox;
end;

procedure TfrmOpenPuzzle.lwPuzzlesCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.SubItems.Count = 0 then Sender.Canvas.Font.Color := clRed;
end;

procedure TfrmOpenPuzzle.lwPuzzlesEdited(Sender: TObject; Item: TListItem; var S: string);
var
  newName: string;

begin
  if ExtractFileExt(s) <> '.' + GetExt(pType, FSave) then s := ChangeFileExt(s, '.' + GetExt(pType, FSave));
  newName := CurrFolder + '\' + s;
  if FileExists(newName) then
  begin
    Application.MessageBox(pchar('Файл "' + s + '" уже существует!'), pchar(Application.Title), MB_OK + MB_ICONERROR);
    s := Item.Caption;
  end else
    if not RenameFile(CurrFolder + '\' + Item.Caption, newName) then s := Item.Caption;
end;

procedure TfrmOpenPuzzle.lwPuzzlesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_DELETE) then sbDeleteClick(sbDelete);
end;

procedure TfrmOpenPuzzle.sbDeleteClick(Sender: TObject);
var
  s: string;

begin
  if not Assigned(lwPuzzles.Selected) then exit;
  s := lwPuzzles.Selected.Caption;
  if Application.MessageBox(pchar('Вы действительно хотите удалить игру "' + s + '"?'), pchar(Application.Title),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then exit;

  DeleteFile(CurrFolder + '\' + s);
  LoadItems;
  if lwPuzzles.Items.Count > 0 then
  begin
    lwPuzzles.Selected := lwPuzzles.Items.Item[0];
    ScrollListBox;
  end else
    if (not FShowPrompt) then btnOK.Enabled := false;
end;

procedure TfrmOpenPuzzle.ScrollListBox;
var
  X: integer;
  i: integer;

begin
  if not Assigned(lwPuzzles.Selected) then exit;
  lwPuzzles.Selected.MakeVisible(true);
  X := lwPuzzles.Items[lwPuzzles.ItemIndex].Top;
  X := Round(X / 200);
  if X = 0 then X := -1;
  for i := 0 to X do
    SendMessage(lwPuzzles.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
end;

end.
