param(
  [switch]$SkipPortableZip
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$LocalFlutter = Join-Path $ProjectRoot ".flutter\bin\flutter.bat"
$Flutter = $null

if (Test-Path $LocalFlutter) {
  $Flutter = $LocalFlutter
} else {
  $FlutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
  if ($FlutterCommand) {
    $Flutter = $FlutterCommand.Source
  }
}

if (-not $Flutter) {
  throw "Flutter was not found. Run 'git submodule update --init .flutter' from the project root or install Flutter and add it to PATH."
}

$Dart = Join-Path (Split-Path $Flutter -Parent) "dart.bat"
if (-not (Test-Path $Dart)) {
  $DartCommand = Get-Command dart -ErrorAction SilentlyContinue
  if (-not $DartCommand) {
    throw "Dart was not found next to Flutter or on PATH."
  }
  $Dart = $DartCommand.Source
}

$DevMode = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
if (-not $DevMode -or $DevMode.AllowDevelopmentWithoutDevLicense -ne 1) {
  Write-Warning "Windows Developer Mode may be disabled. If Flutter reports symlink support errors, run: start ms-settings:developers"
}

$FlagPath = Join-Path $ProjectRoot "lib\utils\update_check_flag_file.dart"
$OriginalFlag = Get-Content -Raw -Path $FlagPath
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

Push-Location $ProjectRoot
try {
  & $Flutter pub get
  & $Dart localization/generator.dart

  [System.IO.File]::WriteAllText($FlagPath, "const updateCheckFlag = true;`n", $Utf8NoBom)
  & $Flutter build windows --release

  if (-not $SkipPortableZip) {
    $ReleaseDir = Join-Path $ProjectRoot "build\windows\x64\runner\Release"
    $DistDir = Join-Path $ProjectRoot "dist"
    $ZipPath = Join-Path $DistDir "Saya-Music-windows-portable.zip"

    New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
    Compress-Archive -Path (Join-Path $ReleaseDir "*") -DestinationPath $ZipPath -Force
    Write-Host "Portable Windows ZIP created at: $ZipPath"
  }
} finally {
  [System.IO.File]::WriteAllText($FlagPath, $OriginalFlag, $Utf8NoBom)
  Pop-Location
}
