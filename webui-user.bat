@echo off

set PYTHON=
set GIT=
set VENV_DIR=

:: --use-directml is required here since webui-user.bat does not forward
:: command-line args to webui.bat -- it must live in COMMANDLINE_ARGS.
:: --precision full --no-half is the fp32 fallback for older DirectML paths
:: that produce black images / NaNs under fp16. Costs VRAM and speed --
:: drop --no-half (or add --medvram) once you confirm fp16 actually works
:: fine on your card.
set COMMANDLINE_ARGS=--use-directml --precision full --no-half --disable-nan-check --skip-torch-cuda-test

:: CPU-only torch build: DirectML supplies its own device backend
:: (torch_directml), so we deliberately avoid pulling a CUDA/ROCm build.
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url https://download.pytorch.org/whl/cpu

set GIT_PYTHON_REFRESH=quiet
set GIT_PYTHON_GIT_EXECUTABLE=%~dp0..\system\git\bin\git.exe

call webui.bat
