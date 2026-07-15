# Скрипт загрузки сайта на GitHub
# Запустите в PowerShell из этой папки после установки Git

param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubUsername,

    [Parameter(Mandatory = $false)]
    [string]$RepoName = "dakinicode"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git не установлен. Установите: winget install Git.Git" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

git add .
git status

$hasCommits = git rev-parse HEAD 2>$null
if (-not $hasCommits) {
    git commit -m "Initial commit: DAKINICODE photography site"
}

$remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
$existingRemote = git remote get-url origin 2>$null

if (-not $existingRemote) {
    git remote add origin $remoteUrl
} elseif ($existingRemote -ne $remoteUrl) {
    git remote set-url origin $remoteUrl
}

Write-Host ""
Write-Host "Перед push создайте репозиторий на GitHub:" -ForegroundColor Yellow
Write-Host "  https://github.com/new" -ForegroundColor Cyan
Write-Host "  Имя: $RepoName (без README, .gitignore, license)" -ForegroundColor Yellow
Write-Host ""
Read-Host "Нажмите Enter когда репозиторий создан"

git push -u origin main

Write-Host ""
Write-Host "Готово! Теперь подключите Vercel:" -ForegroundColor Green
Write-Host "  https://vercel.com/new" -ForegroundColor Cyan
Write-Host "  Import Git Repository -> выберите $RepoName -> Deploy" -ForegroundColor Yellow
