#!/usr/bin/env bash
# ==========================================================
#  Local AI Assistant - Universal Pen Drive Edition (Linux)
#  Works on Debian/Ubuntu-based, Arch-based and Fedora distros
# ==========================================================

# ---- Colors (same palette as the Windows version) ----
C_AQUA=$'\033[96m'
C_RED=$'\033[91m'
C_GREEN=$'\033[92m'
C_YELLOW=$'\033[93m'
C_RESET=$'\033[0m'

# 1. Force the script to execute from the USB folder regardless of mount path
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" || exit 1

pause_exit() {
    echo
    read -r -p "Press Enter to exit..." _
    exit "${1:-0}"
}

# 2. Safety check: Verify llamafile executable exists
#    (the Windows .exe is a universal binary and also runs on Linux)
LLAMAFILE=""
if [ -f "./llamafile-0.10.6" ]; then
    LLAMAFILE="./llamafile-0.10.6"
elif [ -f "./llamafile-0.10.6.exe" ]; then
    LLAMAFILE="./llamafile-0.10.6.exe"
else
    clear
    printf '%s' "$C_RED"
    echo "[ERROR] llamafile-0.10.6 was not found in this folder!"
    echo "Please make sure the executable is in the same directory as this script."
    printf '%s' "$C_RESET"
    pause_exit 1
fi

# 3. Dynamically calculate optimal CPU threads for the host PC
CORES=$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)
THREADS=$CORES
if [ "$CORES" -gt 4 ]; then THREADS=$((CORES - 2)); fi
if [ "$THREADS" -lt 2 ]; then THREADS=2; fi

# 4. Detect System RAM (in GB, rounded)
SYSTEM_RAM=0
if [ -r /proc/meminfo ]; then
    MEM_KB=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null)
    if [ -n "$MEM_KB" ]; then
        SYSTEM_RAM=$(( (MEM_KB + 524288) / 1048576 ))
    fi
fi

# ----------------------------------------------------------
# STEP 1: CHOOSE MODEL
# ----------------------------------------------------------
choose_model() {
    while true; do
        clear
        printf '%s' "$C_AQUA"
        echo "=========================================================="
        echo "      LOCAL AI LAUNCHER - QWEN OPTIMIZED EDITION"
        echo "=========================================================="
        echo "Host CPU Threads : $CORES (Allocated: $THREADS)"
        if [ "$SYSTEM_RAM" -gt 0 ]; then
            echo "Host System RAM  : $SYSTEM_RAM GB"
        else
            echo "Host System RAM  : Unknown"
        fi
        echo "GPU VRAM Target  : 4GB Limit (Crash-Proof Hybrid Mode)"
        echo "=========================================================="
        echo
        echo "STEP 1: CHOOSE YOUR AI MODEL"
        echo
        echo " [1] Qwen 2.5 Coder 7B  (CPU will be high - Model is 4.7GB)"
        echo " [2] Qwen 3 Thinking 4B (CPU will be low  - Model is 3.0GB)"
        echo
        echo "=========================================================="
        read -r -p "Select Model (1 or 2) and press Enter: " mchoice

        case "$mchoice" in
            1)
                MODEL_NAME="qwen2.5-coder-7b-instruct-q4_k_m.gguf"
                GPU_LAYERS=22
                CTX_HOME=8192
                CTX_OFFICE=4096
                EXTRA_FLAGS=(--temp 0.2)
                ;;
            2)
                MODEL_NAME="qwen3-4b-thinking-2507.Q4_K_M.gguf"
                GPU_LAYERS=99
                CTX_HOME=8192
                CTX_OFFICE=4096
                EXTRA_FLAGS=()
                ;;
            *)
                printf '%s' "$C_RED"
                echo
                echo "[!] Invalid selection. Please enter 1 or 2."
                printf '%s' "$C_RESET"
                sleep 2
                continue
                ;;
        esac

        # 5. Safety check: Verify the chosen .gguf file actually exists
        if [ ! -f "./$MODEL_NAME" ]; then
            printf '%s' "$C_RED"
            echo
            echo "[ERROR] The file \"$MODEL_NAME\" is missing!"
            echo "Please make sure it is saved on your USB drive."
            printf '%s' "$C_RESET"
            sleep 4
            continue
        fi
        break
    done
}

# ----------------------------------------------------------
# STEP 2: CHOOSE HARDWARE MODE
# ----------------------------------------------------------
choose_mode() {
    while true; do
        clear
        printf '%s' "$C_AQUA"
        echo "=========================================================="
        echo "STEP 2: CHOOSE HARDWARE MODE FOR THIS PC"
        echo "=========================================================="
        echo
        echo " [1] Home Mode   (Acer Nitro / 16GB+ RAM / 8K Tokens)"
        echo "     - Full precision memory for perfect code accuracy."
        echo
        echo " [2] Office Mode (Work PC / 8GB RAM / 4K Tokens)"
        echo "     - Streams from USB to protect low-RAM systems."
        echo
        echo "=========================================================="
        read -r -p "Select Mode (1 or 2) and press Enter: " pchoice

        case "$pchoice" in
            1)
                if [ "$SYSTEM_RAM" -gt 0 ] && [ "$SYSTEM_RAM" -le 8 ]; then
                    printf '%s' "$C_RED"
                    echo
                    echo "[WARNING] This PC only has $SYSTEM_RAM GB of RAM!"
                    echo "Press Ctrl+C to cancel, or any key to force launch anyway..."
                    read -r -n 1 -s _
                fi
                MODE="home"
                return
                ;;
            2)
                MODE="office"
                return
                ;;
            *)
                printf '%s' "$C_RED"
                echo
                echo "[!] Invalid selection. Please enter 1 or 2."
                printf '%s' "$C_RESET"
                sleep 2
                ;;
        esac
    done
}

# Open the web UI in the default browser after the server has started
open_browser() {
    (
        sleep 4
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1
        fi
    ) &
}

# ----------------------------------------------------------
# LAUNCH
# ----------------------------------------------------------
launch_home() {
    clear
    printf '%s' "$C_GREEN"
    echo "=========================================================="
    echo "Starting in HOME MODE (High-Power 16GB+)..."
    echo "=========================================================="
    echo "- Model Loaded    : $MODEL_NAME"
    echo "- Output Tokens   : UNLIMITED (-n -1)"
    echo "- High Accuracy   : ENABLED (KV Cache is full precision)"
    echo "- GPU Safety      : $GPU_LAYERS Layers offloaded"
    echo "- USB Bypass      : ON (--no-mmap into RAM)"
    echo
    echo "Launching server... Web UI will open shortly at http://127.0.0.1:8080"
    echo "(To shut down the AI safely, press Ctrl+C or close this window.)"
    echo
    open_browser
    # 'sh' is used so it works even if the USB is mounted noexec
    sh "$LLAMAFILE" --server --model "$MODEL_NAME" -ngl "$GPU_LAYERS" -fa on \
        --ctx-size "$CTX_HOME" -n -1 --keep 1024 -t "$THREADS" -b 512 -ub 512 \
        --no-mmap -np 1 "${EXTRA_FLAGS[@]}" --host 127.0.0.1 --port 8080
}

launch_office() {
    clear
    printf '%s' "$C_YELLOW"
    echo "=========================================================="
    echo "Starting in OFFICE MODE (Safe 8GB PC Mode)..."
    echo "=========================================================="
    echo "- Model Loaded    : $MODEL_NAME"
    echo "- Output Tokens   : UNLIMITED (-n -1)"
    echo "- High Accuracy   : ENABLED (KV Cache is full precision)"
    echo "- GPU Safety      : $GPU_LAYERS Layers offloaded"
    echo "- USB Bypass      : OFF (Safe streaming from USB)"
    echo
    echo "Launching server... Web UI will open shortly at http://127.0.0.1:8080"
    echo "(To shut down the AI safely, press Ctrl+C or close this window.)"
    echo
    open_browser
    sh "$LLAMAFILE" --server --model "$MODEL_NAME" -ngl "$GPU_LAYERS" -fa on \
        --ctx-size "$CTX_OFFICE" -n -1 --keep 1024 -t "$THREADS" -b 512 -ub 512 \
        -np 1 "${EXTRA_FLAGS[@]}" --host 127.0.0.1 --port 8080
}

choose_model
choose_mode

if [ "$MODE" = "home" ]; then
    launch_home
else
    launch_office
fi

printf '%s' "$C_RESET"
pause_exit 0
