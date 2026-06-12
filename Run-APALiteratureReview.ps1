<#
.SYNOPSIS
    Generates an APA-formatted literature review from .md research source files.

.DESCRIPTION
    This script:
      1. Scans a folder for .md files containing YAML frontmatter
         (title, author, year, source, doi, tags)
      2. Extracts key points from each source
      3. Groups sources by topic tag
      4. Writes a synthesized literature review in APA 7th edition style

.EXAMPLE
    .\Run-APALiteratureReview.ps1 -SourcePath .\research-sources -OutputPath .\output\review.md -Topic "Cognitive Science of Learning"
#>

param(
    [string]$SourcePath = ".\research-sources",
    [string]$OutputPath = ".\output\literature-review.md",
    [string]$Topic = "Literature Review"
)

# Load the function
. "$PSScriptRoot\New-APALiteratureReview.ps1"

New-APALiteratureReview -SourcePath $SourcePath -OutputPath $OutputPath -Topic $Topic
