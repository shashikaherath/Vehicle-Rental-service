$javac = "C:\Program Files\Java\jdk-24\bin\javac.exe"
$libDir = "web\WEB-INF\lib"
$outDir = "web\WEB-INF\classes"
$classpath = "$libDir\mysql-connector-j-8.0.33.jar;$libDir\jakarta.servlet-api.jar"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " EliteDrive Vehicle Rental - PowerShell Build" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $javac)) {
    Write-Error "javac not found at: $javac"
    Exit 1
}

Write-Host "[OK] Using javac: $javac" -ForegroundColor Green
Write-Host "Collecting Java source files..."

$sources = Get-ChildItem -Path src -Filter *.java -Recurse | ForEach-Object { $_.FullName }
if (-not $sources) {
    Write-Error "No Java source files found in: src"
    Exit 1
}

Write-Host "[OK] Found $($sources.Count) Java source files" -ForegroundColor Green
Write-Host "Compiling..."

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

& $javac -cp $classpath -d $outDir --release 11 $sources

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "  BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "Compiled classes are in: $outDir"
    Write-Host ""
    
    # Deploy to Tomcat webapps
    $deployDir = "C:\Users\User\tomcat10\apache-tomcat-10.1.56\webapps\vehicle_rental"
    Write-Host "Deploying to Tomcat: $deployDir ..." -ForegroundColor Yellow
    if (-not (Test-Path $deployDir)) {
        New-Item -ItemType Directory -Force -Path $deployDir | Out-Null
    }
    Copy-Item -Path "web\*" -Destination $deployDir -Recurse -Force
    Write-Host "Deployment completed successfully!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Error "Compilation failed."
    Exit 1
}
