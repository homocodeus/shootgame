param([string]$Goose = "")
$ErrorActionPreference = 'Stop'
try {
    if (!$Goose) { $Goose = Join-Path $PSScriptRoot 'compiler/goose.exe' }
    if (!(Test-Path -LiteralPath $Goose)) { throw "Compiler missing: $Goose" }
    Set-Location -LiteralPath $PSScriptRoot
    Write-Host 'Checking Goose compiler (maximum 15 seconds)...'
    $probe = Start-Process -FilePath $Goose -ArgumentList '--version' -WindowStyle Hidden -PassThru -RedirectStandardOutput "$PSScriptRoot/compiler-check.log" -RedirectStandardError "$PSScriptRoot/compiler-error.log"
    if (!$probe.WaitForExit(15000)) {
        Stop-Process -Id $probe.Id -Force -ErrorAction SilentlyContinue
        throw 'The Goose compiler does not start, even with --version. Windows is blocking or hanging its startup. The game has not started. See compiler-check.log and compiler-error.log.'
    }
    Get-Content "$PSScriptRoot/compiler-check.log"
    Get-Content "$PSScriptRoot/compiler-error.log"
    if ($probe.ExitCode -ne 0) { throw "Compiler startup failed: $($probe.ExitCode)" }
    Write-Host 'Starting Star Guard...'
    & $Goose run "$PSScriptRoot/main.goose"
    exit $LASTEXITCODE
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
