program jpz;

uses
  Forms,
  sudoku in 'units\sudoku.pas' {frmPrompt},
  about in 'units\about.pas' {fAbout},
  cpuzzle in 'units\cpuzzle.pas' {fmPrompt},
  frmCCPuzzle in 'units\frmCCPuzzle.pas' {FmCCrossPuzzle: TFrame},
  frmCommon in 'units\frmCommon.pas' {CommonFrame: TFrame},
  frmJCPuzzle in 'units\frmJCPuzzle.pas' {FmJCrossPuzzle: TFrame},
  frmSudoku in 'units\frmSudoku.pas' {FmSudoku: TFrame},
  GifImage in 'units\GifImage.pas',
  help in 'units\help.pas' {frmHelp},
  imgUtils in 'units\imgUtils.pas',
  InputSize in 'units\InputSize.pas' {frmInputSize},
  jsCommon in 'units\jsCommon.pas',
  main in 'units\main.pas' {frmMain},
  NewSudoku in 'units\NewSudoku.pas' {fNewSudoku},
  pgrid in 'units\pgrid.pas',
  puzzle in 'units\puzzle.pas' {fPrompt},
  Records in 'units\Records.pas' {frmRecords},
  selbox in 'units\selbox.pas' {fSelectBox},
  select_puzzle in 'units\select_puzzle.pas' {frmOpenPuzzle},
  settings in 'units\settings.pas' {frmSettings},
  splash in 'units\splash.pas' {fSplash},
  toolbox in 'units\toolbox.pas' {FToolBox},
  propertys in 'units\propertys.pas' {FProps};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'японский кроссворд';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
