unit settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, ExtCtrls, Buttons,
  ComCtrls, IniFiles, Registry, ShlObj, ComObj, ShellAPI, ActiveX, ImgList, jsCommon, System.ImageList,
  Vcl.Samples.Spin, DBCtrlsEh;

type
  TfrmSettings = class(TForm)
    tvPartition: TTreeView;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
    pImgAnalyse: TPanel;
    ilSetTree: TImageList;
    pNone: TPanel;
    lblPartDescr: TLabel;
    pGame: TPanel;
    pColors: TPanel;
    btnReset: TBitBtn;
    pStyles: TPanel;
    pGeneral: TPanel;
    pConfirmations: TPanel;
    chbFirstRun: TCheckBox;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Panel2: TPanel;
    rbnRANone: TRadioButton;
    rbnRAGame: TRadioButton;
    rbnRAEditor: TRadioButton;
    rbnRABoth: TRadioButton;
    Panel3: TPanel;
    rbnRSLine: TRadioButton;
    rbnRSStroke: TRadioButton;
    rbnRSDot: TRadioButton;
    rbnRSInversDot: TRadioButton;
    chbShowCellsHint: TCheckBox;
    bntCreateShortcut: TBitBtn;
    chbAutosave: TCheckBox;
    Label24: TLabel;
    cbDifficulty: TComboBox;
    Bevel2: TBevel;
    GroupBox8: TGroupBox;
    rbnNew: TRadioButton;
    rbnLoad: TRadioButton;
    rbnRequest: TRadioButton;
    rbnNone: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    cbStartAction: TComboBox;
    Label3: TLabel;
    chbCloseGameConfirm: TCheckBox;
    chbCloseEditorConfirm: TCheckBox;
    chbAutoCellSize: TCheckBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox6: TGroupBox;
    Label17: TLabel;
    Label19: TLabel;
    GroupBox7: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    cbCapCellStyle: TComboBox;
    cbFieldCellStyle: TComboBox;
    cbCapCellChStyle: TComboBox;
    cbFieldCellChStyle: TComboBox;
    GroupBox9: TGroupBox;
    Label6: TLabel;
    Label14: TLabel;
    Label11: TLabel;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    GroupBox1: TGroupBox;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    ColorDialog: TColorDialog;
    edBackgroundColor: TEdit;
    edLinesColor: TEdit;
    edRulerColor: TEdit;
    edCapOpenBackColor: TEdit;
    edCapBackColor: TEdit;
    edCapOpenColor: TEdit;
    edCapFontColor: TEdit;
    edImgPaintColor: TEdit;
    edImgNoPaintColor: TEdit;
    edImgGrayedColor: TEdit;
    Label27: TLabel;
    Bevel4: TBevel;
    Label28: TLabel;
    Bevel5: TBevel;
    cbFontName: TComboBox;
    Label29: TLabel;
    GroupBox10: TGroupBox;
    chbFontBold: TCheckBox;
    chbFontItalic: TCheckBox;
    chbFontUnderline: TCheckBox;
    chbFontStrikeout: TCheckBox;
    lblFontExample: TLabel;
    chbFastSudoku: TCheckBox;
    Bevel6: TBevel;
    chbOverwriteCells: TCheckBox;
    Label30: TLabel;
    chbNegative: TCheckBox;
    Label31: TLabel;
    chbPxFormat: TComboBox;
    Label25: TLabel;
    Bevel3: TBevel;
    rbnLightness: TRadioButton;
    rbnSaturation: TRadioButton;
    rbnRed: TRadioButton;
    rbnGreen: TRadioButton;
    rbnBlue: TRadioButton;
    chbLightnessBorder: TCheckBox;
    Label26: TLabel;
    trbLightness: TTrackBar;
    rbnMonoPal: TRadioButton;
    chbInvertBg: TCheckBox;
    edLightnessBorder: TSpinEdit;
    edCellWidth: TSpinEdit;
    edCellHeight: TSpinEdit;
    edFontSize: TSpinEdit;
    edLinesWidth: TSpinEdit;
    edFatLineWidth: TSpinEdit;
    edAutosaveInterval: TSpinEdit;
    pCaption: TPanel;
    edGammaCoeff: TDBNumberEditEh;
    procedure edCellHeightChange(Sender: TObject);
    procedure cbFontNameChange(Sender: TObject);
    procedure edBackgroundColorClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnResetClick(Sender: TObject);
    procedure tvPartitionChange(Sender: TObject; Node: TTreeNode);
    procedure tvPartitionCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure chbAutoCellSizeClick(Sender: TObject);
    procedure chbAutosaveClick(Sender: TObject);
    procedure bntCreateShortcutClick(Sender: TObject);
    procedure rbnLightnessClick(Sender: TObject);
    procedure chbLightnessBorderClick(Sender: TObject);
    procedure trbLightnessChange(Sender: TObject);
    procedure edLightnessBorderChange(Sender: TObject);
  private
    IsOnShow: boolean;
    r_ok: boolean;
    SettingFile: string;
    FJCellWidth: integer;
    FJCellHeight: integer;
    FSCellWidth: integer;
    FSCellHeight: integer;
    //FCurrNum: integer;
    procedure SetCellHeight(value: integer);
    function GetCellHeight: integer;
    procedure SetCellWidth(value: integer);
    function GetCellWidth: integer;
    procedure SaveToFile;
    procedure LoadFromFile;
    procedure SaveSettings;
    procedure SetControls;
    procedure SetIndividualGameControls;
    procedure ChangePartControls(nodeID: integer);
    function FontStyleAsString(fstyle: TFontStyles): string;
    function GetFontStyle(style: string): TFontStyles;
    procedure FillFonts(var Combo: TComboBox);
  public
    //настройки программы
    ALeft: integer;
    ATop: integer;
    AWidth: integer;
    AHeight: integer;
    AMaximized: boolean;
    AutoCellSize: boolean;
    Autosave: boolean;
    AutosaveInterval: integer;
    AUser: string;
    AppFolder: string;
    CrossFolder: string;
    SaveFolder: string;
    RecordsFile: string;
    HelpFile: string;
    ABackgroundColor: integer;
    ACapFontColor: integer;
    ACapOpenColor: integer;
    ACapBackColor: integer;
    ACapOpenBackColor: integer;
    AGridLinesColor: integer;
    ALinesWidth: integer;
    AFatLinesWidth: integer;
    AImgPaintColor: integer;
    AImgNoPaintColor: integer;
    AImgGrayedColor: integer;
    ARulerColor: integer;
    ARulerArea: TRulerArea;
    ARulerStyle: TRulerStyle;
    AImgAnalisator: TImgAnalisatorType;
    AImgInvert: boolean;
    ALightnessBorder: byte;
    DefLightnessBorder: byte;
    AUserSetLightness: boolean;
    ACapCellStyle: TCellStyle;
    AFCellStyle: TCellStyle;
    ACapCellChStyle: integer;
    AFCellChStyle: integer;
    AShowCellsHint: boolean;
    APromptLeft: integer;
    APromptTop: integer;
    AFirstRun: boolean;
    AOnGameChange: integer;
    ADifficulty: TDifficulty;
    AStartAction: integer;
    ALastGame: integer;
    ACloseGameConfirm: boolean;
    ACloseEditorConfirm: boolean;
    ACellFontSize: integer;
    ACellFontName: string;
    ACellFontStyle: TFontStyles;
    AFastSudoku: boolean;
    LastJPuzzle: string;
    LastSudoku: string;
    LastCPuzzle: string;
    LastJSaved: string;
    LastSSaved: string;
    LastCSaved: string;
    LastImgFolder: string;
    OverwriteCells: boolean;
    InvertBackground: boolean;
    AGammaCoeff: double;
    APxFormat: TPixelFormat;
    ACrossWidth: integer;
    ACrossHeight: integer;
    SelPuzzlePrv: boolean;
    LwFileNameWidth: integer;
    LwNameWidth: integer;
    LwUserWidth: integer;
    LwTimeWidth: integer;
    LwSizeWidth: integer;
    LwDiffWidth: integer;
    ToolHeight: integer;
    //function GetNextNum: integer;
    property ACellWidth: integer read GetCellWidth write SetCellWidth;
    property ACellHeight: integer read GetCellHeight write SetCellHeight;
  end;

var
  frmSettings: TfrmSettings;

implementation

uses main;

{$R *.dfm}

procedure TfrmSettings.bntCreateShortcutClick(Sender: TObject);
var
  desctoppath: string;
  reg: TRegistry;

begin
  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', false) then
    desctopPath := reg.ReadString('Desktop')
  else exit;
  if not DirectoryExists(desctoppath) then exit;

  CreateLink(Application.ExeName, desctoppath, 'Японский кроссворд', '');
  Application.MessageBox('Ярлык создан', pchar(Application.Title), MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  r_ok := false;
  self.Close;
end;

procedure TfrmSettings.btnResetClick(Sender: TObject);
begin
  if Application.MessageBox('В результате данной операции будут загружены стандартные настройки.'#13#10 +
    'Вы точно хотите сбросить все настройки?', pchar(Application.Title), MB_YESNO + MB_ICONWARNING) = ID_NO then exit;

  DeleteFile(SettingFile + '.bak');
  RenameFile(SettingFile, SettingFile + '.bak');
  LoadFromFile;
  SetControls;
  Application.MessageBox(pchar('Настройки можно восстановить из резервной копии конфигурационного файла "' + SettingFile + '.bak"'),
    pchar(Application.Title), MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin
  SaveSettings;
  r_ok := true;
  self.Close;
end;

procedure TfrmSettings.cbFontNameChange(Sender: TObject);
begin
  lblFontExample.Font.Name := cbFontName.Text;
  if chbFontBold.Checked then lblFontExample.Font.Style := lblFontExample.Font.Style + [fsBold]
  else lblFontExample.Font.Style := lblFontExample.Font.Style - [fsBold];
  if chbFontItalic.Checked then lblFontExample.Font.Style := lblFontExample.Font.Style + [fsItalic]
  else lblFontExample.Font.Style := lblFontExample.Font.Style - [fsItalic];
  if chbFontUnderline.Checked then lblFontExample.Font.Style := lblFontExample.Font.Style + [fsUnderline]
  else lblFontExample.Font.Style := lblFontExample.Font.Style - [fsUnderline];
  if chbFontStrikeout.Checked then lblFontExample.Font.Style := lblFontExample.Font.Style + [fsStrikeOut]
  else lblFontExample.Font.Style := lblFontExample.Font.Style - [fsStrikeOut];
end;

procedure TfrmSettings.ChangePartControls(nodeID: integer);
begin
  pCaption.Caption := tvPartition.Selected.Text;
  lblPartDescr.Caption := 'Выберите раздел';
  pNone.Visible := false;
  pGame.Visible := false;
  pColors.Visible := false;
  pStyles.Visible := false;
  pGeneral.Visible := false;
  pConfirmations.Visible := false;
  pImgAnalyse.Visible := false;
  case nodeID of
    -1: pNone.Visible := true;
    0:
    begin
      pNone.Visible := true;
      lblPartDescr.Caption := 'Основные настройки';
    end;
    1: pGeneral.Visible := true;
    2: pGame.Visible := true;
    3: pConfirmations.Visible := true;
    4:
    begin
      pNone.Visible := true;
      lblPartDescr.Caption := 'Внешний вид игрового поля';
    end;
    5: pStyles.Visible := true;
    6: pColors.Visible := true;
    7:
    begin
      pNone.Visible := true;
      lblPartDescr.Caption := 'Настройки редактора';
    end;
    8: pImgAnalyse.Visible := true;
  end;
end;

procedure TfrmSettings.chbAutoCellSizeClick(Sender: TObject);
begin
  GroupBox2.Enabled := not chbAutoCellSize.Checked;
  label4.Enabled := not chbAutoCellSize.Checked;
  label5.Enabled := not chbAutoCellSize.Checked;
  edCellWidth.Enabled := not chbAutoCellSize.Checked;
  edCellHeight.Enabled := not chbAutoCellSize.Checked;
end;

procedure TfrmSettings.chbAutosaveClick(Sender: TObject);
begin
  edAutosaveInterval.Enabled := chbAutosave.Checked;
end;

procedure TfrmSettings.chbLightnessBorderClick(Sender: TObject);
begin
  edLightnessBorder.Enabled := chbLightnessBorder.Checked;
  trbLightness.Enabled := chbLightnessBorder.Checked;
  label26.Enabled := chbLightnessBorder.Checked;
end;

procedure TfrmSettings.edBackgroundColorClick(Sender: TObject);
begin
  ColorDialog.Color := TEdit(Sender).Color;
  if ColorDialog.Execute then TEdit(sender).Color := ColorDialog.Color;
end;

procedure TfrmSettings.edCellHeightChange(Sender: TObject);
begin
  if (not IsOnShow) and (frmMain.CurrGame = cgSudoku) then
  try
    edFontSize.Value := GetFontSize(edCellHeight.Value);
  except
  end;
end;

procedure TfrmSettings.edLightnessBorderChange(Sender: TObject);
begin
  trbLightness.Position := edLightnessBorder.Value;
end;

procedure TfrmSettings.FillFonts(var Combo: TComboBox);
begin
  Combo.Items := Screen.Fonts;
end;

function TfrmSettings.FontStyleAsString(fstyle: TFontStyles): string;
begin
  result := '';
  if (fsBold in fstyle) then
    if (result = '') then result := 'fsBold'
    else result := result + ',fsBold';
  if (fsItalic in fstyle) then
    if (result = '') then result := 'fsItalic'
    else result := result + ',fsItalic';
  if (fsUnderline in fstyle) then
    if (result = '') then result := 'fsUnderline'
    else result := result + ',fsUnderline';
  if (fsStrikeOut in fstyle) then
    if (result = '') then result := 'fsStrikeOut'
    else result := result + ',fsStrikeOut';
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if r_ok then ModalResult := mrOk
  else ModalResult := mrCancel;
  Action := caHide;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  AppFolder := ExtractFileDir(Application.ExeName);
  CrossFolder := AppFolder + '\data';
  SaveFolder := AppFolder + '\save';
  SettingFile := AppFolder + '\config.ini';
  RecordsFile := AppFolder + '\statx.dat';
  HelpFile := AppFolder + '\help\help.htm';
  DefLightnessBorder := 120;
  ForceDirectories(SaveFolder);
  FillFonts(cbFontName);
  LoadFromFile;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  SaveToFile;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  r_ok := false;
  IsOnShow := true;
  tvPartition.FullExpand;
  SetControls;
  IsOnShow := false;
end;

procedure TfrmSettings.rbnLightnessClick(Sender: TObject);
var
  b: boolean;

begin
  b := rbnLightness.Checked or rbnSaturation.Checked;
  if b then
  begin
    edLightnessBorder.MaxValue := 240;
    trbLightness.Max := 240;
  end else
  begin
    edLightnessBorder.MaxValue := 255;
    trbLightness.Max := 255;
  end;
  edLightnessBorder.Value := Round(edLightnessBorder.MaxValue / 2);
  trbLightness.Position := Round(trbLightness.Max / 2);
end;

function TfrmSettings.GetCellHeight: integer;
begin
  if frmMain.CurrGame = cgSudoku then result := FSCellHeight
  else result := FJCellHeight;
end;

function TfrmSettings.GetCellWidth: integer;
begin
  if frmMain.CurrGame = cgSudoku then result := FSCellWidth
  else result := FJCellWidth;
end;

function TfrmSettings.GetFontStyle(style: string): TFontStyles;
var
  i: integer;
  s: string;

begin
  result := [];
  for i := 0 to WordCountEx(style, [','], []) do
  begin
    s := LowerCase(Trim(ExtractWordEx(i, style, [','], [])));
    if (s = 'fsbold') then result := result + [fsBold];
    if (s = 'fsitalic') then result := result + [fsItalic];
    if (s = 'fsunderline') then result := result + [fsUnderline];
    if (s = 'fsstrikeout') then result := result + [fsStrikeOut];
  end;
end;

{function TfrmSettings.GetNextNum: integer;
begin
  Inc(FCurrNum);
  result := FCurrNum;
end;}

procedure TfrmSettings.LoadFromFile;
var
  f: TIniFile;

begin
  if SettingFile = '' then SettingFile := ExtractFileDir(Application.ExeName) + '\settings.ini';
  f := TIniFile.Create(SettingFile);

  try
    ALeft := f.ReadInteger('WINDOW', 'formleft', Round(Screen.Width / 2) - Round(640 / 2));
    ATop := f.ReadInteger('WINDOW', 'formtop', Round(Screen.Height / 2) - Round(640 / 2));
    AWidth := f.ReadInteger('WINDOW', 'formwidth', 640);
    AHeight := f.ReadInteger('WINDOW', 'formheight', 640);
    AMaximized := f.ReadBool('WINDOW', 'formmaximized', false);
    APromptLeft := f.ReadInteger('WINDOW', 'promptleft', ALeft);
    APromptTop := f.ReadInteger('WINDOW', 'prompttop', ATop);
    FJCellWidth := f.ReadInteger('WINDOW', 'jcellwidth', 15);
    FJCellHeight := f.ReadInteger('WINDOW', 'jcellheight', 15);
    FSCellWidth := f.ReadInteger('WINDOW', 'scellwidth', 35);
    FSCellHeight := f.ReadInteger('WINDOW', 'scellheight', 35);
    AutoCellSize := f.ReadBool('WINDOW', 'autocellsize', false);
    ALinesWidth := f.ReadInteger('WINDOW', 'linewidth', 1);
    AFatLinesWidth := f.ReadInteger('WINDOW', 'fatlinewidth', 3);
    ARulerArea := TRulerArea(f.ReadInteger('WINDOW', 'rulerarea', 2));
    ARulerStyle := TRulerStyle(f.ReadInteger('WINDOW', 'rulerstyle', 3));
    ACapCellStyle := TCellStyle(f.ReadInteger('WINDOW', 'ccellstyle', 5));
    AFCellStyle := TCellStyle(f.ReadInteger('WINDOW', 'fcellstyle', 1));
    ACapCellChStyle := f.ReadInteger('WINDOW', 'ccellchstyle', 5);
    AFCellChStyle := f.ReadInteger('WINDOW', 'fcellchstyle', 0);
    AShowCellsHint := f.ReadBool('WINDOW', 'cellshint', true);
    AFirstRun := f.ReadBool('WINDOW', 'firstrun', true);
    ACellFontSize := f.ReadInteger('WINDOW', 'CellFontSize', 22);
    ACellFontName := f.ReadString('WINDOW', 'CellFontName', 'Comic Sans MS');
    ACellFontStyle := GetFontStyle(f.ReadString('WINDOW', 'CellFontStyle', ''));
    LwFileNameWidth := f.ReadInteger('WINDOW', 'LwFileNameWidth', 130);
    LwNameWidth := f.ReadInteger('WINDOW', 'LwNameWidth', 130);
    LwUserWidth := f.ReadInteger('WINDOW', 'LwUserWidth', 100);
    LwTimeWidth := f.ReadInteger('WINDOW', 'LwTimeWidth', 50);
    LwSizeWidth := f.ReadInteger('WINDOW', 'LwSizeWidth', 50);
    LwDiffWidth := f.ReadInteger('WINDOW', 'LwDiffWidth', 90);
    ToolHeight := f.ReadInteger('WINDOW', 'ToolHeight', 55);

    Autosave := f.ReadBool('GAME', 'autosave', true);
    AutosaveInterval := f.ReadInteger('GAME', 'ainterval', 3);
    AUser := f.ReadString('GAME', 'curruser', 'Игрок 1');
    AOnGameChange := f.ReadInteger('GAME', 'OnGameChange', 2);
    ADifficulty := TDifficulty(f.ReadInteger('GAME', 'Difficulty', 2));
    AStartAction := f.ReadInteger('GAME', 'StartAction', 1);
    ALastGame := f.ReadInteger('GAME', 'LastGame', 0);
    ACloseEditorConfirm := f.ReadBool('GAME', 'CloseEditorConfirm', true);
    ACloseGameConfirm := f.ReadBool('GAME', 'CloseGameConfirm', true);
    AFastSudoku := f.ReadBool('GAME', 'FastSudoku', false);
    LastJPuzzle := f.ReadString('GAME', 'LastJPuzzle', '');
    LastCPuzzle := f.ReadString('GAME', 'LastCPuzzle', '');
    LastSudoku := f.ReadString('GAME', 'LastSudoku', '');
    LastJSaved := f.ReadString('GAME', 'LastJSaved', '');
    LastSSaved := f.ReadString('GAME', 'LastSSaved', '');
    LastCSaved := f.ReadString('GAME', 'LastCSaved', '');
    SelPuzzlePrv := f.ReadBool('GAME', 'SelPuzzlePrv', true);

    ABackgroundColor := f.ReadInteger('COLORS', 'backcolor', 15066597);
    ACapFontColor := f.ReadInteger('COLORS', 'capfontcolor', RGB(0, 0, 128));
    ACapOpenColor := f.ReadInteger('COLORS', 'capopencolor', RGB(255, 0, 0));
    ACapBackColor := f.ReadInteger('COLORS', 'capbackcolor', RGB(224, 223, 227));
    ACapOpenBackColor := f.ReadInteger('COLORS', 'capopbackcolor', RGB(195, 190, 200));
    AGridLinesColor := f.ReadInteger('COLORS', 'linescolor', RGB(224, 223, 227));
    AImgPaintColor := f.ReadInteger('COLORS', 'imgpaintcolor', RGB(0, 0, 0));
    AImgNoPaintColor := f.ReadInteger('COLORS', 'imgnopaintcolor', RGB(255, 255, 255));
    AImgGrayedColor := f.ReadInteger('COLORS', 'imggrayedcolor', RGB(224, 223, 227));
    ARulerColor := f.ReadInteger('COLORS', 'rulercolor', RGB(128, 128, 128));

    AImgAnalisator := TImgAnalisatorType(f.ReadInteger('EDITOR', 'analysetype', 0));
    AImgInvert := f.ReadBool('EDITOR', 'invert', false);
    ALightnessBorder := f.ReadInteger('EDITOR', 'lightborder', 120);
    AUserSetLightness := f.ReadBool('EDITOR', 'userlightness', false);
    //FCurrNum := f.ReadInteger('EDITOR', 'currnum', 0);
    OverwriteCells := f.ReadBool('EDITOR', 'OverwriteCells', true);
    InvertBackground := f.ReadBool('EDITOR', 'InvertBg', true);
    AGammaCoeff := f.ReadFloat('EDITOR', 'GammaCoeff', 3);
    APxFormat := TPixelFormat(f.ReadInteger('EDITOR', 'PxFormat', 2));
    ACrossWidth := f.ReadInteger('EDITOR', 'CrossWidth', 30);
    ACrossHeight := f.ReadInteger('EDITOR', 'CrossHeight', 30);
    LastImgFolder := f.ReadString('EDITOR', 'LastImgFolder', '');
  finally
    f.Free;
  end;
end;

procedure TfrmSettings.SaveSettings;
begin
  AutoCellSize := chbAutoCellSize.Checked;
  AFirstRun := chbFirstRun.Checked;
  ACellWidth := edCellWidth.Value;
  ACellHeight := edCellHeight.Value;
  AFatLinesWidth := edFatLineWidth.Value;
  ALinesWidth := edLinesWidth.Value;
  Autosave := chbAutosave.Checked;
  AShowCellsHint := chbShowCellsHint.Checked;
  AutosaveInterval := edAutosaveInterval.Value;
  ABackgroundColor := edBackgroundColor.Color;
  ACapFontColor := edCapFontColor.Color;
  ACapOpenColor := edCapOpenColor.Color;
  ACapBackColor := edCapBackColor.Color;
  ACapOpenBackColor := edCapOpenBackColor.Color;
  AGridLinesColor := edLinesColor.Color;
  AImgPaintColor := edImgPaintColor.Color;
  AImgNoPaintColor := edImgNoPaintColor.Color;
  AImgGrayedColor := edImgGrayedColor.Color;
  ARulerColor := edRulerColor.Color;
  AImgInvert := chbNegative.Checked;
  ALightnessBorder := edLightnessBorder.Value;
  AUserSetLightness := chbLightnessBorder.Checked;
  ACapCellStyle := TCellStyle(cbCapCellStyle.ItemIndex);
  ACapCellChStyle := cbCapCellChStyle.ItemIndex - 1;
  AFCellStyle := TCellStyle(cbFieldCellStyle.ItemIndex);
  AFCellChStyle := cbFieldCellChStyle.ItemIndex - 1;
  ADifficulty := TDifficulty(cbDifficulty.ItemIndex);

  if rbnRANone.Checked then ARulerArea := raNone
  else if rbnRAGame.Checked then ARulerArea := raGame
  else if rbnRAEditor.Checked then ARulerArea := raEditor
  else if rbnRABoth.Checked then ARulerArea := raBoth;

  if rbnRSLine.Checked then ARulerStyle := rsLines
  else if rbnRSStroke.Checked then ARulerStyle := rsStroke
  else if rbnRSDot.Checked then ARulerStyle := rsDot
  else if rbnRSInversDot.Checked then ARulerStyle := rsInversDot;

  if rbnLightness.Checked then AImgAnalisator := iaLightness
  else if rbnSaturation.Checked then AImgAnalisator := iaSaturation
  else if rbnRed.Checked then AImgAnalisator := iaRed
  else if rbnGreen.Checked then AImgAnalisator := iaGreen
  else if rbnBlue.Checked then AImgAnalisator := iaBlue
  else if rbnMonoPal.Checked then AImgAnalisator := iaMono;

  if rbnNew.Checked then AOnGameChange := 0
  else if rbnLoad.Checked then AOnGameChange := 1
  else if rbnRequest.Checked then AOnGameChange := 2
  else if rbnNone.Checked then AOnGameChange := 3;

  AGammaCoeff := edGammaCoeff.Value;

  AStartAction := cbStartAction.ItemIndex;
  ACloseGameConfirm := chbCloseGameConfirm.Checked;
  ACloseEditorConfirm := chbCloseEditorConfirm.Checked;
  ACellFontSize := edFontSize.Value;
  ACellFontName := cbFontName.Text;

  ACellFontStyle := [];
  if chbFontBold.Checked then ACellFontStyle := ACellFontStyle + [fsBold];
  if chbFontItalic.Checked then ACellFontStyle := ACellFontStyle + [fsItalic];
  if chbFontUnderline.Checked then ACellFontStyle := ACellFontStyle + [fsUnderline];
  if chbFontStrikeout.Checked then ACellFontStyle := ACellFontStyle + [fsStrikeOut];

  AFastSudoku := chbFastSudoku.Checked;
  OverwriteCells := chbOverwriteCells.Checked;
  InvertBackground := chbInvertBg.Checked;

  case chbPxFormat.ItemIndex of
    0: APxFormat := pf1bit; //моно
    1: APxFormat := pf4bit; //16 цв.
    2: APxFormat := pf8bit; //256 цв.
    //3: APxFormat := pf16bit; //65536 цв., то же что и pf15bit
    //3: APxFormat := pf24bit; //24 bit
    3: APxFormat := pf32bit; //32 bit. 24=32 бита, только у 32 есть альфа-канал (прозрачность)
    else APxFormat := pf4bit;
  end;
end;

procedure TfrmSettings.SaveToFile;
var
  f: TIniFile;

begin
  if SettingFile = '' then SettingFile := ExtractFileDir(Application.ExeName) + '\settings.ini';
  f := TIniFile.Create(SettingFile);

  f.WriteInteger('WINDOW', 'formleft', ALeft);
  f.WriteInteger('WINDOW', 'formtop', ATop);
  f.WriteInteger('WINDOW', 'formwidth', AWidth);
  f.WriteInteger('WINDOW', 'formheight', AHeight);
  f.WriteBool('WINDOW', 'formmaximized', AMaximized);
  f.WriteInteger('WINDOW', 'jcellwidth', FJCellWidth);
  f.WriteInteger('WINDOW', 'jcellheight', FJCellHeight);
  f.WriteInteger('WINDOW', 'scellwidth', FSCellWidth);
  f.WriteInteger('WINDOW', 'scellheight', FSCellHeight);
  f.WriteInteger('WINDOW', 'fatlinewidth', AFatLinesWidth);
  f.WriteInteger('WINDOW', 'linewidth', ALinesWidth);
  f.WriteBool('WINDOW', 'autocellsize', AutoCellSize);
  f.WriteInteger('WINDOW', 'rulerarea', Ord(ARulerArea));
  f.WriteInteger('WINDOW', 'rulerstyle', Ord(ARulerStyle));
  f.WriteInteger('WINDOW', 'ccellstyle', Ord(ACapCellStyle));
  f.WriteInteger('WINDOW', 'ccellchstyle', ACapCellChStyle);
  f.WriteInteger('WINDOW', 'fcellstyle', Ord(AFCellStyle));
  f.WriteInteger('WINDOW', 'fcellchstyle', AFCellChStyle);
  f.WriteBool('WINDOW', 'cellshint', AShowCellsHint);
  f.WriteInteger('WINDOW', 'promptleft', APromptLeft);
  f.WriteInteger('WINDOW', 'prompttop', APromptTop);
  f.WriteBool('WINDOW', 'firstrun', AFirstRun);
  f.WriteInteger('WINDOW', 'CellFontSize', ACellFontSize);
  f.WriteString('WINDOW', 'CellFontName', ACellFontName);
  f.WriteString('WINDOW', 'CellFontStyle', FontStyleAsString(ACellFontStyle));
  f.WriteInteger('WINDOW', 'LwFileNameWidth', LwFileNameWidth);
  f.WriteInteger('WINDOW', 'LwNameWidth', LwNameWidth);
  f.WriteInteger('WINDOW', 'LwUserWidth', LwUserWidth);
  f.WriteInteger('WINDOW', 'LwTimeWidth', LwTimeWidth);
  f.WriteInteger('WINDOW', 'LwSizeWidth', LwSizeWidth);
  f.WriteInteger('WINDOW', 'LwDiffWidth', LwDiffWidth);
  f.WriteInteger('WINDOW', 'ToolHeight', ToolHeight);

  f.WriteBool('GAME', 'autosave', Autosave);
  f.WriteString('GAME', 'curruser', AUser);
  f.WriteInteger('GAME', 'ainterval', AutosaveInterval);
  f.WriteInteger('GAME', 'OnGameChange', AOnGameChange);
  f.WriteInteger('GAME', 'Difficulty', Ord(ADifficulty));
  f.WriteInteger('GAME', 'StartAction', AStartAction);
  f.WriteInteger('GAME', 'LastGame', ALastGame);
  f.WriteBool('GAME', 'CloseEditorConfirm', ACloseEditorConfirm);
  f.WriteBool('GAME', 'CloseGameConfirm', ACloseGameConfirm);
  f.WriteBool('GAME', 'FastSudoku', AFastSudoku);
  f.WriteString('GAME', 'LastJPuzzle', LastJPuzzle);
  f.WriteString('GAME', 'LastCPuzzle', LastCPuzzle);
  f.WriteString('GAME', 'LastSudoku', LastSudoku);
  f.WriteString('GAME', 'LastJSaved', LastJSaved);
  f.WriteString('GAME', 'LastSSaved', LastSSaved);
  f.WriteString('GAME', 'LastCSaved', LastCSaved);
  f.WriteBool('GAME', 'SelPuzzlePrv', SelPuzzlePrv);

  f.WriteInteger('COLORS', 'backcolor', ABackgroundColor);
  f.WriteInteger('COLORS', 'capfontcolor', ACapFontColor);
  f.WriteInteger('COLORS', 'capopencolor', ACapOpenColor);
  f.WriteInteger('COLORS', 'capopencolor', ACapOpenColor);
  f.WriteInteger('COLORS', 'capopbackcolor', ACapOpenBackColor);
  f.WriteInteger('COLORS', 'linescolor', AGridLinesColor);
  f.WriteInteger('COLORS', 'imgpaintcolor', AImgPaintColor);
  f.WriteInteger('COLORS', 'imgnopaintcolor', AImgNoPaintColor);
  f.WriteInteger('COLORS', 'imggrayedcolor', AImgGrayedColor);
  f.WriteInteger('COLORS', 'rulercolor', ARulerColor);

  f.WriteInteger('EDITOR', 'analysetype', Ord(AImgAnalisator));
  f.WriteBool('EDITOR', 'invert', AImgInvert);
  f.WriteInteger('EDITOR', 'lightborder', ALightnessBorder);
  f.WriteBool('EDITOR', 'userlightness', AUserSetLightness);
  //f.WriteInteger('EDITOR', 'currnum', FCurrNum);
  f.WriteBool('EDITOR', 'OverwriteCells', OverwriteCells);
  f.WriteBool('EDITOR', 'InvertBg', InvertBackground);
  f.WriteFloat('EDITOR', 'GammaCoeff', AGammaCoeff);
  f.WriteInteger('EDITOR', 'PxFormat', Ord(APxFormat));
  f.WriteInteger('EDITOR', 'CrossWidth', ACrossWidth);
  f.WriteInteger('EDITOR', 'CrossHeight', ACrossHeight);
  f.WriteString('EDITOR', 'LastImgFolder', LastImgFolder);

  f.Free;
end;

procedure TfrmSettings.SetCellHeight(value: integer);
begin
  if value < 8 then value := 8;
  if frmMain.CurrGame = cgSudoku then FSCellHeight := value
  else FJCellHeight := value;
end;

procedure TfrmSettings.SetCellWidth(value: integer);
begin
  if value < 8 then value := 8;
  if frmMain.CurrGame = cgSudoku then FSCellWidth := value
  else FJCellWidth := value;
end;

procedure TfrmSettings.SetControls;
begin
  SetIndividualGameControls;
  chbAutoCellSize.Checked := AutoCellSize;
  chbAutoCellSizeClick(chbAutoCellSize);
  edCellWidth.Value := ACellWidth;
  edCellHeight.Value := ACellHeight;
  edFatLineWidth.Value := AFatLinesWidth;
  edLinesWidth.Value := ALinesWidth;
  chbAutosave.Checked := Autosave;
  edAutosaveInterval.Value := AutosaveInterval;
  chbAutosaveClick(self);
  edBackgroundColor.Color := ABackgroundColor;
  edCapFontColor.Color := ACapFontColor;
  edCapOpenColor.Color := ACapOpenColor;
  edCapBackColor.Color := ACapBackColor;
  edCapOpenBackColor.Color := ACapOpenBackColor;
  edLinesColor.Color := AGridLinesColor;
  edImgPaintColor.Color := AImgPaintColor;
  edImgNoPaintColor.Color := AImgNoPaintColor;
  edImgGrayedColor.Color := AImgGrayedColor;
  edRulerColor.Color := ARulerColor;
  chbNegative.Checked := AImgInvert;
  chbLightnessBorder.Checked := AUserSetLightness;
  chbShowCellsHint.Checked := AShowCellsHint;
  chbFirstRun.Checked := AFirstRun;
  chbLightnessBorderClick(self);
  case ARulerArea of
    raNone: rbnRANone.Checked := true;
    raBoth: rbnRABoth.Checked := true;
    raGame: rbnRAGame.Checked := true;
    raEditor: rbnRAEditor.Checked := true;
  end;
  case ARulerStyle of
    rsLines: rbnRSLine.Checked := true;
    rsStroke: rbnRSStroke.Checked := true;
    rsDot: rbnRSDot.Checked := true;
    rsInversDot: rbnRSInversDot.Checked := true;
  end;
  case AImgAnalisator of
    iaLightness: rbnLightness.Checked := true;
    iaSaturation: rbnSaturation.Checked := true;
    iaRed: rbnRed.Checked := true;
    iaGreen: rbnGreen.Checked := true;
    iaBlue: rbnBlue.Checked := true;
    iaMono: rbnMonoPal.Checked := true;
  end;
  case AOnGameChange of
    0: rbnNew.Checked := true;
    1: rbnLoad.Checked := true;
    2: rbnRequest.Checked := true;
    3: rbnNone.Checked := true;
  end;

  edGammaCoeff.Value := AGammaCoeff;
  edLightnessBorder.Value := ALightnessBorder;
  trbLightness.Position := ALightnessBorder;
  cbCapCellStyle.ItemIndex := Ord(ACapCellStyle);
  cbCapCellChStyle.ItemIndex := ACapCellChStyle + 1;
  cbFieldCellStyle.ItemIndex := Ord(AFCellStyle);
  cbFieldCellChStyle.ItemIndex := AFCellChStyle + 1;
  cbDifficulty.ItemIndex := Ord(ADifficulty);
  cbStartAction.ItemIndex := AStartAction;
  chbCloseGameConfirm.Checked := ACloseGameConfirm;
  chbCloseEditorConfirm.Checked := ACloseEditorConfirm;
  edFontSize.Value := ACellFontSize;
  cbFontName.ItemIndex := cbFontName.Items.IndexOf(ACellFontName);
  chbFontBold.Checked := (fsBold in ACellFontStyle);
  chbFontItalic.Checked := (fsItalic in ACellFontStyle);
  chbFontUnderline.Checked := (fsUnderline in ACellFontStyle);
  chbFontStrikeout.Checked := (fsStrikeOut in ACellFontStyle);
  cbFontNameChange(cbFontName);
  chbFastSudoku.Checked := AFastSudoku;
  chbOverwriteCells.Checked := OverwriteCells;
  chbInvertBg.Checked := InvertBackground;

  case APxFormat of
    pf1bit: chbPxFormat.ItemIndex := 0;
    pf4bit: chbPxFormat.ItemIndex := 1;
    pf8bit: chbPxFormat.ItemIndex := 2;
    //pf15bit, pf16bit: chbPxFormat.ItemIndex := 3;
    //pf24bit: chbPxFormat.ItemIndex := 3;
    pf32bit: chbPxFormat.ItemIndex := 3;
    else chbPxFormat.ItemIndex := 1;
  end;
end;

procedure TfrmSettings.SetIndividualGameControls;
begin
  cbDifficulty.Enabled := frmMain.GetGameState <> gsGame;
  Label24.Enabled := frmMain.GetGameState <> gsGame;
  cbCapCellStyle.Enabled := frmMain.CurrGame <> cgSudoku;
  label20.Enabled := frmMain.CurrGame <> cgSudoku;
  cbCapCellChStyle.Enabled := frmMain.CurrGame <> cgSudoku;
  label22.Enabled := frmMain.CurrGame <> cgSudoku;
  edImgPaintColor.Enabled := frmMain.CurrGame <> cgSudoku;
  edImgNoPaintColor.Enabled := frmMain.CurrGame <> cgSudoku;
  edImgGrayedColor.Enabled := frmMain.CurrGame <> cgSudoku;
  label7.Enabled := frmMain.CurrGame <> cgSudoku;
  label8.Enabled := frmMain.CurrGame <> cgSudoku;
  label12.Enabled := frmMain.CurrGame <> cgSudoku;
  label28.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  edFontSize.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  label27.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  cbFontName.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  label29.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  lblFontExample.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  chbFontBold.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  chbFontItalic.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  chbFontUnderline.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
  chbFontStrikeout.Enabled := frmMain.CurrGame <> cgJCrossPuzzle;
end;

procedure TfrmSettings.trbLightnessChange(Sender: TObject);
begin
  edLightnessBorder.Value := trbLightness.Position;
end;

procedure TfrmSettings.tvPartitionChange(Sender: TObject; Node: TTreeNode);
{var
  nid: integer;}

begin
{  nid := -1;
  if (Node.Text = 'Основные') then nid := 0
  else if (Node.Text = 'Общие') then nid := 1
  else if (Node.Text = 'Игра') then nid := 2
  else if (Node.Text = 'Поведение') then nid := 3
  else if (Node.Text = 'Оформление') then nid := 4
  else if (Node.Text = 'Стили и размеры') then nid := 5
  else if (Node.Text = 'Цвета') then nid := 6
  else if (Node.Text = 'Редактор') then nid := 7
  else if (Node.Text = 'Автоматика') then nid := 8;}
  ChangePartControls(Node.AbsoluteIndex);
end;

procedure TfrmSettings.tvPartitionCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.HasChildren then Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];

  if (cdsSelected in State) then
  begin
    Sender.Canvas.Font.Color := clMaroon;
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
  end;
end;

end.
