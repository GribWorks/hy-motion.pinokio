@echo on
setlocal EnableExtensions

if not exist app\.git (
  git clone https://github.com/Tencent-Hunyuan/HY-Motion-1.0 app
  if errorlevel 1 exit /b %errorlevel%
) else (
  pushd app
  if errorlevel 1 exit /b %errorlevel%
  git pull --ff-only
  if errorlevel 1 (
    popd
    exit /b %errorlevel%
  )
  popd
)

set "PYLAUNCHER="
py -3.12 -c "import sys" >nul 2>&1 && set "PYLAUNCHER=py -3.12"
if not defined PYLAUNCHER py -3.11 -c "import sys" >nul 2>&1 && set "PYLAUNCHER=py -3.11"
if not defined PYLAUNCHER py -3.10 -c "import sys" >nul 2>&1 && set "PYLAUNCHER=py -3.10"

if not defined PYLAUNCHER (
  echo ERROR: Python 3.10, 3.11, or 3.12 is required for torch 2.5.1 cu121.
  echo Install one of those versions, then rerun Install.
  py -0p
  exit /b 1
)

if not exist app\env\Scripts\python.exe (
  echo Creating venv with %PYLAUNCHER%
  %PYLAUNCHER% -m venv app\env
  if errorlevel 1 exit /b %errorlevel%
)

set "PYEXE=app\env\Scripts\python.exe"
if not exist "%PYEXE%" (
  echo ERROR: venv python not found at %PYEXE%
  exit /b 1
)

"%PYEXE%" -c "import sys; print('Python version:', sys.version)"
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install --upgrade pip setuptools wheel
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install --index-url https://download.pytorch.org/whl/cu121 torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install transformers==4.53.3
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install torchdiffeq==0.2.5
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" patch_gradio_compat.py
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" filter_requirements.py
if errorlevel 1 exit /b %errorlevel%

for %%I in (app\requirements.pinokio.txt) do set "REQSIZE=%%~zI"
if "%REQSIZE%"=="" set "REQSIZE=0"
if %REQSIZE% gtr 0 "%PYEXE%" -m pip install -r app\requirements.pinokio.txt
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install gradio==3.50.2 --no-deps
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install gradio-client==0.6.1 --no-deps
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install websockets==11.0.3 aiohttp==3.9.5 aiofiles==23.2.1 httpx==0.28.1 fastapi==0.115.14 uvicorn==0.34.3 python-multipart==0.0.20
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install altair==5.5.0 ffmpy==0.6.3 importlib-resources==6.5.2 matplotlib==3.9.4 orjson==3.11.4 pandas==2.3.3 pydub==0.25.1 semantic-version==2.10.0 markupsafe==2.1.5 pillow==10.4.0
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install huggingface-hub==0.30.0 --force-reinstall --no-deps
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" download_models.py
if errorlevel 1 exit /b %errorlevel%

echo Install complete.
endlocal
exit /b 0

