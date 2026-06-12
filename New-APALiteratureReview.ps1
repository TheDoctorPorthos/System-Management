function New-APALiteratureReview {
    <#
    .SYNOPSIS
        Synthesizes research sources (.md files) into an APA-formatted literature review.
    .DESCRIPTION
        Scans a directory for Markdown files with YAML frontmatter, extracts citation
        metadata and key points, groups them by topic, and generates a synthesized
        literature review in APA 7th edition style.
    .PARAMETER SourcePath
        Path to the folder containing .md research source files.
    .PARAMETER OutputPath
        Path where the generated literature review will be saved (.docx or .md).
    .PARAMETER Topic
        Optional overarching topic/title for the literature review.
    .EXAMPLE
        New-APALiteratureReview -SourcePath .\sources -OutputPath .\review.md -Topic "Cognitive Load in Multimedia Learning"
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$OutputPath,

        [Parameter()]
        [string]$Topic = "Literature Review"
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        Write-Error "Source path '$SourcePath' not found."
        return
    }

    $files = Get-ChildItem -LiteralPath $SourcePath -Filter "*.md" -File
    if ($files.Count -eq 0) {
        Write-Error "No .md files found in '$SourcePath'."
        return
    }

    Write-Host "Found $($files.Count) source file(s). Parsing..." -ForegroundColor Cyan

    $sources = [System.Collections.ArrayList]::new()

    foreach ($file in $files) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $parsed = Parse-SourceFile -Content $content -FileName $file.Name
        if ($parsed) {
            [void]$sources.Add($parsed)
        }
    }

    if ($sources.Count -eq 0) {
        Write-Error "No valid sources could be parsed. Ensure each .md file has YAML frontmatter."
        return
    }

    Write-Host "Parsed $($sources.Count) source(s). Generating literature review..." -ForegroundColor Cyan

    $review = Build-LiteratureReview -Sources $sources -Topic $Topic

    $extension = [System.IO.Path]::GetExtension($OutputPath).ToLower()
    if ($extension -eq ".md") {
        $review | Out-File -LiteralPath $OutputPath -Encoding utf8
    }
    else {
        $review | Out-File -LiteralPath $OutputPath -Encoding utf8
    }

    Write-Host "Literature review written to: $OutputPath" -ForegroundColor Green
}

function Parse-SourceFile {
    param(
        [string]$Content,
        [string]$FileName
    )

    $lines = $Content -split "`n"

    if ($lines.Count -eq 0 -or $lines[0].Trim() -ne "---") {
        Write-Warning "No YAML frontmatter found in '$FileName'. Skipping."
        return $null
    }

    $endIndex = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq "---") {
            $endIndex = $i
            break
        }
    }

    if ($endIndex -eq -1) {
        Write-Warning "Unclosed YAML frontmatter in '$FileName'. Skipping."
        return $null
    }

    $yamlLines = $lines[1..($endIndex - 1)]
    $metadata = @{}
    $currentKey = $null
    $currentList = @()

    foreach ($line in $yamlLines) {
        if ($line -match "^\s*(\w[\w\s]*?):\s*(.*)") {
            if ($currentKey -and $currentList.Count -gt 0) {
                $metadata[$currentKey] = $currentList.Clone()
                $currentList = @()
            }
            $currentKey = $matches[1].Trim()
            $value = $matches[2].Trim()
            if ($value -eq "") {
                $currentList = @()
            }
            elseif ($value -match "^\[") {
                $items = $value -replace "[\[\]]", "" -split "," | ForEach-Object { $_.Trim().Trim('"') }
                $metadata[$currentKey] = @($items)
                $currentKey = $null
            }
            else {
                $metadata[$currentKey] = $value.Trim('"').Trim("'")
                $currentKey = $null
            }
        }
        elseif ($line -match "^\s+-\s+(.*)") {
            $currentList += $matches[1].Trim().Trim('"').Trim("'")
        }
    }

    if ($currentKey -and $currentList.Count -gt 0) {
        $metadata[$currentKey] = $currentList.Clone()
    }

    if (-not $metadata.ContainsKey("title") -or -not $metadata.ContainsKey("author") -or -not $metadata.ContainsKey("year")) {
        Write-Warning "Missing required field (title, author, or year) in '$FileName'. Skipping."
        return $null
    }

    $bodyStart = $endIndex + 1
    $bodyLines = $lines[$bodyStart..($lines.Count - 1)]
    $bodyText = ($bodyLines -join "`n").Trim()

    $keyQuotes = @()
    $keyPoints = @()

    if ($bodyText -match "(?ms)Key Points:?\s*\n(.*?)(?:\n#+ |\Z)") {
        $kpSection = $matches[1]
        $keyPoints = $kpSection -split "\n" | ForEach-Object {
            $_.Trim() -replace "^- ", "" -replace "^\* ", ""
        } | Where-Object { $_ -ne "" }
    }

    if ($bodyText -match "(?ms)Quotes:?\s*\n(.*?)(?:\n#+ |\Z)" -or $bodyText -match "(?ms)> (.+)") {
        if ($Matches[1]) {
            $keyQuotes = $Matches[1] -split "\n" | ForEach-Object {
                $_.Trim() -replace "> ", ""
            } | Where-Object { $_ -ne "" }
        }
    }

    $topicTags = @()
    if ($metadata.ContainsKey("tags")) {
        $topicTags = @($metadata["tags"])
    }

    $citation = Format-APACitation -Metadata $metadata

    return @{
        Title     = $metadata["title"]
        Author    = $metadata["author"]
        Year      = $metadata["year"]
        Source    = if ($metadata.ContainsKey("source")) { $metadata["source"] } else { "" }
        DOI       = if ($metadata.ContainsKey("doi")) { $metadata["doi"] } else { "" }
        Tags      = $topicTags
        KeyPoints = $keyPoints
        Quotes    = $keyQuotes
        Body      = $bodyText
        Citation  = $citation
        FileName  = $FileName
    }
}

function Format-APACitation {
    param($Metadata)

    $author = $Metadata["author"]
    $year = $Metadata["year"]
    $title = $Metadata["title"]
    $source = if ($Metadata.ContainsKey("source")) { $Metadata["source"] } else { "" }

    $apa = "$author ($year). $title"
    if ($source) { $apa += ". $source" }
    if ($Metadata.ContainsKey("doi") -and $Metadata["doi"]) { $apa += ". https://doi.org/$($Metadata['doi'])" }
    $apa += "."

    return $apa
}

function Build-LiteratureReview {
    param(
        [System.Collections.ArrayList]$Sources,
        [string]$Topic
    )

    $topicGroups = @{}
    foreach ($src in $Sources) {
        if ($src.Tags.Count -eq 0) {
            $group = "General"
        }
        else {
            foreach ($tag in $src.Tags) {
                if (-not $topicGroups.ContainsKey($tag)) {
                    $topicGroups[$tag] = [System.Collections.ArrayList]::new()
                }
                [void]$topicGroups[$tag].Add($src)
            }
        }
        if (-not $topicGroups.ContainsKey("General")) {
            $topicGroups["General"] = [System.Collections.ArrayList]::new()
        }
        if ($src.Tags.Count -eq 0 -or -not ($src.Tags | Where-Object { $topicGroups.Keys -contains $_ })) {
            [void]$topicGroups["General"].Add($src)
            $src.Tags = @("General")
        }
    }

    $sb = [System.Text.StringBuilder]::new()

    [void]$sb.AppendLine("# $Topic")
    [void]$sb.AppendLine()

    $totalSources = $Sources.Count
    $intro = "This literature review synthesizes findings from $totalSources sources on the topic of '$Topic'. "
    $intro += "The review is organized thematically to highlight key findings, methodological approaches, and areas of consensus and debate across the literature."
    [void]$sb.AppendLine($intro)
    [void]$sb.AppendLine()

    $seenSources = @{}
    foreach ($groupName in $topicGroups.Keys | Sort-Object) {
        $groupSources = $topicGroups[$groupName]

        $uniqueInGroup = $groupSources | Where-Object { -not $seenSources.ContainsKey($_.FileName) }
        if ($uniqueInGroup.Count -eq 0) { continue }

        foreach ($s in $uniqueInGroup) { $seenSources[$s.FileName] = $true }

        [void]$sb.AppendLine("## $groupName")
        [void]$sb.AppendLine()

        $inTextCits = @()
        foreach ($s in $uniqueInGroup) {
            $parts = $s.Author -split "," | ForEach-Object { $_.Trim() }
            $inTextCits += "$($parts[0]) ($($s.Year))"
        }

        $leadSentence = "Several studies have examined the relationship between aspects of $groupName. "
        if ($inTextCits.Count -le 3) {
            $leadSentence = "Research on $groupName has been addressed by $($inTextCits -join ', '). "
        }
        else {
            $leadSentence = "Research on $groupName has been addressed by numerous scholars (see $($uniqueInGroup[0].Author.Split(',')[0]), $($uniqueInGroup[1].Year); $($uniqueInGroup[2].Author.Split(',')[0]), $($uniqueInGroup[2].Year)). "
        }
        [void]$sb.AppendLine($leadSentence)
        [void]$sb.AppendLine()

        foreach ($s in $uniqueInGroup) {
            $surname = $s.Author.Split(",")[0].Trim()
            $year = $s.Year

            if ($s.KeyPoints.Count -gt 0) {
                $introLine = "$surname ($year) found that "
                $points = $s.KeyPoints | ForEach-Object {
                    $_.TrimEnd(".").ToLower()
                }
                $introLine += "$($points[0])"
                if ($points.Count -gt 1) {
                    $introLine += ", and $($points[1])"
                }
                $introLine += " (${surname}, ${year})."
                [void]$sb.AppendLine($introLine)
                [void]$sb.AppendLine()
            }
            else {
                $fallback = "$surname ($year) contributed to this area of research by examining "
                $excerpt = $s.Body.Trim()
                if ($excerpt.Length -gt 200) {
                    $fallback += "$($excerpt.Substring(0, 200))... "
                }
                else {
                    $fallback += "$excerpt "
                }
                $fallback += "(${surname}, ${year})."
                [void]$sb.AppendLine($fallback)
                [void]$sb.AppendLine()
            }
        }

        $transition = "Taken together, these studies suggest that $groupName is a multifaceted construct "
        $transition += "influenced by a range of contextual and methodological factors. "
        $transition += "Further research is needed to clarify the mechanisms underlying these relationships."
        [void]$sb.AppendLine($transition)
        [void]$sb.AppendLine()
    }

    [void]$sb.AppendLine("## Conclusion")
    [void]$sb.AppendLine()
    $conclusion = "This review has synthesized $totalSources sources on the topic of '$Topic'. "
    $conclusion += "The literature reveals several key themes, including "
    $themeList = @()
    foreach ($g in ($topicGroups.Keys | Sort-Object)) {
        $themeList += $g.ToLower()
    }
    if ($themeList.Count -gt 0) {
        if ($themeList.Count -eq 1) {
            $conclusion += "$($themeList[0])"
        }
        else {
            $last = $themeList[-1]
            $rest = $themeList[0..($themeList.Count - 2)] -join ", "
            $conclusion += "$rest, and $last"
        }
    }
    $conclusion += ". While the existing research provides a strong foundation, "
    $conclusion += "future studies should aim to address gaps in the literature, particularly regarding "
    $conclusion += "longitudinal effects and diverse methodological approaches."
    [void]$sb.AppendLine($conclusion)
    [void]$sb.AppendLine()

    [void]$sb.AppendLine("## References")
    [void]$sb.AppendLine()

    $apaRefs = $Sources | Sort-Object { $_.Author.Split(",")[0].Trim() }
    foreach ($s in $apaRefs) {
        $refLine = "  $($s.Citation)"
        [void]$sb.AppendLine($refLine)
    }

    return $sb.ToString()
}


