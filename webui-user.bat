@echo off

set PYTHON=
set GIT=
set VENV_DIR=
set COMMANDLINE_ARGS=--skip-torch-cuda-test --use-directml --no-half-vae --disable-nan-check

:: Force RDNA 4 AI Hardware Acceleration
set HSA_OVERRIDE_GFX_VERSION=11.0.2
set HIP_VISIBLE_DEVICES=0

:: CPU-Base Dependency Trick to bypass Nvidia check
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url https://pytorch.org

:: Force-feeding dependencies into venv pipeline
set PRE_LAUNCH_COMMAND=".\venv\Scripts\python.exe" -m pip install gradio transformers accelerate safetensors

call webui.bat
