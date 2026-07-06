# Extract structured text from HTML file
param(
    [string]$InputFile,
    [string]$OutputFile
)

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit
}

$html = Get-Content -Path $InputFile -Raw

# Replace common tags with formatted spacing or markdown indicators
$html = $html -replace '(?i)<h1[^>]*>', "`r`n# "
$html = $html -replace '(?i)<h2[^>]*>', "`r`n## "
$html = $html -replace '(?i)<h3[^>]*>', "`r`n### "
$html = $html -replace '(?i)<h4[^>]*>', "`r`n#### "
$html = $html -replace '(?i)<p[^>]*>', "`r`n`r`n"
$html = $html -replace '(?i)<li[^>]*>', "`r`n- "
$html = $html -replace '(?i)<br[^>]*>', "`r`n"
$html = $html -replace '(?i)</td>', " | "
$html = $html -replace '(?i)</tr>', "`r`n"

# Remove all remaining HTML tags
$text = $html -replace '<[^>]+>', ''

# Decode common HTML entities
$text = $text -replace '&nbsp;', ' '
$text = $text -replace '&amp;', '&'
$text = $text -replace '&lt;', '<'
$text = $text -replace '&gt;', '>'
$text = $text -replace '&quot;', '"'
$text = $text -replace '&#39;', "'"
$text = $text -replace '&#x27;', "'"
$text = $text -replace '&mdash;', '—'
$text = $text -replace '&ndash;', '–'

# Normalize multiple empty lines to at most two newlines
$text = $text -replace '(\r?\n){3,}', "`r`n`r`n"

# Clean up leading/trailing spaces on lines
$lines = $text -split "`r?`n"
$cleanedLines = foreach ($line in $lines) {
    $trimmed = $line.Trim()
    if ($trimmed.Length -gt 0 -or $line.Trim().Length -gt 0) {
        $trimmed
    }
}
$text = $cleanedLines -join "`r`n"

# Save to output
$OutputDir = Split-Path -Path $OutputFile -Parent
if ($OutputDir -and -not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
}
$text | Out-File -FilePath $OutputFile -Encoding utf8
Write-Output "Successfully extracted text to $OutputFile"
