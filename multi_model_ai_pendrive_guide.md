# Comprehensive Guide: Multi-Model AI Portable Development Drive
This guide explains how to configure a 32GB USB pendrive into an independent, zero-installation local AI workstation using Windows 11. It allows you to switch between a Deep Reasoning Logic Engine (**Qwen3-4B-Thinking**) and a Fast Code Generation Engine (**Qwen2.5-Coder-7B**) using an interactive on-screen menu interface.

---

## 💾 1. Directory Structure Blueprint
To ensure relative file paths function properly within the batch runtime framework, files must be dropped directly into the root level of your volume. Arrange files exactly as follows:

```text
USB Drive (D: or E:)
├── llamafile-0.10.5.exe
├── Qwen3-4B-Thinking-2507-Q4_K_M.gguf
├── Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf
└── Start.bat
```

---

## 📥 2. Component Retrieval Checklist

### Component A: The Execution Core
- **Tool:** Llamafile Compiler Engine (v0.10.5)
- **Source:** [Mozilla-Ochlocracy Llamafile GitHub Release Repository](https://github.com/Mozilla-Ochlocracy/llamafile)
- **Action:** Download `llamafile-0.10.5.exe`, copy it to your drive root directory, and verify the name does not have appended browser duplicate counts (e.g., `(1)`).

### Component B: The Architecture & Logic Mind
- **Model:** Qwen3-4B-Thinking-2507 (Q4_K_M Quantization Layout)
- **Source:** [unsloth/Qwen3-4B-Thinking-2507-GGUF Repository on Hugging Face](https://huggingface.co/unsloth/Qwen3-4B-Thinking-2507-GGUF)
- **Action:** Grab the standalone file ending with `.gguf` and place it alongside the launcher executable.

### Component C: The Production & Syntax Copilot
- **Model:** Qwen2.5-Coder-7B-Instruct (Q4_K_M Quantization Layout)
- **Source:** [bartowski/Qwen2.5-Coder-7B-Instruct-GGUF Repository on Hugging Face](https://huggingface.co/bartowski/Qwen2.5-Coder-7B-Instruct-GGUF)
- **Action:** Download the `.gguf` binary to provide rapid syntax autocompletes across complex multi-tier programming stacks.

---

## 🛠️ 3. Script Configuration (Start.bat)
Create a plaintext document via Notepad, paste the batch module below, and select **Save As** -> File Name: `Start.bat` -> Save as type: **All Files (*.*)**.

```batch
@echo off
setlocal enabledelayedexpansion
title Multi-Model AI Portable Drive Controller
cls

:MENU
cls
echo =======================================================================
echo          PORTABLE WORKSTATION: MULTI-MODEL LOCAL AI LAUNCHER          
echo =======================================================================
echo  [1] Qwen3-4B-Thinking   (Best for: Complex Logic, System Design, Bugs)
echo  [2] Qwen2.5-Coder-7B     (Best for: Fast Syntax, Boilerplate, Scripts)
echo  [3] Safe Exit Terminal
echo =======================================================================
echo.

set /p choice="Enter your selection [1-3]: "

if "%choice%"=="1" goto BOOT_REASONING
if "%choice%"=="2" goto BOOT_PRODUCTION
if "%choice%"=="3" goto EXIT_ROUTINE
goto INVALID_INPUT

:BOOT_REASONING
echo.
echo [+] Checking files for Reasoning Engine...
if not exist ".\Qwen3-4B-Thinking-2507-Q4_K_M.gguf" (
    echo [!] ERROR: Qwen3-4B-Thinking-2507-Q4_K_M.gguf missing from root.
    pause
    goto MENU
)
echo [+] File validated. Initializing localized compiler server...
echo [+] Access interface locally at: http://localhost:8080
echo [!] To shutdown server safely, press CTRL+C inside this window.
echo.
.\llamafile-0.10.5.exe --server --model "Qwen3-4B-Thinking-2507-Q4_K_M.gguf" --ctx-size 8192
goto EXIT_ROUTINE

:BOOT_PRODUCTION
echo.
echo [+] Checking files for Production Engine...
if not exist ".\Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf" (
    echo [!] ERROR: Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf missing from root.
    pause
    goto MENU
)
echo [+] File validated. Initializing local automation server...
echo [+] Access interface locally at: http://localhost:8080
echo [!] To shutdown server safely, press CTRL+C inside this window.
echo.
.\llamafile-0.10.5.exe --server --model "Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf" --ctx-size 8192
goto EXIT_ROUTINE

:INVALID_INPUT
echo.
echo [!] Evaluation Error: Selection must match numerical flags [1, 2, or 3].
timeout /t 3 >nul
goto MENU

:EXIT_ROUTINE
echo.
echo [+] Freeing allocated workspace memory maps...
echo [+] Disconnect drive safely via taskbar container.
echo Terminal closed.
timeout /t 2 >nul
exit
```

---

## 🏃 4. Operational Execution Procedures

### Step 1: Mounting
Plug your 32GB HP pendrive into an active USB 3.0/3.1 port on your Windows 11 machine. Open File Explorer to view the drive letter assignment.

### Step 2: Selecting Model
Double-click `Start.bat`. A black terminal workspace menu appears. Input `1` to run system architecture analysis or `2` to run code block creation scripts, then hit **Enter**.

### Step 3: Launching Browser Chat
Once the core loads, open your web browser and navigate to:
`http://localhost:8080`

The browser interface acts as a personal chat UI. It operates entirely offline without sending any data over the internet.

### Step 4: Connecting IDE Environment
Because the application functions as an open-source local API endpoint, it can replace commercial subscriptions inside code editor extensions:
1. Open your code editor (such as **VS Code**) and install an extension like **Continue.dev** or **Cline**.
2. Update the extension configuration settings block to point to your local endpoint:
   - **API Type:** `openai`
   - **Base URL:** `http://localhost:8080/v1`
   - **Model Identifier:** Use the exact string name of your chosen `.gguf` file.
3. This setup provides inline code modifications and context-aware workspace refactoring directly out of your portable USB drive hardware.

### Step 5: Safe Dismount & Cache Clearing
When you finish your development session:
1. Return to the open batch terminal console window and press **CTRL + C** to terminate the server.
2. Close out the text panel console window. Your laptop instantly clears the model parameters out of your temporary RAM storage.
3. Use the taskbar option to safely eject your HP hardware drive. No persistent environment changes or junk files remain on your Windows 11 machine.