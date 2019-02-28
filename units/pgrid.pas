unit pgrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Menus, jsCommon;

type
  TPanelGrid = class;

  TPanelCell = class(TObject)
  private
    FPanel: TPanel;
    FParent: TPanelGrid;
    FRow: integer;
    FCol: integer;
    BeforeSelectColor: TColor;
    FIsBlack: boolean;

    procedure SetStyle(value: TCellStyle);
    procedure SetFont(value: TFont);
    procedure SetColor(value: TColor);
    procedure SetText(value: string);
    function GetStyle: TCellStyle;
    function GetFont: TFont;
    function GetColor: TColor;
    function GetText: string;
    function GetLeft: integer;
    function GetTop: integer;
    function GetHeight: integer;
    function GetWidth: integer;
    function GetRect: TRect;
    procedure SetRow(ARow: integer);
    function GetHint: string;
    procedure SetHint(value: string);
    function GetShowHint: boolean;
    procedure SetShowHint(const Value: boolean);
  public
    constructor Create(AParent: TPanelGrid);
    destructor Destroy; override;

    property Left: integer read GetLeft;
    property Top: integer read GetTop;
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;
    property Rect: TRect read GetRect;
    property Row: integer read FRow;
    property Col: integer read FCol;
    property Font: TFont read GetFont write SetFont;
    property Color: TColor read GetColor write SetColor;
    property Style: TCellStyle read GetStyle write SetStyle;
    property Text: string read GetText write SetText;
    property IsBlack: boolean read FIsBlack;
    property Hint: string read GetHint write SetHint;
    property ShowHint: boolean read GetShowHint write SetShowHint;
  end;

  TPCells = array of array of TPanelCell;

  TPanelGrid = class(TPanel)
  private
    FCells: TPCells;
    FCurrCell: TPanelCell;
    FColCount: integer;
    FRowCount: integer;
    FCellsWidth: byte;
    _FCellsWidth: byte;
    FCellsHeight: byte;
    _FCellsHeight: byte;
    FGridLinesWidth: byte;
    _FGridLinesWidth: byte;
    FFatLinesWidth: byte;
    _FFatLinesWidth: byte;
    FFatLinesInterval: byte;
    _FFatLinesInterval: byte;
    FFirstFatRow: byte;
    _FFirstFatRow: byte;
    FFirstFatCol: byte;
    _FFirstFatCol: byte;
    FGridLinesColor: TColor;
    FCellsStyle: TCellStyle;
    FCellsColor: TColor;
    FCellsFont: TFont;
//    FOnGridResize: TNotifyEvent;
    FOnCellClick: TOnCellClick;
    FOnCellDblClick: TOnCellClick;
    FSelection: TRect;
    MousePressed: boolean;
    FShowCellHint: boolean;

    procedure CellPanelClick(Sender: TObject);
    procedure CellPanelDblClick(Sender: TObject);
    procedure CellPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CellPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CellPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    function GetCell(ARow, ACol: integer): TPanelCell;
    procedure SetCellsStyle(value: TCellStyle);
    procedure SetCellsColor(value: TColor);
    procedure SetCellsFont(value: TFont);
    procedure SetColCount(value: integer);
    procedure SetRowCount(value: integer);
    procedure SetCellsWidth(value: byte);
    procedure SetCellsHeight(value: byte);
    procedure SetGridLinesWidth(value: byte);
    procedure SetFatLinesWidth(value: byte);
    procedure SetFatLinesInterval(value: byte);
    procedure SetGridLinesColor(value: TColor);
    procedure SetFirstFatRow(value: byte);
    procedure SetFirstFatCol(value: byte);
    function CreateCell(ARow, ACol: integer): TPanelCell;
    function CalcPos(ARow, ACol, ElemSize, DelimWidth, FatDelimWidth, FatStartPos, FatInterval: integer; row: boolean): integer;
    procedure SetCellsFontSize(value: integer);
    procedure SetCellsFontColor(value: TColor);
    procedure PickPanelSize;
    procedure ClearSelectionColors;
    procedure AddToSelection(ARow, ACol: integer);
    procedure SelectionPaint;
    function FindCellOnPanel(Panel: TPanel): TPanelCell;
    procedure SetCellShowHint(const Value: boolean);
    procedure SetCurrCell(value: TPanelCell); overload;
  public
    FPrCallBack: TProgressFunc;

    constructor Create(AParent: TWinControl);
    destructor Destroy; override;

    procedure ClearSelection;
    procedure SetSelection(ARect: TRect);
    procedure RefreshCells;
 //   procedure SetCurrCell(ARow, ACol: byte); overload;

    property DefaultCellsStyle: TCellStyle read FCellsStyle write SetCellsStyle;
    property DefaultCellsColor: TColor read FCellsColor write SetCellsColor;
    property DefaultCellsFont: TFont read FCellsFont write SetCellsFont;
    property DefaultShowHint: boolean read FShowCellHint write SetCellShowHint;
    property OnCellClick: TOnCellClick read FOnCellClick write FOnCellClick;
    property OnCellDblClick: TOnCellClick read FOnCellDblClick write FOnCellDblClick;
    property ColCount: integer read FColCount write SetColCount;
    property RowCount: integer read FRowCount write SetRowCount;
    property CellsWidth: byte read FCellsWidth write SetCellsWidth;
    property CellsHeight: byte read FCellsHeight write SetCellsHeight;
    property GridLinesWidth: byte read FGridLinesWidth write SetGridLinesWidth;
    property FatLinesWidth: byte read FFatLinesWidth write SetFatLinesWidth;
    property FatLinesInterval: byte read FFatLinesInterval write SetFatLinesInterval;
    property GridLinesColor: TColor read FGridLinesColor write SetGridLinesColor;
    property FirstFatRow: byte read FFirstFatRow write SetFirstFatRow;
    property FirstFatCol: byte read FFirstFatCol write SetFirstFatCol;
    property CellsFontSize: integer write SetCellsFontSize;
    property CellsFontColor: TColor write SetCellsFontColor;
    property Cell[ARow, ACol: integer]: TPanelCell read GetCell;
    property CurrCell: TPanelCell read FCurrCell write SetCurrCell;
    property Selection: TRect read FSelection;
  end;

implementation

{ TPanelGrid }

procedure TPanelGrid.AddToSelection(ARow, ACol: integer);
begin
  ClearSelectionColors;

  if ARow > Selection.Top then
    if ARow > Selection.Bottom then
      FSelection.Bottom := ARow
    else
  else
    if ARow < Selection.Top then
      FSelection.Top := ARow;

  if ACol > Selection.Left then
    if ACol > Selection.Right then
      FSelection.Right := ACol
    else
  else
    if ACol < Selection.Left then
      FSelection.Left := ACol;

  if (FSelection.Left <> FSelection.Right) or (FSelection.Top <> FSelection.Bottom) then
    SelectionPaint;
end;

function TPanelGrid.CalcPos(ARow, ACol, ElemSize, DelimWidth, FatDelimWidth, FatStartPos, FatInterval: integer; row: boolean): integer;
var
  c: TPanelCell;
  x, y, n: integer;

begin
  result := 1;
  if row then
  begin
    x := ARow - 1;
    y := ACol;
  end else
  begin
    x := ARow;
    y := ACol - 1;
  end;
  c := GetCell(x, y);
  if (not Assigned(c)) then exit;
  if row then
  begin
    result := c.Top + c.Height;
    n := ARow;
  end else
  begin
    result := c.Left + c.Width;
    n := ACol;
  end;

  if (FatDelimWidth > 1) then
    if (FatStartPos = n) or ((FatStartPos < n) and (Frac((n - FatStartPos) / FatInterval) = 0)) then
    begin
      result := result + FatDelimWidth;
      if not (FatStartPos = n) then c.FIsBlack := true;
    end else
      result := Result + DelimWidth
  else
    result := Result + DelimWidth;
end;

procedure TPanelGrid.CellPanelClick(Sender: TObject);
var
  r: TRect;
  cell: TPanelCell;

begin
  if Sender is TPanel then
  begin
    cell := FindCellOnPanel(TPanel(Sender));
    if cell = nil then exit;
    FCurrCell := cell;
    if Assigned(OnCellClick) then
    begin
      r.Left := FCurrCell.Left;
      r.Top := FCurrCell.Top;
      r.Right := FCurrCell.Left + FCurrCell.Width;
      r.Bottom := FCurrCell.Top + FCurrCell.Height;
      OnCellClick(Sender, r, FCurrCell.FRow, FCurrCell.FCol);
    end;
  end;
end;

procedure TPanelGrid.CellPanelDblClick(Sender: TObject);
var
  r: TRect;
  cell: TPanelCell;

begin
  if Sender is TPanel then
  begin
    cell := FindCellOnPanel(TPanel(Sender));
    if cell = nil then exit;
    FCurrCell := cell;
    if Assigned(OnCellDblClick) then
    begin
      r.Left := FCurrCell.Left;
      r.Top := FCurrCell.Top;
      r.Right := FCurrCell.Left + FCurrCell.Width;
      r.Bottom := FCurrCell.Top + FCurrCell.Height;
      OnCellDblClick(Sender, r, FCurrCell.FRow, FCurrCell.FCol);
    end;
  end;
end;

procedure TPanelGrid.CellPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cell: TPanelCell;

begin
  MousePressed := true;
  if Sender is TPanel then
  begin
    cell := FindCellOnPanel(TPanel(Sender));
    if cell = nil then exit;
    FCurrCell := cell;
    if not (ssShift in Shift) then
      SetSelection(Rect(cell.Col, cell.Row, cell.Col, cell.Row));
    if (ssShift in Shift) then
      AddToSelection(cell.Row, cell.Col);
    if Assigned(cell.FParent.OnMouseDown) then
      cell.FParent.OnMouseDown(Sender, Button, Shift, X, Y);
  end;
end;

procedure TPanelGrid.CellPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  cell: TPanelCell;
  h: string;

begin
  if Sender is TPanel then
  begin
    cell := FindCellOnPanel(TPanel(Sender));
    if cell = nil then exit;
    if MousePressed then AddToSelection(cell.Row, cell.Col);
    if Assigned(cell.FParent.OnMouseMove) then
    begin
      cell.FParent.OnMouseMove(Sender, Shift, X + cell.Left + cell.FParent.Left, Y + cell.Top + cell.FParent.Top);
      if cell.Text <> '' then
        if cell.ShowHint then
          h := ' "' + cell.Text + '"'#13 + ' стр:' + IntToStr(cell.Row - FirstFatRow + 1) + ', кол:' +
            IntToStr(cell.Col - FirstFatCol + 1) + '|стр:' + IntToStr(cell.Row - FirstFatRow + 1) + ', кол:' +
            IntToStr(cell.Col - FirstFatCol + 1)
        else
          h := ' "' + cell.Text + '" стр:' + IntToStr(cell.Row - FirstFatRow + 1) + ', кол:' + IntToStr(cell.Col - FirstFatCol + 1)
      else
        h := 'стр:' + IntToStr(cell.Row - FirstFatRow + 1) + ', кол:' + IntToStr(cell.Col - FirstFatCol + 1);

      cell.Hint := h;
    end;
  end;
end;

procedure TPanelGrid.CellPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cell: TPanelCell;

begin
  MousePressed := false;
  if Sender is TPanel then
  begin
    cell := FindCellOnPanel(TPanel(Sender));
    if cell = nil then exit;
    if Assigned(cell.FParent.OnMouseUp) then
      cell.FParent.OnMouseUp(Sender, Button, Shift, X, Y);
  end;
end;

procedure TPanelGrid.ClearSelection;
begin
  ClearSelectionColors;
  FSelection.Left := 0;
  FSelection.Top := 0;
  FSelection.Right := 0;
  FSelection.Bottom := 0;
end;

procedure TPanelGrid.ClearSelectionColors;
var
  i, j: integer;

begin
  //восстановим цвета
  for i := FSelection.Top to FSelection.Bottom do
    for j := FSelection.Left to FSelection.Right do
      try
        Cell[i, j].FPanel.Color := Cell[i, j].BeforeSelectColor;
      except
      end;
end;

constructor TPanelGrid.Create(AParent: TWinControl);
begin
  inherited Create(AParent);
  ParentBackground := false;
  ParentColor := false;
  ParentFont := false;
  ParentCtl3D := false;
  Parent := AParent;
  FCellsFont := Font;
  FCellsStyle := csRaised;
  FCellsColor := clBtnFace;
  FColCount := 0;
  FRowCount := 0;
  FGridLinesWidth := 1;
  FFatLinesWidth := 2;
  FFatLinesInterval := 5;
  FGridLinesColor := clBtnFace;
  BevelInner := bvNone;
  BevelOuter := bvRaised;
  BevelKind := bkNone;
  BevelWidth := 1;
  Visible := true;
  SetLength(FCells, 0);
end;

function TPanelGrid.CreateCell(ARow, ACol: integer): TPanelCell;
begin
  result := TPanelCell.Create(self);
  Result.SetRow(ARow);
  result.FCol := ACol;
  result.FPanel.Top := CalcPos(ARow, ACol, FCellsHeight, FGridLinesWidth, FFatLinesWidth, FFirstFatRow, FFatLinesInterval, true);
  result.FPanel.Left := CalcPos(ARow, ACol, FCellsWidth, FGridLinesWidth, FFatLinesWidth, FFirstFatCol, FFatLinesInterval, false);
  result.FPanel.Visible := true;
  result.ShowHint := FShowCellHint;
  result.FPanel.OnClick := CellPanelClick;
  result.FPanel.OnDblClick := CellPanelDblClick;
  result.FPanel.OnMouseDown := CellPanelMouseDown;
  result.FPanel.OnMouseUp := CellPanelMouseUp;
  result.FPanel.OnMouseMove := CellPanelMouseMove;
end;

destructor TPanelGrid.Destroy;
var
  i, j: integer;

begin
  for i := 0 to Length(FCells) - 1 do
    for j := 0 to Length(FCells[i]) - 1 do
      if Assigned(FCells[i][j]) then FCells[i][j].Free;
  SetLength(FCells, 0);

  inherited;
end;

function TPanelGrid.FindCellOnPanel(Panel: TPanel): TPanelCell;
var
  j: integer;

begin
  result := nil;
  if (Length(FCells) <= Panel.Tag) or (Panel.Tag < 0) then exit;
  for j := 0 to Length(FCells[Panel.Tag]) - 1 do
    if FCells[Panel.Tag][j].FPanel = Panel then
    begin
      result := FCells[Panel.Tag][j];
      break;
    end;
end;

function TPanelGrid.GetCell(ARow, ACol: integer): TPanelCell;
begin
  result := nil;
  if (ARow < 0) or (ACol < 0) then exit;
  if (Length(FCells) <= ARow) or (Length(FCells[ARow]) <= ACol) then exit;
  result := FCells[ARow][ACol];
end;

procedure TPanelGrid.PickPanelSize;
begin
  if (FRowCount = 0) or (FColCount = 0) then
  begin
    Height := 1;
    Width := 1;
  end else
  begin
    Width := FCells[FRowCount - 1][FColCount - 1].Left + FCells[FRowCount - 1][FColCount - 1].Width + FGridLinesWidth;
    Height := FCells[FRowCount - 1][FColCount - 1].Top + FCells[FRowCount - 1][FColCount - 1].Height + FGridLinesWidth;
  end;
end;

procedure TPanelGrid.RefreshCells;
var
  i, j, n: integer;
  oldvis: boolean;

begin
  if (FCellsHeight <> _FCellsHeight) or (FCellsWidth <> _FCellsWidth) or
    (_FFatLinesInterval <> FFatLinesInterval) or (_FFatLinesWidth <> FFatLinesWidth) or
    (_FGridLinesWidth <> FGridLinesWidth) or (FFirstFatCol <> _FFirstFatCol) or
    (_FFirstFatRow <> FFirstFatRow) then
  begin
    _FFirstFatCol := FFirstFatCol;
    _FFirstFatRow := FFirstFatRow;
    _FFatLinesInterval := FFatLinesInterval;
    _FFatLinesWidth := FFatLinesWidth;
    _FGridLinesWidth := FGridLinesWidth;

    oldvis := Visible;
    Visible := false;
    n := 1;
    if @FPrCallBack <> nil then
      FPrCallBack(FRowCount * FColCount, 0, '', true);
    try
      for i:= 0 to FRowCount - 1 do
        for j := 0 to FColCount - 1 do
        begin
          if Assigned(FCells[i][j]) then
          begin
            FCells[i][j].FPanel.Height := FCellsHeight;
            FCells[i][j].FPanel.Width := FCellsWidth;
            FCells[i][j].FPanel.Top := CalcPos(i, j, FCellsHeight, FGridLinesWidth, FFatLinesWidth, FFirstFatRow, FFatLinesInterval, true);
            FCells[i][j].FPanel.Left := CalcPos(i, j, FCellsWidth, FGridLinesWidth, FFatLinesWidth, FFirstFatCol, FFatLinesInterval, false);
            FCells[i][j].Font.Size := FCellsFont.Size;
            if @FPrCallBack <> nil then FPrCallBack(0, n, '', true);
          end;
          Inc(n);
        end;
    finally
      if @FPrCallBack <> nil then FPrCallBack(0, 0, '', false);
      PickPanelSize;
      Visible := oldvis;
    end;
  end;
end;

procedure TPanelGrid.SelectionPaint;
var
  i, j: integer;
//  hlscol: THLSColor;

begin
  for i := Selection.Top to Selection.Bottom do
    for j := Selection.Left to Selection.Right do
    try
      Cell[i, j].BeforeSelectColor := Cell[i, j].Color;
      {hlscol := RGBtoHLS(Cell[i, j].FPanel.Color);
      hlscol.S := hlscol.S - round((hlscol.S * 20) / 100);}
      if Cell[i, j].FPanel.Color = 0 then
        Cell[i, j].FPanel.Color := RGB(80, 80, 80)
      else
        Cell[i, j].FPanel.Color := Cell[i, j].FPanel.Color - round((Cell[i, j].FPanel.Color * 20) / 100);
    except
    end;
end;

procedure TPanelGrid.SetCellsColor(value: TColor);
begin
  FCellsColor := value;
end;

procedure TPanelGrid.SetCellsFont(value: TFont);
begin
  FCellsFont := value;
end;

procedure TPanelGrid.SetCellsFontColor(value: TColor);
begin
  FCellsFont.Color := value;
end;

procedure TPanelGrid.SetCellsFontSize(value: integer);
begin
  FCellsFont.Size := value;
end;

procedure TPanelGrid.SetCellsHeight(value: byte);
begin
  FCellsHeight := value;
end;

procedure TPanelGrid.SetCellShowHint(const Value: boolean);
begin
  FShowCellHint := Value;
end;

procedure TPanelGrid.SetCellsStyle(value: TCellStyle);
begin
  FCellsStyle := value;
end;

procedure TPanelGrid.SetCellsWidth(value: byte);
begin
  FCellsWidth := value;
end;

procedure TPanelGrid.SetColCount(value: integer);
var
  i, j: integer;

begin
  if FColCount = value then exit;
  //увеличиваем
  if FColCount < value then
  begin
    for i := 0 to RowCount - 1 do
    begin
      SetLength(FCells[i], value);
      for j := FColCount to value - 1 do
        FCells[i][j] := CreateCell(i, j);
    end;
  end;
  //уменьшаем
  if FColCount > value then
  begin
    for i := 0 to RowCount - 1 do
    begin
      for j := FColCount - 1 downto value do
        if Assigned(FCells[i][j]) then FCells[i][j].Free;
      SetLength(FCells[i], value);
    end;
  end;
  FColCount := value;
  PickPanelSize;
end;

procedure TPanelGrid.SetCurrCell(value: TPanelCell);
begin
  if (value <> nil) then FCurrCell := value;
end;
{
procedure TPanelGrid.SetCurrCell(ARow, ACol: byte);
begin
  if Cell[ARow, ACol] <> nil then FCurrCell := Cell[ARow, ACol];
end;
}
procedure TPanelGrid.SetFirstFatCol(value: byte);
begin
  FFirstFatCol := value;
end;

procedure TPanelGrid.SetFirstFatRow(value: byte);
begin
  FFirstFatRow := value;
end;

procedure TPanelGrid.SetFatLinesInterval(value: byte);
begin
  FFatLinesInterval := value;
end;

procedure TPanelGrid.SetFatLinesWidth(value: byte);
begin
  FFatLinesWidth := value;
end;

procedure TPanelGrid.SetGridLinesColor(value: TColor);
begin
  FGridLinesColor := value;
  Color := FGridLinesColor;
end;

procedure TPanelGrid.SetGridLinesWidth(value: byte);
begin
  FGridLinesWidth := value;
end;

procedure TPanelGrid.SetRowCount(value: integer);
var
  i, j: integer;

begin
  if FRowCount = value then exit;
  //увеличиваем
  if FRowCount < value then
  begin
    SetLength(FCells, value);
    for i := FRowCount to value - 1 do
    begin
      SetLength(FCells[i], FColCount);
      for j := 0 to FColCount - 1 do
        FCells[i][j] := CreateCell(i, j);
    end;
  end;
  //уменьшаем
  if FRowCount > value then
  begin
    for i := FRowCount - 1 downto value do
    begin
      for j := 0 to FColCount - 1 do
        if Assigned(FCells[i][j]) then FCells[i][j].Free;
    end;
    SetLength(FCells, value);
  end;
  FRowCount := value;
  PickPanelSize;
end;

procedure TPanelGrid.SetSelection(ARect: TRect);
begin
  ClearSelectionColors;
  FSelection := ARect;
  if (FSelection.Left <> FSelection.Right) or (FSelection.Top <> FSelection.Bottom) then
    SelectionPaint;
end;

{ TPanelCell }

constructor TPanelCell.Create(AParent: TPanelGrid);
begin
  inherited Create;
  FParent := AParent;
  SetRow(0);
  FCol := 0;
  FPanel := TPanel.Create(AParent);
  FPanel.ParentBackground := false;
  FPanel.ParentColor := false;
  FPanel.ParentFont := false;
  FPanel.ParentCtl3D := false;
  FPanel.Parent := AParent;
  FPanel.Height := FParent.FCellsHeight;
  FPanel.Width := FParent.FCellsWidth;
  FPanel.Anchors := [akLeft, akTop];
  FPanel.Visible := True;
  Font := FParent.DefaultCellsFont;
  Style := FParent.DefaultCellsStyle;
  Color := FParent.DefaultCellsColor;
  BeforeSelectColor := Color;
  FIsBlack := false;
  Text := '';
end;

destructor TPanelCell.Destroy;
begin
  if Assigned(FPanel) then FPanel.Free;
  inherited;
end;

function TPanelCell.GetColor: TColor;
begin
  result := FPanel.Color;
end;

function TPanelCell.GetFont: TFont;
begin
  result := FPanel.Font;
end;

function TPanelCell.GetHeight: integer;
begin
  result := FPanel.Height;
end;

function TPanelCell.GetHint: string;
begin
  result := FPanel.Hint;
end;

function TPanelCell.GetLeft: integer;
begin
  result := FPanel.Left;
end;

function TPanelCell.GetRect: TRect;
begin
  result.Left := FPanel.Left;
  result.Top := FPanel.Top;
  result.Right := FPanel.Left + FPanel.Width;
  result.Bottom := FPanel.Top + FPanel.Height;
end;

function TPanelCell.GetShowHint: boolean;
begin
  result := FPanel.ShowHint;
end;

function TPanelCell.GetStyle: TCellStyle;
begin
  case FPanel.BevelInner of
    bvLowered:
      case FPanel.BevelOuter of
        bvLowered: result := csDeepLowered;
        bvNone: result := csLowered;
        bvRaised, bvSpace: result := csRFrame;
      end;
    bvNone:
      case FPanel.BevelOuter of
        bvLowered: result := csLowered;
        bvNone: result := csNone;
        bvRaised, bvSpace: result := csRaised;
      end;
    bvRaised:
      case FPanel.BevelOuter of
        bvLowered: result := csLFrame;
        bvNone: result := csRaised;
        bvRaised, bvSpace: result := csBigRaised;
      end;
    bvSpace:
      case FPanel.BevelOuter of
        bvLowered: result := csLFrame;
        bvNone: result := csRaised;
        bvRaised, bvSpace: result := csBigRaised;
      end;
  end;
end;

function TPanelCell.GetText: string;
begin
  Result := FPanel.Caption;
end;

function TPanelCell.GetTop: integer;
begin
  result := FPanel.Top;
end;

function TPanelCell.GetWidth: integer;
begin
  result := FPanel.Width;
end;

procedure TPanelCell.SetColor(value: TColor);
begin
  FPanel.Color := value;
  BeforeSelectColor := value;
end;

procedure TPanelCell.SetFont(value: TFont);
begin
  FPanel.Font := value;
end;

procedure TPanelCell.SetHint(value: string);
begin
  FPanel.Hint := value;
//  FPanel.ShowHint := FPanel.Hint <> '';
end;

procedure TPanelCell.SetRow(ARow: integer);
begin
  FRow := ARow;
  if Assigned(FPanel) then FPanel.Tag := FRow;
end;

procedure TPanelCell.SetShowHint(const Value: boolean);
begin
  FPanel.ShowHint := value;
end;

procedure TPanelCell.SetStyle(value: TCellStyle);
begin
  case value of
    csNone:
    begin
      FPanel.BevelInner := bvNone;
      FPanel.BevelOuter := bvNone;
    end;
    csRaised:
    begin
      FPanel.BevelInner := bvRaised;
      FPanel.BevelOuter := bvNone;
    end;
    csBigRaised:
    begin
      FPanel.BevelInner := bvRaised;
      FPanel.BevelOuter := bvRaised;
    end;
    csLowered:
    begin
      FPanel.BevelInner := bvLowered;
      FPanel.BevelOuter := bvNone;
    end;
    csDeepLowered:
    begin
      FPanel.BevelInner := bvLowered;
      FPanel.BevelOuter := bvLowered;
    end;
    csLFrame:
    begin
      FPanel.BevelInner := bvRaised;
      FPanel.BevelOuter := bvLowered;
    end;
    csRFrame:
    begin
      FPanel.BevelInner := bvLowered;
      FPanel.BevelOuter := bvRaised;
    end;
  end;
end;

procedure TPanelCell.SetText(value: string);
begin
  FPanel.Caption := value;
end;

end.
