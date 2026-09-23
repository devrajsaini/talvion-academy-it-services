# inject_heroes.ps1 - Adds home-style hero banner to about, contact, and program pages
$baseDir = Split-Path $MyInvocation.MyCommand.Path

$heroStyle = '<style id="talvion-page-hero-style">
.tal-page-hero{padding:48px 24px 20px;background:#ffffff;}
.tal-page-hero-inner{max-width:1240px;margin:0 auto;background:transparent;border:none;border-radius:0;box-shadow:none;overflow:visible;padding:0;}
.tal-page-hero-row{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:40px;}
.tal-page-hero-left{flex:1 1 520px;max-width:580px;}
.tal-page-hero-right{flex:1 1 400px;max-width:500px;position:relative;}
.tal-page-hero-kicker{display:inline-flex;align-items:center;gap:8px;background:#eaf0ff;border:1px solid #d4e1fd;padding:6px 14px;border-radius:20px;font-size:12px;font-weight:700;color:#2f65f6;letter-spacing:0.08em;text-transform:uppercase;margin-bottom:20px;}
.tal-page-hero-h{font-size:clamp(32px,3.6vw,48px);line-height:1.12;font-weight:800;color:#07153a;letter-spacing:-0.035em;margin:0 0 16px 0;}
.tal-page-hero-h span{background:linear-gradient(135deg,#2b61f4 0%,#6841e2 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
.tal-page-hero-p{font-size:16px;line-height:1.6;color:#5a667d;margin:0 0 28px 0;max-width:520px;}
.tal-page-hero-badges{display:flex;flex-wrap:wrap;gap:12px;margin-bottom:32px;}
.tal-page-hero-badge{display:inline-flex;align-items:center;gap:8px;background:#ffffff;border:1px solid #e2e8f4;padding:9px 16px;border-radius:12px;font-size:13.5px;font-weight:600;color:#1e293b;box-shadow:0 2px 8px rgba(0,0,0,0.03);}
.tal-page-hero-cta{display:inline-flex;align-items:center;gap:10px;background:linear-gradient(135deg,#533be5 0%,#2968f2 100%);color:#ffffff;font-size:15px;font-weight:700;padding:14px 28px;border-radius:12px;text-decoration:none;box-shadow:0 8px 24px rgba(83,59,229,0.35);transition:transform 0.2s ease,box-shadow 0.2s ease;}
.tal-page-hero-cta:hover{transform:translateY(-2px);box-shadow:0 12px 32px rgba(83,59,229,0.45);}
.tal-page-hero-img{width:100%;height:auto;display:block;object-fit:cover;border-radius:20px;box-shadow:0 16px 36px rgba(17,34,75,0.12);border:2px solid #ffffff;aspect-ratio:16/9;}
.tal-page-hero-float{position:absolute;bottom:-14px;left:24px;background:#ffffff;border:1px solid #e2e8f4;padding:8px 16px;border-radius:24px;box-shadow:0 8px 20px rgba(0,0,0,0.08);display:flex;align-items:center;gap:8px;font-size:13px;font-weight:700;color:#07153a;}
.tal-page-hero-float-dot{width:10px;height:10px;border-radius:50%;background:#10b981;display:inline-block;}
@media(max-width:768px){.tal-page-hero-inner{padding:0;}.tal-page-hero-right{display:none;}}
</style>'

function Inject-Hero {
  param([string]$FilePath, [string]$HeroHtml, [string]$InsertAfter)
  $c = Get-Content $FilePath -Raw -Encoding UTF8
  if ($c.IndexOf('tal-page-hero') -ge 0) {
    Write-Host "SKIP (already has hero): $FilePath"
    return
  }
  $idx = $c.IndexOf($InsertAfter)
  if ($idx -lt 0) {
    Write-Host "WARN - inject point not found: $FilePath"
    return
  }
  $pos = $idx + $InsertAfter.Length
  $newContent = $c.Substring(0, $pos) + "`n" + $heroStyle + $HeroHtml + $c.Substring($pos)
  Set-Content $FilePath -Value $newContent -Encoding UTF8 -NoNewline
  Write-Host "OK: $FilePath"
}

# SVG clock icon (shared)
$svg = '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2f65f6" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>'

# ── ABOUT.HTML ──────────────────────────────────────────────────────────────
$aboutHero = @"

<!-- TALVION PAGE HERO -->
<section class="tal-page-hero" aria-label="About Talvion Academy">
  <div class="tal-page-hero-inner">
    <div class="tal-page-hero-row">
      <div class="tal-page-hero-left">
        <div class="tal-page-hero-kicker">$svg INDIA'S PREMIER IT TRAINING ACADEMY</div>
        <h2 class="tal-page-hero-h">Shaping Tomorrow's <span>Tech Leaders</span></h2>
        <p class="tal-page-hero-p">Talvion Academy delivers world-class AI, Data Science, Cloud &amp; Full-Stack training with live mentoring, real projects, and guaranteed career support.</p>
        <div class="tal-page-hero-badges">
          <div class="tal-page-hero-badge"><span>&#9733;</span> Expert Mentors</div>
          <div class="tal-page-hero-badge"><span>&#128640;</span> Live Projects</div>
          <div class="tal-page-hero-badge"><span>&#127919;</span> Career Support</div>
        </div>
        <a href="courses.html" class="tal-page-hero-cta">Explore Our Programs <span style="font-size:17px;">&#8594;</span></a>
      </div>
      <div class="tal-page-hero-right">
        <img src="./about-assets/talvion-about-us-final.jpg" alt="Talvion Academy - About Us" class="tal-page-hero-img">
        <div class="tal-page-hero-float"><span class="tal-page-hero-float-dot"></span> 500+ Learners Placed</div>
      </div>
    </div>
  </div>
</section>

"@

Inject-Hero -FilePath (Join-Path $baseDir "about.html") `
            -HeroHtml $aboutHero `
            -InsertAfter '</header><!-- .site-branding-container -->'

# ── CONTACT.HTML ─────────────────────────────────────────────────────────────
$contactHero = @"

<!-- TALVION PAGE HERO -->
<section class="tal-page-hero" aria-label="Contact Talvion Academy">
  <div class="tal-page-hero-inner">
    <div class="tal-page-hero-row">
      <div class="tal-page-hero-left">
        <div class="tal-page-hero-kicker">$svg GET IN TOUCH WITH TALVION</div>
        <h2 class="tal-page-hero-h">We're Here to <span>Help You Grow</span></h2>
        <p class="tal-page-hero-p">Have questions about our programs, admissions, or career paths? Reach out to the Talvion team — we reply within 24 hours.</p>
        <div class="tal-page-hero-badges">
          <div class="tal-page-hero-badge"><span>&#128222;</span> 24h Response</div>
          <div class="tal-page-hero-badge"><span>&#128640;</span> Expert Guidance</div>
          <div class="tal-page-hero-badge"><span>&#127919;</span> Free Counselling</div>
        </div>
        <a href="#contact-form" class="tal-page-hero-cta">Start a Conversation <span style="font-size:17px;">&#8594;</span></a>
      </div>
      <div class="tal-page-hero-right">
        <img src="./course-assets/talvion-roadmap-hero.jpg" alt="Contact Talvion Academy" class="tal-page-hero-img">
        <div class="tal-page-hero-float"><span class="tal-page-hero-float-dot"></span> Support Available Mon - Sat</div>
      </div>
    </div>
  </div>
</section>

"@

# contact.html ends header with just </header> (no extra comment)
$contactFile = Join-Path $baseDir "contact.html"
$cc = Get-Content $contactFile -Raw -Encoding UTF8
if ($cc.IndexOf('tal-page-hero') -ge 0) {
  Write-Host "SKIP (already has hero): contact.html"
} else {
  $insertMark1 = '</header><!-- .site-branding-container -->'
  $insertMark2 = '</header>'
  if ($cc.IndexOf($insertMark1) -ge 0) {
    $pos = $cc.IndexOf($insertMark1) + $insertMark1.Length
    $cc = $cc.Substring(0, $pos) + "`n" + $heroStyle + $contactHero + $cc.Substring($pos)
    Set-Content $contactFile -Value $cc -Encoding UTF8 -NoNewline
    Write-Host "OK: contact.html (mark1)"
  } elseif ($cc.IndexOf($insertMark2) -ge 0) {
    $pos = $cc.IndexOf($insertMark2) + $insertMark2.Length
    $cc = $cc.Substring(0, $pos) + "`n" + $heroStyle + $contactHero + $cc.Substring($pos)
    Set-Content $contactFile -Value $cc -Encoding UTF8 -NoNewline
    Write-Host "OK: contact.html (mark2)"
  } else {
    Write-Host "WARN - inject point not found: contact.html"
  }
}

# ── PROGRAM / COURSE DETAIL PAGES ─────────────────────────────────────────────
$courseDetailDirs = Get-ChildItem -Path (Join-Path $baseDir "courses") -Directory |
  Where-Object { $_.Name -ne 'page' -and $_.Name -ne 'feed' }

foreach ($dir in $courseDetailDirs) {
  $pageFile = Join-Path $dir.FullName "index.html"
  if (-not (Test-Path $pageFile)) { continue }

  $c = Get-Content $pageFile -Raw -Encoding UTF8
  if ($c.IndexOf('tal-page-hero') -ge 0) {
    Write-Host "SKIP (already has hero): $($dir.Name)"
    continue
  }

  # Parse category from tp-category span
  $catMatch = [regex]::Match($c, 'class="tp-category">([^<]+)<')
  $cat = if ($catMatch.Success) { $catMatch.Groups[1].Value.Trim().ToUpper() } else { "PROFESSIONAL PROGRAM" }

  $progHero = @"

<!-- TALVION PAGE HERO -->
<section class="tal-page-hero" aria-label="$cat Program">
  <div class="tal-page-hero-inner">
    <div class="tal-page-hero-row">
      <div class="tal-page-hero-left">
        <div class="tal-page-hero-kicker">$svg $cat PROGRAM</div>
        <h2 class="tal-page-hero-h">Build Your Career in <span>$cat</span></h2>
        <p class="tal-page-hero-p">Enroll in Talvion's structured program. Get live mentorship, hands-on projects, and complete career support to land your dream role in tech.</p>
        <div class="tal-page-hero-badges">
          <div class="tal-page-hero-badge"><span>&#9733;</span> Structured Curriculum</div>
          <div class="tal-page-hero-badge"><span>&#128640;</span> Hands-on Projects</div>
          <div class="tal-page-hero-badge"><span>&#127919;</span> Career Support</div>
        </div>
        <a href="#course-description" class="tal-page-hero-cta">View Program Details <span style="font-size:17px;">&#8594;</span></a>
      </div>
      <div class="tal-page-hero-right">
        <img src="../../course-assets/talvion-roadmap-hero.jpg" alt="$cat Program - Talvion Academy" class="tal-page-hero-img">
        <div class="tal-page-hero-float"><span class="tal-page-hero-float-dot"></span> Enroll Today</div>
      </div>
    </div>
  </div>
</section>

"@

  $insertMark = '</header><!-- #masthead -->'
  $insertMark2 = '</header>'
  if ($c.IndexOf($insertMark) -ge 0) {
    $pos = $c.IndexOf($insertMark) + $insertMark.Length
    $c = $c.Substring(0, $pos) + "`n" + $heroStyle + $progHero + $c.Substring($pos)
    Set-Content $pageFile -Value $c -Encoding UTF8 -NoNewline
    Write-Host "OK: courses/$($dir.Name)/index.html"
  } elseif ($c.IndexOf($insertMark2) -ge 0) {
    $pos = $c.IndexOf($insertMark2) + $insertMark2.Length
    $c = $c.Substring(0, $pos) + "`n" + $heroStyle + $progHero + $c.Substring($pos)
    Set-Content $pageFile -Value $c -Encoding UTF8 -NoNewline
    Write-Host "OK: courses/$($dir.Name)/index.html (mark2)"
  } else {
    Write-Host "WARN - inject point not found: $($dir.Name)"
  }
}

Write-Host ""
Write-Host "All done!"
