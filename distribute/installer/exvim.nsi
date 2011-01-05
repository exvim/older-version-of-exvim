;  ======================================================================================
;  File         : exvim.nsi
;  Author       : Wu Jie 
;  Last Change  : 10/09/2010 | 17:41:01 PM | Saturday,October
;  Description  : 
;  ======================================================================================

; /////////////////////////////////////////////////////////////////////////////
; include Modern UI
; /////////////////////////////////////////////////////////////////////////////

!include "MUI2.nsh"
!include "EnvVarUpdate.nsh"

; /////////////////////////////////////////////////////////////////////////////
; General
; /////////////////////////////////////////////////////////////////////////////

; Name and File
Name "exvim installer" 
Caption "exvim installer"
Icon "rawdata\images\exvim_icon.ico"
OutFile "exvim_installer.exe"

; Default installation
; DISABLE: InstallDir "$PROGRAMFILES\exdev"
InstallDir "c:\exdev"

;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\exdev" ""

;Request application privileges for Windows Vista
RequestExecutionLevel user

; /////////////////////////////////////////////////////////////////////////////
; Show splash 
; /////////////////////////////////////////////////////////////////////////////

XPStyle on

Function .onInit
	# the plugins dir is automatically deleted when the installer exits
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "rawdata\images\exvim_splash.bmp"
	#optional
	#File /oname=$PLUGINSDIR\splash.wav "C:\myprog\sound.wav"

	splash::show 500 $PLUGINSDIR\splash

	Pop $0 ; $0 has '1' if the user closed the splash screen early, '0' if everything closed normally, and '-1' if some error occurred.

    # run the install program to check for already installed versions
    SetOutPath $TEMP
    File rawdata\vim\vim73\install.exe
    ExecWait "$TEMP\install.exe -uninstall-check"
    Delete $TEMP\install.exe
FunctionEnd

; /////////////////////////////////////////////////////////////////////////////
; Interface Settings
; /////////////////////////////////////////////////////////////////////////////

!define MUI_ICON "rawdata\images\orange-install.ico"
!define MUI_UNICON "rawdata\images\modern-uninstall-full.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "rawdata\images\exvim_header.bmp" ; optional
!define MUI_BGCOLOR F0F0F0
!define MUI_ABORTWARNING

; /////////////////////////////////////////////////////////////////////////////
; Pages
; /////////////////////////////////////////////////////////////////////////////

;  DISABLE { 
; !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
;  } DISABLE end 
!insertmacro MUI_PAGE_COMPONENTS 
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; /////////////////////////////////////////////////////////////////////////////
; Languages
; /////////////////////////////////////////////////////////////////////////////

!insertmacro MUI_LANGUAGE "English"

; /////////////////////////////////////////////////////////////////////////////
; Installer Sections 
; /////////////////////////////////////////////////////////////////////////////

InstType "full"
InstType "minimal"

;  ------------------------------------------------------------------ 
;  Desc: exvim
;  ------------------------------------------------------------------ 

SectionGroup "!vim" sec_vim

    ;  ======================================================== 
    ;  vim  
    ;  ======================================================== 

    Section "gvim73" sec_gvim
        SectionIn 1 2

        ; copy vim files
        SetOutPath $INSTDIR\tools\exvim
        File /r rawdata\vim\vim73\*

        ; append GnuWin32 bin path to user PATH environment variable
        ;  DISABLE { 
        ;  ReadRegStr $0 HKCU "Environment" "PATH"
        ;  WriteRegExpandStr HKCU "Environment" "PATH" "$INSTDIR\tools\exvim\vim73;$0"
        ;  } DISABLE end 
        ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\tools\exvim\vim73"  
    SectionEnd

    ;  ======================================================== 
    ;  exvim
    ;  ======================================================== 

    Section "exvim" sec_exvim
        SectionIn 1 2

        ; copy vim-plugin files
        SetOutPath $INSTDIR\tools\exvim
        File /r rawdata\vim\exvim\*
    SectionEnd

SectionGroupEnd

;  ------------------------------------------------------------------ 
;  Desc: gnu tools
;  ------------------------------------------------------------------ 

SectionGroup "GNU-tools" sec_gnu_tools

    ;  ======================================================== 
    ;  gawk  
    ;  ======================================================== 

    Section "gawk" sec_gawk
        SectionIn 1

        ; copy gawk files
        SetOutPath $INSTDIR\bin
        File /r rawdata\gnu\bin\gawk.exe
    SectionEnd

    ;  ======================================================== 
    ;  diffutils 
    ;  ======================================================== 

    Section "diffutils" sec_diffutils
        SectionIn 1

        ; copy diff files
        SetOutPath $INSTDIR\bin
        File /r rawdata\gnu\bin\diff.exe
        File /r rawdata\gnu\bin\diff3.exe
    SectionEnd

    ;  ======================================================== 
    ;  id-utils
    ;  ======================================================== 

    Section "id-utils" sec_idutils
        SectionIn 1

        ; copy id-utils files
        SetOutPath $INSTDIR\bin
        File /r rawdata\gnu\bin\lid.exe
        File /r rawdata\gnu\bin\mkid.exe

        ; copy share files
        SetOutPath $INSTDIR\share
        File /r rawdata\gnu\share\id-lang.map
    SectionEnd

    ;  ======================================================== 
    ;  sed
    ;  ======================================================== 

    Section "sed" sec_sed
        SectionIn 1

        ; copy sed files
        SetOutPath $INSTDIR\bin
        File /r rawdata\gnu\bin\libintl3.dll
        File /r rawdata\gnu\bin\libiconv2.dll
        File /r rawdata\gnu\bin\regex2.dll
        File /r rawdata\gnu\bin\sed.exe
    SectionEnd

    ;  ======================================================== 
    ;  src-highlite
    ;  ======================================================== 

    Section "src-highlite" sec_src_highlite
        SectionIn 1

        ; copy src-highlite files
        SetOutPath $INSTDIR\bin
        File /r rawdata\gnu\bin\source-highlight.exe

        ; copy share files
        SetOutPath $INSTDIR\share\source-highlight
        File /r rawdata\gnu\share\source-highlight\*
    SectionEnd

    ;  ======================================================== 
    ;  PostGnuWin32
    ;  ======================================================== 

    Section # "PostGnuWin32"
        ; append GnuWin32 bin path to user PATH environment variable
        ;  DISABLE { 
        ;  ReadRegStr $0 HKCU "Environment" "PATH"
        ;  WriteRegExpandStr HKCU "Environment" "PATH" "$INSTDIR\GnuWin32\bin;$0"
        ;  } DISABLE end 
        ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\bin"  
    SectionEnd

SectionGroupEnd

;  ------------------------------------------------------------------ 
;  Desc: gnu tools
;  ------------------------------------------------------------------ 

SectionGroup "other-tools" sec_other_tools

    ;  ======================================================== 
    ;  Graphviz 
    ;  ======================================================== 

    Section "Graphviz" sec_graphviz
        SectionIn 1

        ; copy grpahviz files
        SetOutPath $INSTDIR\tools\Graphviz
        File /r rawdata\graphviz\*
    
        ; append Graphviz bin path to user PATH environment variable
        ;  DISABLE { 
        ;  ReadRegStr $0 HKCU "Environment" "PATH"
        ;  WriteRegExpandStr HKCU "Environment" "PATH" "$INSTDIR\Graphviz\bin;$0"
        ;  } DISABLE end 
        ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\tools\Graphviz\bin"  
    SectionEnd

    ;  ======================================================== 
    ;  IrfanView 
    ;  ======================================================== 

    Section "IrfanView" sec_irfanview
        SectionIn 1

        ; copy grpahviz files
        SetOutPath $INSTDIR\tools\IrfanView
        File /r rawdata\irfanview\*
    SectionEnd

    ;  ======================================================== 
    ;  fonts  
    ;  ======================================================== 

    Section "fonts" sec_fonts
        SectionIn 1

        File /oname=$FONTS\VeraMono.ttf rawdata\fonts\VeraMono.ttf
        Push "$FONTS\VeraMono.ttf"
        System::Call "Gdi32::AddFontResource(t s) i .s"
        Pop $0
        IntCmp $0 0 0 +2 +2
        MessageBox MB_OK "Failed To Register Fonts VeraMono"
        SendMessage ${HWND_BROADcast} ${WM_FONTCHANGE} 0 0
    SectionEnd

SectionGroupEnd

;  ------------------------------------------------------------------ 
;  Desc: PostInstall 
;  ------------------------------------------------------------------ 

Section # "PostInstall"
    ; Store installation folder
    WriteRegStr HKCU "Software\exdev" "" $INSTDIR

    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; Create Environment variable EX_DEV
    WriteRegStr HKCU "Environment" "EX_DEV" $INSTDIR

    ; Refresh environment variables
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

    ; Register to Add/Remove program in control pannel
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exvim" "DisplayName" "exvim"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exvim" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exvim" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'

    ; File Association
    ; Associate the files
    WriteRegStr HKCR ".vimentry" "" "exvim.vimentry"
    WriteRegStr HKCR "exvim.vimentry" "" "exvim vimentry file"
    WriteRegStr HKCR "exvim.vimentry\shell" "" "open"
    WriteRegStr HKCR "exvim.vimentry\shell\open\command" "" '"$INSTDIR\tools\exvim\vim73\gvim.exe" "%1"'
    ; Add vimentry to new file
    WriteRegStr HKCR ".vimentry\ShellNew" "NullFile" ""
    System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v (0x08000000, 0, 0, 0)'
SectionEnd

; /////////////////////////////////////////////////////////////////////////////
; Descriptions
; /////////////////////////////////////////////////////////////////////////////

;Language strings
LangString DESC_vim ${LANG_ENGLISH} "vim"
LangString DESC_gvim ${LANG_ENGLISH} "Install gvim73 (compile with python,cscope)"
LangString DESC_exvim ${LANG_ENGLISH} "exvim files"

LangString DESC_gnu_tools ${LANG_ENGLISH} "gnu tools"
LangString DESC_gawk ${LANG_ENGLISH} "gawk"
LangString DESC_diffutils ${LANG_ENGLISH} "diffutils"
LangString DESC_idutils ${LANG_ENGLISH} "id-utils"
LangString DESC_sed ${LANG_ENGLISH} "sed"
LangString DESC_src_highlite ${LANG_ENGLISH} "src-highlite"

LangString DESC_other_tools ${LANG_ENGLISH} "other tools"
LangString DESC_graphviz ${LANG_ENGLISH} "Graphviz"
LangString DESC_irfanview ${LANG_ENGLISH} "IrfanView"
LangString DESC_fonts ${LANG_ENGLISH} "Fonts"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_vim} $(DESC_vim)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_gvim} $(DESC_gvim)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_exvim} $(DESC_exvim)

    !insertmacro MUI_DESCRIPTION_TEXT ${sec_gnu_tools} $(DESC_gnu_tools)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_gawk} $(DESC_gawk)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_diffutils} $(DESC_diffutils)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_idutils} $(DESC_idutils)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_sed} $(DESC_sed)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_src_highlite} $(DESC_src_highlite)

    !insertmacro MUI_DESCRIPTION_TEXT ${sec_other_tools} $(DESC_other_tools)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_graphviz} $(DESC_graphviz)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_irfanview} $(DESC_irfanview)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_fonts} $(DESC_fonts)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; /////////////////////////////////////////////////////////////////////////////
; Uninstaller Section
; /////////////////////////////////////////////////////////////////////////////

;  ------------------------------------------------------------------ 
;  Desc: 
;  ------------------------------------------------------------------ 

Function un.onInit
    ; Warning Message
    MessageBox MB_OKCANCEL|MB_ICONINFORMATION "Warning: Uninstall will delete all files under $INSTDIR, include your custom files, please backup your files before uninstall. Click OK to Continue." IDOK true IDCANCEL false
    false:
        Abort
    true:
FunctionEnd

;  ------------------------------------------------------------------ 
;  Desc: 
;  ------------------------------------------------------------------ 

Section "Uninstall"

	# We may have been put to the background when uninstall did something.
	BringToFront
    
    ; remove registry value
    DeleteRegKey /ifempty HKCU "Software\exdev"

    ; remove environment variable EX_DEV
    DeleteRegValue HKCU "Environment" "EX_DEV"

    ; remove the Add/Remove information
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exvim"

    ; remove from environment
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\bin"  
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\tools\Graphviz\bin"
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\tools\exvim\vim73"  

    ; Refresh environment variables
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000 

    ; remove file association ane new item
    DeleteRegKey HKCR ".vimentry"
    System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v (0x08000000, 0, 0, 0)'

    ; remove fonts
    Push "$FONTS\VeraMono.ttf"
    System::Call "Gdi32::RemoveFontResource(t s) i .s"
    Pop $0
    IntCmp $0 0 0 +2 +2
    DetailPrint "failed to remove Vera Mono"
    SendMessage ${HWND_BROADcast} ${WM_FONTCHANGE} 0 0

    Delete "$FONTS\VeraMono.ttf"
    ;  Delete "$INSTDIR\share\fonts\VeraMono.ttf"
    
    ; remove install directory
    RMDir /r "$INSTDIR\bin"
    RMDir /r "$INSTDIR\share"
    RMDir /r "$INSTDIR\tools\exvim"
    RMDir /r "$INSTDIR\tools\Graphviz"
    RMDir /r "$INSTDIR\tools\IrfanView"
    Delete $INSTDIR\uninstall.exe
SectionEnd
