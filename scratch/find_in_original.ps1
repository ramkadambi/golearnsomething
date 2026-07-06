$html = Get-Content -Path "Pcb themes" -Raw
Write-Output "Length of original: $($html.Length)"
$words = @("theme", "circuit", "SpaceX", "monsoon", "flood", "greenhouse")
foreach ($w in $words) {
    $idx = $html.IndexOf($w)
    Write-Output "Word '$w' index: $idx"
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 100)
        $len = [Math]::Min(200, $html.Length - $start)
        Write-Output "  Context: $($html.SubString($start, $len))"
        Write-Output "========================================"
    }
}
