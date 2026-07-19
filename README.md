# Illyasviel-stable-diffusion-web-ui-AMD-

i shared it on reddit around two months ago ... but i guess i didnt get much apreciation. link: https://www.reddit.com/r/StableDiffusion/comments/1tcyyb4/stable_diffusion_webui_forge_for_amd_gpu/
there is an img of the cmd startup proces there.

i asked ai to sumarize everything i shat on by sharing all files with it ...cause it was 2 months ago and i could not bother remembering because i am lazy.. so anyways... here it is: 


 Stable Diffusion WebUI Forge â€” AMD DirectML setup

Forge configs to run on AMD GPUs through DirectML instead of CUDA. Two variants included, tuned for different GPU generations.

## What it does

Standard Forge builds assume an Nvidia GPU and CUDA. This setup redirects that pipeline through DirectML so it runs on AMD hardware instead â€” no CUDA, no ROCm required.

**CPU-base torch install.** Installs the CPU-only build of torch (`torch==2.3.1+cpu`) instead of a CUDA build. Actual GPU compute is handled separately by `torch-directml`, which takes over in place of `torch.cuda`.

**DirectML launch flag.** `run.bat` calls `webui-user.bat --use-directml`, routing generation through the DirectML backend.

**GPU architecture override.** `HSA_OVERRIDE_GFX_VERSION` and `HIP_VISIBLE_DEVICES` report a GPU architecture to ROCm/HIP tooling. Only relevant if a ROCm path exists â€” under pure DirectML they're inert, left in for compatibility.

**Startup checks.** The CUDA availability check in `launch_utils.py` never hard-fails when no CUDA device is found â€” it falls through and lets the app keep booting on non-Nvidia hardware.

**VRAM reporting.** `memory_management.py` reports a fixed placeholder value for total/free VRAM whenever DirectML is active. Forge's automatic offload decisions run off that placeholder, not your card's real VRAM â€” worth knowing if memory behavior looks off.

`webui.bat` is unmodified from the base project. All AMD-specific behavior lives in `webui-user.bat`, `run.bat`, and the two Python files.

## The two versions

### RX 9000-series (RDNA4)

```bat
set COMMANDLINE_ARGS=--use-directml --no-half-vae --disable-nan-check
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url https://download.pytorch.org/whl/cpu
```

Runs fp16 with just the VAE kept in fp32 (`--no-half-vae`) â€” enough headroom on newer cards without paying the full fp32 cost everywhere.

### Older / lower-VRAM AMD cards

```bat
set COMMANDLINE_ARGS=--use-directml --precision full --no-half --disable-nan-check
set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu --index-url https://download.pytorch.org/whl/cpu
```

Runs full fp32 precision (`--precision full --no-half`) instead of fp16. Some older AMD/DirectML combos produce black-image or NaN output under fp16 â€” this trades VRAM headroom and speed for stability. Also includes a manual dependency install line and a portable git path, set up for a self-contained install rather than assuming Python/Git are already on the system PATH.

## Which one to use

- **RX 9000-series / RDNA4** â†’ use the fp16 + no-half-vae version. Faster, lower VRAM, no known stability issues on this generation.
- **Older AMD cards (RDNA2/RDNA3, lower VRAM)** â†’ use the full-precision version. Slower and heavier on VRAM, but avoids the black-image/NaN failure mode some of these cards hit under fp16.
