unit sudoku;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Math, Forms, ExtCtrls, Controls, Grids, jsCommon;

type
  TfrmPrompt = class(TForm)
    pPreviewArea: TPanel;
    sgPreview: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

  TSudoku = class
  private
    FSudokuMatrix: TSudokuCore;
    FSudokuCore: TSudokuCore;
    FLoading: boolean;
    FCoreFile: string;
    FBehaviour: TBehaviour;
    FPrompt: TfrmPrompt;
    FDifficulty: TDifficulty;
    bMap: TSudokuCore;
    FName: string;
    procedure LoadCore(corefile: string);
    procedure GenNewCore(Rand: boolean);
    procedure GenCoreFromText(TxtFile: string);
    procedure GenerateMatrix(AEmpty: boolean = false; ARefrsh: boolean = false);
    procedure ClearMatrix(ASaveCore: boolean = false);
    function GetItemState(i, j: byte): byte;
    procedure SetItemState(i, j: byte; value: byte);
    function GetItemText(i, j: byte): string;
    function GetName: string;
    procedure SetName(value: string);
    function GetDifficulty: TDifficulty;
    procedure SetDifficulty(value: TDifficulty);
    procedure LoadPreview;
    function GetPromptLeft: integer;
    procedure SetPromptLeft(value: integer);
    function GetPromptTop: integer;
    procedure SetPromptTop(value: integer);
    function CheckValue(AMatrix: TSudokuCore; X, Y: integer; n: integer = -1): boolean;
    function GetItemType(i, j: byte): byte;
    procedure SetBlockingMap(value: TSudokuCore);
    function GetBlockingMap: TSudokuCore;
    function GetFileName: string;
    //методы решения судоку
    function CheckSmallSquare(AMatrix: TSudokuCore; X, Y: integer; value: integer): boolean; overload;
    function CheckSmallSquare(AMatrix: TSudokuCore; Cell: TPoint; value: integer; var SmallSquare: TRect): boolean; overload;
    function CheckLines(AMatrix: TSudokuCore; X, Y: integer; var row, col: boolean; value: integer): boolean;
    procedure Exchange(AMatrix: TSudokuCore; fromPos, toPos: TPoint);
    function FindNextEmpty(Start: TPoint): TPoint;
    function GetNextCellVariant(Start: integer; Cell: TPoint): integer;
    function GetNothings(Cell: TPoint; Direction: TMoveDirection): TNumericArray;
    function FindNoise(Cell: TPoint; value: integer; Direction: TMoveDirection): TPoint;
    function GetReplacer(Noise: TPoint; value: integer; Direction: TMoveDirection; CheckTarget: TReplaceTarget): TPoint;
    function GetExCell(Cell: TPoint; Direction: TMoveDirection): TPoint;
    function CheckAndMove(Cell, Noise: TPoint; value: integer; Direction: TMoveDirection; Advanced, Prepare: boolean;
      var RecursionStep: integer): boolean;
    function PrepareFill: boolean;
    procedure FillRandom;
  public
    constructor CreateEmpty(Rand: boolean);
    constructor CreateForFile(AFile: string; ABehaviour: TBehaviour; ADifficulty: TDifficulty; EmptyMatrix: boolean = false);
    constructor CreateForText(TxtFile: string);
    destructor Destroy; override;

    function IsSolve(var ARow, ACol: integer; CheckCore: boolean = false): boolean;
    function IsCorrect(var ARow, ACol: integer; CheckCore: boolean = false): boolean;
    function SaveCore(AFile: string): boolean;
    function IsEmpty: boolean;
    procedure ShowPreview;
    procedure GenerateRandom(AOverwrite: boolean);
    procedure ReloadMatrix;
    property PromptLeft: integer read GetPromptLeft write SetPromptLeft;
    property PromptTop: integer read GetPromptTop write SetPromptTop;
    property ItemState[ARow: byte; ACol: byte]: byte read GetItemState write SetItemState;
    property ItemText[ARow: byte; ACol: byte]: string read GetItemText;
    property Name: string read GetName write SetName;
    property Difficulty: TDifficulty read GetDifficulty write SetDifficulty;
    property ItemType[ARow: byte; ACol: byte]: byte read GetItemType;
    property BlockMap: TSudokuCore read GetBlockingMap write SetBlockingMap;
    property FileName: string read GetFileName;
  end;

implementation

uses Types;

{$R *.dfm}

{ TfPrompt }

procedure TfrmPrompt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

{ TSudoku }

function TSudoku.CheckValue(AMatrix: TSudokuCore; X, Y: integer; n: integer): boolean;
var
  i, j: integer;
  lsX1, lsX2, lsY1, lsY2: integer;

begin
  result := false;
  if (Length(AMatrix) <= 0) or (X < 0) or (X >= Length(AMatrix)) or (Y < 0) or (Y >= Length(AMatrix)) then exit;
  if (n < 0) and ((AMatrix[X][Y] < 1) or (AMatrix[X][Y] > 9)) then exit;

  if n < 0 then n := AMatrix[X][Y];
  //проверим совпадения в ряду
  for i := 0 to 8 do
    if (AMatrix[X][i] = n) and (i <> Y) then exit;
  //проверим совпадения в столбце
  for j := 0 to 8 do
    if (AMatrix[j][Y] = n) and (j <> X) then exit;

  //теперь проверим совпадение в своем малом квадрате (3х3)
  lsX1 := -1;
  lsY1 := -1;

  case X of
    0..2: lsX1 := 0;
    3..5: lsX1 := 3;
    6..8: lsX1 := 6;
  end;
  case Y of
    0..2: lsY1 := 0;
    3..5: lsY1 := 3;
    6..8: lsY1 := 6;
  end;
  lsX2 := lsX1 + 2;
  lsY2 := lsY1 + 2;

  for i := lsX1 to lsX2 do
    for j := lsY1 to lsY2 do
      if (AMatrix[i][j] = n) and (i <> X) and (j <> Y) then exit;

  result := true;
end;

procedure TSudoku.ClearMatrix(ASaveCore: boolean);
begin
  while FLoading do ;
  FLoading := true;
  try
    if not ASaveCore then SetLength(FSudokuCore, 0);
    SetLength(FSudokuMatrix, 0);
    SetLength(bMap, 0);
  finally
    FLoading := false;
  end;
end;    

constructor TSudoku.CreateEmpty(Rand: boolean);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  FBehaviour := bhSynchro;
  GenNewCore(Rand);
  GenerateMatrix;
  FPrompt := TfrmPrompt.Create(nil);
end;

constructor TSudoku.CreateForFile(AFile: string; ABehaviour: TBehaviour; ADifficulty: TDifficulty; EmptyMatrix: boolean);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  if not FileExists(AFile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [AFile]));
  FBehaviour := ABehaviour;
  LoadCore(AFile);
  Difficulty := ADifficulty;   // сложность переписываем той, что передана, т.к. она задается в игре
  GenerateMatrix(EmptyMatrix);
  FPrompt := TfrmPrompt.Create(nil);
end;

constructor TSudoku.CreateForText(TxtFile: string);
begin
  inherited Create;
  FLoading := false;
  ClearMatrix;
  if not FileExists(TxtFile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [TxtFile]));
  FBehaviour := bhSynchro;
  GenCoreFromText(TxtFile);
  GenerateMatrix;
  FPrompt := TfrmPrompt.Create(nil);
end;

destructor TSudoku.Destroy;
begin
  ClearMatrix;
  if Assigned(FPrompt) then FPrompt.Free;
  inherited;
end;

{ БЛОК МЕТОДОВ ГЕНЕРАЦИИ ПОСЛЕДОВАТЕЛЬНОСТЕЙ СУДОКУ }

function TSudoku.CheckSmallSquare(AMatrix: TSudokuCore; X, Y: integer; value: integer): boolean;
var
  i, j: integer;
  lsX1, lsX2, lsY1, lsY2: integer;

begin
  //проверяет совпадение в своем малом квадрате (3х3)
  //(если совпадения есть - малый квадрат неверный, result = false)
  result := false;
  if (Length(AMatrix) <= 0) or (X < 0) or (X >= Length(AMatrix)) or (Y < 0) or (Y >= Length(AMatrix)) then exit;
  if value = 0 then
  begin
    result := true;
    exit;
  end;

  lsX1 := -1;
  lsY1 := -1;

  case X of
    0..2: lsX1 := 0;
    3..5: lsX1 := 3;
    6..8: lsX1 := 6;
  end;
  case Y of
    0..2: lsY1 := 0;
    3..5: lsY1 := 3;
    6..8: lsY1 := 6;
  end;
  lsX2 := lsX1 + 2;
  lsY2 := lsY1 + 2;

  for i := lsX1 to lsX2 do
    for j := lsY1 to lsY2 do
      if (AMatrix[i][j] = value) and (i <> X) and (j <> Y) then exit;

  result := true;
end;

function TSudoku.CheckSmallSquare(AMatrix: TSudokuCore; Cell: TPoint; value: integer; var SmallSquare: TRect): boolean;
var
  i, j: integer;

begin
  //проверяет совпадение в своем малом квадрате (3х3)
  //(если совпадения есть - малый квадрат неверный, result = false)
  result := false;
  if (Length(AMatrix) <= 0) or (Cell.X < 0) or (Cell.X >= Length(AMatrix)) or (Cell.Y < 0) or (Cell.Y >= Length(AMatrix)) then exit;
  if value = 0 then
  begin
    result := true;
    exit;
  end;

  case Cell.X of
    0..2: SmallSquare.Top := 0;
    3..5: SmallSquare.Top := 3;
    6..8: SmallSquare.Top := 6;
  end;
  case Cell.Y of
    0..2: SmallSquare.Left := 0;
    3..5: SmallSquare.Left := 3;
    6..8: SmallSquare.Left := 6;
  end;
  SmallSquare.Bottom := SmallSquare.Top + 2;
  SmallSquare.Right := SmallSquare.Left + 2;

  for i := SmallSquare.Top to SmallSquare.Bottom do
    for j := SmallSquare.Left to SmallSquare.Right do
      if (AMatrix[i][j] = value) and (i <> Cell.X) and (j <> Cell.Y) then exit;

  result := true;
end;

function TSudoku.CheckAndMove(Cell, Noise: TPoint; value: integer; Direction: TMoveDirection; Advanced, Prepare: boolean;
  var RecursionStep: integer): boolean;
var
  Noise2, exCell, exCell2: TPoint;

begin
  //Основной метод анализа и перестановки (Этапы 2 и 3)
  //осуществляет проверку возможности перестановки чисел и выполняет саму перестановку
  //2 режима: в простом (Advanced=false) просто ищет возможность обмена, если сталкивается
  //с препятствием - на выход, если препятствий нет - обмен
  //в расширенном (Advanced=true) выполняется углубленный анализ по двум алгоритмам:
  //  сначала проверяет, можно ли обменять пустую ячейку с числом, отсутствующим в линии
  //  (если отсутствующее число есть среди вариантов обмена), если да - производит обмен
  //  Если 1 алгоритм ничего не нашел, выполняется второй: рекурсивный поиск помех для
  //  устранения помех, пока не переберет все варианты перестановки или пока не 
  //  вычислит самую первую помеху, к-рую можно устранить, после чего в обратном порядке
  //  устраняются все помехи (меняются местами ячейки)
  //если выполнялись перестановки - result = true   

  result := false;

  if not Advanced then
  begin
    if value = 0 then exit;
    Noise := FindNoise(Cell, value, Direction);
    if (Noise.X = -1) or (Noise.Y = -1) then exit;
    exCell := GetReplacer(Noise, value, Direction, rdBoth);
    if (exCell.X > -1) and (exCell.Y > -1) then
    begin
      result := true;
      Exchange(FSudokuCore, Noise, exCell);
    end;
  end else
  begin
    if Prepare then
    begin
      RecursionStep := 0;
      //сначала надо найти 1 помеху
      Noise := FindNoise(Cell, value, Direction);
      if (Noise.X = -1) or (Noise.Y = -1) then exit;

      // это первый нерекурсивный вызов, надо выполнить первичную проверку
      exCell := GetExCell(Cell, Direction);
      if (exCell.X > -1) and (exCell.Y > -1) then
      begin
        Exchange(FSudokuCore, Cell, exCell);
        result := true;
        exit;
      end;

      //определим направление обмена
      //проверим, можно ли убрать помеху в один из рядов/столбцов (проверяются сразу оба ряда)
      exCell := GetReplacer(Noise, value, Direction, rdTo);
      if (exCell.X > -1) and (exCell.Y > -1) then
      begin
        //туда ставить можно, проверим, можно ли ставить оттуда
        Noise2 := FindNoise(Noise, FSudokuCore[exCell.X][exCell.Y], Direction);
        //если препятствий нет - делаем обмен
        if (Noise2.X = -1) or (Noise2.Y = -1) then
        begin
          Exchange(FSudokuCore, Noise, exCell);
          result := true;
          exit;
        end else
        begin
          //если препятствия есть запускаем рекурсивный поиск-устранение препятствий
          exCell2.X := exCell.X;
          exCell2.Y := exCell.Y;
          case Direction of
            mdLeft, mdRight: exCell2.Y := Noise2.Y;
            mdUp, mdDown: exCell2.X := Noise2.X;
          end;
          result := CheckAndMove(Noise2, exCell2, FSudokuCore[exCell2.X][exCell2.Y], Direction, true, false, RecursionStep);
          if result then Exchange(FSudokuCore, Noise, exCell);
        end;
      end else
      begin
        //если туда ставить нельзя ни в одном из вариантов, проверим, можно ли поставить
        //из одного из рядов число на место помехи (если и тут неудача - тупик, выходим)
        exCell := GetReplacer(Noise, value, Direction, rdFrom);
        if (exCell.X > -1) and (exCell.Y > -1) then
        begin
          //оттуда ставить можно, туда нельзя (мы это раньше определили), определим помеху для "туда"
          Noise2 := FindNoise(exCell, FSudokuCore[Noise.X][Noise.Y], Direction);
          //если препятствий нет - делаем обмен (на самом деле, если мы уже тут, то препятствие заведеомо есть,
          //а это перестраховка)
          if (Noise2.X = -1) or (Noise2.Y = -1) then
          begin
            Exchange(FSudokuCore, Noise, exCell);
            result := true;
            exit;
          end else
          begin
            //если препятствия есть запускаем рекурсивный поиск-устранение препятствий
            exCell2.X := Noise.X;
            exCell2.Y := Noise.Y;
            case Direction of
              mdLeft, mdRight: exCell2.X := Noise2.X;
              mdUp, mdDown: exCell2.Y := Noise2.Y;
            end;
            result := CheckAndMove(Noise2, exCell2, FSudokuCore[exCell2.X][exCell2.Y], Direction, true, false, RecursionStep);
            if result then Exchange(FSudokuCore, Noise, exCell);
          end;
        end;
      end;

      exit;
    end;

    //блок рекурсивной проверки
    if RecursionStep > RECURSIONLIMIT then exit;
    Inc(RecursionStep);
    Noise2 := FindNoise(Cell, FSudokuCore[Noise.X][Noise.Y], Direction);
    if (Noise2.X = -1) or (Noise2.Y = -1) then
    begin
      Exchange(FSudokuCore, Noise, Cell);
      result := true;
      exit;
    end else
    begin
      exCell.X := Noise2.X;
      exCell.Y := Noise2.Y;
      case Direction of
        mdLeft, mdRight: exCell.X := Noise.X;
        mdUp, mdDown: exCell.Y := Noise.Y;
      end;
      result := CheckAndMove(Noise2, exCell, FSudokuCore[exCell.X][exCell.Y], Direction, true, false, RecursionStep);
      if result then Exchange(FSudokuCore, Noise, Cell);
    end;
  end;
end;

function TSudoku.CheckLines(AMatrix: TSudokuCore; X, Y: integer; var row, col: boolean; value: integer): boolean;
var
  i, j: integer;

begin
  //проверяет совпадения в ряду и столбце (если совпадения есть - "линия" неверная, result = false)
  result := false;
  row := false;
  col := false;
  if (Length(AMatrix) <= 0) or (X < 0) or (X >= Length(AMatrix)) or (Y < 0) or (Y >= Length(AMatrix)) then exit;
  if value = 0 then
  begin
    result := true;
    exit;
  end;

  //проверим совпадения в ряду
  row := true;
  col := true;
  for i := 0 to Length(AMatrix[X]) - 1 do
    if (AMatrix[X][i] = value) and (i <> Y) then
    begin
      row := false;
      break;
    end;
  //проверим совпадения в столбце
  for j := 0 to Length(AMatrix) - 1 do
    if (AMatrix[j][Y] = value) and (j <> X) then
    begin
      col := false;
      break;
    end;
  result := row and col;
end;

procedure TSudoku.Exchange(AMatrix: TSudokuCore; fromPos, toPos: TPoint);
var
  from_val, to_val: byte;

begin
  //обмен данными ячеек
  from_val := AMatrix[fromPos.X][fromPos.Y];
  to_val := AMatrix[toPos.X][toPos.Y];
  AMatrix[fromPos.X][fromPos.Y] := to_val;
  AMatrix[toPos.X][toPos.Y] := from_val;
end;

function TSudoku.FindNextEmpty(Start: TPoint): TPoint;
var
  i, j: integer;

begin
  //поиск следующей пустой ячейки
  result.X := -1;
  result.Y := -1;
  if Start.X = -1 then Start.X := 0;
  if Start.Y = -1 then Start.Y := 0
  else if Start.Y = 8 then
  begin
    Start.Y := 0;
    Start.X := Start.X + 1;
  end else
    Start.Y := Start.Y + 1;

  for i := Start.X to Length(FSudokuCore) - 1 do
  begin
    for j := Start.Y to Length(FSudokuCore[i]) - 1 do
      if FSudokuCore[i][j] = 0 then
      begin
        result.X := i;
        result.Y := j;
        exit;
      end;
    Start.Y := 0;
  end;
end;

function TSudoku.FindNoise(Cell: TPoint; value: integer; Direction: TMoveDirection): TPoint;
var
  i: integer;

begin
  //поиск помехи в заданном направлении (ряду или столбце)
  Result.X := -1;
  Result.Y := -1;
  if value = 0 then exit;
  
  case Direction of
    mdLeft, mdRight:
    begin
      Result.X := Cell.X;
      Result.Y := -1;
      for i := 0 to Length(FSudokuCore) - 1 do
        if (FSudokuCore[Cell.X][i] = value) and (i <> Cell.Y) then
        begin
          Result.Y := i;
          break;
        end;
      if Result.Y = -1 then Result.X := -1;
    end;
    mdUp, mdDown:
    begin
      Result.X := -1;
      Result.Y := Cell.Y;
      for i := 0 to Length(FSudokuCore) - 1 do
        if (FSudokuCore[i][Cell.Y] = value) and (i <> Cell.X) then
        begin
          Result.X := i;
          break;
        end;
      if Result.X = -1 then Result.Y := -1;
    end;
  end;
end;

function TSudoku.GetNextCellVariant(Start: integer; Cell: TPoint): integer;
var
  i, j: integer;
  finded: boolean;
  SmallSquare: TRect;

begin
  //поиск следующего возможного значения в малому квадрате (3х3), определяем по ячейке
  result := Start;

  case Cell.X of
    0..2: SmallSquare.Top := 0;
    3..5: SmallSquare.Top := 3;
    6..8: SmallSquare.Top := 6;
  end;
  case Cell.Y of
    0..2: SmallSquare.Left := 0;
    3..5: SmallSquare.Left := 3;
    6..8: SmallSquare.Left := 6;
  end;
  SmallSquare.Bottom := SmallSquare.Top + 2;
  SmallSquare.Right := SmallSquare.Left + 2;

  while result < 10 do
  begin
    Inc(result);
    finded := false;
    for i := SmallSquare.Top to SmallSquare.Bottom do
    begin
      if finded then break;
      for j := SmallSquare.Left to SmallSquare.Right do
        if (FSudokuCore[i][j] = result) then
        begin
          finded := true;
          break;
        end;
    end;
    if not finded then break;
  end;
  if (result > 9) then result := -1;
end;

function TSudoku.GetNothings(Cell: TPoint; Direction: TMoveDirection): TNumericArray;
var
  tears: TNumericArray;
  i, j, n: integer;
  finded: boolean;

begin
  //возвращает список чисел, к-рых нет в ряду/столбце, кроме тех, что можно поставить в
  //пустые ячейки
  //составим список исключений - те числа из отсутствующих в ряду, к-рые встанут в пустые ячейки
  SetLength(result, 0);
  SetLength(tears, 0);
  for i := 0 to Length(FSudokuCore) - 1 do
    if ((Direction in [mdLeft, mdRight]) and (FSudokuCore[Cell.X][i] = 0)) or
      ((Direction in [mdUp, mdDown]) and (FSudokuCore[i][Cell.Y] = 0)) then
    begin
      SetLength(tears, Length(tears) + 1);
      tears[High(tears)] := GetNextCellVariant(0, Cell);
      while tears[High(tears)] > -1 do
      begin
        SetLength(tears, Length(tears) + 1);
        tears[High(tears)] := GetNextCellVariant(tears[High(tears)-1], Cell);
      end;
      if tears[High(tears)] = -1 then SetLength(tears, Length(tears) - 1);
    end;

  //собственно, поищем еще недостающих чисел
  for i := 1 to Length(FSudokuCore) do
  begin
    finded := false;
    for j := 0 to Length(FSudokuCore) - 1 do
    begin
      if ((Direction in [mdLeft, mdRight]) and (FSudokuCore[Cell.X][j] = i)) or
        ((Direction in [mdUp, mdDown]) and (FSudokuCore[j][Cell.Y] = i)) then
      begin
        finded := true;
        break;
      end;
    end;
    if not finded then
    begin
      finded := false;
      for n := 0 to Length(tears) - 1 do
        if tears[n] = i then
        begin
          finded := true;
          break;
        end;
      if not finded then
      begin
        SetLength(result, Length(result) + 1);
        result[High(result)] := i;
      end;
    end;
  end;
end;

function TSudoku.GetReplacer(Noise: TPoint; value: integer; Direction: TMoveDirection; CheckTarget: TReplaceTarget): TPoint;
var
  i, j: integer;
  b: boolean;
  increments: array [0..1] of integer;
  replacedValue: integer;
  _tmp: integer;

begin
  //ищет координаты ячейки, с которой возможен обмен значениями для заданной ячейки
  b := true;
  
  if Direction in [mdLeft, mdRight] then _tmp := Noise.X
  else _tmp := Noise.Y;

  case _tmp of
    0, 3, 6:
    begin
      increments[0] := 1;
      increments[1] := 2;
    end;
    1, 4, 7:
    begin
      increments[0] := -1;
      increments[1] := 1;
    end;
    2, 5, 8:
    begin
      increments[0] := -1;
      increments[1] := -2;
    end;
  end;

  case Direction of
    mdLeft, mdRight:
    begin
      for i := 0 to 1 do
      begin
        b := false;
        Result.X := Noise.X + increments[i];
        Result.Y := Noise.Y;
        replacedValue := FSudokuCore[Result.X][Result.Y];
        
        //проверим, можно ли число помеху поставить на новое место
        //(если помеха = 0, то можно)
        if CheckTarget in [rdBoth, rdTo] then
        begin
          if value <> 0 then
            for j := 0 to Length(FSudokuCore) - 1 do
              if (FSudokuCore[Result.X][j] = value) and (j <> Result.Y) then
              begin
                b := true;
                break;
              end;
          if b then continue;
        end;

        //проверим, можно ли число с нового места поставить на наше (где помеха)
        //ясное дело, если на новом месте 0, то можно
        if CheckTarget in [rdBoth, rdFrom] then
        begin
          if replacedValue <> 0 then
            for j := 0 to Length(FSudokuCore) - 1 do
              if (FSudokuCore[Noise.X][j] = replacedValue) and (j <> Noise.Y) then
              begin
                b := true;
                break;
              end;
          if b then continue;
        end;

        //если мы тут, то все ОК
        break;
      end;
    end;
    mdUp, mdDown:
    begin
      for i := 0 to 1 do
      begin
        b := false;
        Result.Y := Noise.Y + increments[i];
        Result.X := Noise.X;
        replacedValue := FSudokuCore[Result.X][Result.Y];

        //проверим, можно ли число помеху поставить на новое место
        //(если помеха = 0, то можно)
        if CheckTarget in [rdBoth, rdTo] then
        begin
          if value <> 0 then
            for j := 0 to Length(FSudokuCore) - 1 do
              if (FSudokuCore[j][Result.Y] = value) and (j <> Result.X) then
              begin
                b := true;
                break;
              end;
          if b then continue;
        end;

        //проверим, можно ли число с нового места поставить на наше (где помеха)
        //ясное дело, если на новом месте 0, то можно
        if CheckTarget in [rdBoth, rdFrom] then
        begin
          if replacedValue <> 0 then
            for j := 0 to Length(FSudokuCore) - 1 do
              if (FSudokuCore[j][Noise.Y] = replacedValue) and (j <> Noise.X) then
              begin
                b := true;
                break;
              end;
          if b then continue;
        end;

        //если мы тут, то все ОК
        break;
      end;
    end;
  end;

  if b then
  begin
    Result.X := -1;
    Result.Y := -1;
  end;
end;

function TSudoku.GetExCell(Cell: TPoint; Direction: TMoveDirection): TPoint;
var
  i, j: integer;
  b: boolean;
  increments: array [0..1] of integer;
  _tmp: integer;
  nothings: TNumericArray;

begin
  //проверяет, есть ли среди вариантов обмена (в малом столбце если помеха в ряду или
  //в малой строке, если помеха в столбце) числа, к-рых нет в ряду/столбце, и если
  //есть - возвращает координаты такой ячейки - их можно смело обменивать с нашей пустой
  Result.X := -1;
  Result.Y := -1;

  //сначала поищем, какого числа нет в ряду, кроме тех, что должны встать в пустые ячейки,
  SetLength(nothings, 0);
  nothings := GetNothings(Cell, Direction);

  if Direction in [mdLeft, mdRight] then _tmp := Cell.X
  else _tmp := Cell.Y;

  case _tmp of
    0, 3, 6:
    begin
      increments[0] := 1;
      increments[1] := 2;
    end;
    1, 4, 7:
    begin
      increments[0] := -1;
      increments[1] := 1;
    end;
    2, 5, 8:
    begin
      increments[0] := -1;
      increments[1] := -2;
    end;
  end;

  //проверим, есть ли в малом ряду (при проверке столбца) или в малом столбце (при проверке ряда)
  //найденные числа
  b := false;
  for i := 0 to Length(nothings) - 1 do
  begin
    for j := 0 to 1 do
      if ((Direction in [mdLeft, mdRight]) and (FSudokuCore[Cell.X + increments[j]][Cell.Y] = nothings[i])) or
        ((Direction in [mdUp, mdDown]) and (FSudokuCore[Cell.X][Cell.Y + increments[j]] = nothings[i])) then
      begin
        b := true;
        case Direction of
          mdLeft, mdRight:
          begin
            Result.X := Cell.X + increments[j];
            Result.Y := Cell.Y;
          end;
          mdUp, mdDown:
          begin
            Result.X := Cell.X;
            Result.Y := Cell.Y + increments[j];
          end;
        end;
        break;
      end;
    if b then break;
  end;
end;

function TSudoku.PrepareFill: boolean;

  function IsExist(nr: TNumericArray; num: integer): boolean;
  var
    i: integer;

  begin
    result := false;
    for i := 0 to Length(nr) - 1 do
      if nr[i] = num then
      begin
        result := true;
        break;
      end;
  end;

var
  i, j: integer;
  x: integer;
  n: integer;
  col, row: boolean;
  cMap: TSudokuCore;
  busysum: integer;
  prohibitsum: integer;
  numrow: TNumericArray;

begin
  //Этап 1 - предварительное заполнение случайными значениями всего, что получится
  //состояния ячеек:
  //  0 - свободная
  //  1 - занята
  //  2 - запрещенная (в этом ряду/столбце/малом квадрате уже есть такое число)

  result := false;
  //генерирую ряд случайно расположенных чисел от 1 до 9 (эта последовательность будет
  //использоваться для заполнения массива)
  SetLength(numrow, SUDOKUSIZELIMIT);
  Randomize;
  n := 0;
  for i := 0 to Length(numrow) - 1 do
  begin
    while (n = 0) or (IsExist(numrow, n)) do n := Random(10);
    numrow[i] := n;
  end;

  SetLength(cMap, SUDOKUSIZELIMIT);
  for i := 0 to Length(cMap) - 1 do SetLength(cMap[i], SUDOKUSIZELIMIT);

  for n := 0 to Length(numrow) - 1 do
  begin
    x := 1;
    while x < 10 do
    begin
      //составляем карту свободных ячеек
      for i := 0 to Length(FSudokuCore) - 1 do
        for j := 0 to Length(FSudokuCore[i]) - 1 do
        begin
          if (FSudokuCore[i][j] <> 0) then
            cMap[i][j] := 1
          else if (not CheckSmallSquare(FSudokuCore, i, j, numrow[n])) or
            (not CheckLines(FSudokuCore, i, j, row, col, numrow[n])) then
            cMap[i][j] := 2
          else
            cMap[i][j] := 0;
        end;

      busysum := 0;
      prohibitsum := 0;
      for i := 0 to Length(cMap) - 1 do
        for j := 0 to Length(cMap[i]) - 1 do
        begin
          if cMap[i][j] = 1 then Inc(busysum);
          if cMap[i][j] = 2 then Inc(prohibitsum);
        end;
      //проверим - если все ячейки заняты, можно заканчивать
      if busysum = 81 then exit;
      //проверим - если все ячейки запрещены - надо переходить к следующему числу
      if (prohibitsum = 81) or ((prohibitsum + busysum) = 81) then break;

      //теперь проставим текущее число в одну из свободных ячеек (куда именно определяется случайно)
      Randomize;
      repeat
        i := Random(SUDOKUSIZELIMIT);
        j := Random(SUDOKUSIZELIMIT);
      until (cMap[i][j] = 0);
      FSudokuCore[i][j] := numrow[n];
      result := true;
      Inc(x);
    end;
  end;
end;

procedure TSudoku.ReloadMatrix;
var
  refresh: boolean;

begin
  if FBehaviour = bhSynchro then exit;
  if Length(bMap) <= 0 then refresh := false
  else refresh := true;

  while FLoading do ;
  FLoading := true;
  try
    SetLength(FSudokuMatrix, 0);
  finally
    FLoading := false;
  end;
  GenerateMatrix(false, refresh);
end;

procedure TSudoku.FillRandom;
var
  _changed: boolean;
  currCell: TPoint;
  ARow, ACol: integer;
  cellVar: integer;
  CurrStep: integer;
  r: integer;
  
begin
  //точка входа для генерации последовательности судоку (основной управляющий алгоритм)
  _changed := true;
  currCell.X := -1;
  currCell.Y := -1;
  CurrStep := 0;
  while (CurrStep < CYCLESTEPLIMIT) and _changed do
  begin
    Inc(CurrStep);
    _changed := false;
    if PrepareFill then _changed := true;
    currCell := FindNextEmpty(currCell);
    while (currCell.X <> -1) and (currCell.Y <> -1) do
    begin
      if IsCorrect(ARow, ACol, true) then exit;
      cellVar := 0;
      while cellVar > -1 do
      begin
        cellVar := GetNextCellVariant(cellVar, currCell);
        if cellVar = -1 then break;
        if FSudokuCore[currCell.X][currCell.Y] <> 0 then break;
        //проверяем ряд
        if CheckAndMove(currCell, currCell, cellVar, mdLeft, false, false, r) then _changed := true;
        if PrepareFill then _changed := true;
        if FSudokuCore[currCell.X][currCell.Y] <> 0 then break;
        //проверяем столбец
        if CheckAndMove(currCell, currCell, cellVar, mdUp, false, false, r) then _changed := true;
        if PrepareFill then _changed := true;
        if FSudokuCore[currCell.X][currCell.Y] <> 0 then break;
        //если опять нет - запускаем рекурсивный поиск и перестановки, ряд
        if CheckAndMove(currCell, currCell, cellVar, mdLeft, true, true, r) then _changed := true;
        if PrepareFill then _changed := true;
        if FSudokuCore[currCell.X][currCell.Y] <> 0 then break;
        //если опять нет - запускаем рекурсивный поиск и перестановки, столбец
        if CheckAndMove(currCell, currCell, cellVar, mdUp, true, true, r) then _changed := true;
        if PrepareFill then _changed := true;
      end;
      if PrepareFill then _changed := true;
      currCell := FindNextEmpty(currCell);
    end;
  end;
end;

{ КОНЕЦ БЛОКА МЕТОДОВ ГЕНЕРАЦИИ СУДОКУ }

function TSudoku.GetFileName: string;
begin
  result := ExtractFileName(FCoreFile);
end;

procedure TSudoku.GenCoreFromText(TxtFile: string);
var
  f: TextFile;
  l, s: string;
  i, j, n: integer;

begin
  while FLoading do ;
  try
    AssignFile(f, TxtFile);
    Reset(f);
    while not Eof(f) do
    begin
      Readln(f, l);
      s := s + TrimEx(l, [#10, #13, #9, #32], [], true);
    end;

    n := 1;
    GenNewCore(false);
    FLoading := true;
    for i := 0 to Length(FSudokuCore) - 1 do
      for j := 0 to Length(FSudokuCore[i]) - 1 do
      try
        FSudokuCore[i][j] := StrToInt(s[n]);
        Inc(n);
      except
        on e: Exception do raise Exception.Create(Format(MSG_TXT_WRONG, [TxtFile]) + #13#10 + e.Message);
      end;
  finally
    CloseFile(f);
    FLoading := false;
  end;
end;

procedure TSudoku.GenerateMatrix(AEmpty: boolean; ARefrsh: boolean);
var
  i, j, n: integer;
  d: integer;

begin
  while FLoading do ;
  FLoading := true;
  d := 2;
  try
    if (FBehaviour = bhAsynchro) and (not AEmpty) and (not ARefrsh) then
    begin
      case Difficulty of
        dfVeryEasy: d := DIF_VERYEASY;
        dfEasy: d := DIF_EASY;
        dfNormal: d := DIF_NORMAL;
        dfHard: d := DIF_HARD;
        dfVeryHard: d := DIF_VERYHARD;
      end;
      d := d - Random(d - (d - 6));
      Randomize;
      SetLength(bMap, SUDOKUSIZELIMIT);
      for i := 0 to Length(FSudokuCore) - 1 do SetLength(bMap[i], SUDOKUSIZELIMIT);
      for n := 0 to d - 1 do
      begin
        i := Random(SUDOKUSIZELIMIT);
        j := Random(SUDOKUSIZELIMIT);
        while bMap[i][j] <> 0 do
        begin
          i := Random(SUDOKUSIZELIMIT);
          j := Random(SUDOKUSIZELIMIT);
        end;
        bMap[i][j] := 1;
      end;
    end;

    SetLength(FSudokuMatrix, Length(FSudokuCore));
    for i := 0 to Length(FSudokuCore) - 1 do
    begin
      SetLength(FSudokuMatrix[i], Length(FSudokuCore[i]));
      for j := 0 to Length(FSudokuCore[i]) - 1 do
        case FBehaviour of
          bhSynchro: FSudokuMatrix[i][j] := FSudokuCore[i][j];
          bhAsynchro:
          begin
            if (not AEmpty) and (bMap[i][j] = 1) then FSudokuMatrix[i][j] := FSudokuCore[i][j]
            else FSudokuMatrix[i][j] := 0;
          end;
        end;
    end;
  finally
    FLoading := false;
  end;
end;

procedure TSudoku.GenerateRandom(AOverwrite: boolean);
var
  i, j: integer;

begin
  if FBehaviour = bhAsynchro then exit;
  FLoading := true;
  try
    if AOverwrite then
    begin
      for i := 0 to Length(FSudokuCore) - 1 do
        for j := 0 to Length(FSudokuCore[i]) - 1 do
          FSudokuCore[i][j] := 0;
    end;
    FillRandom;
  finally
    SetLength(bMap, 0);
    FLoading := false;
  end;
  ClearMatrix(true);
  GenerateMatrix;
end;

procedure TSudoku.GenNewCore(Rand: boolean);
var
  i, j: integer;

begin
  while FLoading do ;
  FLoading := true;
  Randomize;
  try
    SetLength(FSudokuCore, SUDOKUSIZELIMIT);
    for i := 0 to SUDOKUSIZELIMIT - 1 do
    begin
      SetLength(FSudokuCore[i], SUDOKUSIZELIMIT);
      for j := 0 to SUDOKUSIZELIMIT - 1 do
        FSudokuCore[i][j] := 0;
    end;

    if Rand then FillRandom;
  finally
    FLoading := false;
  end;
end;

function TSudoku.GetBlockingMap: TSudokuCore;
begin
  result := bMap;
end;

function TSudoku.GetDifficulty: TDifficulty;
begin
  result := FDifficulty;
end;

function TSudoku.GetItemState(i, j: byte): byte;
begin
  if (i >= Length(FSudokuMatrix)) or (j >= Length(FSudokuMatrix[i])) then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));
  result := FSudokuMatrix[i][j];
end;

function TSudoku.GetItemText(i, j: byte): string;
begin
  result := IntToStr(ItemState[i, j]);
end;

function TSudoku.GetItemType(i, j: byte): byte;
begin
  result := 0;
  if FBehaviour = bhAsynchro then
    if (i < Length(bMap)) and (j < Length(bMap[i])) then result := bMap[i][j];
end;

function TSudoku.GetName: string;
begin
  result := FName;
end;

function TSudoku.GetPromptLeft: integer;
begin
  if Assigned(FPrompt) then result := FPrompt.Left
  else result := -1;
end;

function TSudoku.GetPromptTop: integer;
begin
  if Assigned(FPrompt) then result := FPrompt.Top
  else result := -1;
end;

function TSudoku.IsCorrect(var ARow, ACol: integer; CheckCore: boolean): boolean;
var
  i, j: integer;
  m: TSudokuCore;

begin
  result := false;
  ARow := -1;
  ACol := -1;
  if (FBehaviour = bhSynchro) and (not CheckCore) then exit;
  if not IsSolve(ARow, ACol, CheckCore) then exit;
  if FLoading then exit;
  if CheckCore then m := FSudokuCore
  else m := FSudokuMatrix;
  for i := 0 to Length(m) - 1 do
    for j := 0 to Length(m[i]) - 1 do
      if not CheckValue(m, i, j) then
      begin
        ARow := i;
        ACol := j;
        exit;
      end;
  result := true;
end;

function TSudoku.IsEmpty: boolean;
begin
  result := (Length(FSudokuMatrix) <= 0) or (Length(FSudokuCore) <= 0);
end;

function TSudoku.IsSolve(var ARow, ACol: integer; CheckCore: boolean): boolean;
var
  i, j: integer;
  m: TSudokuCore;

begin
  result := false;
  ARow := -1;
  ACol := -1;
  if FLoading then exit;
  if CheckCore then m := FSudokuCore
  else m := FSudokuMatrix;
  if (Length(m) = 0) or (Length(m[0]) = 0) then exit;
  for i := 0 to Length(m) - 1 do
    for j := 0 to Length(m[i]) - 1 do
      if m[i][j] = 0 then
      begin
        ARow := i;
        ACol := j;
        exit;
      end;
  result := true;
end;

procedure TSudoku.LoadCore(corefile: string);
var
  i, j: integer;
  f: TFileStream;
  head: TCoreFileHeader;
  c: char;
  
begin
  while FLoading do ;
  FLoading := true;
  SetLength(FSudokuCore, 0);
  
  try
    if not FileExists(corefile) then raise Exception.Create(Format(MSG_COREFILE_NOT_EXIEST, [corefile]));
    if LowerCase(CutFileExt(corefile)) <> GetExt(cgSudoku) then raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [corefile]));
    FCoreFile := corefile;

    try
      f := TFileStream.Create(FCoreFile, fmOpenRead);
      //читаем заголовок
      f.Read(head, SizeOf(head));
      if (head._type <> Ord(cgSudoku)) or (head.Height <= 0) or (head.Width <= 0) then
        raise Exception.Create(Format(MSG_COREFILE_NOT_VALID, [FCoreFile]));

      if (head.Height > SUDOKUSIZELIMIT) or (head.Width > SUDOKUSIZELIMIT) then
        raise Exception.Create(Format(MSG_MATRIX_TOOBIG, [IntToStr(SUDOKUSIZELIMIT), IntToStr(SUDOKUSIZELIMIT)]));

      Difficulty := TDifficulty(head.diff);

      // название
      FName := '';
      for i := 1 to head.sz_name do
      begin
        f.Read(c, 1);
        FName := FName + c;
      end;

      //читаем тело
      SetLength(FSudokuCore, head.Height);
      for i := 0 to head.Height - 1 do
      begin
        SetLength(FSudokuCore[i], head.Width);
        for j := 0 to head.Width - 1 do f.Read(FSudokuCore[i][j], SizeOf(byte));
      end;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_READ_ERROR, [FCoreFile]) + ':'#13#10 + e.Message);
    end;
  finally
    FLoading := false;
    if Assigned(f) then f.Free;
    if not IsCorrect(i, j, true) then
      raise Exception.Create('Судоку содержит ошибку (стр. ' + IntToStr(i + 1) + ', кол. ' + IntToStr(j + 1) + ')! Проверьте его повнимательнее!');
  end;
end;

procedure TSudoku.LoadPreview;
var
  i, j: integer;

begin
  if not Assigned(FPrompt) then exit;
  if (not Assigned(FSudokuCore)) or (Length(FSudokuCore) = 0) or (Length(FSudokuCore[0]) = 0) then
  begin
    FPrompt.pPreviewArea.Caption := '<нет>';
    FPrompt.Caption := '<нет>';
    FPrompt.sgPreview.Visible := false;
    exit;
  end else
  begin
    FPrompt.Caption := Name;
    FPrompt.pPreviewArea.Caption := '';
    for i := 0 to Length(FSudokuCore) - 1 do
      for j := 0 to Length(FSudokuCore[i]) - 1 do
        FPrompt.sgPreview.Cells[j, i] := IntToStr(FSudokuCore[i][j]);
    FPrompt.sgPreview.Visible := true;
  end;
end;

function TSudoku.SaveCore(AFile: string): boolean;
var
  f: TFileStream;
  i, j: integer;
  head: TCoreFileHeader;
  Mode: Word;

begin
  result := false;
  if not IsCorrect(i, j, true) then
    raise Exception.Create('Судоку содержит ошибку (стр. ' + IntToStr(i + 1) + ', кол. ' + IntToStr(j + 1) + ')! Проверьте его повнимательнее!');

  FCoreFile := AFile;
  head._type := Ord(cgSudoku);
  head.diff := Ord(Difficulty);
  head.Height := Length(FSudokuCore);
  head.Width := Length(FSudokuCore[0]);
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
          f.Write(FSudokuCore[i][j], SizeOf(byte));

      result := true;
    except
      on e: Exception do raise Exception.Create(Format(MSG_FILE_WRITE_ERROR, [FCoreFile]) + ':'#13#10 + e.Message);
    end;
  finally
    if Assigned(f) then f.Free;
  end;
end;

procedure TSudoku.SetBlockingMap(value: TSudokuCore);
{var
  i, j: integer;
 }
begin
  if FBehaviour = bhSynchro then exit;
  while FLoading do ;
  FLoading := true;
  try
    if Length(value) <= 0 then raise Exception.Create('Не удалось загрузить таблицу блокировок!');
    bMap := value;
      {SetLength(bMap, Length(value));
      for i := 0 to Length(value) - 1 do
      begin
        SetLength(bMap[i], Length(value[i]));
        for j := 0 to Length(value[i]) - 1 do bMap[i][j] := value[i][j];
      end;}
  finally
    FLoading := false;
  end;
end;

procedure TSudoku.SetDifficulty(value: TDifficulty);
begin
  FDifficulty := value;
end;

procedure TSudoku.SetItemState(i, j, value: byte);
begin
  if (i >= Length(FSudokuMatrix)) or (j >= Length(FSudokuMatrix[i])) then raise Exception.Create(Format(MSG_ITEM_NOT_EXIST, [i, j]));

  if value > 9 then value := FSudokuMatrix[i][j];
  if ItemType[i, j] = 0 then
  begin
    FSudokuMatrix[i][j] := value;
    if FBehaviour = bhSynchro then FSudokuCore[i][j] := value;
  end;
end;

procedure TSudoku.SetName(value: string);
begin
  FName := value;
end;

procedure TSudoku.SetPromptLeft(value: integer);
begin
  if Assigned(FPrompt) then FPrompt.Left := value;
end;

procedure TSudoku.SetPromptTop(value: integer);
begin
  if Assigned(FPrompt) then FPrompt.Top := value;
end;

procedure TSudoku.ShowPreview;
begin
  if Assigned(FPrompt) then
  begin
    LoadPreview;
    if FPrompt.Visible then FPrompt.Hide
    else FPrompt.Show;
  end;
end;

end.
