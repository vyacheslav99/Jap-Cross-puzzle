unit jsCommon;

interface

uses
  Windows, Forms, SysUtils, Variants, Math, ShlObj, ActiveX, ComObj, Classes, ComCtrls, Registry, Controls, Graphics, ShellAPI, DB;

const
  CYCLESTEPLIMIT = 100;
  RECURSIONLIMIT = 20;
  PUZZLESIZELIMIT = 99;
  SUDOKUSIZELIMIT = 9;
  UNDOLIMIT = PUZZLESIZELIMIT * PUZZLESIZELIMIT;
  EJCROSSPUZZLE = 'JCrossPuzzle';
  ECCROSSPUZZLE = 'CCrossPuzzle';
  ESUDOKU = 'Sudoku';
  RJCROSSPUZZLE = '�������� ���������';
  RCCROSSPUZZLE = '������� �������� ���������';
  RSUDOKU = '������';
  JPZFILEEXT = 'jpz';
  JPZSAVEEXT = 'jsg';
  SUDOKUFILEEXT = 'spz';
  SUDOKUSAVEEXT = 'ssg';
  CPZFILEEXT = 'cpz';
  CPZSAVEEXT = 'csg';
  DEFAULT_CROSS_FILE = 'cross';
  DEFAULT_SUDOKU_FILE = 'sudoku';

  //���������
  MSG_ITEM_NOT_EXIST = '�� ���������� �������� � ������������: ������ %i, ������� %i!';
  MSG_ITEM_NOT_EXIST2 = '������� �� ������!';
  MSG_MATRIX_EMPTY = '������� ���������� ������!';
  MSG_RANGE_OUTFLOW = '���������� [������ %i, ������� %i] ������� �� ������� ������� ����������!';
  MSG_X_OUTFLOW = '���������� ������ (%i) ��������� ���-�� ����� ���������� (%i)!';
  MSG_Y_OUTFLOW = '���������� ������� (%i) ��������� ���-�� �������� ���������� (%i)!';
  MSG_COREFILE_NOT_EXIEST = '���� "%s" �� ����������!';
  MSG_COREFILE_NOT_VALID = '�������� ������ ����� "%s"!';
  MSG_FILE_WRITE_ERROR = '������ ������ � ���� "%s"!';
  MSG_FILE_READ_ERROR = '������ ������ ����� "%s"!';
  MSG_MATRIX_TOOBIG = '������� ������� ������ ������� ����������! ������ ������� �� ������ ��������� %s�%s ����� (����� �����������).';
  MSG_TXT_WRONG = '�������� ������ ��������������� ����� "%s"!';
  MSG_INVALID_VALUE = '�������� �������� �������� ("%s")!';

  {������ ��������� - ����� 5 (����� ����� 81 (9�9)):
    0 (����� ������) - ������� ~50% ����� (40-45)
    1 (������) - ������� ~40% ����� (35-40)
    2 (����������) - ������� ~30% ����� (30-35)
    3 (�������) - ������� ~20% ����� (25-30)
    4 (������������) - ������� ~10% ����� (20-25) }

  DIF_VERYEASY = 45;
  DIF_EASY = 40;
  DIF_NORMAL = 35;
  DIF_HARD = 30;
  DIF_VERYHARD = 25;
  DIFR_VERYEASY = '����� ������';
  DIFR_EASY = '������';
  DIFR_NORMAL = '����������';
  DIFR_HARD = '�������';
  DIFR_VERYHARD = '������������';
  DIFE_VERYEASY = 'VERYEASY';
  DIFE_EASY = 'EASY';
  DIFE_NORMAL = 'NORMAL';
  DIFE_HARD = 'HARD';
  DIFE_VERYHARD = 'VERYHARD';

  ASCII_SCALE {: array [0..96] of char} = ' `''.,-_~^":;!|/\(){}?<>[]1072534698@=+*%ijlftrcouvybdgpqhnzxkaes&mwIJLTCGDOQUVZFPYAES$KXRNHBMW#';
  
type
  //���������, ������������ � ������ �������, �� ������� ���� �����
  TProgressFunc = procedure(init, newpos: integer; msg: string; show: boolean) of object;
  TSetStatusFunc = procedure(str: string; index: integer) of object;
  TGetStatusFunc = function(index: integer): string of object;
  TResetFunc = procedure of object;
  TOnCellClick = procedure(Sender: TObject; Rect: TRect; ARow, ACol: integer) of object;

  //������������ ����
  TCurrGame = (cgNone, cgJCrossPuzzle, cgSudoku, cgCCrossPuzzle);
  TGameState = (gsNone, gsGame, gsWin, gsEdit);
  TGameAction = (gaNew, gaCurrent, gaOther, gaRandom, gaImport, gaImport2, gaImport3, gaReload, gaSolve);
  TMoveDirection = (mdUp, mdDown, mdLeft, mdRight);
  TBehaviour = (bhSynchro, bhAsynchro);
  TRulerArea = (raNone, raBoth, raGame, raEditor);
  TRulerStyle = (rsLines, rsStroke, rsDot, rsInversDot);
  TpzItemType = (pztNone, pztService, pztCaption, pztCell);
  TImgAnalisatorType = (iaLightness, iaSaturation, iaRed, iaGreen, iaBlue, iaMono);
  TCellStyle = (csNone, csRaised, csBigRaised, csLowered, csDeepLowered, csLFrame, csRFrame);
  TLang = (lRU, lENG);
  TDifficulty = (dfVeryEasy, dfEasy, dfNormal, dfHard, dfVeryHard);
  TReplaceTarget = (rdBoth, rdFrom, rdTo);

  //�������
  TSudokuCore = array of array of byte;
  TNumericArray = array of integer;
  TPChar = array [0..31] of char;
  TLongPChar = array [0..255] of char;
  TFieldsList = array [0..8] of TPChar;

  TUndoItem = record
    p: TPoint;
    val: integer;
  end;
  TUndoData = array of TUndoItem;

  TCoreFileHeader = record
    _type: byte;            // Ord(TCurrGame) = 1 - �/� ���������, 2 - ������, 3 - ��. ���������
    diff: byte;             // ������� ��������� ������� (� ������ �� ������������)    
    Height: integer;        // ������ (���-�� �����)
    Width: integer;         // ������ (���-�� ��������� - ���-�� ����� � ������)
    bgColor: integer;       // ���� �������� ����� � ��. ������. (� ��������� �� ������������)
    sz_name: integer;       // ����� ������ � ������ ���������� (����. �� ���������� ����)
  end;

  TSaveFileHeader = record
    _type: byte;            // Ord(TCurrGame) = 1 - �/� ���������, 2 - ������, 3 - ��. ���������
    Difficulty: byte;       // ������� ��������� ����
    GTime: double;          // ����� ���� (TTime = double)
    sz_name: integer;       // ����� ������ � ������ ���������� (����. �� ���������� ����)
    sz_user: integer;       // ����� ������ � ������ ������ (����. �� ������ ���������� ����)
    sz_base: integer;       // ����� ��������� ����� (�������, ����� = x*y)
    sz_extra: integer;      // ����� ���. ����� (�������, ����� = x*y) - � ������ ��� ������ ����������, � ��������� ����� ����� ���
    b_top: integer;         // ���-�� ����� � ������� ���. ����
    b_left: integer;        // ���-�� �������� � ����� ���. ����
  end;

  TStatHeader = record
    cols: byte;             // ���-�� �������� (���-�� ��-��� � ������� fields = 8)
    rows: integer;          // ���-�� ������� (���-�� ������ TStatBlock)
    fields: TFieldsList;    // ������ (�������� � �������) �������� - ������ ��� ��������
  end;

  TStatBlock = record
    game: TCurrGame;        // ��� ����
    diff: TDifficulty;      // ���������
    szW: byte;              // ������ ���� (���-�� ���������)
    szH: byte;              // ������ ���� (���-�� �����)
    user: TLongPChar;       // �����
    name: TLongPChar;       // �������� �������
    time: TTime;            // ����� ����
    last: byte;             // ����, ��� ��� ������ �����������/����������� ���������: 0 - ���, 1 - ��
    score: integer;         // ����
  end;

  PStatArray = ^TStatArray;
  TStatArray = array of TStatBlock;

function DifficultyAsText(Diff: TDifficulty; lang: TLang): string;
function DifficultyFromText(DiffName: string; lang: TLang): TDifficulty;
function GetFontSize(x: integer): integer;
function GetExt(cg: TCurrGame; SaveFile: boolean = false): string;
function GetVersion: string;
function GetGameName(cg: TCurrGame; lang: TLang): string;
function TranslateGameName(gName: string): string;
function TranslateDifficulty(DiffName: string): string;
function CutFileExt(var filename: string; blockname: boolean = true): string;
function GenRandString(genrule, vlength: byte): string;
function iif(expr: boolean; iftrue: variant; iffalse: variant): variant;
function WordCountEx(s: string; WordDelims: TSysCharSet; IgnoreBlockChars: TSysCharSet): integer;
function ExtractWordEx(n: integer; s: string; WordDelims: TSysCharSet; IgnoreBlockChars: TSysCharSet): string;
function ReplaceEx(s: string; FindChars: TSysCharSet; ReplaceStr: string; IgnoreBlockChars: TSysCharSet): string;
function TrimEx(s: string; CanDelSymbs: TSysCharSet; IgnoreBlockChars: TSysCharSet; Inside: boolean = false): string;
procedure CreateLink(PathObj, PathLink, Desc, param: string);
function ConvertTPCharToStr(pc: TPChar): string; overload;
function ConvertTPCharToStr(pc: TLongPChar): string; overload;
procedure ConvertStrToTPChar(str: string; var pch: TPChar); overload;
procedure ConvertStrToTPChar(str: string; var pch: TLongPChar); overload;
function LoadStat(ds: TDataSet; FileName: string; GameType: TCurrGame; AReset: boolean): boolean;
function SaveStat(ds: TDataSet; FileName: string): boolean;
procedure SortStatData(var sd: TStatArray);
procedure CopyBlock(sb: TStatBlock; var db: TStatBlock);
function SecondsToTime(seconds: integer): TTime;
function TimeToSeconds(ATime: TTime): integer;
function GetASCIIWeight(Symb: char): byte;

implementation

function DifficultyAsText(Diff: TDifficulty; lang: TLang): string;
begin
  case lang of
    lRU:
    case Diff of
      dfVeryEasy: result := DIFR_VERYEASY;
      dfEasy: result := DIFR_EASY;
      dfNormal: result := DIFR_NORMAL;
      dfHard: result := DIFR_HARD;
      dfVeryHard: result := DIFR_VERYHARD;
    end;
    lENG:
    case Diff of
      dfVeryEasy: result := DIFE_VERYEASY;
      dfEasy: result := DIFE_EASY;
      dfNormal: result := DIFE_NORMAL;
      dfHard: result := DIFE_HARD;
      dfVeryHard: result := DIFE_VERYHARD;
    end;
  end;
end;

function DifficultyFromText(DiffName: string; lang: TLang): TDifficulty;
begin
  case lang of
    lRU:
      if DiffName = DIFR_VERYEASY then result := dfVeryEasy
      else if DiffName = DIFR_EASY then result := dfEasy
      else if DiffName = DIFR_NORMAL then result := dfNormal
      else if DiffName = DIFR_HARD then result := dfHard
      else if DiffName = DIFR_VERYHARD then result := dfVeryHard;
    lENG:
      if DiffName = DIFE_VERYEASY then result := dfVeryEasy
      else if DiffName = DIFE_EASY then result := dfEasy
      else if DiffName = DIFE_NORMAL then result := dfNormal
      else if DiffName = DIFE_HARD then result := dfHard
      else if DiffName = DIFE_VERYHARD then result := dfVeryHard;
  end;
end;

function GetFontSize(x: integer): integer;
begin
  if x < 0 then
  begin
    result := 1;
    exit;
  end;
  case x of
    0..5: result := 2;
    6..8: result := 4;
    9..11: result := 6;
    12..13: result := 7;
    14..20: result := 8;
    21..25: result := 12;
    26..30: result := 16;
    31..35: result := 20;
    36..40: result := 26;
    41..45: result := 30;
    46..50: result := 36;
    51..55: result := 40;
    56..60: result := 46;
    else result := 50;
  end;
end;

function GetExt(cg: TCurrGame; SaveFile: boolean): string;
begin
  if SaveFile then
    case cg of
      cgNone: result := '';
      cgJCrossPuzzle: result := JPZSAVEEXT;
      cgSudoku: result := SUDOKUSAVEEXT;
      cgCCrossPuzzle: result := CPZSAVEEXT;
    end
  else
    case cg of
      cgNone: result := '';
      cgJCrossPuzzle: result := JPZFILEEXT;
      cgSudoku: result := SUDOKUFILEEXT;
      cgCCrossPuzzle: result := CPZFILEEXT;
    end;
end;

function GetVersion: string;
var
  fname: string;
  Info: Pointer;
  InfoSize: DWORD;
  FileInfo: PVSFixedFileInfo;
  FileInfoSize: DWORD;
  Tmp: DWORD;
  Major1, Major2, Minor1, Minor2: Integer;

begin
  fname := Application.ExeName;
  Major1 := 0;
  Major2 := 0;
  Minor1 := 0;
  Minor2 := 0;

  InfoSize := GetFileVersionInfoSize(PChar(fname), Tmp);

  if InfoSize = 0 then result := ''
  else begin
    GetMem(Info, InfoSize);
    try
      GetFileVersionInfo(PChar(fname), 0, InfoSize, Info);
      VerQueryValue(Info, '\', Pointer(FileInfo), FileInfoSize);
      Major1 := FileInfo.dwFileVersionMS shr 16;
      Major2 := FileInfo.dwFileVersionMS and $FFFF;
      Minor1 := FileInfo.dwFileVersionLS shr 16;
      Minor2 := FileInfo.dwFileVersionLS and $FFFF;
    finally
      FreeMem(Info, FileInfoSize);
    end;
  end;

  result := IntToStr(Major1) + '.' + IntToStr(Major2) + '.' + IntToStr(Minor1) + '.' + IntToStr(Minor2);
end;

function GetGameName(cg: TCurrGame; lang: TLang): string;
begin
  case lang of
    lRU:
    case cg of
      cgNone: result := '';
      cgJCrossPuzzle: result := RJCROSSPUZZLE;
      cgSudoku: result := RSUDOKU;
      cgCCrossPuzzle: result := RCCROSSPUZZLE;
    end;
    lENG:
    case cg of
      cgNone: result := '';
      cgJCrossPuzzle: result := EJCROSSPUZZLE;
      cgSudoku: result := ESUDOKU;
      cgCCrossPuzzle: result := ECCROSSPUZZLE;
    end;
  end;
end;

function TranslateGameName(gName: string): string;
begin
  if gName = RJCROSSPUZZLE then result := EJCROSSPUZZLE
  else if gName = EJCROSSPUZZLE then Result := RJCROSSPUZZLE
  else if gName = RSUDOKU then result := ESUDOKU
  else if gName = ESUDOKU then Result := RSUDOKU
  else if gName = RCCROSSPUZZLE then result := ECCROSSPUZZLE
  else if gName = ECCROSSPUZZLE then result := RCCROSSPUZZLE;
end;

function TranslateDifficulty(DiffName: string): string;
begin
  if DiffName = DIFR_VERYEASY then result := DIFE_VERYEASY
  else if DiffName = DIFE_VERYEASY then Result := DIFR_VERYEASY
  else if DiffName = DIFR_EASY then result := DIFE_EASY
  else if DiffName = DIFE_EASY then Result := DIFR_EASY
  else if DiffName = DIFR_NORMAL then result := DIFE_NORMAL
  else if DiffName = DIFE_NORMAL then Result := DIFR_NORMAL
  else if DiffName = DIFR_HARD then result := DIFE_HARD
  else if DiffName = DIFE_HARD then Result := DIFR_HARD
  else if DiffName = DIFR_VERYHARD then result := DIFE_VERYHARD
  else if DiffName = DIFE_VERYHARD then Result := DIFR_VERYHARD;
end;

function CutFileExt(var filename: string; blockname: boolean = true): string;
var
  i: integer;

begin
  result := '';
  if filename = '' then exit;

  for i := Length(filename) downto 0 do
    if filename[i] = '.' then break;

  if i > 0 then
  begin
    result := Copy(filename, i + 1, Length(filename) - i + 1);
    if not blockname then
      Delete(filename, i, Length(filename) - i + 1);
  end;
end;

function GenRandString(genrule, vlength: byte): string;
var
  i: integer;
  c: byte;
  symbs: set of byte;

begin
  result := '';
  symbs := [];
  if genrule > 6 then genrule := 6;

  case genrule of
    0: symbs := symbs + [48..57];                           //����� 0..9
    1: symbs := symbs + [65..90, 97..122];                  //����� A..Z, a..z
    2: symbs := symbs + [65..90];                           //����� A..Z
    3: symbs := symbs + [97..122];                          //����� a..z
    4: symbs := symbs + [48..57, 65..90];                   //����� + ����� A..Z
    5: symbs := symbs + [48..57, 97..122];                  //����� + ����� a..z
    6: symbs := symbs + [48..57, 65..90, 97..122];          //����� + ����� A..Z, a..z
  end;
  if symbs = [] then exit;

  Randomize;
  for i := 1 to vlength do
  begin
    c := Random(123);
    while not (c in symbs) do c := Random(123);
    result := result + chr(c);
  end;
end;

function iif(expr: boolean; iftrue: variant; iffalse: variant): variant;
begin
  if expr then result := iftrue
  else result := iffalse;
end;

function WordCountEx(s: string; WordDelims: TSysCharSet; IgnoreBlockChars: TSysCharSet): integer;
var
  CurrBlChar: char;
  iblock: boolean;
  i: integer;

begin
  //������� ���������� �������� � ������ s, ���������� ��������� WordDelims.
  //��� ������ ������������ ���������� ����� ������, ���������� ������� ��������� ������ IgnoreBlockChars,
  //�������� ���������. ���� ���� ������� � ������ �� �������� ������������� ������, �� ����� ����� ���������
  //���, ��� ���������� ����� �� ������, �.�. ������ ����� ��������� �� ������������ �������� �� �����������.
  //��������, ���� �������, ���������� ������������ ����� - " � ', � ������� ���� � ", � �� ��� ���������� ������ ',
  //�� ���� �� ��������� �����������, � �����������, ���� �� ���������� ������ ".
  //����� ���� ����� ���������� � ������ �� ���� �������.

  if (s = '') then result := 0
  else result := 1;
  iblock := false;
  CurrBlChar := #0;

  for i := 1 to Length(s) do
  begin
    if (iblock) then
    begin
      if (s[i] = CurrBlChar) then
      begin
        iblock := false;
        CurrBlChar := #0;
      end;
      continue;
    end;
    if (s[i] in IgnoreBlockChars) then
    begin
      iblock := true;
      CurrBlChar := s[i];
      continue;
    end;
    if ((s[i] in WordDelims) and (i < Length(s))) then Inc(result);
  end;
end;

function ExtractWordEx(n: integer; s: string; WordDelims: TSysCharSet; IgnoreBlockChars: TSysCharSet): string;
var
  CurrBlChar: char;
  iblock: boolean;
  i: integer;
  wn: integer;

begin
  //���������� n-�� ��������� ������ s, ���������� ��������� WordDelims.
  //��� ������ ������������ ���������� ����� ������, ���������� ������� ��������� ������ IgnoreBlockChars.

  result := '';
  iblock := false;
  CurrBlChar := #0;
  wn := 1;

  for i := 1 to Length(s) do
  begin
    if (iblock) then
    begin
      if (s[i] = CurrBlChar) then
      begin
        iblock := false;
        CurrBlChar := #0;
      end;
      if (wn = n) then result := result + s[i];
      continue;
    end;
    if (s[i] in IgnoreBlockChars) then
    begin
      iblock := true;
      CurrBlChar := s[i];
      if (wn = n) then result := result + s[i];
      continue;
    end;
    if (s[i] in WordDelims) then
    begin
      Inc(wn);
      if (wn > n) then exit;
    end else
      if (wn = n) then result := result + s[i];
  end;
end;

function ReplaceEx(s: string; FindChars: TSysCharSet; ReplaceStr: string; IgnoreBlockChars: TSysCharSet): string;
var
  CurrBlChar: char;
  iblock: boolean;
  i: integer;

begin
  //�������� ��� ������� ������ FindChars, ������� ReplaceStr.
  //��� ������ �������� ���������� ����� ������, ���������� ������� ��������� IgnoreBlockChars.

  result := '';
  iblock := false;
  CurrBlChar := #0;

  for i := 1 to Length(s) do
  begin
    if (iblock) then
    begin
      if (s[i] = CurrBlChar) then
      begin
        iblock := false;
        CurrBlChar := #0;
      end;
    end else
      if (s[i] in IgnoreBlockChars) then
      begin
        iblock := true;
        CurrBlChar := s[i];
      end;
    if iblock then
      result := result + s[i]
    else
      if (s[i] in FindChars) then
        result := result + ReplaceStr
      else
        result := result + s[i];
  end;
end;

function TrimEx(s: string; CanDelSymbs: TSysCharSet; IgnoreBlockChars: TSysCharSet; Inside: boolean = false): string;
var
  CurrBlChar: char;
  iblock: boolean;
  i: integer;

begin
  //������� � ������ � ����� ������ s ��� ������� ������ CanDelSymbs. ���� Inside = true, ������� ��� ��
  //��� ��� ������� �� ���� ������. ��� ��������� ������ ���������� ����� ������, ���������� �������
  //��������� ������ IgnoreBlockChars, �������� ���������.
  //���� ���� �� ��������, ������� ���� ������� (CanDelSymbs) � ������ ������������ (IgnoreBlockChars), �� ����
  //������ ������ �� �����

  result := s;
  if (s = '') then exit;
  
  if (not Inside) then
  begin
    while (result[1] in CanDelSymbs) do Delete(result, 1, 1);
    while (result[Length(result)] in CanDelSymbs) do Delete(result, Length(result), 1);
    exit;
  end;

  CurrBlChar := #0;
  iblock := false;
  i := 1;

  while true do
  begin
    if (iblock) then
    begin
      if (result[i] = CurrBlChar) then
      begin
        iblock := false;
        CurrBlChar := #0;
      end;
      Inc(i);
      continue;
    end;
    if (result[i] in IgnoreBlockChars) then
    begin
      iblock := true;
      CurrBlChar := result[i];
      Inc(i);
      continue;
    end;
    if (result[i] in CanDelSymbs) then
      Delete(result, i, 1)
    else
      Inc(i);
    if (i > Length(result)) then break;
  end;
end;

procedure CreateLink(PathObj, PathLink, Desc, param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
  lFileName: WideString;

begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(pchar(param));
    SetDescription(pchar(Desc));
    SetPath(pchar(PathObj));
    SetWorkingDirectory(pchar(ExtractFilePath(PathObj)));
  end;
  lFileName := PathLink + '\' + Desc + '.lnk';
  PFile.Save(pwChar(lFileName), false);
end;

function ConvertTPCharToStr(pc: TPChar): string;
var
  i: integer;

begin
  result := '';
  for i := 0 to Length(pc) - 1 do
  begin
    if pc[i] = #0 then break;
    result := result + pc[i];
  end;
end;

function ConvertTPCharToStr(pc: TLongPChar): string;
var
  i: integer;

begin
  result := '';
  for i := 0 to Length(pc) - 1 do
  begin
    if pc[i] = #0 then break;
    result := result + pc[i];
  end;
end;

procedure ConvertStrToTPChar(str: string; var pch: TPChar);
var
  i: integer;

begin
  for i := 1 to Length(str) do
  begin
    if i = Length(pch) - 1 then
    begin
      pch[i] := #0;
      break;
    end;
    pch[i-1] := str[i];
    if i = Length(str) then pch[i] := #0;
  end;
end;

procedure ConvertStrToTPChar(str: string; var pch: TLongPChar);
var
  i: integer;

begin
  for i := 1 to Length(str) do
  begin
    if i = Length(pch) - 1 then
    begin
      pch[i] := #0;
      break;
    end;
    pch[i-1] := str[i];
    if i = Length(str) then pch[i] := #0;
  end;
end;

function LoadStat(ds: TDataSet; FileName: string; GameType: TCurrGame; AReset: boolean): boolean;
var
  cg: TCurrGame;
  data: TFileStream;
  i: integer;
  sh: TStatHeader;
  sb: TStatBlock;
  fldName: string;
  sdj, sdc, sds: TStatArray;
  currsd: PStatArray;

begin
  result := false;
  if not Assigned(ds) then exit;

  result := true;
  ds.Close;
  if not FileExists(FileName) then exit;

  data := TFileStream.Create(FileName, fmOpenRead);
  try
    data.Read(sh, SizeOf(TStatHeader));
    for i := 0 to sh.cols - 1 do
    begin
      fldName := ConvertTPCharToStr(sh.fields[i]);
      if not Assigned(ds.FindField(fldName)) then
        raise Exception.Create('�������� ������ ����� ���������� "' + FileName + '"!'#13#10 + '�������� ������� "' + fldName + '".');
    end;

    // ��������� ������ �� ������ ���� � ��������� ������
    currsd := nil;
    for i := 0 to sh.rows - 1 do
    begin
      data.Read(sb, SizeOf(TStatBlock));
      case sb.game of
        cgJCrossPuzzle: currsd := @sdj;
        cgCCrossPuzzle: currsd := @sdc;
        cgSudoku: currsd := @sds;
        else continue;
      end;
      SetLength(currsd^, Length(currsd^) + 1);
      currsd^[High(currsd^)] := sb;
    end;

    // ������� ������ ��� ��� � ������� � ��� ������������� ����
    ds.Open;
    for cg := cgJCrossPuzzle to cgCCrossPuzzle do
    begin
      case cg of
        cgJCrossPuzzle: currsd := @sdj;
        cgCCrossPuzzle: currsd := @sdc;
        cgSudoku: currsd := @sds;
      end;

      if (GameType <> cgNone) and (GameType <> cg) then continue;

      // ��������� �� �����
      SortStatData(currsd^);

      for i := 0 to Length(currsd^) - 1 do
      begin
        if AReset then currsd^[i].last := 0;
        ds.Append;
        ds.FieldByName(ConvertTPCharToStr(sh.fields[0])).Value := Ord(currsd^[i].game);
        ds.FieldByName(ConvertTPCharToStr(sh.fields[1])).Value := Ord(currsd^[i].diff);
        ds.FieldByName(ConvertTPCharToStr(sh.fields[2])).Value := currsd^[i].szW;
        ds.FieldByName(ConvertTPCharToStr(sh.fields[3])).Value := currsd^[i].szH;
        ds.FieldByName(ConvertTPCharToStr(sh.fields[4])).Value := ConvertTPCharToStr(currsd^[i].user);
        ds.FieldByName(ConvertTPCharToStr(sh.fields[5])).Value := ConvertTPCharToStr(currsd^[i].name);
        ds.FieldByName(ConvertTPCharToStr(sh.fields[6])).Value := currsd^[i].time;
        ds.FieldByName(ConvertTPCharToStr(sh.fields[7])).Value := currsd^[i].last;
        ds.FieldByName(ConvertTPCharToStr(sh.fields[8])).Value := currsd^[i].score;
        ds.Post;
      end;
    end;
  finally
    data.Free;
  end;
end;

function SaveStat(ds: TDataSet; FileName: string): boolean;
var
  data: TFileStream;
  i: integer;
  sh: TStatHeader;
  sb: TStatBlock;
  mode: word;

begin
  result := false;
  if not Assigned(ds) then exit;

  result := true;
  if not FileExists(FileName) then mode := fmCreate
  else mode := fmOpenWrite;

  data := TFileStream.Create(FileName, mode);
  try
    sh.cols := ds.FieldCount;
    sh.rows := ds.RecordCount;
    for i := 0 to ds.FieldCount - 1 do
      ConvertStrToTPChar(ds.Fields.Fields[i].FieldName, sh.fields[i]);

    data.Write(sh, SizeOf(TStatHeader));
    if not ds.Active then exit;
    ds.First;
    while not ds.Eof do
    begin
      sb.game := TCurrGame(ds.Fields.Fields[0].AsInteger);
      sb.diff := TDifficulty(ds.Fields.Fields[1].AsInteger);
      sb.szW := ds.Fields.Fields[2].AsInteger;
      sb.szH := ds.Fields.Fields[3].AsInteger;
      ConvertStrToTPChar(ds.Fields.Fields[4].AsString, sb.user);
      ConvertStrToTPChar(ds.Fields.Fields[5].AsString, sb.name);
      sb.time := ds.Fields.Fields[6].AsFloat;
      sb.last := ds.Fields.Fields[7].AsInteger;
      sb.score := ds.Fields.Fields[8].AsInteger;
      data.Write(sb, SizeOf(TStatBlock));
      ds.Next;
    end;
  finally
    data.Free;
  end;
end;

procedure CopyBlock(sb: TStatBlock; var db: TStatBlock);
begin
  db.game := sb.game;
  db.diff := sb.diff;
  db.szW := sb.szW;
  db.szH := sb.szH;
  db.user := sb.user;
  db.name := sb.name;
  db.time := sb.time;
  db.last := sb.last;
  db.score := sb.score;
end;

procedure SortStatData(var sd: TStatArray);
var
  k, len, i, j: integer;
  n: TStatBlock;

begin
  // ���������� ������� �����
  len := High(sd);
  k := len div 2; // = len shr 1;
  while k > 0 do
  begin
    for i := 0 to len - k do
    begin
      j := i;
      while (j >= 0) and (sd[j].score < sd[j + k].score) do
      begin
        CopyBlock(sd[j], n);
        CopyBlock(sd[j + k], sd[j]);
        CopyBlock(n, sd[j + k]);
        if j > k then Dec(j, k)
        else j := 0;
      end;
    end;
    k := k div 2; // = k shr 1;
  end;
end;

function SecondsToTime(seconds: integer): TTime;
var
  tf: double;
  h, m, s: integer;

begin
  h := round(int(seconds / 60 / 60));
  tf := frac(seconds / 60 / 60);
  m := round(tf * 60);
  tf := frac(tf * 60);
  s := round(tf * 60);
  result := EncodeTime(h, m, s, 0);
end;

function TimeToSeconds(ATime: TTime): integer;
var
  h, m, s, ms: word;

begin
  DecodeTime(ATime, h, m, s, ms);
  result := (h * 60 * 60) + (m * 60) + s;
end;

function GetASCIIWeight(Symb: char): byte;
var
  i: integer;
  
begin
  result := 0;
  for i := 1 to Length(ASCII_SCALE) do
    if Symb = ASCII_SCALE[i] then
    begin
      result := i - 1;
      break;
    end;
end;

end.
