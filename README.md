# 🚀 Run AI from USB: Local AI Launcher (Qwen Optimized)

A lightweight, fully portable collection of Windows batch and Linux Bash scripts designed to launch and run local AI models directly from a USB drive. This cross-platform launcher is optimized for llamafile and GGUF models, ensuring a seamless, plug-and-play local AI environment with zero installation required.

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

## 🐧 Linux Guide (Debian/Ubuntu, Arch, Fedora)

The same USB drive also works on Linux using the included `Start.sh` launcher. It offers the same model menu, the same Home/Office hardware modes and the same automatic CPU thread and RAM detection as the Windows script.

### 📂 Linux Directory Structure

Put `Start.sh` next to the Windows files. The same `llamafile` binary works on both systems, so you can either keep the existing `.exe` or add a copy without the extension:

```text
USB_Drive_Root/
│── start.bat                 # Windows launcher
│── Start.sh                  # Linux launcher
│── llamafile-0.10.6.exe      # Works on Windows AND Linux
│── llamafile-0.10.6          # (Optional) same file without ".exe", also detected by Start.sh
│── qwen2.5-coder-7b-instruct-q4_k_m.gguf
└── qwen3-4b-thinking-2507.Q4_K_M.gguf
```

> **Note:** `Start.sh` looks for the `.gguf` model files in the **same folder as the script**, exactly like the Windows `.bat` file does. It first looks for `llamafile-0.10.6`, then falls back to `llamafile-0.10.6.exe`.

### ⚙️ Linux Prerequisites

1. A USB drive formatted as **exFAT** or **NTFS** (FAT32 cannot hold files over 4GB).
2. A Linux machine based on Debian/Ubuntu, Arch, or Fedora (or any other modern distro with `bash`).
3. `bash`, `awk` and `xdg-open` (used to open the browser automatically). Most desktop distros already include them. If the browser does not open by itself, install `xdg-utils`:

| Distro family | Install command |
|---|---|
| Debian / Ubuntu / Mint / Pop!_OS | `sudo apt install xdg-utils` |
| Arch / Manjaro / EndeavourOS | `sudo pacman -S xdg-utils` |
| Fedora / Nobara | `sudo dnf install xdg-utils` |

4. exFAT support: modern kernels (5.7+) include it. On very old systems install it with `sudo apt install exfatprogs` (Debian/Ubuntu), `sudo pacman -S exfatprogs` (Arch) or `sudo dnf install exfatprogs` (Fedora). For NTFS drives install `ntfs-3g` if the drive does not mount.

### 🚀 Linux Usage

1. Plug in your USB drive and open it in your file manager (it is mounted under `/run/media/<user>/<drive>` or `/media/<user>/<drive>`).
2. Open a terminal in that folder (right-click → *Open in Terminal*, or use `cd`):

```bash
cd /run/media/$USER/YOUR_USB_NAME
```

3. Start the launcher with:

```bash
bash Start.sh
```

   Running it with `bash` is the most reliable method, because exFAT and NTFS drives do not store Linux execute permissions. If your drive is formatted with ext4 you can instead run `chmod +x Start.sh` once and then start it with `./Start.sh`.

4. Choose your AI model (**1** = Qwen 2.5 Coder 7B, **2** = Qwen 3 Thinking 4B).
5. Choose your hardware mode (**1** = Home Mode, **2** = Office Mode).
6. The Web UI opens automatically at `http://127.0.0.1:8080`. If the browser does not open, open that address manually.
7. To shut the AI down safely, press `Ctrl+C` in the terminal or close the terminal window.

### 🛠️ Linux Troubleshooting

* **"Permission denied" when running `./Start.sh`:** The drive is exFAT/NTFS or mounted without execute permission. Use `bash Start.sh` instead.
* **llamafile will not start or prints "cannot execute binary file":** `Start.sh` already launches llamafile through `sh`, which avoids most problems (including drives mounted as `noexec`). If it still fails on a system running WINE or other `binfmt_misc` handlers, register the APE loader or run the llamafile once manually with `sh ./llamafile-0.10.6 --help` to see the real error.
* **Runs on CPU only / no GPU acceleration:** GPU offloading on Linux depends on your drivers. For NVIDIA, install the proprietary driver plus the CUDA toolkit and a C compiler (`gcc`); for AMD, install ROCm/HIP. If the GPU cannot be used, llamafile automatically falls back to the CPU, which is slower but works fine.
* **Out of memory on an 8GB PC:** Choose **Office Mode** and the smaller **Qwen 3 Thinking 4B** model.
* **Browser did not open:** Install `xdg-utils` (see table above) or open `http://127.0.0.1:8080` manually.
* **Port 8080 already in use:** Close the other program using the port, or edit `--port 8080` and the two `http://127.0.0.1:8080` addresses in `Start.sh`.

## 🛠️ Customization

You can edit the `.bat` file using any text editor to:
* Adjust the default context window (e.g., change from `8192` to `4096` for lower-end hardware).
* Change the target `.gguf` model filenames to match your downloads.
* Modify CPU thread allocation logic.

## 📄 License

This project is open-source and available under the MIT License.
