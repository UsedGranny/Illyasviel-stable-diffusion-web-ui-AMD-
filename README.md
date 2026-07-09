# Illyasviel-stable-diffusion-web-ui-AMD-

I took Illyasviel pack ... And brute forced it until amd worked.
i shared it on reddit around two months ago ... but i guess i didnt get much apreciation. link: https://www.reddit.com/r/StableDiffusion/comments/1tcyyb4/stable_diffusion_webui_forge_for_amd_gpu/


i asked ai to sumarize everything i shat on by sharing all files with it ...cause it was 2 months ago and i could not bother remembering because i am lazy.. so anyways... here it is: 


## 🛠️ The Technical Breakthrough (What This Fix Changes)

Standard Forge standalone bundles are hardcoded to crash instantly if they do not detect an Nvidia system architecture. This 5-file override brute-forces compatibility by gutting the validation checks and reshaping how dependencies load:

### 1. The CPU-Base Dependency Trick (`webui-user.bat`)
* **The Override:** Replaced the native Nvidia library acquisition hook with `set TORCH_COMMAND=pip install torch==2.3.1+cpu torchvision==0.18.1+cpu`.
* **The Impact:** This is the key to the entire fix. Forcing a bare CPU-level PyTorch base initialization completely breaks the hardcoded pre-flight Nvidia driver verification loop on startup.

### 2. Manual Virtual Environment Force-Feeding (`webui-user.bat`)
* **The Override:** Injected a raw, custom-piped dependency array directly into the `venv\Scripts\python.exe` pipeline on launch.
* **The Impact:** It manually pushes every critical library—from Gradio and Transformers to Accelerate and SafeTensors—directly into the environment, preventing automated installer scripts from crashing when looking for Nvidia wheels.

### 3. VRAM Stability and Precision Safeguards (`webui-user.bat`)
* **The Override:** Hardcoded the arguments `--skip-torch-cuda-test --precision full --no-half --disable-nan-check`.
* **The Impact:** Completely strips away Nvidia-specific 16-bit half-precision allocation shortcuts. Forcing full precision stops memory segmentation faults and black-screen NaN glitches on RDNA graphics cards.

### 4. DirectML Pipeline Alignment (`run.bat`)
* **The Override:** Modified the core execution string to call `webui-user.bat --use-directml`.
* **The Impact:** Safely bridges the initial CPU-base runtime straight into Microsoft's DirectML translation layer, routing the heavy image generation tasks directly to your AMD GPU.

### 5. Hardware Identity Hijack (`webui-user.bat`)
* **The Override:** Enforced `set HSA_OVERRIDE_GFX_VERSION=10.3.0` and `set HIP_VISIBLE_DEVICES=0`.
* **The Impact:** Fools the lower-level hardware checking scripts into properly handling the compute instructions on standard Radeon setups.

### 6. Validation Gutting (`launch_utils.py` & `memory_management.py`)
* **The Override:** Removed and commented out the active hardware validation blocks.
* **The Impact:** Silences the explicit backend functions that throw the "Found no NVIDIA driver" error screen, allowing the code to run blindly on alternative configurations.
