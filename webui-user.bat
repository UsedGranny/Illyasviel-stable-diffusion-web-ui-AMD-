@echo off

set PYTHON=
set GIT=
set VENV_DIR=

set HSA_OVERRIDE_GFX_VERSION=10.3.0
set HIP_VISIBLE_DEVICES=0
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url pytorch.org

set GIT_PYTHON_REFRESH=quiet
set GIT_PYTHON_GIT_EXECUTABLE=%~dp0..\system\git\bin\git.exe

venv\Scripts\python.exe -m pip install fastapi psutil safetensors gradio transformers timm einops pytorch_lightning omegaconf diskcache scikit-image clean-fid GitPython piexif blendmodes opencv-python lark torchdiffeq k-diffusion accelerate fonts font-roboto piq open-clip-torch setuptools

set COMMANDLINE_ARGS=--skip-torch-cuda-test --precision full --no-half --disable-nan-check

call webui.bat
