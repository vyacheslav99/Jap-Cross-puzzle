unit toolbox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, ComCtrls, ExtCtrls,
  Buttons, jsCommon, settings, Vcl.Samples.Spin, DBCtrlsEh;

type
  TFToolBox = class(TForm)
    pGSCross: TPanel;
    Label25: TLabel;
    Bevel3: TBevel;
    rbnLightness: TRadioButton;
    rbnSaturation: TRadioButton;
    rbnRed: TRadioButton;
    rbnGreen: TRadioButton;
    rbnBlue: TRadioButton;
    rbnMonoPal: TRadioButton;
    chbLightnessBorder: TCheckBox;
    Label26: TLabel;
    trbLightness: TTrackBar;
    pColorCross: TPanel;
    Label30: TLabel;
    Label31: TLabel;
    chbPxFormat: TComboBox;
    pAllCross: TPanel;
    chbNegative: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnOK: TBitBtn;
    edLightnessBorder: TSpinEdit;
    edWidth: TSpinEdit;
    edHeight: TSpinEdit;
    edGammaCoeff: TDBNumberEditEh;
    procedure trbLightnessChange(Sender: TObject);
    procedure edLightnessBorderChange(Sender: TObject);
    procedure chbLightnessBorderClick(Sender: TObject);
    procedure rbnLightnessClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
  private
    FGameType: TCurrGame;
    FImpType: TGameAction;
    procedure SetControls;
    procedure ShowControls;
    procedure SaveControls;
  public
    function ShowDlg(AGameType: TCurrGame; AImpType: TGameAction): boolean;
  end;

implementation

{$R *.dfm}

uses main, frmCommon;

procedure TFToolBox.btnOKClick(Sender: TObject);
begin
  self.Close;
end;

procedure TFToolBox.chbLightnessBorderClick(Sender: TObject);
begin
  edLightnessBorder.Enabled := chbLightnessBorder.Checked;
  trbLightness.Enabled := chbLightnessBorder.Checked;
  label26.Enabled := chbLightnessBorder.Checked;
end;

procedure TFToolBox.edLightnessBorderChange(Sender: TObject);
begin
  trbLightness.Position := edLightnessBorder.Value;
end;

procedure TFToolBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TFToolBox.rbnLightnessClick(Sender: TObject);
var
  b: boolean;

begin
  case FImpType of
    gaImport, gaImport2:
    begin
      if TRadioButton(Sender) <> rbnMonoPal then
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
        edLightnessBorder.Value := round(edLightnessBorder.MaxValue / 2);
        trbLightness.Position := round(trbLightness.Max / 2);
      end;
    end;
    gaImport3:
    begin
      if edLightnessBorder.MaxValue > 96 then
      begin
        edLightnessBorder.MaxValue := 96;
        trbLightness.Max := 96;
        edLightnessBorder.Value := round(edLightnessBorder.MaxValue / 2);
        trbLightness.Position := round(trbLightness.Max / 2);
      end;
    end;
  end;
end;

procedure TFToolBox.SaveControls;
begin
  if rbnLightness.Checked then frmSettings.AImgAnalisator := iaLightness
  else if rbnSaturation.Checked then frmSettings.AImgAnalisator := iaSaturation
  else if rbnRed.Checked then frmSettings.AImgAnalisator := iaRed
  else if rbnGreen.Checked then frmSettings.AImgAnalisator := iaGreen
  else if rbnBlue.Checked then frmSettings.AImgAnalisator := iaBlue
  else if rbnMonoPal.Checked then frmSettings.AImgAnalisator := iaMono;
  frmSettings.AUserSetLightness := chbLightnessBorder.Checked;
  frmSettings.ALightnessBorder := edLightnessBorder.Value;
  frmSettings.AGammaCoeff := edGammaCoeff.Value;
  case chbPxFormat.ItemIndex of
    0: frmSettings.APxFormat := pf1bit; //моно
    1: frmSettings.APxFormat := pf4bit; //16 цв.
    2: frmSettings.APxFormat := pf8bit; //256 цв.
    //3: frmSettings.APxFormat := pf16bit; //65536 цв., то же что и pf15bit
    //3: frmSettings.APxFormat := pf24bit; //24 bit
    3: frmSettings.APxFormat := pf32bit; //32 bit
    else frmSettings.APxFormat := pf4bit;
  end;
  frmSettings.AImgInvert := chbNegative.Checked;
  frmSettings.ACrossWidth := edWidth.Value;
  frmSettings.ACrossHeight := edHeight.Value;
end;

procedure TFToolBox.SetControls;
begin
  case frmSettings.AImgAnalisator of
    iaLightness: rbnLightness.Checked := true;
    iaSaturation: rbnSaturation.Checked := true;
    iaRed: rbnRed.Checked := true;
    iaGreen: rbnGreen.Checked := true;
    iaBlue: rbnBlue.Checked := true;
    iaMono: rbnMonoPal.Checked := true;
  end;
  chbLightnessBorder.Checked := frmSettings.AUserSetLightness;
  chbLightnessBorderClick(chbLightnessBorder);
  edLightnessBorder.Value := frmSettings.ALightnessBorder;
  trbLightness.Position := frmSettings.ALightnessBorder;
  edGammaCoeff.Value := frmSettings.AGammaCoeff;
  chbNegative.Checked := frmSettings.AImgInvert;
  case frmSettings.APxFormat of
    pf1bit: chbPxFormat.ItemIndex := 0;
    pf4bit: chbPxFormat.ItemIndex := 1;
    pf8bit: chbPxFormat.ItemIndex := 2;
    //pf15bit, pf16bit: chbPxFormat.ItemIndex := 3;
    //pf24bit: chbPxFormat.ItemIndex := 3;
    pf32bit: chbPxFormat.ItemIndex := 3;
    else chbPxFormat.ItemIndex := 1;
  end;
  edWidth.MaxValue := PUZZLESIZELIMIT;
  edHeight.MaxValue := PUZZLESIZELIMIT;
  edWidth.Value := frmSettings.ACrossWidth;
  edHeight.Value := frmSettings.ACrossHeight;
end;

procedure TFToolBox.ShowControls;
begin
  pGSCross.Visible := false;
  pColorCross.Visible := false;
  pAllCross.Visible := true;
  self.ClientWidth := pGSCross.Width;
  case FGameType of
    cgJCrossPuzzle:
    begin
      pGSCross.Visible := true;
      pGSCross.Top := 0;
      pAllCross.Top := pGSCross.Height;
      case FImpType of
        gaImport:
        begin
          rbnMonoPal.Caption := 'Преобразование палитры в ч/б';
          Label2.Hint := 'Реально размерность кроссворда совпадет с указанным здесь значением только по наибольшему из измерений';
          Label3.Hint := Label2.Hint;
          Label4.Hint := Label2.Hint;
        end;
        gaImport2:
        begin
          rbnMonoPal.Caption := 'Простое преобразование';
          Label2.Enabled := false;
          Label3.Enabled := false;
          Label4.Enabled := false;
          edWidth.Enabled := false;
          edHeight.Enabled := false;
        end;
        gaImport3:
        begin
          Label25.Enabled := false;
          if (not rbnLightness.Checked) and (not rbnSaturation.Checked) then rbnLightness.Checked := true
          else rbnLightnessClick(rbnLightness);
          rbnLightness.Caption := 'Степень плотности символа';
          rbnSaturation.Caption := 'Наличие или отсутсвие символа';
          rbnRed.Enabled := false;
          rbnGreen.Enabled := false;
          rbnBlue.Enabled := false;
          rbnMonoPal.Enabled := false;
          chbLightnessBorder.Caption := 'Задать порог плотности символа';
          Label26.Caption := 'Лёгкие                                 |                              Плотные';
          Label2.Caption := 'Отступы:';
          Label3.Caption := 'Слева';
          Label4.Caption := 'Сверху';
          edWidth.MinValue := 0;
          edHeight.MinValue := 0;
          chbNegative.Caption := 'Инвертировать';
          edWidth.Value := 0;
          edHeight.Value := 0;
        end;
      end;
    end;
    cgCCrossPuzzle:
    begin
      pColorCross.Visible := true;
      pColorCross.Top := 0;
      pAllCross.Top := pColorCross.Height;
    end;
  end;
  self.Height := pAllCross.Height + pAllCross.Top + 65;
end;

function TFToolBox.ShowDlg(AGameType: TCurrGame; AImpType: TGameAction): boolean;
begin
  result := false;
  FGameType := AGameType;
  FImpType := AImpType;
  SetControls;
  ShowControls;
  self.ShowModal;
  SaveControls;
  self.Free;
  result := true;
end;

procedure TFToolBox.trbLightnessChange(Sender: TObject);
begin
  edLightnessBorder.Value := trbLightness.Position;
end;

end.
