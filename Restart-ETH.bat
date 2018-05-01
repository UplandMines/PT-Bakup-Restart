:: #######################################################################################################
::       Thank you for using my batch script file. Any donations would be greatly appreciated
::       if you use it, or build off of it.
::
::       BTC ADDRESS: 15WoGzUQ1aPgn5qczWiMExarpWAQr7aipZ
::       LTC ADDRESS: LNcneuwWjCxddq29RrVCKQsx5Q9qtpcQfc
::       ETH ADDRESS: 0xe0543b417ff933e66c3d6c6d2db0240879763631
::  
::    IMPORTANT
::    Edit Run-ProfitTrailer.cmd and include TITLE "ProfitTrailer" on 1st Line "" are important
::    Edit Run-ProfitTrailer-blacklist.bat and incliude TITLE "ProfitTrailer-Blacklist"
::    Typical Start Path = start /d "C:\Program Files\Trader\ProfitTrailer" Run-ProfitTrailer.cmd
::
::    When you run the file for the first time, depending on a VPS or LOCAL PC title may appear different
::        If CMD.exe Title isn't Administrator: {TITLE} change or remove {Adminstrator}
::             ex: taskkill /F /FI "WindowTitle eq  \"ProfitTrailer""
::        Or change {Administrator:} to {YOURNAMEID:}
::
::    If using a different browser than Chrome.exe this will have to be changed to your default browser
::
::    One more note; if you are using PT Feeder or PT Magic, They can be added the same way you added
::        Profit Trailer. If you do not use PT-Blacklist then just comment it out using ::
::
:: =======================================================================================================
TITLE "ETH-Bot Restart"
@echo off
setlocal

:: SET YOUR FILE LOCATION FOR PROFITTRAILER
Set PTFolder=C:\Trader\ETH-Bot\ProfitTrailer
Set PTZipped=C:\Trader\ETH-Bot\ProfitTrailerBackup


:LOOP
cls
ECHO ---------------------------------------------------------------------------
ECHO           Starting Profit Trailer -- PT Magic -- PT Blacklist
ECHO ---------------------------------------------------------------------------

start /d "C:\Trader\ETH-Bot\ProfitTrailer" Run-ProfitTrailer.cmd
:: start /d "C:\Program Files\Trader\ProfitTrailer" Run-ProfitTrailer-blacklist.bat

ECHO Will Restart ETH-Bot Profit Trailer In:
timeout /t 86400

:: =======================================================================================================
::         BACKUP FILES
:: =======================================================================================================

::Set PTTrades=%PTFolder%\trading

::for /f "delims=" %%a in ('"powershell [DateTime]::Now.AddHours(0).ToString('yyyy-MM-dd_hhmm')"') do set datetime=%%a

::mkdir "%PTZipped%\%datetime%_Backup"

::SET ZipDir=%PTZipped%\%datetime%_Backup
::SET ZippedTrades=%ZipDir%\ProfitTrailer_Trades.zip

ECHO Trading files being zipped
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%PTTrades%', '%ZippedTrades%'); }"

ECHO.
ECHO Backing up ProfitTrailerData.json
xcopy "%PTFolder%\ProfitTrailerData.json" "%ZipDir%\*.*" /h /k /f /y

ECHO.
ECHO Files have been backed up to %ZipDir%. Preparing to shutdown
Timeout /t 10 

:: =======================================================================================================
::         STOP PROFIT TRAILER
:: =======================================================================================================
ECHO.
ECHO ---------------------------------------------------------------------------
ECHO           Stopping Profit Trailer and All Associations
ECHO ---------------------------------------------------------------------------
taskkill /F /FI "WindowTitle eq  Administrator:  \"ETH-ProfitTrailer"" /T
:: taskkill /F /FI "WindowTitle eq  Administrator:  \"ETH-ProfitTrailer-Blacklist"" /T
:: taskkill /F /IM Chrome.exe /T

ECHO Waiting for Programs to Close
timeout /t 30
goto LOOP