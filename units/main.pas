unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, ActnList, Menus,
  AppEvnts, ImgList, ExtCtrls, INIFiles, XPMan, StdCtrls, ToolWin, Buttons, splash, frmCommon, frmJCPuzzle, frmCCPuzzle,
  frmSudoku, settings, Records, about, jsCommon, selbox, ShellAPI, help, InputSize, System.ImageList, System.Actions;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    aNewGame: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    AppEvt: TApplicationEvents;
    aSettings: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    aCloseGame: TAction;
    N5: TMenuItem;
    tmrGame: TTimer;
    aShowRecords: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    aExit: TAction;
    N9: TMenuItem;
    N10: TMenuItem;
    aRestart: TAction;
    N11: TMenuItem;
    N12: TMenuItem;
    aNewCore: TAction;
    aOpenCore: TAction;
    aEditCore: TAction;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    aPaint: TAction;
    aUnPaint: TAction;
    aSetUnknown: TAction;
    aAbout: TAction;
    aHelp: TAction;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    aSaveGame: TAction;
    aLoadGame: TAction;
    aRandom: TAction;
    aLoadImage: TAction;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N32: TMenuItem;
    aPrint: TAction;
    N34: TMenuItem;
    tmrAutosave: TTimer;
    ilMain: TImageList;
    N35: TMenuItem;
    aShowPrompt: TAction;
    N33: TMenuItem;
    aSelectAll: TAction;
    aUnselectAll: TAction;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    aJCPuzzle: TAction;
    aSudoku: TAction;
    N44: TMenuItem;
    N45: TMenuItem;
    pmSelectGame: TPopupMenu;
    N46: TMenuItem;
    N47: TMenuItem;
    tbMain: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton12: TToolButton;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    aUp: TAction;
    aDown: TAction;
    aLeft: TAction;
    aRight: TAction;
    aCheckSudoku: TAction;
    N20: TMenuItem;
    aCCPuzzle: TAction;
    N48: TMenuItem;
    aUndo: TAction;
    N51: TMenuItem;
    N52: TMenuItem;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    aRedo: TAction;
    N53: TMenuItem;
    ToolButton16: TToolButton;
    miDifficulty: TMenuItem;
    aDiffVeryEasy: TAction;
    aDiffEasy: TAction;
    aDiffNormal: TAction;
    aDiffHard: TAction;
    aDiffVeryHard: TAction;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    ASetUser: TAction;
    N59: TMenuItem;
    aDeleteCol: TAction;
    aDeleteRow: TAction;
    aAddCol: TAction;
    aAddRow: TAction;
    N65: TMenuItem;
    N66: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    N70: TMenuItem;
    N31: TMenuItem;
    N13: TMenuItem;
    aInvert: TAction;
    aConvertColor: TAction;
    N30: TMenuItem;
    N71: TMenuItem;
    N72: TMenuItem;
    ToolButton11: TToolButton;
    ToolButton13: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    aShowTools: TAction;
    N17: TMenuItem;
    N18: TMenuItem;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    AProps: TAction;
    N19: TMenuItem;
    ToolButton25: TToolButton;
    aLoadText: TAction;
    aImport: TAction;
    pmImport: TPopupMenu;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N49: TMenuItem;
    procedure aAddRowExecute(Sender: TObject);
    procedure aAddColExecute(Sender: TObject);
    procedure aDeleteRowExecute(Sender: TObject);
    procedure aDeleteColUpdate(Sender: TObject);
    procedure aDeleteColExecute(Sender: TObject);
    procedure ASetUserExecute(Sender: TObject);
    procedure aSetDiffUpdate(Sender: TObject);
    procedure aSetDiffExecute(Sender: TObject);
    procedure aRedoUpdate(Sender: TObject);
    procedure aRedoExecute(Sender: TObject);
    procedure aUndoUpdate(Sender: TObject);
    procedure aUndoExecute(Sender: TObject);
    procedure AppEvtActivate(Sender: TObject);
    procedure AppEvtDeactivate(Sender: TObject);
    procedure aRandomExecute(Sender: TObject);
    procedure aRandomUpdate(Sender: TObject);
    procedure aUpExecute(Sender: TObject);
    procedure aUpUpdate(Sender: TObject);
    procedure aLoadGameUpdate(Sender: TObject);
    procedure aUnselectAllExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure AppEvtHint(Sender: TObject);
    procedure aNewGameExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aSettingsExecute(Sender: TObject);
    procedure aCloseGameExecute(Sender: TObject);
    procedure tmrGameTimer(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aRestartExecute(Sender: TObject);
    procedure aCloseGameUpdate(Sender: TObject);
    procedure aNewCoreExecute(Sender: TObject);
    procedure aPaintExecute(Sender: TObject);
    procedure aUnPaintExecute(Sender: TObject);
    procedure aSetUnknownExecute(Sender: TObject);
    procedure aPaintUpdate(Sender: TObject);
    procedure aShowRecordsExecute(Sender: TObject);
    procedure aCloseEditorExecute(Sender: TObject);
    procedure aHelpExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aSaveGameExecute(Sender: TObject);
    procedure aLoadGameExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure tmrAutosaveTimer(Sender: TObject);
    procedure aShowPromptExecute(Sender: TObject);
    procedure aSetGameExecute(Sender: TObject);
    procedure aCheckSudokuExecute(Sender: TObject);
    procedure aCheckSudokuUpdate(Sender: TObject);
    procedure aEditCoreUpdate(Sender: TObject);
    procedure aInvertExecute(Sender: TObject);
    procedure aConvertColorUpdate(Sender: TObject);
    procedure aShowToolsExecute(Sender: TObject);
    procedure APropsExecute(Sender: TObject);
    procedure aImportExecute(Sender: TObject);
    procedure aLoadTextUpdate(Sender: TObject);
    procedure aLoadImageUpdate(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  private
    oldprbartext: string;
    FCurrGame: TCurrGame;
    procedure ResetAll;
    function IsSaved: boolean;
    procedure SetCurrGame(value: TCurrGame);
    procedure ClearAll;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure RegisterHotKeys;
    procedure UnRegisterHotKeys;
    procedure SaveWndState;
    procedure SetActionButtons(Val: boolean);
  public
    FPuzzle: TCommonFrame;
    procedure SetProgress(init, newpos: integer; msg: string; show: boolean);
    procedure SetStatusText(str: string; index: integer);
    function GetStatusText(index: integer): string;
    procedure StartGame;
    procedure CreateFrame(FType: TCurrGame);
    function GetGameState: TGameState;
    property CurrGame: TCurrGame read FCurrGame write SetCurrGame;
  end;

const
  NUM1 = VK_NUMPAD1;
  NUM2 = VK_NUMPAD2;
  NUM3 = VK_NUMPAD3;
  NUM4 = VK_NUMPAD4;
  NUM5 = VK_NUMPAD5;
  NUM6 = VK_NUMPAD6;
  NUM7 = VK_NUMPAD7;
  NUM8 = VK_NUMPAD8;
  NUM9 = VK_NUMPAD9;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.aAboutExecute(Sender: TObject);
var
  a: TfAbout;

begin
  a := TfAbout.Create(self);
  a.ShowModal;
end;

procedure TfrmMain.aAddColExecute(Sender: TObject);
var
  inps: TfrmInputSize;

begin
  if Application.MessageBox(pchar('Добавить столбцы после столбца № ' + IntToStr(FPuzzle.CurrCol + 1) + '?'),
    pchar(Application.Title), MB_YESNO + MB_ICONQUESTION) <> ID_YES then exit;

  if (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit) then
  begin
    inps := TfrmInputSize.Create(self);
    try
      inps.edHeight.Enabled := false;
      inps.Caption := 'Введите кол-во столбцов';
      if inps.ShowModal = mrOk then FPuzzle.AddCol(-1, inps.AWidth);
    finally
      inps.Free;
    end;
  end;
end;

procedure TfrmMain.aAddRowExecute(Sender: TObject);
var
  inps: TfrmInputSize;

begin
  if Application.MessageBox(pchar('Добавить строки после строки № ' + IntToStr(FPuzzle.CurrRow + 1) + '?'),
    pchar(Application.Title), MB_YESNO + MB_ICONQUESTION) <> ID_YES then exit;

  if (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit) then
  begin
    inps := TfrmInputSize.Create(self);
    try
      inps.edWidth.Enabled := false;
      inps.Caption := 'Введите кол-во строк';
      if inps.ShowModal = mrOk then FPuzzle.AddRow(-1, inps.AHeight);
    finally
      inps.Free;
    end;
  end;
end;

procedure TfrmMain.aCheckSudokuExecute(Sender: TObject);
var
  r, c: integer;

begin
  if (CurrGame = cgSudoku) and (FPuzzle.GameState = gsEdit) then
    if TFmSudoku(FPuzzle).CheckSudoku(r, c) then
      Application.MessageBox('Судоку верный!', pchar(self.Caption), MB_OK + MB_ICONINFORMATION)
    else
      Application.MessageBox(pchar('Судоку содержит ошибку (стр. ' + IntToStr(r + 1) + ', кол. ' + IntToStr(c + 1) +
        ')! Проверьте его повнимательнее!'), pchar(self.Caption), MB_OK + MB_ICONWARNING);
end;

procedure TfrmMain.aCheckSudokuUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame = cgSudoku) and (FPuzzle.GameState = gsEdit);
end;

procedure TfrmMain.aCloseEditorExecute(Sender: TObject);
begin
  if IsSaved then
    if CurrGame <> cgNone then FPuzzle.SetGameState(gsNone, gaNew);
  UnRegisterHotKeys;
end;

procedure TfrmMain.aCloseGameExecute(Sender: TObject);
begin
  UnRegisterHotKeys;
  if IsSaved then
    if CurrGame <> cgNone then FPuzzle.SetGameState(gsNone, gaNew);
end;

procedure TfrmMain.aCloseGameUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState in [gsGame, gsEdit]);
end;

procedure TfrmMain.aConvertColorUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame = cgJCrossPuzzle);
end;

procedure TfrmMain.aDeleteColExecute(Sender: TObject);
begin
  if Application.MessageBox(pchar('Удалить столбец № ' + IntToStr(FPuzzle.CurrCol + 1) + '?'), pchar(Application.Title),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then exit;
  if (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit) then FPuzzle.DeleteCol();
end;

procedure TfrmMain.aDeleteColUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(Fpuzzle) and (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit);
end;

procedure TfrmMain.aDeleteRowExecute(Sender: TObject);
begin
  if Application.MessageBox(pchar('Удалить строку № ' + IntToStr(FPuzzle.CurrRow + 1) + '?'), pchar(Application.Title),
    MB_YESNO + MB_ICONQUESTION) <> ID_YES then exit;
  if (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit) then FPuzzle.DeleteRow();
end;

procedure TfrmMain.aSetDiffUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (not Assigned(FPuzzle)) or (CurrGame = cgNone) or (Assigned(FPuzzle) and (not (FPuzzle.GameState in [gsGame])));

  case frmSettings.ADifficulty of
    dfVeryEasy: aDiffVeryEasy.Checked := true;
    dfEasy: aDiffEasy.Checked := true;
    dfNormal: aDiffNormal.Checked := true;
    dfHard: aDiffHard.Checked := true;
    dfVeryHard: aDiffVeryHard.Checked := true;
  end;
end;

procedure TfrmMain.aSetDiffExecute(Sender: TObject);
begin
  if TAction(Sender) = aDiffVeryEasy then frmSettings.ADifficulty := dfVeryEasy
  else if TAction(Sender) = aDiffEasy then frmSettings.ADifficulty := dfEasy
  else if TAction(Sender) = aDiffNormal then frmSettings.ADifficulty := dfNormal
  else if TAction(Sender) = aDiffHard then frmSettings.ADifficulty := dfHard
  else if TAction(Sender) = aDiffVeryHard then frmSettings.ADifficulty := dfVeryHard;
end;

procedure TfrmMain.aEditCoreUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState = gsGame);
end;

procedure TfrmMain.aExitExecute(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmMain.aHelpExecute(Sender: TObject);
var
  frmHelp: TfrmHelp;

begin
  frmHelp := TfrmHelp.Create(self);
  frmHelp.Show;
  //ShellExecute(Application.Handle, 'open', pchar(frmSettings.HelpFile), nil, pchar(frmSettings.AppFolder + '\help'), SW_SHOWNORMAL);
end;

procedure TfrmMain.aImportExecute(Sender: TObject);
var
  m: TMouse;

begin
  pmImport.Popup(m.CursorPos.X, m.CursorPos.Y);
end;

procedure TfrmMain.aInvertExecute(Sender: TObject);
begin
  if (CurrGame <> cgNone) and (FCurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]) and (FPuzzle.GameState = gsEdit) then
    FPuzzle.Invert(frmSettings.InvertBackground);
end;

procedure TfrmMain.aLoadGameExecute(Sender: TObject);
begin
  UnRegisterHotKeys;
  if IsSaved and (CurrGame <> cgNone) then
  begin
    tmrGame.Enabled := false;
    FPuzzle.LoadGame;
    tmrGame.Enabled := true;
    if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
  end;
end;

procedure TfrmMain.aLoadGameUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrGame <> cgNone;
end;

procedure TfrmMain.aLoadImageUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle]);
end;

procedure TfrmMain.aLoadTextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame in [cgJCrossPuzzle, cgSudoku]);
  if TAction(Sender) = aLoadText then
  begin
    case CurrGame of
      cgNone:
      begin
        aLoadText.Caption := 'Импорт текста';
        aLoadText.Hint := 'Импорт из текстового файла';
      end;
      cgJCrossPuzzle:
      begin
        aLoadText.Caption := 'Импорт текста (ASCII-art)';
        aLoadText.Hint := 'Создать кроссворд из текста ASCII-art';
      end;
      cgSudoku:
      begin
        aLoadText.Caption := 'Импорт текста';
        aLoadText.Hint := 'Создать судоку из текста';
      end;
    end;
  end;
end;

procedure TfrmMain.aNewCoreExecute(Sender: TObject);
var
  ca: TGameAction;

begin
  if not IsSaved then exit;
  if CurrGame = cgNone then exit;
  if TAction(Sender) = aNewCore then ca := gaNew
//  else if TAction(Sender) = aRandom then ca := gaRandom
  else if TAction(Sender) = aEditCore then ca := gaCurrent
  else if TAction(Sender) = aOpenCore then ca := gaOther
  else if TAction(Sender) = aLoadImage then ca := gaImport
  else if TAction(Sender) = aLoadText then ca := gaImport3
  else if TAction(Sender) = aConvertColor then ca := gaImport2
  else exit;
  FPuzzle.SetGameState(gsEdit, ca);
  if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
end;

procedure TfrmMain.aNewGameExecute(Sender: TObject);
var
  m: TMouse;

begin
  if not IsSaved then exit;
  if CurrGame = cgNone then pmSelectGame.Popup(m.CursorPos.X, m.CursorPos.Y)
  else StartGame;
end;

procedure TfrmMain.aPaintExecute(Sender: TObject);
begin
  case CurrGame of
    cgJCrossPuzzle: FPuzzle.SetRangeState(1);
    cgSudoku: FPuzzle.SetRangeState(TAction(Sender).Tag);
    cgCCrossPuzzle: FPuzzle.SetRangeState(FPuzzle.BrushColor);
  end;
end;

procedure TfrmMain.aPaintUpdate(Sender: TObject);
begin
  TAction(sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState in [gsEdit, gsGame]);
end;

procedure TfrmMain.AppEvtActivate(Sender: TObject);
begin
  if (CurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
end;

procedure TfrmMain.AppEvtDeactivate(Sender: TObject);
begin
  UnRegisterHotKeys;
end;

procedure TfrmMain.AppEvtHint(Sender: TObject);
begin
  StatusBar1.Panels[4].Text := Application.Hint;
end;

procedure TfrmMain.aPrintExecute(Sender: TObject);
begin
  if (CurrGame <> cgNone) then FPuzzle.PrintCross;
end;

procedure TfrmMain.APropsExecute(Sender: TObject);
begin
  if (CurrGame <> cgNone) and (FPuzzle.GameState = gsEdit) then FPuzzle.ShowProps;
end;

procedure TfrmMain.aRandomExecute(Sender: TObject);
begin
  if (CurrGame <> cgNone) and (FPuzzle.GameState = gsEdit) then FPuzzle.FillRandom(frmSettings.OverwriteCells);
end;

procedure TfrmMain.aRandomUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState = gsEdit);
  if TAction(Sender) = aRandom then
  begin
    case CurrGame of
      cgNone:
      begin
        aRandom.Caption := 'Генератор случайных';
        aRandom.Hint := 'Генерация случайных последовательностей';
      end;
      cgJCrossPuzzle, cgCCrossPuzzle:
      begin
        aRandom.Caption := 'Заполнить случайным образом';
        aRandom.Hint := 'Заполнит поле случайным образом сгенерированными значениями';
      end;
      cgSudoku:
      begin
        aRandom.Caption := 'Генерировать судоку';
        aRandom.Hint := 'Создает новую последовательность судоку';
      end;
    end;
  end;
end;

procedure TfrmMain.aRedoExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.Redo;
end;

procedure TfrmMain.aRedoUpdate(Sender: TObject);
begin
  TAction(sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState in [gsEdit, gsGame]) and FPuzzle.CanRedo;
end;

procedure TfrmMain.aRestartExecute(Sender: TObject);
begin
  if not IsSaved then exit;
  if CurrGame in [cgJCrossPuzzle, cgCCrossPuzzle] then FPuzzle.SetGameState(gsGame, gaCurrent)
  else FPuzzle.SetGameState(gsGame, gaReload);
end;

procedure TfrmMain.aSaveGameExecute(Sender: TObject);
var
  _oldtext: string;

begin
  UnRegisterHotKeys;
  if (CurrGame <> cgNone) then
  begin
    case FPuzzle.GameState of
      gsGame:
      begin
        _oldtext := StatusBar1.Panels[2].Text;
        FPuzzle.SaveGame('', true);
        StatusBar1.Panels[2].Text := _oldtext;
      end;
      gsEdit:
      begin
        //aCheckSudokuExecute(aCheckSudoku);
        if (CurrGame <> cgNone) then FPuzzle.SaveCore;
      end;
    end;
    if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
  end;
end;

procedure TfrmMain.aSelectAllExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.SelectAll;
end;

procedure TfrmMain.aSetGameExecute(Sender: TObject);
begin
  if not IsSaved then exit;
  if TAction(Sender) = aJCPuzzle then CurrGame := cgJCrossPuzzle
  else if TAction(Sender) = aSudoku then CurrGame := cgSudoku
  else if TAction(Sender) = aCCPuzzle then CurrGame := cgCCrossPuzzle
  else CurrGame := cgNone;
end;

procedure TfrmMain.aSettingsExecute(Sender: TObject);
begin
  UnRegisterHotKeys;
  try
    if CurrGame <> cgNone then FPuzzle.SaveOldSettings;
    if frmSettings.ShowModal = mrCancel then exit;
    Screen.Cursor := crHourGlass;
    try
      if CurrGame <> cgNone then FPuzzle.SetSettings;
    finally
      Screen.Cursor := crDefault;
    end;
    //tmrAutosave.Interval := frmSettings.AutosaveInterval * 1000 * 60;
    //tmrAutosave.Enabled := frmSettings.Autosave and (CurrGame <> cgNone) and (FPuzzle.GameState = gsGame);
  finally
    if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
  end;
end;

procedure TfrmMain.aSetUnknownExecute(Sender: TObject);
begin
  case CurrGame of
    cgJCrossPuzzle: FPuzzle.SetRangeState(2);
    cgCCrossPuzzle: FPuzzle.SetRangeState(-1);
    cgSudoku: FPuzzle.SetRangeState(0);
  end;
end;

procedure TfrmMain.ASetUserExecute(Sender: TObject);
begin
  frmSettings.AUser := InputBox(Application.Title, 'Введите ваше имя', frmSettings.AUser);
  self.Repaint;
end;

procedure TfrmMain.aShowPromptExecute(Sender: TObject);
begin
  if (CurrGame <> cgNone) and (FPuzzle.GameState = gsGame) then FPuzzle.ShowPrompt;
end;

procedure TfrmMain.aShowRecordsExecute(Sender: TObject);
var
  frmRecords: TfrmRecords;

begin
  frmRecords := TfrmRecords.Create(self);
  frmRecords.ShowModal;
end;

procedure TfrmMain.aShowToolsExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.ShowTools(true);
end;

procedure TfrmMain.aUndoExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.Undo;
end;

procedure TfrmMain.aUndoUpdate(Sender: TObject);
begin
  TAction(sender).Enabled := (CurrGame <> cgNone) and (FPuzzle.GameState in [gsEdit, gsGame]) and FPuzzle.CanUndo;
end;

procedure TfrmMain.aUnPaintExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.SetRangeState(0);
end;

procedure TfrmMain.aUnselectAllExecute(Sender: TObject);
begin
  if CurrGame <> cgNone then FPuzzle.UnSelectAll;
end;

procedure TfrmMain.aUpExecute(Sender: TObject);
begin
  if (CurrGame <> cgSudoku) and (FPuzzle.GameState = gsNone) then exit;
  if TAction(Sender) = aUp then FPuzzle.MoveToCell(mdUp)
  else if TAction(Sender) = aDown then FPuzzle.MoveToCell(mdDown)
  else if TAction(Sender) = aLeft then FPuzzle.MoveToCell(mdLeft)
  else if TAction(Sender) = aRight then FPuzzle.MoveToCell(mdRight);
end;

procedure TfrmMain.aUpUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]);
end;

procedure TfrmMain.SetActionButtons(Val: boolean);
begin
  ToolButton18.Visible := Val;
  ToolButton13.Visible := Val;
  ToolButton17.Visible := Val;
  ToolButton20.Visible := Val;
  ToolButton21.Visible := Val;
  ToolButton22.Visible := Val;
  ToolButton23.Visible := Val;
end;

procedure TfrmMain.ClearAll;
begin
  UnRegisterHotKeys;
  if Assigned(FPuzzle) then
  begin
    Fpuzzle.SetGameState(gsNone, gaNew);
    FPuzzle.Free;
    FPuzzle := nil;
  end;
end;

procedure TfrmMain.CreateFrame(FType: TCurrGame);
begin
  if Assigned(FPuzzle) then
  begin
    FPuzzle.Free;
    FPuzzle := nil;   
  end;    
  case FType of
    cgNone: exit;
    cgJCrossPuzzle: FPuzzle := TFmJCrossPuzzle.Create(self);
    cgSudoku: FPuzzle := TFmSudoku.Create(self);
    cgCCrossPuzzle: FPuzzle := TFmCCrossPuzzle.Create(self);
  end;
  FPuzzle.PSetActionButtons := SetActionButtons;
  FPuzzle.SetProgress := SetProgress;
  FPuzzle.SetStatus := SetStatusText;
  FPuzzle.GetStatus := GetStatusText;
  FPuzzle.AReset := ResetAll;
  FPuzzle.ATmrGame := tmrGame;
  //FPuzzle.ATmrAutosave := tmrAutosave;
  FPuzzle.Parent := self;
  FPuzzle.Align := alClient;
  FPuzzle.Visible := true;
end;

procedure TfrmMain.RegisterHotKeys;
begin
  RegisterHotKey(self.Handle, NUM1, 0, NUM1);
  RegisterHotKey(self.Handle, NUM2, 0, NUM2);
  RegisterHotKey(self.Handle, NUM3, 0, NUM3);
  RegisterHotKey(self.Handle, NUM4, 0, NUM4);
  RegisterHotKey(self.Handle, NUM5, 0, NUM5);
  RegisterHotKey(self.Handle, NUM6, 0, NUM6);
  RegisterHotKey(self.Handle, NUM7, 0, NUM7);
  RegisterHotKey(self.Handle, NUM8, 0, NUM8);
  RegisterHotKey(self.Handle, NUM9, 0, NUM9);
end;

procedure TfrmMain.ResetAll;
begin
  UnRegisterHotKeys;
  tmrGame.Enabled := False;
  //tmrAutosave.Enabled := false;
  //tmrAutosave.Interval := frmSettings.AutosaveInterval * 1000 * 60;
  aShowPrompt.Enabled := false;
  SetProgress(0, 0, '', false);
  StatusBar1.Panels[2].Text := self.Caption;
  StatusBar1.Panels[1].Text := '';
  StatusBar1.Panels[3].Text := ''; //GetVersion;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  _cg: TCurrGame;

begin
  if not IsSaved then
  begin
    Action := caNone;
    exit;
  end;
  try
    SaveWndState;
    _cg := CurrGame;
    CurrGame := cgNone;
    frmSettings.ALastGame := Ord(_cg);
    frmSettings.Free;
  except
    on e: exception do Application.MessageBox(pchar(e.Message), pchar(Application.Title), MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Randomize;
  frmSettings := TfrmSettings.Create(self);
  if frmSettings.AFirstRun then
  begin
    fSplash := TfSplash.Create(self);
    fSplash.ShowModal;
  end;
  with ProgressBar1 do
  begin
    Visible := false;
    Parent := StatusBar1;
    Width := StatusBar1.Panels[4].Width - 10;
    Height := StatusBar1.Height - 3;
    Top := 2;
    Left := StatusBar1.Panels[0].Width + StatusBar1.Panels[1].Width + StatusBar1.Panels[2].Width + StatusBar1.Panels[3].Width + 2;
    Max := 100;
    Position := 0;
  end;
  self.Caption := Application.Title;
  self.Top := frmSettings.ATop;
  self.Left := frmSettings.ALeft;
  self.Width := frmSettings.AWidth;
  self.Height := frmSettings.AHeight;
  if frmSettings.AMaximized then self.WindowState := wsMaximized
  else self.WindowState := wsNormal;
  ResetAll;
  case frmSettings.AStartAction of
    0: CurrGame := cgNone;
    1:
    case frmSettings.ALastGame of
      0: CurrGame := cgNone;
      1: CurrGame := cgJCrossPuzzle;
      2: CurrGame := cgSudoku;
      3: CurrGame := cgCCrossPuzzle;
    end;
    2: CurrGame := cgJCrossPuzzle;
    3: CurrGame := cgSudoku;
    4: CurrGame := cgCCrossPuzzle;
  end;
end;

procedure TfrmMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if CurrGame <> cgNone then
    FPuzzle.ScrollBox1MouseWheelDown(Sender, Shift, MousePos, Handled);
end;

procedure TfrmMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if CurrGame <> cgNone then
    FPuzzle.ScrollBox1MouseWheelUp(Sender, Shift, MousePos, Handled);
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  //SaveWndState;
  if CurrGame <> cgNone then
  begin
    case FPuzzle.GameState of
      gsEdit: StatusBar1.Panels[0].Text := 'Редактор';
      gsGame: StatusBar1.Panels[0].Text := frmSettings.AUser;
    end;
  end;
end;

function TfrmMain.GetGameState: TGameState;
begin
  if CurrGame <> cgNone then result := FPuzzle.GameState
  else result := gsNone;
end;

function TfrmMain.GetStatusText(index: integer): string;
begin
  if (index < 0) or (index >= StatusBar1.Panels.Count) then exit;
  result := StatusBar1.Panels.Items[index].Text;
end;

function TfrmMain.IsSaved: boolean;
var
  mr: integer;

begin
  if CurrGame = cgNone then
  begin
    result := true;
    exit;
  end;
  case FPuzzle.GameState of
    gsGame:
    begin
      if frmSettings.Autosave then FPuzzle.Autosave;
      if FPuzzle.AChanged and (frmSettings.ACloseGameConfirm) then
      begin
        mr := Application.MessageBox('Текущая игра не сохранена. Вы хотите сохранить игру?', pchar(Application.Title),
          MB_YESNOCANCEL + MB_ICONQUESTION);
        case mr of
          ID_YES:
          begin
            aSaveGameExecute(aSaveGame);
            result := true;
          end;
          ID_NO: result := true;
          ID_CANCEL: result := false;
          else result := true;
        end;
      end else result := true;
    end;
    gsEdit:
      if FPuzzle.AChanged and (frmSettings.ACloseEditorConfirm) then
      begin
        mr := Application.MessageBox('Содержимое редактора было изменено. Вы хотите сохранить изменения?', pchar(Application.Title),
          MB_YESNOCANCEL + MB_ICONQUESTION);
        case mr of
          ID_YES:
          begin
            aSaveGameExecute(self);
            result := true;
          end;
          ID_NO: result := true;
          ID_CANCEL: result := false;
          else result := true;
        end;
      end else result := true;
    else result := true;
  end;
end;

procedure TfrmMain.SaveWndState;
begin
  frmSettings.AMaximized := self.WindowState = wsMaximized;
  if not frmSettings.AMaximized then
  begin
    frmSettings.ATop := self.Top;
    frmSettings.ALeft := self.Left;
    frmSettings.AWidth := self.Width;
    frmSettings.AHeight := self.Height;
  end;
end;

procedure TfrmMain.SetCurrGame(value: TCurrGame);
var
  mr: integer;

begin
  FCurrGame := value;
  ClearAll;
  CreateFrame(FCurrGame);
  SetStatusText(GetGameName(FCurrGame, lRU), 2);
  self.Caption := GetGameName(FCurrGame, lRU);
  if FCurrGame <> cgNone then
  begin
    case frmSettings.AOnGameChange of
      0: FPuzzle.SetGameState(gsGame, gaNew);
      1: aLoadGameExecute(self);
      2:
      begin
        mr := SelectBox(self.Caption,
          'Выберите, что вы хотите сделать - запустить новую игру, загрузить ранее сохраненную игру или ничего не делать?');
        case mr of
          1: FPuzzle.SetGameState(gsGame, gaNew);
          2: aLoadGameExecute(self);
        end;
      end;
      //3: ; //ничего не делаем
    end;
  end else self.Caption := 'Японские кроссворды. Судоку';
  if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys
  else UnRegisterHotKeys;
  frmSettings.ALastGame := Ord(FCurrGame);
end;

procedure TfrmMain.SetProgress(init, newpos: integer; msg: string; show: boolean);
begin
  if init > 0 then
  begin
    oldprbartext := StatusBar1.Panels[2].Text;
    ProgressBar1.Max := init;
  end;
  if msg <> '' then StatusBar1.Panels[2].Text := msg;
  if show then ProgressBar1.Position := newpos
  else begin
    ProgressBar1.Position := 0;
    StatusBar1.Panels[2].Text := oldprbartext;
  end;
  ProgressBar1.Visible := show;
end;

procedure TfrmMain.SetStatusText(str: string; index: integer);
begin
  if (index < 0) or (index >= StatusBar1.Panels.Count) then exit;
  StatusBar1.Panels[index].Text := str;
end;

procedure TfrmMain.StartGame;
begin
  if CurrGame = cgNone then exit;
  FPuzzle.SetGameState(gsGame, gaNew);
  if (FCurrGame = cgSudoku) and (FPuzzle.GameState in [gsGame, gsEdit]) then RegisterHotKeys;
end;

procedure TfrmMain.tmrAutosaveTimer(Sender: TObject);
var
  c: boolean;

begin
  tmrAutosave.Enabled := false;
  if CurrGame <> cgNone then
  begin
    c := FPuzzle.AChanged;
    FPuzzle.SaveGame(frmSettings.SaveFolder + '\autosave.' + GetExt(FCurrGame, true), false);
    FPuzzle.AChanged := c;
  end;
  tmrAutosave.Enabled := true;
end;

procedure TfrmMain.tmrGameTimer(Sender: TObject);
begin
  if CurrGame = cgNone then tmrGame.Enabled := false
  else begin
    FPuzzle.GameTime := Time - FPuzzle.StartTime;
    StatusBar1.Panels[1].Text := TimeToStr(FPuzzle.GameTime);
    Application.ProcessMessages;
  end;
end;

procedure TfrmMain.UnRegisterHotKeys;
begin
  UnRegisterHotKey(self.Handle, NUM1);
  UnRegisterHotKey(self.Handle, NUM2);
  UnRegisterHotKey(self.Handle, NUM3);
  UnRegisterHotKey(self.Handle, NUM4);
  UnRegisterHotKey(self.Handle, NUM5);
  UnRegisterHotKey(self.Handle, NUM6);
  UnRegisterHotKey(self.Handle, NUM7);
  UnRegisterHotKey(self.Handle, NUM8);
  UnRegisterHotKey(self.Handle, NUM9);
end;

procedure TfrmMain.WMHotKey(var Msg: TWMHotKey);
begin
  case msg.HotKey of
    NUM1: aPaintExecute(Action1);
    NUM2: aPaintExecute(Action2);
    NUM3: aPaintExecute(Action3);
    NUM4: aPaintExecute(Action4);
    NUM5: aPaintExecute(Action5);
    NUM6: aPaintExecute(Action6);
    NUM7: aPaintExecute(Action7);
    NUM8: aPaintExecute(Action8);
    NUM9: aPaintExecute(Action9);
  end;
end;

end.
