#!/usr/bin/env bash

# Colors (matching your Windows color scheme)
CYAN='\033[1;36m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Reset color

# 1. Force the script to execute from the USB folder regardless of mount path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

LLAMAFILE="./llamafile-0.10.6.exe"

# 2. Safety check: Verify llamafile executable exists
if [[ ! -f "$LLAMAFILE" ]]; then
    echo -e "${RED}[ERROR] llamafile-0.10.6.exe was not found in this folder!${NC}"
    echo "Please make sure the executable is in the same directory as this script."
    echo ""
    read -rp "Press Enter to exit..."
    exit 1
fi

# 3. Dynamically calculate optimal CPU threads for the host PC
TOTAL_THREADS=$(nproc)
THREADS=$TOTAL_THREADS
if (( THREADS > 4 )); then
    THREADS=$(( TOTAL_THREADS - 2 ))
fi
if (( THREADS < 2 )); then
    THREADS=2
fi

# 4. Detect System RAM (in GB, rounded)
SYSTEM_RAM=$(awk '/MemTotal/ {printf "%.0f", $2/1024/1024}' /proc/meminfo 2>/dev/null)
SYSTEM_RAM=${SYSTEM_RAM:-0}

# STEP 1: CHOOSE MODEL
while true; do
    clear
    echo -e "${CYAN}=========================================================="
    echo "      LOCAL AI LAUNCHER - QWEN OPTIMIZED EDITION"
    echo "=========================================================="
    echo "Host CPU Threads : $TOTAL_THREADS (Allocated: $THREADS)"
    if (( SYSTEM_RAM > 0 )); then
        echo "Host System RAM  : ${SYSTEM_RAM} GB"
    else
        echo "Host System RAM  : Unknown"
    fi
    echo "GPU VRAM Target  : 4GB Limit (Crash-Proof Hybrid Mode)"
    echo "=========================================================="
    echo ""
    echo "STEP 1: CHOOSE YOUR AI MODEL"
    echo ""
    echo " [1] Qwen 2.5 Coder 7B  (CPU will be high - Model is 4.7GB)"
    echo " [2] Qwen 3 Thinking 4B (CPU will be low  - Model is 3.0GB)"
    echo ""
    echo -e "==========================================================${NC}"
    read -rp "Select Model (1 or 2) and press Enter: " mchoice

    EXTRA_FLAGS=()
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
            echo -e "\n${RED}[!] Invalid selection. Please enter 1 or 2.${NC}"
            sleep 2
            continue
            ;;
    esac

    # 5. Safety check: Verify the chosen .gguf file actually exists
    if [[ ! -f "./$MODEL_NAME" ]]; then
        echo -e "\n${RED}[ERROR] The file \"$MODEL_NAME\" is missing!"
        echo -e "Please make sure it is saved on your USB drive.${NC}"
        sleep 4
        continue
    fi
    break
done

# STEP 2: CHOOSE HARDWARE MODE
while true; do
    clear
    echo -e "${CYAN}=========================================================="
    echo "STEP 2: CHOOSE HARDWARE MODE FOR THIS PC"
    echo "=========================================================="
    echo ""
    echo " [1] Home Mode   (Acer Nitro / 16GB+ RAM / 8K Tokens)"
    echo "     - Full precision memory for perfect code accuracy."
    echo ""
    echo " [2] Office Mode (Work PC / 8GB RAM / 4K Tokens)"
    echo "     - Streams from USB to protect low-RAM systems."
    echo ""
    echo -e "==========================================================${NC}"
    read -rp "Select Mode (1 or 2) and press Enter: " pchoice

    case "$pchoice" in
        1)
            if (( SYSTEM_RAM > 0 && SYSTEM_RAM <= 8 )); then
                echo -e "\n${RED}[WARNING] This PC only has ${SYSTEM_RAM} GB of RAM!"
                read -rp "Press Ctrl+C to cancel, or press Enter to force launch anyway...${NC}"
            fi
            MODE="HOME"
            break
            ;;
        2)
            MODE="OFFICE"
            break
            ;;
        *)
            echo -e "\n${RED}[!] Invalid selection. Please enter 1 or 2.${NC}"
            sleep 2
            ;;
    esac
done

# LAUNCH SERVER
clear
if [[ "$MODE" == "HOME" ]]; then
    echo -e "${GREEN}=========================================================="
    echo "Starting in HOME MODE (High-Power 16GB+)..."
    echo "=========================================================="
    echo "- Model Loaded    : $MODEL_NAME"
    echo "- Output Tokens   : UNLIMITED (-n -1)"
    echo "- High Accuracy   : ENABLED (KV Cache is full precision)"
    echo "- GPU Safety      : $GPU_LAYERS Layers offloaded"
    echo "- USB Bypass      : ON (--no-mmap into RAM)"
    echo ""
    echo "Launching server... Web UI will open shortly at http://127.0.0.1:8080"
    echo -e "(To shut down the AI safely, press Ctrl+C or close this terminal.)${NC}"
    echo ""

    # Open browser in background after 4 seconds
    (sleep 4 && xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1) &

    # Use 'sh' to run llamafile safely even on FAT32/exFAT USB drives
    sh "$LLAMAFILE" --server --model "$MODEL_NAME" -ngl "$GPU_LAYERS" -fa on \
        --ctx-size "$CTX_HOME" -n -1 --keep 1024 -t "$THREADS" -b 512 -ub 512 \
        --no-mmap -np 1 "${EXTRA_FLAGS[@]}" --host 127.0.0.1 --port 8080
else
    echo -e "${YELLOW}=========================================================="
    echo "Starting in OFFICE MODE (Safe 8GB PC Mode)..."
    echo "=========================================================="
    echo "- Model Loaded    : $MODEL_NAME"
    echo "- Output Tokens   : UNLIMITED (-n -1)"
    echo "- High Accuracy   : ENABLED (KV Cache is full precision)"
    echo "- GPU Safety      : $GPU_LAYERS Layers offloaded"
    echo "- USB Bypass      : OFF (Safe streaming from USB)"
    echo ""
    echo "Launching server... Web UI will open shortly at http://127.0.0.1:8080"
    echo -e "(To shut down the AI safely, press Ctrl+C or close this terminal.)${NC}"
    echo ""

    (sleep 4 && xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1) &

    sh "$LLAMAFILE" --server --model "$MODEL_NAME" -ngl "$GPU_LAYERS" -fa on \
        --ctx-size "$CTX_OFFICE" -n -1 --keep 1024 -t "$THREADS" -b 512 -ub 512 \
        -np 1 "${EXTRA_FLAGS[@]}" --host 127.0.0.1 --port 8080
fi

echo ""
read -rp "Server stopped. Press Enter to exit..."