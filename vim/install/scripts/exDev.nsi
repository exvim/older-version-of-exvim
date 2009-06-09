;  ======================================================================================
;  File         : exDev.nsi
;  Author       : Wu Jie 
;  Last Change  : 05/09/2009 | 15:32:39 PM | Saturday,May
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
Name "exDev Installer" 
Caption "exDev Installer"
Icon "resource\exVim_icon.ico"
OutFile "exDev-Installer.exe"

; Default installation
; DISABLE: InstallDir "$PROGRAMFILES\exDev"
InstallDir "c:\exDev"

;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\exDev" ""

;Request application privileges for Windows Vista
RequestExecutionLevel user

; /////////////////////////////////////////////////////////////////////////////
; Show splash 
; /////////////////////////////////////////////////////////////////////////////

XPStyle on

Function .onInit
	# the plugins dir is automatically deleted when the installer exits
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "resource\exVim_splash.bmp"
	#optional
	#File /oname=$PLUGINSDIR\splash.wav "C:\myprog\sound.wav"

	splash::show 500 $PLUGINSDIR\splash

	Pop $0 ; $0 has '1' if the user closed the splash screen early, '0' if everything closed normally, and '-1' if some error occurred.

    ;  CHECK { 
    # run the install program to check for already installed versions
    SetOutPath $TEMP
    File exDev\exVim\vim\vim72\install.exe
    ExecWait "$TEMP\install.exe -uninstall-check"
    Delete $TEMP\install.exe
    ;  } CHECK end 
FunctionEnd

; /////////////////////////////////////////////////////////////////////////////
; Interface Settings
; /////////////////////////////////////////////////////////////////////////////

!define MUI_ICON "resource\orange-install.ico"
!define MUI_UNICON "resource\modern-uninstall-full.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "resource\exVim_header.bmp" ; optional
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
;  Desc: exVim
;  ------------------------------------------------------------------ 

SectionGroup "!exVim" sec_exVim

    ;  ======================================================== 
    ;  vim  
    ;  ======================================================== 

    Section "vim72" sec_vim
        SectionIn 1 2

        ; copy vim files
        SetOutPath $INSTDIR\vim
        File /r exDev\exVim\vim\*

        ; append GnuWin32 bin path to user PATH environment variable
        ;  DISABLE { 
        ;  ReadRegStr $0 HKCU "Environment" "PATH"
        ;  WriteRegExpandStr HKCU "Environment" "PATH" "$INSTDIR\vim\vim72;$0"
        ;  } DISABLE end 
        ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\vim\vim72"  
    SectionEnd

    ;  ======================================================== 
    ;  vim-plugins  
    ;  ======================================================== 

    Section "vim-plugins" sec_vim_plugins
        SectionIn 1 2

        ; copy vim-plugin files
        SetOutPath $INSTDIR\vim
        File /r exDev\exVim\vim-plugins\*
    SectionEnd

SectionGroupEnd

;  ------------------------------------------------------------------ 
;  Desc: other tools
;  ------------------------------------------------------------------ 

SectionGroup "other tools" sec_other_tools

    ;  ------------------------------------------------------------------ 
    ;  Desc: GnuWin32 
    ;  ------------------------------------------------------------------ 

    SectionGroup "GnuWin32" sec_gnu_win32

        ;  ======================================================== 
        ;  gawk  
        ;  ======================================================== 

        Section "gawk" sec_gawk
            SectionIn 1

            ; copy gawk files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\gawk\*
        SectionEnd

        ;  ======================================================== 
        ;  diffutils 
        ;  ======================================================== 

        Section "diffutils" sec_diffutils
            SectionIn 1

            ; copy diff files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\diffutils\*
        SectionEnd

        ;  ======================================================== 
        ;  id-utils
        ;  ======================================================== 

        Section "id-utils" sec_idutils
            SectionIn 1

            ; copy libintl files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\libintl\*

            ; copy libiconv files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\libiconv\*

            ; copy id-utils files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\id-utils\*
        SectionEnd

        ;  ======================================================== 
        ;  sed
        ;  ======================================================== 

        Section "sed" sec_sed
            SectionIn 1

            ; copy sed files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\regex\*

            ; copy sed files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\sed\*
        SectionEnd

        ;  ======================================================== 
        ;  src-highlite
        ;  ======================================================== 

        Section "src-highlite" sec_src_highlite
            SectionIn 1

            ; copy src-highlite files
            SetOutPath $INSTDIR\GnuWin32
            File /r exDev\GnuWin32\src-highlite\*
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
            ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\GnuWin32\bin"  
        SectionEnd

    SectionGroupEnd

    ;  ======================================================== 
    ;  Graphviz 
    ;  ======================================================== 

    Section "Graphviz" sec_graphviz
        SectionIn 1

        ; copy grpahviz files
        SetOutPath $INSTDIR\Graphviz
        File /r exDev\Graphviz\*
    
        ; append Graphviz bin path to user PATH environment variable
        ;  DISABLE { 
        ;  ReadRegStr $0 HKCU "Environment" "PATH"
        ;  WriteRegExpandStr HKCU "Environment" "PATH" "$INSTDIR\Graphviz\bin;$0"
        ;  } DISABLE end 
        ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\Graphviz\bin"  
    SectionEnd

SectionGroupEnd

;  ------------------------------------------------------------------ 
;  Desc: PostInstall 
;  ------------------------------------------------------------------ 

Section # "PostInstall"
    ; Store installation folder
    WriteRegStr HKCU "Software\exDev" "" $INSTDIR

    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; Create Environment variable EX_DEV
    WriteRegStr HKCU "Environment" "EX_DEV" $INSTDIR

    ; Refresh environment variables
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

    ;  CHECK { 
    ; Register to Add/Remove program in control pannel
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exVim" "DisplayName" "exVim"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exVim" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exVim" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
    ;  } CHECK end 
SectionEnd

; /////////////////////////////////////////////////////////////////////////////
; Descriptions
; /////////////////////////////////////////////////////////////////////////////

;Language strings
LangString DESC_exVim ${LANG_ENGLISH} "exVim"
LangString DESC_vim ${LANG_ENGLISH} "vim compile with python,cscope"
LangString DESC_vim_plugins ${LANG_ENGLISH} "vim-plugins for vim"
LangString DESC_other_tools ${LANG_ENGLISH} "terminal tools"
LangString DESC_gnu_win32 ${LANG_ENGLISH} "GnuWin32 tools"
LangString DESC_gawk ${LANG_ENGLISH} "gawk"
LangString DESC_diffutils ${LANG_ENGLISH} "diffutils"
LangString DESC_idutils ${LANG_ENGLISH} "id-utils"
LangString DESC_sed ${LANG_ENGLISH} "sed"
LangString DESC_src_highlite ${LANG_ENGLISH} "src-highlite"
LangString DESC_graphviz ${LANG_ENGLISH} "Graphviz"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_exVim} $(DESC_exVim)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_vim} $(DESC_vim)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_vim_plugins} $(DESC_vim_plugins)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_other_tools} $(DESC_other_tools)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_gnu_win32} $(DESC_gnu_win32)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_gawk} $(DESC_gawk)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_diffutils} $(DESC_diffutils)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_idutils} $(DESC_idutils)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_sed} $(DESC_sed)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_src_highlite} $(DESC_src_highlite)
    !insertmacro MUI_DESCRIPTION_TEXT ${sec_graphviz} $(DESC_graphviz)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; /////////////////////////////////////////////////////////////////////////////
; Uninstaller Section
; /////////////////////////////////////////////////////////////////////////////

;  ------------------------------------------------------------------ 
;  Desc: 
;  ------------------------------------------------------------------ 

Function un.onInit
    ; Warning Message
    MessageBox MB_OKCANCEL|MB_ICONSTOP "Warning: Uninstall will delete all files under $INSTDIR, include your custom files, please backup your files before uninstall. Click OK to Continue." IDOK true IDCANCEL false
    false:
        Abort
    true:
FunctionEnd

;  ------------------------------------------------------------------ 
;  Desc: 
;  ------------------------------------------------------------------ 

Section "Uninstall"
    
    ; remove install directory
    RMDir /r "$INSTDIR\vim"
    RMDir /r "$INSTDIR\GnuWin32"
    RMDir /r "$INSTDIR\Graphviz"
    Delete $INSTDIR\uninstall.exe
    
    ; remove registry value
    DeleteRegKey /ifempty HKCU "Software\exDev"

    ; remove environment variable EX_DEV
    DeleteRegValue HKCU "Environment" "EX_DEV"

    ;  CHECK { 
    ; remove the Add/Remove information
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\exVim"

    ; remove from environment
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\Graphviz\bin"
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\GnuWin32\bin"  
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\vim\vim72"  

    ; Refresh environment variables
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000 
    ;  } CHECK end 
    
SectionEnd
