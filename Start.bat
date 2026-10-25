@echo off
title Local AI Assistant - Universal Pen Drive Edition
color 0B
cls

:: 1. Force the script to execute from the USB folder regardless of drive letter
cd /d "%~dp0"

:: 2. Safety check: Verify llamafile executable exists
if not exist ".\llamafile-0.10.6.exe" (
    color 0C
    echo [ERROR] llamafile-0.10.6.exe was not found in this folder!
    echo Please make sure the executable is in the same directory as this script.
    echo.
    pause
    exit /b
)

:: 3. Dynamically calculate optimal CPU threads for the host PC
set /a THREADS=%NUMBER_OF_PROCESSORS%
if %THREADS% GTR 4 set /a THREADS=%NUMBER_OF_PROCESSORS%-2
if %THREADS% LSS 2 set THREADS=2

:: 4. Detect System RAM
set SYSTEM_RAM=0
for /f %%a in ('powershell -NoProfile -Command "([math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB))" 2^>nul') do set SYSTEM_RAM=%%a

:choose_model
cls
echo ==========================================================
echo       LOCAL AI LAUNCHER - QWEN OPTIMIZED EDITION
echo ==========================================================
echo Host CPU Threads : %NUMBER_OF_PROCESSORS% (Allocated: %THREADS%)
if %SYSTEM_RAM% GTR 0 (echo Host System RAM  : %SYSTEM_RAM% GB) else (echo Host System RAM  : Unknown)
echo GPU VRAM Target  : 4GB Limit (Crash-Proof Hybrid Mode)
echo ==========================================================
echo.
echo STEP 1: CHOOSE YOUR AI MODEL
echo.
echo  [1] Qwen 2.5 Coder 7B  (CPU will be high - Model is 4.7GB)
echo  [2] Qwen 3 Thinking 4B (CPU will be low  - Model is 3.0GB)
echo.
echo ==========================================================
set /p mchoice="Select Model (1 or 2) and press Enter: "

if "%mchoice%"=="1" (
    set "MODEL_NAME=qwen2.5-coder-7b-instruct-q4_k_m.gguf"
    set "GPU_LAYERS=22"
    set "CTX_HOME=8192"
    set "CTX_OFFICE=4096"
    set "EXTRA_FLAGS=--temp 0.2"
    goto verify_model
)
if "%mchoice%"=="2" (
    set "MODEL_NAME=qwen3-4b-thinking-2507.Q4_K_M.gguf"
    set "GPU_LAYERS=99"
    set "CTX_HOME=8192"
    set "CTX_OFFICE=4096"
    set "EXTRA_FLAGS="
    goto verify_model
)

color 0C
echo.
echo [!] Invalid selection. Please enter 1 or 2.
timeout /t 2 >nul
color 0B
goto choose_model

:verify_model
:: 5. Safety check: Verify the chosen .gguf file actually exists
if not exist ".\%MODEL_NAME%" (
    color 0C
    echo.
    echo [ERROR] The file "%MODEL_NAME%" is missing!
    echo Please make sure it is saved on your USB drive.
    timeout /t 4 >nul
    color 0B
    goto choose_model
)
goto choose_mode

:choose_mode
cls
echo ==========================================================
echo STEP 2: CHOOSE HARDWARE MODE FOR THIS PC
echo ==========================================================
echo.
echo  [1] Home Mode   (Acer Nitro / 16GB+ RAM / 8K Tokens)
echo      - Full precision memory for perfect code accuracy.
echo.
echo  [2] Office Mode (Work PC / 8GB RAM / 4K Tokens)
echo      - Streams from USB to protect low-RAM systems.
echo.
echo ==========================================================
set /p pchoice="Select Mode (1 or 2) and press Enter: "

if "%pchoice%"=="1" (
    if %SYSTEM_RAM% GTR 0 if %SYSTEM_RAM% LEQ 8 (
        color 0C
        echo.
        echo [WARNING] This PC only has %SYSTEM_RAM% GB of RAM!
        echo Press Ctrl+C to cancel, or any key to force launch anyway...
        pause >nul
    )
    goto launch_home
)
if "%pchoice%"=="2" goto launch_office

color 0C
echo.
echo [!] Invalid selection. Please enter 1 or 2.
timeout /t 2 >nul
color 0B
goto choose_mode

:launch_home
cls
color 0A
echo ==========================================================
echo Starting in HOME MODE (High-Power 16GB+)...
echo ==========================================================
echo - Model Loaded    : %MODEL_NAME%
echo - Output Tokens   : UNLIMITED (-n -1)
echo - High Accuracy   : ENABLED (KV Cache is full precision)
echo - GPU Safety      : %GPU_LAYERS% Layers offloaded
echo - USB Bypass      : ON (--no-mmap into RAM)
echo.
echo Launching server... Web UI will open shortly at http://127.0.0.1:8080
echo (To shut down the AI safely, just close this window.)
echo.
start "" cmd /c "timeout /t 4 /nobreak >nul && start http://127.0.0.1:8080"
.\llamafile-0.10.6.exe --server --model "%MODEL_NAME%" -ngl %GPU_LAYERS% -fa on --ctx-size %CTX_HOME% -n -1 --keep 1024 -t %THREADS% -b 512 -ub 512 --no-mmap -np 1 %EXTRA_FLAGS% --host 127.0.0.1 --port 8080
goto end

:launch_office
cls
color 0E
echo ==========================================================
echo Starting in OFFICE MODE (Safe 8GB PC Mode)...
echo ==========================================================
echo - Model Loaded    : %MODEL_NAME%
echo - Output Tokens   : UNLIMITED (-n -1)
echo - High Accuracy   : ENABLED (KV Cache is full precision)
echo - GPU Safety      : %GPU_LAYERS% Layers offloaded
echo - USB Bypass      : OFF (Safe streaming from USB)
echo.
echo Launching server... Web UI will open shortly at http://127.0.0.1:8080
echo (To shut down the AI safely, just close this window.)
echo.
start "" cmd /c "timeout /t 4 /nobreak >nul && start http://127.0.0.1:8080"
.\llamafile-0.10.6.exe --server --model "%MODEL_NAME%" -ngl %GPU_LAYERS% -fa on --ctx-size %CTX_OFFICE% -n -1 --keep 1024 -t %THREADS% -b 512 -ub 512 -np 1 %EXTRA_FLAGS% --host 127.0.0.1 --port 8080
goto end

:end
pause
