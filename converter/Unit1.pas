unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, jsCommon;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
  private
    Files: TStringList;
    procedure ScanFolder(fldr: string; FilesList: TStringList);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  fdest, fsrc: TFileStream;
  i, j: integer;
  name: string;
  head: TCoreFileHeader;

begin
  Screen.Cursor := crHourGlass;
  Files := TStringList.Create;
  ScanFolder(ExtractFileDir(Application.ExeName) + '\data', Files);
  ProgressBar1.Max := Files.Count;
  ProgressBar1.Position := 0;

  for i := 0 to Files.Count - 1 do
  begin
    name := ChangeFileExt(ExtractFileName(Files.Strings[i]), '');
    fsrc := TFileStream.Create(Files.Strings[i], fmOpenRead);
    fdest := TFileStream.Create(Files.Strings[i] + '.new', fmCreate);
    fsrc.Read(head, SizeOf(TCoreFileHeader));
    head.sz_name := Length(name);
    fdest.Write(head, SizeOf(TCoreFileHeader));
    for j := 1 to head.sz_name do fdest.Write(name[j], 1);
    fdest.CopyFrom(fsrc, fsrc.Size - fsrc.Position);

    fsrc.Free;
    fdest.Free;

    DeleteFile(Files.Strings[i]);
    RenameFile(Files.Strings[i] + '.new', Files.Strings[i]);
    DeleteFile(Files.Strings[i] + '.new');
    ProgressBar1.Position := i;
    Application.ProcessMessages;
  end;
  Files.Free;
  Screen.Cursor := crDefault;
end;

procedure TForm1.ScanFolder(fldr: string; FilesList: TStringList);
var
  sr: TSearchRec;
  i: integer;

begin
  FilesList.Clear;
  i := FindFirst(fldr + '\*.*', faAnyFile, sr);
  while i = 0 do
  begin
    if ((sr.Attr and faDirectory) <> faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
      if (ExtractFileExt(sr.Name) = '.cpz') or (ExtractFileExt(sr.Name) = '.jpz') or
        (ExtractFileExt(sr.Name) = '.spz') then
        FilesList.Add(fldr + '\' + sr.Name);
    i := FindNext(sr);
  end;
  FindClose(sr);
end;

end.
