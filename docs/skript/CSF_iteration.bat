@echo off
setlocal enabledelayedexpansion
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Davkovy skript pro hromadnou filtraci LAZ/LAS souboru hierarchickou iteraci CSF filtru        ::
::                                  Autor: Antonin Skacel                                        ::
:: priloha bp - ZPRACOVANI A PREZENTACE LASEROVYCH DATA PRO POTREBY MONTIORINGU KOMARICH LIHNIST ::
::                  postup  prevzat z CloudCompare dokumentace a online tutorialu                ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: 1. ZDE NASTAVTE CESTY K CC A ADRESARI S MRACNY
set CC_PATH="C:\Cesta\k\CloudCompare.exe"
set INPUT_DIR="D:\Cesta\k\adresari\s\bodovymi\mracny"

:: 2. ZMENTE KONCOVKU Z .TXT NA .BAT

:: Presunuti pracovni slozky primo k mracnum
cd /d "%INPUT_DIR%"

echo Startuji 4-krokove hierarchicke CSF zpracovani bodovych mracen...
echo.

:: Cyklus pro kazdy LAZ soubor ve slozce
for %%f in ("*.laz") do (
    
    echo ====================================================
    echo ZPRACOVAVAM SOUBOR: %%~nxf
    echo ====================================================

    :: VYTVORENI SLOZKY PRO DLAZDICI
    set "OUT_FOLDER=%%~nf"
    if not exist "!OUT_FOLDER!" mkdir "!OUT_FOLDER!"

    :: ITERACE 1: Res 0.2, Thresh 0.4
    echo   probiha iterace 1...
    %CC_PATH% -SILENT -C_EXPORT_FMT LAS -EXT laz -O "%%~nxf" -CSF -SCENES SLOPE -PROC_SLOPE -CLOTH_RESOLUTION 0.2 -CLASS_THRESHOLD 0.4 -EXPORT_GROUND -EXPORT_OFFGROUND
    ren "%%~nf_ground_points.laz" "%%~nf_G1.laz"
    ren "%%~nf_offground_points.laz" "%%~nf_O1.laz"

    :: ITERACE 2: Res 0.4, Thresh 0.8 (Aplikovano na G1)
    echo   probiha iterace 2...
    %CC_PATH% -SILENT -C_EXPORT_FMT LAS -EXT laz -O "%%~nf_G1.laz" -CSF -SCENES SLOPE -PROC_SLOPE -CLOTH_RESOLUTION 0.4 -CLASS_THRESHOLD 0.8 -EXPORT_GROUND -EXPORT_OFFGROUND
    ren "%%~nf_G1_ground_points.laz" "%%~nf_G2.laz"
    ren "%%~nf_G1_offground_points.laz" "%%~nf_O2.laz"

    :: ITERACE 3: Res 0.8, Thresh 1.6 (Aplikovano na G2)
    echo   probiha iterace 3...
    %CC_PATH% -SILENT -C_EXPORT_FMT LAS -EXT laz -O "%%~nf_G2.laz" -CSF -SCENES SLOPE -PROC_SLOPE -CLOTH_RESOLUTION 0.8 -CLASS_THRESHOLD 1.6 -EXPORT_GROUND -EXPORT_OFFGROUND
    ren "%%~nf_G2_ground_points.laz" "%%~nf_G3.laz"
    ren "%%~nf_G2_offground_points.laz" "%%~nf_O3.laz"

    :: ITERACE 4: Res 0.8, Thresh 0.5 (Aplikovano na G3)
    echo   probiha iterace 4...
    %CC_PATH% -SILENT -C_EXPORT_FMT LAS -EXT laz -O "%%~nf_G3.laz" -CSF -SCENES SLOPE -PROC_SLOPE -CLOTH_RESOLUTION 0.8 -CLASS_THRESHOLD 0.5 -EXPORT_GROUND -EXPORT_OFFGROUND
    
    :: PRESUN FINALNICH SOUBORU DO NOVEHO ADRESARE
    echo   ukladani souboru do adresare: %%~nf...
    move /Y "%%~nf_G3_ground_points.laz" "!OUT_FOLDER!\%%~nf_Ground.laz" >nul
    move /Y "%%~nf_G3_offground_points.laz" "!OUT_FOLDER!\%%~nf_O4_kontrola.laz" >nul

    :: MERGE KROK: Slouceni O1, O2, a O3
    echo   slucuji off-ground mracna 1, 2, and 3...
    %CC_PATH% -SILENT -AUTO_SAVE OFF -O "%%~nf_O1.laz" -O "%%~nf_O2.laz" -O "%%~nf_O3.laz" -MERGE_CLOUDS -C_EXPORT_FMT LAS -EXT laz -SAVE_CLOUDS FILE "!OUT_FOLDER!\%%~nf_Offground.laz"

    :: CLEANUP KROK: Smazani docasnych souboru
    echo   odstranuji docasne soubory...
    del "%%~nf_G1.laz"
    del "%%~nf_G2.laz"
    del "%%~nf_G3.laz"
    del "%%~nf_O1.laz"
    del "%%~nf_O2.laz"
    del "%%~nf_O3.laz"

    echo   filtrace dokoncena pro %%~nxf!
    echo.
)

echo Vsechna mracna byla zpracovana a ulozena do adresaru ke kontrole!
pause
