@echo off

set PYTHON=
set GIT=
set VENV_DIR=

:: --use-directml is required here since webui-user.bat does not forward
:: command-line args to webui.bat -- it must live in COMMANDLINE_ARGS.
:: --disable-xformers skips a pointless import attempt: xformers is already
:: force-disabled under DirectML by memory_management.py, so importing it
:: only adds startup noise and a slower boot with no functional benefit.
set COMMANDLINE_ARGS=--use-directml --no-half-vae --disable-nan-check --skip-torch-cuda-test --disable-xformers

:: CPU-only torch build: DirectML supplies its own device backend
:: (torch_directml), so we deliberately avoid pulling a CUDA/ROCm build.
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url https://download.pytorch.org/whl/cpu

call webui.bat
