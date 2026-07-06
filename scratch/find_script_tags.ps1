$html = Get-Content -Path "Pcb themes" -Raw
$matches = [regex]::Matches($html, '<script\b[^>]*>')
foreach ($m in $matches) {
    Write-Output $m.Value
}
