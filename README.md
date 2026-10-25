# 🚀 Run AI from USB: Local AI Launcher (Qwen Optimized)

A lightweight, fully portable Windows batch script designed to launch and run local AI models directly from a USB drive. This launcher is optimized for **llamafile** and GGUF models, ensuring a seamless, plug-and-play local AI environment with zero installation required.

## ✨ Features

* **True Portability:** Run advanced language models directly from any external USB drive.
* **Auto-Configuration:** Dynamically calculates optimal CPU threads and applies hardware memory safety modes.
* **Qwen Optimized:** Pre-configured support for models like `Qwen 2.5 Coder 7B` and `Qwen 3 Thinking 4B`.
* **Hardware Profiles:** Includes specialized execution environments like **Home Mode** (Optimized for 16GB+ RAM systems like Acer Nitro with 8K context windows).
* **Zero Dependencies:** No need to install Python, Docker, or heavy frameworks on the host machine. 

## 📂 Recommended Directory Structure

For the batch script to execute flawlessly, organize your USB drive as follows:

```text
USB_Drive_Root/
│── start.bat                 # The main execution script
│── llamafile-0.10.5.exe         # The llamafile executable
└── models/
    ├── qwen2.5-coder-7b-instruct-q4_k_m.gguf
    └── qwen3-4b-thinking-2507.Q4_K_M.gguf
```

## ⚙️ Prerequisites

1. A USB Flash Drive or External SSD formatted as NTFS or exFAT (FAT32 has a 4GB file size limit, which blocks most AI models).
2. A Windows host machine.
3. [Llamafile](https://github.com/Mozilla-Ocho/llamafile) executable downloaded to the root folder.
4. Your preferred `.gguf` model weights placed in the `models/` directory.

## 🚀 Usage

1. Plug your USB drive into any Windows PC.
2. Navigate to the USB drive in File Explorer.
3. Double-click the `.bat` launcher script.
4. Select your hardware profile (e.g., *Home Mode* for 16GB RAM) when prompted.
5. The script will initialize Llamafile in the background and open the local AI chat interface in your default web browser.

## 🛠️ Customization

You can edit the `.bat` file using any text editor to:
* Adjust the default context window (e.g., change from `8192` to `4096` for lower-end hardware).
* Change the target `.gguf` model filenames to match your downloads.
* Modify CPU thread allocation logic.

## 📄 License

This project is open-source and available under the MIT License.
