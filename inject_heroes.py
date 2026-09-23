#!/usr/bin/env python3
"""inject_heroes.py - Adds home-style hero banner to about, contact, and course detail pages."""
import os, re

base = r'C:\Users\saini\OneDrive\Desktop\Talvion Acadmy IT services'

HERO_STYLE = '''<style id="talvion-page-hero-style">
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
</style>'''

SVG_CLOCK = '''<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2f65f6" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>'''


def make_hero(kicker, title, accent, desc, b1, b2, b3, cta_text, cta_href, img_src, img_alt, float_text):
    return f'''
<!-- TALVION PAGE HERO -->
<section class="tal-page-hero" aria-label="{kicker}">
  <div class="tal-page-hero-inner">
    <div class="tal-page-hero-row">
      <div class="tal-page-hero-left">
        <div class="tal-page-hero-kicker">{SVG_CLOCK} {kicker}</div>
        <h2 class="tal-page-hero-h">{title} <span>{accent}</span></h2>
        <p class="tal-page-hero-p">{desc}</p>
        <div class="tal-page-hero-badges">
          <div class="tal-page-hero-badge">&#9733; {b1}</div>
          <div class="tal-page-hero-badge">&#128640; {b2}</div>
          <div class="tal-page-hero-badge">&#127919; {b3}</div>
        </div>
        <a href="{cta_href}" class="tal-page-hero-cta">{cta_text} &#8594;</a>
      </div>
      <div class="tal-page-hero-right">
        <img src="{img_src}" alt="{img_alt}" class="tal-page-hero-img">
        <div class="tal-page-hero-float"><span class="tal-page-hero-float-dot"></span> {float_text}</div>
      </div>
    </div>
  </div>
</section>
'''


def inject(filepath, hero_html, markers):
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    if 'tal-page-hero' in content:
        print(f'SKIP (already has hero): {os.path.basename(filepath)}')
        return
    for marker in markers:
        idx = content.find(marker)
        if idx >= 0:
            pos = idx + len(marker)
            new_content = content[:pos] + '\n' + HERO_STYLE + hero_html + content[pos:]
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f'OK: {filepath}')
            return
    print(f'WARN - no injection marker found: {filepath}')


# ── ABOUT.HTML ────────────────────────────────────────────────────────────────
about_hero = make_hero(
    "INDIA'S PREMIER IT TRAINING ACADEMY",
    "Shaping Tomorrow's", "Tech Leaders",
    "Talvion Academy delivers world-class AI, Data Science, Cloud &amp; Full-Stack training with live mentoring, real projects, and guaranteed career support.",
    "Expert Mentors", "Live Projects", "Career Support",
    "Explore Our Programs", "courses.html",
    "./about-assets/talvion-about-us-final.jpg", "Talvion Academy - About Us",
    "500+ Learners Placed"
)
inject(
    os.path.join(base, 'about.html'),
    about_hero,
    ['</header><!-- .site-branding-container -->', '</header>']
)

# ── CONTACT.HTML ──────────────────────────────────────────────────────────────
contact_hero = make_hero(
    "GET IN TOUCH WITH TALVION",
    "We're Here to", "Help You Grow",
    "Have questions about our programs, admissions, or career paths? Reach out to the Talvion team &mdash; we reply within 24 hours.",
    "24h Response", "Expert Guidance", "Free Counselling",
    "Start a Conversation", "#contact-form",
    "./course-assets/talvion-roadmap-hero.jpg", "Contact Talvion Academy",
    "Support Available Mon - Sat"
)
inject(
    os.path.join(base, 'contact.html'),
    contact_hero,
    ['</header><!-- .site-branding-container -->', '</header>']
)

# ── PROGRAM / COURSE DETAIL PAGES ─────────────────────────────────────────────
courses_dir = os.path.join(base, 'courses')
skip_dirs = {'page', 'feed'}

for d in os.listdir(courses_dir):
    if d in skip_dirs:
        continue
    page = os.path.join(courses_dir, d, 'index.html')
    if not os.path.isfile(page):
        continue

    with open(page, 'r', encoding='utf-8', errors='replace') as f:
        c = f.read()

    if 'tal-page-hero' in c:
        print(f'SKIP (already has hero): courses/{d}')
        continue

    # Extract category
    cat_m = re.search(r'class="tp-category">([^<]+)<', c)
    cat = cat_m.group(1).strip().upper() if cat_m else 'PROFESSIONAL PROGRAM'

    prog_hero = make_hero(
        cat + ' PROGRAM',
        'Build Your Career in', cat,
        'Enroll in Talvion structured program. Get live mentorship, hands-on projects, and complete career support to land your dream role in tech.',
        'Structured Curriculum', 'Hands-on Projects', 'Career Support',
        'View Program Details', '#course-description',
        '../../course-assets/talvion-roadmap-hero.jpg', f'{cat} Program - Talvion Academy',
        'Enroll Today'
    )

    inject(page, prog_hero, ['</header><!-- #masthead -->', '</header><!-- .site-branding-container -->', '</header>'])

print('\nAll done!')
