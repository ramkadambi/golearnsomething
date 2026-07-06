# Clean extract of chat text
$html = Get-Content -Path "Pcb themes" -Raw

# Remove script, style, and head tags entirely to avoid their content leaking in
$html = $html -replace '(?s)<script\b[^>]*>.*?</script>', ''
$html = $html -replace '(?s)<style\b[^>]*>.*?</style>', ''
$html = $html -replace '(?s)<head\b[^>]*>.*?</head>', ''

# Find tags of interest: h1, h2, h3, h4, p, li, blockquote, pre
$pattern = '(?si)<(h[1-6]|p|li|blockquote|pre)\b[^>]*>(.*?)</\1>'
$matches = [regex]::Matches($html, $pattern)

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($m in $matches) {
    $tag = $m.Groups[1].Value.ToLower()
    $rawContent = $m.Groups[2].Value
    
    # Strip any nested HTML tags from the content
    $cleanContent = $rawContent -replace '(?s)<[^>]+>', ''
    
    # Decode HTML entities
    $cleanContent = $cleanContent -replace '&nbsp;', ' '
    $cleanContent = $cleanContent -replace '&amp;', '&'
    $cleanContent = $cleanContent -replace '&lt;', '<'
    $cleanContent = $cleanContent -replace '&gt;', '>'
    $cleanContent = $cleanContent -replace '&quot;', '"'
    $cleanContent = $cleanContent -replace '&#39;', "'"
    $cleanContent = $cleanContent -replace '&#x27;', "'"
    $cleanContent = $cleanContent -replace '&mdash;', '—'
    $cleanContent = $cleanContent -replace '&ndash;', '–'
    
    $cleanContent = $cleanContent.Trim()
    
    if ($cleanContent.Length -gt 0 -and $cleanContent -notmatch '^[@\.\{\}\(\)\*_]') {
        # Check if it looks like code or metadata
        if ($cleanContent -match '^var\s+' -or $cleanContent -match '^const\s+' -or $cleanContent -match '^[a-zA-Z0-9_\-\.]+\s*\{') {
            continue
        }
        
        if ($tag -match 'h[1-6]') {
            $lines.Add("`r`n### " + $cleanContent)
        } elseif ($tag -eq 'li') {
            $lines.Add("- " + $cleanContent)
        } elseif ($tag -eq 'blockquote') {
            $lines.Add("> " + $cleanContent)
        } else {
            $lines.Add($cleanContent + "`r`n")
        }
    }
}

$lines | Out-File -FilePath "scratch/pcb_themes_clean.md" -Encoding utf8
Write-Output "Extracted clean content to scratch/pcb_themes_clean.md"
