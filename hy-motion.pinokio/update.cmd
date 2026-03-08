@echo on
setlocal EnableExtensions

if not exist app\env\Scripts\python.exe (
  echo Run Install first.
  exit /b 1
)
set "PYEXE=app\env\Scripts\python.exe"

pushd app
if errorlevel 1 exit /b %errorlevel%

git pull --ff-only
if errorlevel 1 (
  popd
  exit /b %errorlevel%
)

popd

"%PYEXE%" patch_gradio_compat.py
if errorlevel 1 exit /b %errorlevel%

"%PYEXE%" -m pip install torchdiffeq==0.2.5
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

echo Update complete.
endlocal
exit /b 0

