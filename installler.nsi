; GENERAL ----------------------------------------------------------------------
!include MUI2.nsh
Name "�������� ���������"
OutFile ".\jcp_install.exe"
InstallDir "$PROGRAMFILES\Jap Cross-puzzle"
InstallDirRegKey HKLM "Software\Jap Cross-puzzle" "Install_Dir"
RequestExecutionLevel admin
XPStyle on
SetDatablockOptimize on
AutoCloseWindow false
ShowInstDetails show
ShowUninstDetails show
Caption "��������� ��������� ����������"
  
VIAddVersionKey "ProductName" "Jap Cross-puzzle"
VIAddVersionKey "Comments" ""
VIAddVersionKey "CompanyName" 'ViSla'
VIAddVersionKey "LegalTrademarks" 'ViSla TM'
VIAddVersionKey "LegalCopyright" '� ViSla'
VIAddVersionKey "FileDescription" "Jap Cross-puzzle installer"
VIAddVersionKey "FileVersion" "4.0.0.0"
VIProductVersion "4.0.0.0"

Var StartMenuFolder

; DEFINES ----------------------------------------------------------------------
; ������������� ������
!define MUI_ABORTWARNING

; ������
;!define MUI_ICON "ico\logo.ico"  
;!define MUI_UNICON "\uninst.ico"

; ��������� �� �������� ����������� � 3 ������
!define MUI_WELCOMEPAGE_TITLE_3LINES

; ������� �������� �������� (���� �� ���������, �� ������ ������ "�����" ����� "�������")
!define MUI_LICENSEPAGE_CHECKBOX
!define MUI_LICENSEPAGE_CHECKBOX_TEXT "� �������� ������� ������������� ����������"

; �������� ��������������� ����������� ����������� �����, (�� ��������� �����)  
!define MUI_COMPONENTSPAGE_SMALLDESC

; ������� � ������ ��� ����� � �����, ��������� ������������� (��� ������������) 
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "SOFTWARE\Jap Cross-puzzle" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenuFolder"

; �������� ����� ���������
!define MUI_FINISHPAGE_SHOWREADME "readme.txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "���������� ��������"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED

; �� ��������� ����� ��������� ��������� ���������, ���� ����� ���� ���������� ���
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

; PAGES ------------------------------------------------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ".\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU App $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; LANGUAGE ----------------------------------------------------------------------
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_RESERVEFILE_LANGDLL

; INST TYPES -------------------------------------------------------------------
!ifndef NOINSTTYPES
  InstType "������ ���������"
!endif

; SECTIONS ---------------------------------------------------------------------

Section "����� ���������" sBase
  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r ".\data"
  File /r ".\help"
  File /r ".\jpz.exe"
  File /r ".\license.txt"
  File /r ".\readme.txt"
  WriteUninstaller "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_BEGIN App
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\���������������� ����.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
    CopyFiles "$INSTDIR\readme.txt" "$SMPROGRAMS\$StartMenuFolder\readme.txt" 0
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\������.lnk" "$INSTDIR\Help\Help.htm" "" "" 0
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\�������� ���������.lnk" "$INSTDIR\jpz.exe" "" "$INSTDIR\jpz.exe" 0
  !insertmacro MUI_STARTMENU_WRITE_END
  ; ������� ����� - ����� ��������� ��������, ��� ������ �� �����������  
  StrCpy $0 "0"
SectionEnd

Section "������� ����� �� ������� �����" sLinks
  SectionIn 1
  StrCpy $0 "1"
  CreateShortCut "$DESKTOP\�������� ���������.lnk" "$INSTDIR\jpz.exe" "" "$INSTDIR\jpz.exe" 0
SectionEnd

Section ""
  WriteRegStr HKLM "SOFTWARE\Jap Cross-puzzle" "Install_Dir" "$INSTDIR"
  DetailPrint "������ ���� ������� HKLM SOFTWARE\Jap Cross-puzzle"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle" "DisplayName" "�������� ���������"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle" "UninstallString" '"$INSTDIR\uninst.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle" "NoRepair" 1
  DetailPrint "������ ���� ������� HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle"
  WriteRegStr HKLM "SOFTWARE\Jap Cross-puzzle" "Links" $0
  DetailPrint "������ �������� ������� HKLM SOFTWARE\Jap Cross-puzzle"
SectionEnd

; DESCRIPTIONS -----------------------------------------------------------------
; LangStrings
LangString DESC_sBase ${LANG_RUSSIAN} "�������� ����� ���������"
LangString DESC_sLinks ${LANG_RUSSIAN} "������� ����� ��� ������� ���� �� ������� �����"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${sBase} $(DESC_sBase)
  !insertmacro MUI_DESCRIPTION_TEXT ${sLinks} $(DESC_sLinks)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;-------------------------------------------------------------------------------

; Uninstaller ------------------------------------------------------------------

Section "Uninstall"
  ; ������� �������� ��������� ���������
  !insertmacro MUI_STARTMENU_GETFOLDER App $StartMenuFolder
  ReadRegStr $0 HKLM "SOFTWARE\Jap Cross-puzzle" "Links"   
  RMDir /r "$SMPROGRAMS\$StartMenuFolder"
  StrCmp $0 "0" NoLinks
    Delete "$DESKTOP\�������� ���������.lnk"
  NoLinks:
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle"
  DetailPrint "������ ���� ������� HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Jap Cross-puzzle"
  DeleteRegKey HKLM "SOFTWARE\Jap Cross-puzzle"
  DetailPrint "������ ���� ������� HKLM SOFTWARE\Jap Cross-puzzle"
  RMDir /r "$INSTDIR"
SectionEnd
