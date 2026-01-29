$srcRoot  = Get-Location
$dstRoots = @(
    "C:\Users\hoge\.codex\skills",
    "C:\Users\hoge\.claude\skills"
)

# カレント直下ディレクトリのみ
$sourceDirs = Get-ChildItem -Path $srcRoot -Directory

foreach ($dstRoot in $dstRoots) {

    # 宛先ルートが無ければ作成
    if (!(Test-Path $dstRoot)) {
        New-Item -ItemType Directory -Path $dstRoot | Out-Null
    }

    foreach ($dir in $sourceDirs) {

        $targetPath = $dir.FullName
        $linkPath   = Join-Path $dstRoot $dir.Name

        # 既に存在する場合の安全処理
        if (Test-Path $linkPath) {

            $item = Get-Item $linkPath -ErrorAction SilentlyContinue

            # 同じリンクならスキップ
            if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $targetPath) {
                Write-Host "Skip (correct link): $linkPath"
                continue
            }

            Write-Host "Skip (exists but different): $linkPath"
            continue
        }

        New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
        Write-Host "Linked: $linkPath -> $targetPath"
    }
}
