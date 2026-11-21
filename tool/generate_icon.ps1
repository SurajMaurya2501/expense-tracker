# Generates the SpendWise launcher icon artwork into assets/icon/.
#
#   powershell -ExecutionPolicy Bypass -File tool/generate_icon.ps1
#
# Then apply it to Android and iOS with:
#   dart run flutter_launcher_icons
#
# Outputs (1024x1024):
#   app_icon.png             full icon (background + coin), used for iOS / legacy Android
#   app_icon_foreground.png  coin on transparent, Android adaptive foreground
#   app_icon_monochrome.png  wallet silhouette, Android 13+ themed icon

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$size = 1024
$outDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'assets\icon'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function Get-Color([string]$hex, [int]$alpha = 255) {
    $c = [System.Drawing.ColorTranslator]::FromHtml($hex)
    return [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
}

function New-RoundedRect([single]$x, [single]$y, [single]$w, [single]$h, [single]$r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = [Math]::Min($r * 2, [Math]::Min($w, $h))
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

function New-Canvas {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    return @{ Bitmap = $bmp; Graphics = $g }
}

# Wallet with a bill peeking out and a clasp. Drawn around ($cx, $cy), sized by $w.
# $gap is the colour of the thin separation lines and the clasp cut-out. When
# $transparentCuts is set they are punched out as transparent instead (for the
# monochrome themed icon).
function Draw-Wallet($g, [single]$cx, [single]$cy, [single]$w, $ink, $gap, [bool]$transparentCuts) {
    $h = $w * 0.74
    $x = $cx - $w / 2
    $y = $cy - $h / 2 + $w * 0.07
    $inkBrush = New-Object System.Drawing.SolidBrush($ink)

    $punch = {
        param($path, $pen)
        $prev = $g.CompositingMode
        if ($transparentCuts) { $g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy }
        $clear = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
        $color = if ($transparentCuts) { $clear } else { $gap }
        if ($pen) {
            $p = New-Object System.Drawing.Pen($color, $pen)
            $p.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
            $g.DrawPath($p, $path)
            $p.Dispose()
        } else {
            $b = New-Object System.Drawing.SolidBrush($color)
            $g.FillPath($b, $path)
            $b.Dispose()
        }
        $g.CompositingMode = $prev
    }

    # Bill peeking out of the top, slightly tilted.
    $state = $g.Save()
    $g.TranslateTransform($cx + $w * 0.02, $y - $h * 0.04)
    $g.RotateTransform(-7)
    $bill = New-RoundedRect (-$w * 0.34) (-$h * 0.36) ($w * 0.68) ($h * 0.62) ($w * 0.07)
    $g.FillPath($inkBrush, $bill)
    # Small ring on the bill.
    $ringPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $ringPath.AddEllipse((-$w * 0.075), (-$h * 0.2), ($w * 0.15), ($w * 0.15))
    & $punch $ringPath ($w * 0.028)
    $g.Restore($state)

    # Wallet body, with a thin gap separating it from the bill.
    $body = New-RoundedRect $x $y $w $h ($w * 0.16)
    & $punch $body ($w * 0.05)
    $g.FillPath($inkBrush, $body)

    # Clasp on the right side.
    $claspW = $w * 0.40
    $claspH = $h * 0.36
    $claspX = $x + $w - $claspW + $w * 0.04
    $claspY = $y + ($h - $claspH) / 2 + $h * 0.02
    $clasp = New-RoundedRect $claspX $claspY $claspW $claspH ($claspH * 0.5)
    & $punch $clasp $null
    $dotR = $claspH * 0.17
    $dotX = $claspX + $claspH * 0.5
    $dotY = $claspY + $claspH / 2
    $g.FillEllipse($inkBrush, ($dotX - $dotR), ($dotY - $dotR), ($dotR * 2), ($dotR * 2))

    $inkBrush.Dispose()
}

# Gold coin with soft shadow, rim and a wallet in the middle.
function Draw-Coin($g, [single]$cx, [single]$cy, [single]$r, [bool]$withShadow) {
    $ink = Get-Color '#1A1403'
    $goldLight = Get-Color '#FFE7A8'
    $gold = Get-Color '#FFC857'
    $goldDark = Get-Color '#E39B1F'
    $rimDark = Get-Color '#C98412'

    if ($withShadow) {
        for ($i = 0; $i -lt 9; $i++) {
            $grow = $r * 0.012 * $i
            $alpha = 20
            $brush = New-Object System.Drawing.SolidBrush((Get-Color '#000000' $alpha))
            $g.FillEllipse($brush, ($cx - $r - $grow), ($cy - $r - $grow + $r * 0.07), (($r + $grow) * 2), (($r + $grow) * 2))
            $brush.Dispose()
        }
    }

    $rect = New-Object System.Drawing.RectangleF(($cx - $r), ($cy - $r), ($r * 2), ($r * 2))
    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $goldLight, $goldDark, 50.0)
    $blend = New-Object System.Drawing.Drawing2D.ColorBlend(3)
    $blend.Colors = @($goldLight, $gold, $goldDark)
    $blend.Positions = @(0.0, 0.5, 1.0)
    $grad.InterpolationColors = $blend
    $g.FillEllipse($grad, $rect)
    $grad.Dispose()

    # Outer edge and inner rim for a stamped-coin look.
    $edge = New-Object System.Drawing.Pen((Get-Color '#B87410' 150), ($r * 0.022))
    $g.DrawEllipse($edge, ($cx - $r), ($cy - $r), ($r * 2), ($r * 2))
    $edge.Dispose()
    $rr = $r * 0.86
    $rim = New-Object System.Drawing.Pen($rimDark, ($r * 0.03))
    $g.DrawEllipse($rim, ($cx - $rr), ($cy - $rr), ($rr * 2), ($rr * 2))
    $rim.Dispose()
    $hl = New-Object System.Drawing.Pen((Get-Color '#FFFFFF' 110), ($r * 0.016))
    $rr2 = $r * 0.9
    $g.DrawArc($hl, ($cx - $rr2), ($cy - $rr2), ($rr2 * 2), ($rr2 * 2), 195, 70)
    $hl.Dispose()

    Draw-Wallet $g $cx $cy ($r * 1.08) $ink (Get-Color '#FFC95C') $false
}

function Save-Png($canvas, [string]$name) {
    $path = Join-Path $outDir $name
    $canvas.Graphics.Dispose()
    $canvas.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $canvas.Bitmap.Dispose()
    Write-Host "Wrote $path"
}

$center = $size / 2

# 1. Full icon: dark navy gradient + coin.
$full = New-Canvas
$bgRect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
$bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, (Get-Color '#2A3760'), (Get-Color '#090912'), 55.0)
$full.Graphics.FillRectangle($bg, $bgRect)
$bg.Dispose()
Draw-Coin $full.Graphics $center $center 330 $true
Save-Png $full 'app_icon.png'

# 2. Adaptive foreground: coin only. flutter_launcher_icons already insets the
# adaptive layers by 16%, so the artwork can fill most of the canvas.
$fg = New-Canvas
Draw-Coin $fg.Graphics $center $center 440 $true
Save-Png $fg 'app_icon_foreground.png'

# 3. Monochrome themed icon: wallet silhouette only.
$mono = New-Canvas
Draw-Wallet $mono.Graphics $center $center 780 (Get-Color '#FFFFFF') (Get-Color '#FFFFFF') $true
Save-Png $mono 'app_icon_monochrome.png'
