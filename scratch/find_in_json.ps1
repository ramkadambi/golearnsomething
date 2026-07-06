$json = Get-Content -Path "scratch/bootstrap.json" -Raw
Write-Output "Length of bootstrap.json: $($json.Length)"

# Search for common words
$words = @("theme", "circuit", "SpaceX", "monsoon", "flood", "greenhouse")
foreach ($w in $words) {
    $idx = $json.IndexOf($w)
    Write-Output "Word '$w' index: $idx"
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 100)
        $len = [Math]::Min(200, $json.Length - $start)
        Write-Output "  Context: $($json.SubString($start, $len))"
        Write-Output "========================================"
    }
}
