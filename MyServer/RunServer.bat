@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with Administrator privileges...
) else (
    echo Error: You must right-click and "Run as Administrator".
    pause
    exit
)

cd /d "%~dp0"

echo Starting PS5 Redirect Server on Port 80...
echo Keep this window open.

powershell -NoProfile -Command "$listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://*:80/'); $listener.Start(); Write-Host 'Server is live! Waiting for PS5...'; while($listener.IsListening) { $context = $listener.GetContext(); $request = $context.Request; $response = $context.Response; $path = (Get-Location).Path + $request.Url.LocalPath.Replace('/', '\'); if (Test-Path $path -PathType Leaf) { $content = [System.IO.File]::ReadAllBytes($path); $response.OutputStream.Write($content, 0, $content.Length); Write-Host 'File Sent: ' $request.Url.LocalPath; } else { $response.StatusCode = 404; Write-Host '404 - Not Found: ' $request.Url.LocalPath; }; $response.Close(); }"

pause