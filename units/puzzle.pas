unit puzzle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Math, Forms, ExtCtrls, Controls, imgUtils, Types, jsCommon;

type
  //статусы:
  //pzCell: 0 (пустое пространство), 1 (закрашенное пространство), 2 (не разгадано)
  //pzService: зарезервировано для хранения служебной информации
  //pzCaption: 0 (не открыто), 1 (открыто)

  TPuzzleCore = array of array of byte;

  TPuzzleItem = class
  private
    fpiType: TpzItemType;
    fpiState: byte;
    fpiText: string;
    procedure SetPiState(value: byte);
    procedure SetPiType(value: TpzItemType);
  public
    constructor Create(AType: TpzItemType; AText: string);
    property piType: TpzItemType read fpiType;
    property piState: byte read fpiState write SetPiState;
    property piText: string read fpiText write fpiText;
  end;

  TPuzzleMatrix = array of array of TPuzzleItem;

  TfPrompt = class(TForm)
    pPreviewArea: TPanel;
    bmPreview: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

  TCrossPuzzle = class
  private
    FPuzzleMatrix: TPuzzleMatrix;
    FPuzzleCore: TPuzzleCore;
    FLoading: boolean;
    FCoreFile: string;
    FBehaviour: TBehaviour;
    leftLen: integer;
    topHi: integer;
    FPrompt: TfPrompt;
    FDifficulty: TDifficulty;
    FName: string;
    function GetCoreColCount: byte;
    function GetCoreRowCount: byte;
    procedure LoadCore(corefile: string);
    procedure GenNewCore(AHeight, AWidth: integer; Rand: boolean; NoSizeException: boolean = false);
    procedure GenCoreFromImage(ImgFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte; AHeight, AWidth: integer);
    procedure GenCoreFromCPuzzle(PuzzleFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte);
    procedure GenCoreFromText(TextFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte; LeftIndent, TopIndent: integer);
    procedure GenerateMatrix;
    procedure ClearMatrix(ASaveCore: boolean = false);
    function GetPuzzleItem(i, j: byte): TPuzzleItem;
    function GetItemType(i, j: byte): TpzItemType;
    procedure SetItemType(i, j: byte; value: TpzItemType);
    function GetItemState(i, j: byte): byte;
    procedure SetItemState(i, j: byte; value: byte);
    function GetItemText(i, j: byte): string;
    procedure SetItemText(i, j: byte; value: string);
    function GetPuzzleName: string;
    procedure SetPuzzleName(value: string);
    function GetRowCount: byte;
    function GetColCount: byte;
    function GetCoreSizeText: string;
    procedure LoadPreview;
    function GetScale(aCount: integer): integer;
    function GetPromptLeft: integer;
    procedure SetPromptLeft(value: integer);
    function GetPromptTop: integer;
    procedure SetPromptTop(value: integer);
    function GetDifficulty: TDifficulty;
    procedure SetDifficulty(value: TDifficulty);
    function GetFileName: string;
    procedure FillRandom(AOverwrite: boolean = true);
    procedure InvertCore;
    property PuzzleItem[ARow: byte; ACol: byte]: TPuzzleItem read GetPuzzleItem;
  public
    constructor CreateEmpty(AHeight, AWidth: integer; Rand: boolean);
    constructor CreateForFile(AFile: string; ABehaviour: TBehaviour; ADifficulty: TDifficulty);
    constructor CreateForImage(ImgFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte; AHeight, AWidth: integer;
      SourceType: TGameAction);
    destructor Destroy; override;
    function GetItemRow(item: TPuzzleItem): byte;
    function GetItemCol(item: TPuzzleItem): byte;
    function IsSolve: boolean;
    function IsCorrect: boolean;
    function SaveCore(AFile: string): boolean;
    function IsEmpty: boolean;
    procedure ShowPreview;
    procedure GenerateRandom(AOverwrite: boolean);
    procedure Invert;
    procedure DeleteRow(RowNo, Count: integer);
    procedure DeleteCol(ColNo, Count: integer);
    procedure AddRow(Index, Count: integer);
    procedure AddCol(Index, Count: integer);
    property ItemType[ARow: byte; ACol: byte]: TpzItemType read GetItemType; //write SetItemType;
    property ItemState[ARow: byte; ACol: byte]: byte read GetItemState write SetItemState;
    property ItemText[ARow: byte; ACol: byte]: string read GetItemText write SetItemText;
    property Name: string read GetPuzzleName write SetPuzzleName;
    property RowCount: byte read GetRowCount;
    property ColCount: byte read GetColCount;
    property CrossSizeText: string read GetCoreSizeText;
    property LeftIndent: integer read leftLen;
    property TopIndent: integer read topHi;
    property PromptLeft: integer read GetPromptLeft write SetPromptLeft;
    property PromptTop: integer read GetPromptTop write SetPromptTop;
    property CoreRowCount: byte read GetCoreRowCount;
    property CoreColCount: byte read GetCoreColCount;
    property Difficulty: TDifficulty read GetDifficulty write SetDifficulty;
    property FileName: string read GetFileName;
  end;

implementation

{$R *.dfm}

{ TPuzzleItem }

constructor TPuzzleItem.Create(AType: TpzItemType; AText: string);
begin
  inherited Create;
  SetPiType(AType);
  fpiText := AText;
end;

procedure TPuzzleItem.SetPiState(value: byte);
begin
  case fpiType of
    pztCaption: if not (value in [0, 1]) then value := fpiState;
    pztCell: if not (value in [0, 1, 2]) then value := fpiState;
  end;
  fpiState := value;
end;

procedure TPuzzleItem.SetPiType(value: TpzItemType);
begin
  fpiType := value;
  if value = pztCell then fpiState := 2
  else fpiState := 0;
end;

{ TCrossPuzzle }

procedure TCrossPuzzle.AddCol(Index, Count: integer);
var
  i, j: integer;

begin
  if (FBehaviour <> bhSynchro) or (Length(FPuzzleCore) <= 0) or (Index < 0) or (Count < 1) then exit;

  if (Length(FPuzzleCore[0]) + Count) > PUZZLESIZELIMIT then
    raise Exception.Create(Format(MSG_MATRIX_TOOBIG, [IntToStr(PUZZLESIZELIMIT), IntToStr(PUZZLESIZELIMIT)]));

  if Index > Length(FPuzzleCore[0]) then Index := Length(FPuzzleCore[0]);

  for i := 0 to Length(FPuzzleCore) - 1 do
    SetLength(FPuzzleCore[i], Length(FPuzzleCore[i]) + Count);

  for i := 0 to Length(FPuzzleCore) - 1 do
    for j := Length(FPuzzleCore[i]) - 1 downto Index + Count do FPuzzleCore[i][j] := FPuzzleCore[i][j - Count];

  for i := 0 to Length(FPuzzleCore) - 1 do
    for j := Index + 1 to Index + Count do FPuzzleCore[i][j] := 0;

  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TCrossPuzzle.AddRow(Index, Count: integer);
var
  i, j: integer;
  old_sz: integer;

begin
  if (FBehaviour <> bhSynchro) or (Index < 0) or (Count < 1) then exit;

  if (Length(FPuzzleCore) + Count) > PUZZLESIZELIMIT then
    raise Exception.Create(Format(MSG_MATRIX_TOOBIG, [IntToStr(PUZZLESIZELIMIT), IntToStr(PUZZLESIZELIMIT)]));

  if Index > Length(FPuzzleCore) then Index := Length(FPuzzleCore);
  old_sz := Length(FPuzzleCore);
  SetLength(FPuzzleCore, Length(FPuzzleCore) + Count);

  for i := old_sz to Length(FPuzzleCore) - 1 do
    SetLength(FPuzzleCore[i], Length(FPuzzleCore[0]));

  for i := Length(FPuzzleCore) - 1 downto Index + Count do
    for j := 0 to Length(FPuzzleCore[i]) - 1 do FPuzzleCore[i][j] := FPuzzleCore[i - Count][j];

  for i := Index + 1 to Index + Count do
    for j := 0 to Length(FPuzzleCore[i]) - 1 do FPuzzleCore[i][j] := 0;

  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TCrossPuzzle.ClearMatrix(ASaveCore: boolean);
var
  i, j: integer;

begin
  while FLoading do ;
  FLoading := true;
  try
    if not ASaveCore then SetLength(FPuzzleCore, 0);
    for i := 0 to Length(FPuzzleMatrix) - 1 do
      for j := 0 to Length(FPuzzleMatrix[i]) - 1 do
        FPuzzleMatrix[i][j].Free;
    SetLength(FPuzzleMatrix, 0);
  finally
    FLoading := false;
  end;
end;

constructor TCrossPuzzle.CreateEmpty(AHeight, AWidth: integer; Rand: boolean);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  FBehaviour := bhSynchro;
  FDifficulty := dfVeryEasy;
  GenNewCore(AHeight, AWidth, Rand);
  GenerateMatrix;
  FPrompt := TfPrompt.Create(nil);
end;

constructor TCrossPuzzle.CreateForFile(AFile: string; ABehaviour: TBehaviour; ADifficulty: TDifficulty);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  if not FileExists(AFile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [AFile]));
  FBehaviour := ABehaviour;
  Difficulty := ADifficulty; // сложность перезапишется LoadCore (она фиксирвана в файле ядра)
  LoadCore(AFile);
  GenerateMatrix;
  FPrompt := TfPrompt.Create(nil);
end;

constructor TCrossPuzzle.CreateForImage(ImgFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte;
  AHeight, AWidth: integer; SourceType: TGameAction);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  if not FileExists(ImgFile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [ImgFile]));
  FBehaviour := bhSynchro;
  FDifficulty := dfVeryEasy;
  case SourceType of
    gaImport: GenCoreFromImage(ImgFile, AnalisatorType, AInvert, ABorder, AHeight, AWidth);
    gaImport2: GenCoreFromCPuzzle(ImgFile, AnalisatorType, AInvert, ABorder);
    gaImport3: GenCoreFromText(ImgFile, AnalisatorType, AInvert, ABorder, AWidth, AHeight);
    else raise Exception.Create('Неверный тип источника для импорта кроссворда!');
  end;
  GenerateMatrix;
  FPrompt := TfPrompt.Create(nil);
end;

procedure TCrossPuzzle.DeleteCol(ColNo, Count: integer);
var
  i, j, n: integer;

begin
  if (FBehaviour <> bhSynchro) or (Length(FPuzzleCore) <= 0) or (ColNo < 0) or (ColNo >= Length(FPuzzleCore[0])) or (Count <= 0) then exit;

  if (Length(FPuzzleCore[0]) - Count) < 1 then raise Exception.Create('Нельзя удалить больше столбцов, чем их есть!');

  for j := 0 to Length(FPuzzleCore) - 1 do
  begin
    if Length(FPuzzleCore[j]) <= 0 then continue;
    if (ColNo + 1) < Length(FPuzzleCore[j]) then
      for n := 0 to Count - 1 do
        for i := ColNo + 1 to Length(FPuzzleCore[j]) - 1 do
          FPuzzleCore[j][i - 1] := FPuzzleCore[j][i];

    SetLength(FPuzzleCore[j], Length(FPuzzleCore[j]) - Count);
  end;

  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TCrossPuzzle.DeleteRow(RowNo, Count: integer);
var
  i, n: integer;

begin
  if (FBehaviour <> bhSynchro) or (Length(FPuzzleCore) <= 0) or (RowNo < 0) or (RowNo >= Length(FPuzzleCore)) or (Count <= 0) then exit;

  if (Length(FPuzzleCore) - Count) < 1 then raise Exception.Create('Нельзя удалить больше строк, чем их есть!');

  if (RowNo + 1) < Length(FPuzzleCore) then
    for n := 0 to Count - 1 do
      for i := RowNo + 1 to Length(FPuzzleCore) - 1 do
        FPuzzleCore[i - 1] := FPuzzleCore[i];

  SetLength(FPuzzleCore, Length(FPuzzleCore) - Count);

  ClearMatrix(true);
  GenerateMatrix;
end;

destructor TCrossPuzzle.Destroy;
begin
  ClearMatrix;
  if Assigned(FPrompt) then FPrompt.Free;
  inherited;
end;

procedure TCrossPuzzle.FillRandom(AOverwrite: boolean);
var
  invert: byte;
  i, j, m, n, b: integer;
  AHeight, AWidth: integer;
  r: TRect;
  X, pX: integer;
  Y, pY: integer;

begin
  //применения параметра AOwervrite пока нет
  AHeight := Length(FPuzzleCore);
  if (AHeight <= 0) then exit;
  AWidth := Length(FPuzzleCore[0]);
  if (AWidth <= 0) then exit;

  Randomize;
  invert := Random(2);
  n := Random(AHeight * AWidth);
  X := Random(AWidth);
  Y := Random(AHeight);
  pX := Random(AWidth + AHeight);
  pY := Random(AWidth + AHeight);
  r.Left := X - pX;
  r.Top := Y - pY;
  r.Right := X + pX;
  r.Bottom := Y + pY;

  for m := 1 to n do
  begin
    i := Random(AHeight);
    j := Random(AWidth);
    b := Random(3);
    if b <> 0 then
    begin
      while (j < r.Left) or (j > r.Right) do j := Random(AWidth);
      while (i < r.Top) or (i > r.Bottom) do i := Random(AHeight);
    end;
    if (i > 0) and (i < AHeight) and (j > 0) and (j < AWidth) then FPuzzleCore[i][j] := 1;
  end;
  if invert = 1 then
    for i := 0 to AHeight - 1 do
      for j := 0 to AWidth - 1 do
        if FPuzzleCore[i][j] = 0 then FPuzzleCore[i][j] := 1
        else FPuzzleCore[i][j] := 0;
end;

procedure TCrossPuzzle.GenCoreFromCPuzzle(PuzzleFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte);
var
  cpz: array of array of TColor;
  clr: TColor;
  bgclr: TColor;
  hlsclr: THLSColor;
  i, j: integer;
  val: byte;
  lMax, lMin: byte;
  f: TFileStream;
  head: TCoreFileHeader;
  c: char;

begin
  // читаем файл-источник
  SetLength(cpz, 0);

  try
    if LowerCase(CutFileExt(PuzzleFile)) <> GetExt(cgCCrossPuzzle) then raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [PuzzleFile]));

    try
      f := TFileStream.Create(PuzzleFile, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));
      if (head._type <> Ord(cgCCrossPuzzle)) or (head.Height <= 0) or (head.Width <= 0) then
        raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [PuzzleFile]));

      Difficulty := TDifficulty(head.diff);
      bgclr := head.bgColor;

      // название
      FName := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(c, 1);
        FName := FName + c;
      end;

      //читаем тело
      SetLength(cpz, head.Height);
      for i := 0 to head.Height - 1 do
      begin
        SetLength(cpz[i], head.Width);
        for j := 0 to head.Width - 1 do f.Read(cpz[i][j], SizeOf(integer));
      end;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_READ_ERROR, [PuzzleFile]) + ':'#13#10 + e.Message);
    end;
  finally
    if Assigned(f) then f.Free;
  end;

  //теперь собственно анализ и преобразование
  try
    GenNewCore(Length(cpz), Length(cpz[0]), false);
    FLoading := true;

    if (ABorder = 0) and (AnalisatorType <> iaMono) then
    begin
      lMax := 0;
      lMin := 255;
      for i := 0 to Length(cpz) - 1 do
        for j := 0 to Length(cpz[i]) - 1 do
        begin
          clr := cpz[i][j];
          //if clr = bgclr then Continue;
          hlsclr := RGBtoHLS(clr);
          case AnalisatorType of
            iaLightness:
            begin
              if hlsclr.L > lMax then lMax := hlsclr.L;
              if hlsclr.L < lMin then lMin := hlsclr.L;
            end;
            iaSaturation:
            begin
              if hlsclr.S > lMax then lMax := hlsclr.S;
              if hlsclr.S < lMin then lMin := hlsclr.S;
            end;
            iaRed:
            begin
              if GetRValue(clr) > lMax then lMax := GetRValue(clr);
              if GetRValue(clr) < lMin then lMin := GetRValue(clr);
            end;
            iaGreen:
            begin
              if GetGValue(clr) > lMax then lMax := GetGValue(clr);
              if GetGValue(clr) < lMin then lMin := GetGValue(clr);
            end;
            iaBlue:
            begin
              if GetBValue(clr) > lMax then lMax := GetBValue(clr);
              if GetBValue(clr) < lMin then lMin := GetBValue(clr);
            end;
          end;
        end;
      ABorder := round(lMin + ((lMax - lMin) / 2));
    end;

    for i := 0 to Length(cpz) - 1 do
      for j := 0 to Length(cpz[i]) - 1 do
      begin
        clr := cpz[i][j];
        if AnalisatorType = iaMono then
        begin
          if clr = bgclr then
            if AInvert then val := 1
            else val := 0
          else
            if AInvert then val := 0
            else val := 1
        end else
        begin
          hlsclr := RGBtoHLS(clr);
          case AnalisatorType of
            iaLightness:
              if hlsclr.L <= ABorder then
                if AInvert then val := 0
                else val := 1
              else
                if AInvert then val := 1
                else val := 0;
            iaSaturation:
              if hlsclr.S <= ABorder then
                if AInvert then val := 1
                else val := 0
              else
                if AInvert then val := 0
                else val := 1;
            iaRed:
              if GetRValue(clr) <= ABorder then
                if AInvert then val := 1
                else val := 0
              else
                if AInvert then val := 0
                else val := 1;
            iaGreen:
              if GetGValue(clr) <= ABorder then
                if AInvert then val := 1
                else val := 0
              else
                if AInvert then val := 0
                else val := 1;
            iaBlue:
              if GetBValue(clr) <= ABorder then
                if AInvert then val := 1
                else val := 0
              else
                if AInvert then val := 0
                else val := 1;
          end;
        end;
        FPuzzleCore[i][j] := val;
      end;
  finally
    FCoreFile := ChangeFileExt(PuzzleFile, '.' + GetExt(cgJCrossPuzzle));
    FLoading := false;
  end;
end;

procedure TCrossPuzzle.GenCoreFromImage(ImgFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte;
  AHeight, AWidth: integer);
var
  bmp: TBitmap;
  x, y: integer;
  clr: TColor;
  hlsclr: THLSColor;
  i, j: integer;
  val: byte;
  lMax, lMin: byte;
  coeff: double;

begin
  bmp := TBitmap.Create;
  try
    bmp.Assign(LoadPicture(ImgFile));
    //сначала разберемся с размерами
    if (AWidth < 1) or (AHeight < 1) then
    begin
      AWidth := PUZZLESIZELIMIT;
      AHeight := PUZZLESIZELIMIT;
    end;

    //подгоним размеры мозайки под рисунок
    AHeight := Min(AHeight, bmp.Height);
    AWidth := Min(AWidth, bmp.Width);
    //уменьшаем масштаб, если нужно
    if (bmp.Height > AHeight) or (bmp.Width > AWidth) then
    begin
      coeff := Max(AWidth, AHeight) / Max(bmp.Width, bmp.Height);
      DecreaseBitmap(bmp, Round(bmp.Width * coeff), Round(bmp.Height * coeff));
    end;

    //теперь собственно анализ и преобразование
    x := bmp.Width;
    y := bmp.Height;
    GenNewCore(y, x, false);
    FLoading := true;

    if ABorder = 0 then
    begin
      lMax := 0;
      lMin := 255;
      for i := 0 to x - 1 do
        for j := 0 to y - 1 do
        begin
          clr := bmp.Canvas.Pixels[i, j];
          hlsclr := RGBtoHLS(clr);
          case AnalisatorType of
            iaLightness:
            begin
              if hlsclr.L > lMax then lMax := hlsclr.L;
              if hlsclr.L < lMin then lMin := hlsclr.L;
            end;
            iaSaturation:
            begin
              if hlsclr.S > lMax then lMax := hlsclr.S;
              if hlsclr.S < lMin then lMin := hlsclr.S;
            end;
            iaRed:
            begin
              if GetRValue(clr) > lMax then lMax := GetRValue(clr);
              if GetRValue(clr) < lMin then lMin := GetRValue(clr);
            end;
            iaGreen:
            begin
              if GetGValue(clr) > lMax then lMax := GetGValue(clr);
              if GetGValue(clr) < lMin then lMin := GetGValue(clr);
            end;
            iaBlue:
            begin
              if GetBValue(clr) > lMax then lMax := GetBValue(clr);
              if GetBValue(clr) < lMin then lMin := GetBValue(clr);
            end;
          end;
        end;
      ABorder := round(lMin + ((lMax - lMin) / 2));
    end;

    if AnalisatorType = iaMono then bmp.PixelFormat := pf1bit;
    for i := 0 to x - 1 do
      for j := 0 to y - 1 do
      begin
        clr := bmp.Canvas.Pixels[i, j];
        hlsclr := RGBtoHLS(clr);
        case AnalisatorType of
          iaLightness:
            if hlsclr.L <= ABorder then
              if AInvert then val := 0
              else val := 1
            else
              if AInvert then val := 1
              else val := 0;
          iaSaturation:
            if hlsclr.S <= ABorder then
              if AInvert then val := 1
              else val := 0
            else
              if AInvert then val := 0
              else val := 1;
          iaRed:
            if GetRValue(clr) <= ABorder then
              if AInvert then val := 1
              else val := 0
            else
              if AInvert then val := 0
              else val := 1;
          iaGreen:
            if GetGValue(clr) <= ABorder then
              if AInvert then val := 1
              else val := 0
            else
              if AInvert then val := 0
              else val := 1;
          iaBlue:
            if GetBValue(clr) <= ABorder then
              if AInvert then val := 1
              else val := 0
            else
              if AInvert then val := 0
              else val := 1;
          iaMono:
            if clr = 0 then
              if AInvert then val := 0
              else val := 1
            else
              if AInvert then val := 1
              else val := 0;
        end;
        FPuzzleCore[j][i] := val;
      end;
  finally
    FCoreFile := ChangeFileExt(ImgFile, '.' + GetExt(cgJCrossPuzzle));
    FLoading := false;
    bmp.Free;
  end;
end;

procedure TCrossPuzzle.GenCoreFromText(TextFile: string; AnalisatorType: TImgAnalisatorType; AInvert: boolean; ABorder: byte;
  LeftIndent, TopIndent: integer);
var
  h, w: integer;
  i, j, x, y: integer;
  sl: TStringList;
  aWeight: byte;

begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(TextFile);
    // определимся с размерами: высота = кол-во строк, ширина = длине самой длинной строки
    h := sl.Count;
    w := 0;
    for i := 0 to sl.Count - 1 do w := Max(w, Length(sl.Strings[i]));

    GenNewCore(h, w, false, true);
    FLoading := true;

    // реальные размеры
    h := Length(FPuzzleCore);
    if h = 0 then exit;
    w := Length(FPuzzleCore[0]);
    x := 0;
    for i := TopIndent to sl.Count - 1 do
    begin
      if x >= h then break;
      y := 0;
      for j := LeftIndent + 1 to Length(sl.Strings[i]) do
      begin
        if y >= w then break;
        case AnalisatorType of
          iaLightness:
          begin
            // анализ "веса" символа
            aWeight := GetASCIIWeight(sl.Strings[i][j]);
            if aWeight >= ABorder then FPuzzleCore[x][y] := 1;
          end;
          iaSaturation: if Ord(sl.Strings[i][j]) in [33..159, 161..255] then FPuzzleCore[x][y] := 1;
        end;
        Inc(y);
      end;
      Inc(x);
    end;
    if AInvert then Invert;
  finally
    FCoreFile := ChangeFileExt(TextFile, '.' + GetExt(cgJCrossPuzzle));
    FLoading := false;
    sl.Free;
  end;
end;

procedure TCrossPuzzle.GenerateMatrix;
var
  leftSteer: array of array of byte;
  topSteer: array of array of byte;
  i, j, n: integer;
  fr: boolean;
  cr: integer;

begin
  while FLoading do ;
  FLoading := true;
  leftLen := 0;
  topHi := 0;
  try
    if FBehaviour = bhSynchro then
    begin
      SetLength(FPuzzleMatrix, Length(FPuzzleCore));
      for i := 0 to Length(FPuzzleCore) - 1 do
      begin
        SetLength(FPuzzleMatrix[i], Length(FPuzzleCore[i]));
        for j := 0 to Length(FPuzzleCore[i]) - 1 do
        begin
          FPuzzleMatrix[i][j] := TPuzzleItem.Create(pztCell, '');
          FPuzzleMatrix[i][j].fpiState := FPuzzleCore[i][j];
        end;
      end;
    end else
    begin
      SetLength(leftSteer, 0);

      for i := 0 to Length(FPuzzleCore) - 1 do
      begin
        fr := false;
        cr := 0;
        SetLength(leftSteer, i + 1);
        SetLength(leftSteer[i], 0);
        for j := 0 to Length(FPuzzleCore[i]) - 1 do
        begin
          if FPuzzleCore[i][j] = 1 then
          begin
            fr := true;
            cr := cr + 1;
            if (Length(FPuzzleCore[i]) - 1 = j) and fr then
            begin
              SetLength(leftSteer[i], Length(leftSteer[i]) + 1);
              leftSteer[i][High(leftSteer[i])] := cr;
              cr := 0;
              fr := false;
            end;
          end else
          begin
            if fr then
            begin
              SetLength(leftSteer[i], Length(leftSteer[i]) + 1);
              leftSteer[i][High(leftSteer[i])] := cr;
              cr := 0;
              fr := false;
            end;
          end;
        end;
      end;

      SetLength(topSteer, 1);
      SetLength(topSteer[0], Length(FPuzzleCore[0]));
      for j := 0 to Length(FPuzzleCore[0]) - 1 do
      begin
        fr := false;
        cr := 0;
        for i := 0 to Length(FPuzzleCore) - 1 do
        begin
          if FPuzzleCore[i][j] = 1 then
          begin
            fr := true;
            cr := cr + 1;
            if (Length(FPuzzleCore) - 1 = i) and fr then
            begin
              n := 0;
              while topSteer[n][j] <> 0 do
              begin
                n := n + 1;
                if Length(topSteer) < (n + 1) then
                begin
                  SetLength(topSteer, n + 1);
                  SetLength(topSteer[n], Length(FPuzzleCore[i]));
                end;
              end;
              topSteer[n][j] := cr;
              cr := 0;
              fr := false;
            end;
          end else
          begin
            if fr then
            begin
              n := 0;
              while topSteer[n][j] <> 0 do
              begin
                n := n + 1;
                if Length(topSteer) < (n + 1) then
                begin
                  SetLength(topSteer, n + 1);
                  SetLength(topSteer[n], Length(FPuzzleCore[i]));
                end;
              end;
              topSteer[n][j] := cr;
              cr := 0;
              fr := false;
            end;
          end;
        end;
      end;

      for i := 0 to Length(leftSteer) - 1 do
        if leftLen < Length(leftSteer[i]) then leftLen := Length(leftSteer[i]);
      for i := 0 to Length(leftSteer) - 1 do
      begin
        SetLength(leftSteer[i], leftLen);
        {for j := leftLen - 1 downto 0 do
        begin
          n := leftLen - 1 - j;
          if j <= n then break;
          if leftSteer[i][j] = 0 then
          begin
            leftSteer[i][j] := leftSteer[i][n];
            leftSteer[i][n] := 0;
          end else break;
        end;}
      end;

      for i := 0 to Length(topSteer) - 1 do
        if Length(topSteer[i]) > 0 then topHi := topHi + 1;

      SetLength(FPuzzleMatrix, topHi);
      for i := 0 to topHi - 1 do
      begin
        SetLength(FPuzzleMatrix[i], leftLen);
        for j := 0 to leftLen - 1 do
          FPuzzleMatrix[i][j] := TPuzzleItem.Create(pztService, '');
        SetLength(FPuzzleMatrix[i], leftLen + Length(FPuzzleCore[i]));
        for j := leftLen to Length(FPuzzleMatrix[i]) - 1 do
        begin
          n := j - leftLen;
          FPuzzleMatrix[i][j] := TPuzzleItem.Create(pztCaption, '');
          if topSteer[i][n] <> 0 then FPuzzleMatrix[i][j].piText := IntToStr(topSteer[i][n]);
        end;
      end;

      SetLength(FPuzzleMatrix, Length(FPuzzleMatrix) + Length(FPuzzleCore));
      for i := topHi to Length(FPuzzleMatrix) - 1 do
      begin
        n := i - topHi;
        SetLength(FPuzzleMatrix[i], leftLen + Length(FPuzzleCore[n]));
        for j := 0 to leftLen - 1 do
        begin
          FPuzzleMatrix[i][j] := TPuzzleItem.Create(pztCaption, '');
          if leftSteer[n][j] <> 0 then FPuzzleMatrix[i][j].piText := IntToStr(leftSteer[n][j]);
        end;
        for j := leftLen to Length(FPuzzleMatrix[i]) - 1 do
          FPuzzleMatrix[i][j] := TPuzzleItem.Create(pztCell, '');
      end;
    end;
  finally
    FLoading := false;
  end;
end;

procedure TCrossPuzzle.GenerateRandom(AOverwrite: boolean);
begin
  FLoading := true;
  try
    FillRandom(AOverwrite);
  finally
    FLoading := false;
  end;
  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TCrossPuzzle.GenNewCore(AHeight, AWidth: integer; Rand: boolean; NoSizeException: boolean);
var
  i, j: integer;

begin
  if (AHeight > PUZZLESIZELIMIT) or (AWidth > PUZZLESIZELIMIT) then
    if NoSizeException then
    begin
      AHeight := Min(AHeight, PUZZLESIZELIMIT);
      AWidth := Min(AWidth, PUZZLESIZELIMIT);
    end else
      raise Exception.Create(Format(MSG_MATRIX_TOOBIG, [IntToStr(PUZZLESIZELIMIT), IntToStr(PUZZLESIZELIMIT)]));

  while FLoading do ;
  FLoading := true;
  if Rand then Randomize;
  SetLength(FPuzzleCore, 0);
  try
    SetLength(FPuzzleCore, AHeight);
    for i := 0 to AHeight - 1 do
    begin
      SetLength(FPuzzleCore[i], AWidth);
      for j := 0 to AWidth - 1 do FPuzzleCore[i][j] := 0;
    end;

    if Rand then FillRandom;
  finally
    FLoading := false;
  end;
end;

function TCrossPuzzle.GetColCount: byte;
begin
  if Length(FPuzzleMatrix) <= 0 then result := 0
  else result := Length(FPuzzleMatrix[0]);
end;

function TCrossPuzzle.GetCoreColCount: byte;
begin
  if Length(FPuzzleCore) <= 0 then result := 0
  else result := Length(FPuzzleCore[0]);
end;

function TCrossPuzzle.GetCoreRowCount: byte;
begin
  result := Length(FPuzzleCore);
end;

function TCrossPuzzle.GetCoreSizeText: string;
begin
  result := IntToStr(Length(FPuzzleCore[0])) + 'x' + IntToStr(Length(FPuzzleCore)); 
end;

function TCrossPuzzle.GetDifficulty: TDifficulty;
begin
  result := FDifficulty;
end;

function TCrossPuzzle.GetFileName: string;
begin
  result := ExtractFileName(FCoreFile);
end;

function TCrossPuzzle.GetItemCol(item: TPuzzleItem): byte;
var
  i, j: integer;
  ok_flg: boolean;

begin
  result := 0;
  ok_flg := false;
  for i:= 0 to Length(FPuzzleMatrix) do
  begin
    if ok_flg then break;
    for j := 0 to Length(FPuzzleMatrix[i]) do
      if FPuzzleMatrix[i][j] = item then
      begin
        result := j;
        ok_flg := true;
        break;
      end;
  end;
  if not ok_flg then raise Exception.Create(MSG_ITEM_NOT_EXIST2);
end;

function TCrossPuzzle.GetItemState(i, j: byte): byte;
begin
  if PuzzleItem[i, j] = nil then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  result := PuzzleItem[i, j].piState;
end;

function TCrossPuzzle.GetItemText(i, j: byte): string;
begin
  if PuzzleItem[i, j] = nil then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  result := PuzzleItem[i, j].piText;
end;

function TCrossPuzzle.GetItemType(i, j: byte): TpzItemType;
begin
  if PuzzleItem[i, j] = nil then result := pztNone
  else result := PuzzleItem[i, j].piType;
end;

function TCrossPuzzle.GetPromptLeft: integer;
begin
  if Assigned(FPrompt) then result := FPrompt.Left
  else result := -1;
end;

function TCrossPuzzle.GetPromptTop: integer;
begin
  if Assigned(FPrompt) then result := FPrompt.Top
  else result := -1;
end;

function TCrossPuzzle.GetPuzzleItem(i, j: byte): TPuzzleItem;
begin
  result := nil;
  if FLoading then exit;
  if i < Length(FPuzzleMatrix) then
    if j < Length(FPuzzleMatrix[i]) then
      result := FPuzzleMatrix[i][j];
end;

function TCrossPuzzle.GetPuzzleName: string;
begin
  result := FName;
end;

function TCrossPuzzle.GetRowCount: byte;
begin
  result := Length(FPuzzleMatrix);
end;

function TCrossPuzzle.GetScale(aCount: integer): integer;
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

procedure TCrossPuzzle.Invert;
begin
  FLoading := true;
  try
    InvertCore;
  finally
    FLoading := false;
  end;
  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TCrossPuzzle.InvertCore;
var
  i, j: integer;

begin
  if (Length(FPuzzleCore) <= 0) then exit;
  if (Length(FPuzzleCore[0]) <= 0) then exit;

  for i := 0 to Length(FPuzzleCore) - 1 do
    for j := 0 to Length(FPuzzleCore[i]) - 1 do
      if FPuzzleCore[i][j] = 0 then FPuzzleCore[i][j] := 1
      else FPuzzleCore[i][j] := 0;
end;

function TCrossPuzzle.IsCorrect: boolean;
var
  i, j, x, y: integer;
  start: boolean;

begin
  x := 0;
  y := 0;
  result := false;
  start := false;
  if FBehaviour = bhSynchro then exit;
  if not IsSolve then exit;
  if FLoading then exit;
  result := true;
  for i := 0 to Length(FPuzzleMatrix) - 1 do
  begin
    for j := 0 to Length(FPuzzleMatrix[i]) - 1 do
    begin
      if FPuzzleMatrix[i][j].piType = pztCell then
        if not start then
        begin
          start := true;
          x := i;
          y := j;
        end else
          if FPuzzleMatrix[i][j].piState <> FPuzzleCore[i - x][j - y] then
          begin
            result := false;
            exit;
          end;
    end;
  end;
end;

function TCrossPuzzle.IsEmpty: boolean;
begin
  result := (Length(FPuzzleMatrix) <= 0) or (Length(FPuzzleCore) <= 0);
end;

function TCrossPuzzle.IsSolve: boolean;
var
  i, j: integer;

begin
  result := false;
  if FLoading then exit;
  if (Length(FPuzzleMatrix) = 0) or (Length(FPuzzleMatrix[0]) = 0) then exit;
  result := true;
  for i := 0 to Length(FPuzzleMatrix) - 1 do
    for j := 0 to Length(FPuzzleMatrix[i]) - 1 do
      if FPuzzleMatrix[i][j].piType = pztCell then
        if FPuzzleMatrix[i][j].piState <> 2 then exit;
  result := false;
end;

function TCrossPuzzle.GetItemRow(item: TPuzzleItem): byte;
var
  i, j: integer;
  ok_flg: boolean;

begin
  result := 0;
  ok_flg := false;
  for i:= 0 to Length(FPuzzleMatrix) do
  begin
    if ok_flg then break;
    for j := 0 to Length(FPuzzleMatrix[i]) do
      if FPuzzleMatrix[i][j] = item then
      begin
        result := i;
        ok_flg := true;
        break;
      end;
  end;
  if not ok_flg then raise Exception.Create(MSG_ITEM_NOT_EXIST2);
end;

procedure TCrossPuzzle.LoadCore(corefile: string);
var
  i, j: integer;
  f: TFileStream;
  head: TCoreFileHeader;
  c: char;

begin
  while FLoading do ;
  FLoading := true;
  SetLength(FPuzzleCore, 0);

  try
    if not FileExists(corefile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [corefile]));
    if LowerCase(CutFileExt(corefile)) <> GetExt(cgJCrossPuzzle) then raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [corefile]));
    FCoreFile := corefile;

    try
      f := TFileStream.Create(FCoreFile, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));
      if (head._type <> Ord(cgJCrossPuzzle)) or (head.Height <= 0) or (head.Width <= 0) then
        raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [FCoreFile]));

      if (head.Height > PUZZLESIZELIMIT) or (head.Width > PUZZLESIZELIMIT) then
        raise Exception.Create(Format(MSG_MATRIX_TOOBIG, [IntToStr(PUZZLESIZELIMIT), IntToStr(PUZZLESIZELIMIT)]));

      Difficulty := TDifficulty(head.diff);

      // название
      FName := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(c, 1);
        FName := FName + c;
      end;

      //читаем тело
      SetLength(FPuzzleCore, head.Height);
      for i := 0 to head.Height - 1 do
      begin
        SetLength(FPuzzleCore[i], head.Width);
        for j := 0 to head.Width - 1 do
          f.Read(FPuzzleCore[i][j], SizeOf(byte));
      end;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_READ_ERROR, [FCoreFile]) + ':'#13#10 + e.Message);
    end;
  finally
    FLoading := false;
    if Assigned(f) then f.Free;
  end;
end;

procedure TCrossPuzzle.LoadPreview;
var
  i, j: integer;
  r: TRect;
  x1, y1, x2, y2: integer;
  xscale: integer;
  yscale: integer;

begin
  if (not Assigned(FPrompt)) then exit;
  r.Left := 0;
  r.Top := 0;
  r.Right := FPrompt.bmPreview.Width;
  r.Bottom := FPrompt.bmPreview.Height;
  FPrompt.bmPreview.Canvas.Brush.Color := clBtnFace;
  FPrompt.bmPreview.Canvas.FillRect(r);
  if (not Assigned(FPuzzleCore)) or (Length(FPuzzleCore) = 0) or (Length(FPuzzleCore[0]) = 0) then
  begin
    FPrompt.pPreviewArea.Caption := '<нет>';
    FPrompt.Caption := '<нет>';
    exit;
  end else
  begin
    FPrompt.Caption := Name;
    yscale := GetScale(Length(FPuzzleCore));
    //xscale := GetScale(Length(FPuzzleCore[0]));
    xscale := yscale;
    FPrompt.bmPreview.Height := Length(FPuzzleCore) * yscale + 10;
    FPrompt.bmPreview.Width := Length(FPuzzleCore[0]) * xscale + 10;
    FPrompt.pPreviewArea.Caption := '';
    x1 := 5;
    x2 := x1 + xscale;
    y1 := 5;
    y2 := y1 + yscale;
    for i := 0 to Length(FPuzzleCore) - 1 do
    begin
      for j := 0 to Length(FPuzzleCore[i]) - 1 do
      begin
        if FPuzzleCore[i][j] = 0 then FPrompt.bmPreview.Canvas.Brush.Color := clWhite
        else FPrompt.bmPreview.Canvas.Brush.Color := clBlack;
        FPrompt.bmPreview.Canvas.Rectangle(x1, y1, x2, y2);
        x1 := x2;
        x2 := x1 + xscale;
      end;
      x1 := 5;
      x2 := x1 + xscale;
      y1 := y2;
      y2 := y1 + yscale;
    end;
    FPrompt.bmPreview.Repaint;
  end;
  FPrompt.ClientHeight := FPrompt.bmPreview.Height + 2;
  FPrompt.ClientWidth := FPrompt.bmPreview.Width + 2;
end;

function TCrossPuzzle.SaveCore(AFile: string): boolean;
var
  f: TFileStream;
  i, j: integer;
  head: TCoreFileHeader;
  Mode: Word;

begin
  result := false;
  if (Length(FPuzzleCore) <= 0) or (Length(FPuzzleCore[0]) <= 0) then exit;
  FCoreFile := AFile;
  head._type := Ord(cgJCrossPuzzle);
  head.diff := Ord(Difficulty);
  head.Height := Length(FPuzzleCore);
  head.Width := Length(FPuzzleCore[0]);
  head.bgColor := 0;
  head.sz_name := Length(FName);

  try
    try
      if FileExists(FCoreFile) then Mode := fmOpenWrite
      else mode := fmCreate;
      f := TFileStream.Create(FCoreFile, Mode);
      //записываем заголовок
      f.Write(head, SizeOf(head));
      //название
      for i := 1 to head.sz_name do f.Write(FName[i], 1);
      //записываем тело
      for i := 0 to head.Height - 1 do
        for j := 0 to head.Width - 1 do
          f.Write(FPuzzleCore[i][j], SizeOf(byte));

      result := true;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_WRITE_ERROR, [FCoreFile]) + ':'#13#10 + e.Message);
    end;
  finally
    if Assigned(f) then f.Free;
  end;
end;

procedure TCrossPuzzle.SetDifficulty(value: TDifficulty);
begin
  FDifficulty := value;
end;

procedure TCrossPuzzle.SetItemState(i, j, value: byte);
begin
  if PuzzleItem[i, j] = nil then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  if FBehaviour = bhSynchro then
  begin
    if not (value in [0, 1]) then value := PuzzleItem[i, j].piState;
    PuzzleItem[i, j].piState := value;
    FPuzzleCore[i][j] := value;
  end else
    PuzzleItem[i, j].piState := value;
end;

procedure TCrossPuzzle.SetItemText(i, j: byte; value: string);
begin
  if PuzzleItem[i, j] = nil then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  PuzzleItem[i, j].piText := value;
end;

procedure TCrossPuzzle.SetItemType(i, j: byte; value: TpzItemType);
begin
{  if not Assigned(PuzzleItem[i, j]) then
    raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  if value <> pztNone then
    PuzzleItem[i, j].piType := value;
}
end;

procedure TCrossPuzzle.SetPromptLeft(value: integer);
begin
  if Assigned(FPrompt) then FPrompt.Left := value;
end;

procedure TCrossPuzzle.SetPromptTop(value: integer);
begin
  if Assigned(FPrompt) then FPrompt.Top := value;
end;

procedure TCrossPuzzle.SetPuzzleName(value: string);
begin
  FName := value;
end;

procedure TCrossPuzzle.ShowPreview;
begin
  if Assigned(FPrompt) then
  begin
    LoadPreview;
    if FPrompt.Visible then FPrompt.Hide
    else FPrompt.Show;
  end;
end;

{ TfPrompt }

procedure TfPrompt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

end.
