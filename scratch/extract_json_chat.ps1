# Extract JSON from client-bootstrap script tag
$html = Get-Content -Path "Pcb themes" -Raw

if ($html -match '(?s)<script\s+[^>]*id="client-bootstrap"[^>]*>(.*?)</script>') {
    $jsonText = $Matches[1]
    $jsonText | Out-File -FilePath "scratch/bootstrap.json" -Encoding utf8
    Write-Output "Extracted client-bootstrap JSON to scratch/bootstrap.json"
    
    # Try parsing
    try {
        $data = ConvertFrom-Json $jsonText
        Write-Output "Successfully parsed JSON!"
        Write-Output "Top-level keys:"
        $data | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name }
    } catch {
        Write-Error "Failed to parse JSON: $_"
    }
} else {
    Write-Output "Could not find client-bootstrap script tag"
}
