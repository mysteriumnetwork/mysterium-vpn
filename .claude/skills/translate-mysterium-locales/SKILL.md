---
name: translate-mysterium-locales
description: Use when translating Mysterium VPN locale JSON/ARB files between languages, generating new locale files, or filling missing translations — encodes glossary, brand handling, placeholder/ICU plural preservation, brevity rules, and per-locale tone/formality so output is consistent run-to-run and stays UI-tight.
---

# Translating Mysterium VPN Locales

## Overview

Locale files live at `resources/langs/{lang}.json`. The canonical English source for translation is `resources/cleaned/en.cleaned.json` (Localizely-compatible: flat keys, ICU plural strings). Other locales follow the same key set.

**Core principle: translate the UI element, not the words.** Before translating any non-trivial key, look up where it's used in `lib/**/*.dart` (excluding `lib/generated/`). The English string is a hint; the call site is the ground truth. A "Stay" button in a logout dialog and a "Stay" label on a recents screen are different translations. The key-name suffix (`Btn`/`Lbl`/`Title`/`Desc`/`Action`/`Subtitle`/`Disclaimer`) is the second-strongest signal — match the register and length budget of the UI element type, not just the source words.

**Secondary principle: UI strings stay short.** A button label that's 8 characters in English must not become 38 characters in another language. When in doubt, prefer the tighter phrasing even if the source has slightly more flavor.

## Hard Rules (Never Violate)

1. **Preserve every placeholder verbatim.** `{}`, `{store}`, `{email}`, `{amount}`, `{period}`, `{percent}`, `{planId}`, `{date}`, `{errorCode}`, `{couponCode}`, `{statesNum}`, `{count}`. Do not translate, reorder relative to surrounding words only when grammar requires it.
2. **Preserve ICU plural structure.** `{count, plural, one {…} other {…}}` — only translate inner text. Keep `{count}` inside arms. Add `zero`/`few`/`many` arms only when the target language's CLDR rules require them (e.g., Arabic, Russian).
3. **Preserve emoji and flag glyphs.** 🇪🇸 🇩🇪 etc. stay exactly as in source.
4. **Preserve smart quotes and typographic characters** when present in source: `'` `'` `"` `"` `…` `—`. Normalize source `" - "` (space-hyphen-space) to ` — ` when typographically natural in the target language.
5. **JSON output:** same key order as source, 2-space indent, UTF-8 (do not escape non-ASCII), trailing newline.

## Do-Not-Translate Glossary

Keep these exact across **all** locales:

| Term | Notes |
|---|---|
| `Mysterium VPN`, `MysteriumVPN`, `Mysterium Network` | Brand. Preserve source casing/spacing. |
| `VPN` | Acronym, universally recognized. |
| `IP`, `DNS`, `API`, `P2P`, `NSFW`, `QA` | Acronyms. Never expand. |
| `WireGuard`, `OpenVPN` | Protocol names. |
| `Apple`, `Google`, `App Store` | Brand names. |
| `Basic`, `Plus` | Plan tier names — keep English for cross-locale consistency. |
| `Wi-Fi` | Standardized term. |
| `Streaming` | Loanword; keep English unless target locale has a dominant native term (e.g., 流媒体 acceptable in ZH). |
| `QA Toolbox` | Internal tool label — **never** expand to "control de calidad" or equivalent. |
| Plan/IP type names already in English in source (`Best speed`, `Max privacy`, `Low latency`) | Translate normally — these are not brand terms. |
| `kill switch` | Industry term. Keep English in DE/JA/ZH. ES/IT/PT/FR/TR/ID/AR may keep English; only translate when there is a well-established native term in the VPN market. |

## Brevity Rules

| Key suffix / type | Length target vs source |
|---|---|
| `*Btn`, `*Action` (buttons) | within ±50% chars (Spanish/Italian/Portuguese: ±100% for short EN sources <8 chars — "Reset"→"Restablecer" is unavoidable) |
| `*Lbl`, `*Title` (labels, titles) | within ±50% chars |
| `*Desc`, `*Subtitle`, `*Message`, `*Body` (descriptions) | within ±50% chars |
| `*Disclaimer` | match source intent; concise > literal |

**The hard rule isn't a ratio — it's: don't add words the source didn't have.** "Reset" → "Restablecer" is fine (one word → one word). "QA Toolbox" → "Caja de herramientas de control de calidad" is not (2 words → 7, expanded the acronym).

If you can't fit, drop the least-load-bearing word — not the placeholder, not the brand, not the action verb.

**Anti-patterns to avoid:**
- ❌ `QA Toolbox` → `Caja de herramientas de control de calidad` (expanding acronyms)
- ❌ `Refresh IP` → `Actualizar la dirección IP` (verbose for a button)
- ❌ `Settings` → `Configuración del sistema` (over-translation)
- ❌ Rewriting in a more formal register than source
- ❌ Adding "por favor" / "bitte" / etc. where source has no "please"

## Per-Locale Tone & Formality

| Locale | Form of address | Notes |
|---|---|---|
| es | informal `tú` (consumer app, global Spanish) | "Inicia sesión", "Tu cuenta". Avoid `usted`. |
| fr | informal `tu` | "Connecte-toi", "Ton compte". |
| it | informal `tu` | "Accedi", "Il tuo account". |
| pt | informal `você` (Brazilian-leaning) | "Entrar", "Sua conta". |
| de | informal `du` | "Melde dich an", "Dein Konto". |
| ja | です／ます polite-neutral | No 敬語 keigo. Avoid "ください" overuse. |
| zh | Simplified, neutral. No 您 unless source is formal. |
| tr | informal `sen`-form | "Giriş yap", "Hesabın". |
| id | informal standard | "Masuk", "Akunmu". |
| ar | Modern Standard Arabic, neutral; ensure RTL-safe (avoid mixing punctuation that breaks bidi). |

## Plural Rules Per Locale

When converting English `one/other` plurals to other locales, **only add CLDR-required arms**:

- es, fr, it, pt, de, tr, id: `one` + `other` (same as English)
- ja, zh: only `other` (no plural distinction) — translate as if `other`
- ar: `zero`, `one`, `two`, `few`, `many`, `other` (six forms) — provide all
- ru (if added later): `one`, `few`, `many`, `other`

## Workflow

1. Read `resources/cleaned/en.cleaned.json` as source of truth.
2. **Map ambiguous keys to call-site context first.** Dispatch an Explore agent (or grep `lib/` excluding `lib/generated/`) for `LocaleKeys.<keyName>` usages. Identify UI element type (Text/AppBar title/dialog title/dialog action/banner CTA/dropdown option/tooltip/badge/bullet point/status indicator) and feature area (settings/onboarding/paywall/login/location picker). Skip obvious keys (`cancelBtn`, country codes, plain error messages) — focus on:
   - One-word verbs that could be button/status/title (Stay, Confirm, Reset, Refresh, Allow, Continue, Update, Submit, Delete, Manage)
   - One-word nouns that could be section/value/header (Home, Account, Connection, Subscription, Hidden, Residential)
   - Theme/dropdown values (`light`, `dark`, `system`, `noneLbl`, `malwareLbl`)
   - Status indicators (`connected`, `connecting`, `disconnected`, `disconnecting`) — match OS-style phrasing in target locale
   - Comparison-card bullets and onboarding text
3. Translate per the call-site context, applying the glossary and brevity rules below. Preserve placeholders and ICU structure.
4. Write to `resources/langs/{lang}.cleaned.json` (do not overwrite the legacy `{lang}.json` — that still feeds easy_localization at runtime).
5. Verify with the validation script (see below) before claiming done.

### Context-Driven Translation Cheatsheet

| Source word/phrase | Naive translation | Context-aware translation |
|---|---|---|
| `system` (theme value) | "Predeterminado" / "Standard" (literal "Default") | **"Sistema" / "System"** — matches OS theme-picker convention |
| `connecting` / `disconnecting` (status badge in top bar) | imperative form | use the OS-style status phrasing (DE: "Wird verbunden…" not "Verbinde…") |
| `preferences` vs `settings` (two section headers in same screen) | both → "Einstellungen" | distinguish with `preferences` → "Allgemein" (General) in DE; "Preferencias" works in ES |
| `kill switch` (tooltip title) | "Notausschalter" | **"Kill Switch"** — industry term, kept English |
| `BEST VALUE` (badge above plan card) | "MEJOR VALOR" / "BESTER WERT" | **"MEJOR PRECIO" / "BESTPREIS"** — German/Spanish marketing convention |
| `residential` / `Residential IPs` (IP-type term) | keep English "Residential IPs" | **Localize per-locale** — mirror the `datacenter` treatment (native word or transliteration, `IP` acronym stays Latin). See the "Datacenter / Residential IP-type terms" section below. |
| `stayButton` ("Stay") on logout/device-limit dialog | could be "remain logged in" | "Bleiben" / "Quedarme" — means "stay on this screen", a dismiss action |
| `recentLocations` (section header for VPN locations) | "Ubicaciones recientes" / "Letzte Standorte" | both work; DE "Zuletzt verwendet" is more idiomatic for a recents list |
| Comparison-card bullet points (`*ComparisonCardItem*`) | full-sentence translation | trim to ≤ 4 words; these are pill-style bullets |
| `userIntent*` keys | translate as generic phrase | these are **preset names** (Best speed, Max privacy, Low latency) — keep as product feature labels, not generic advice |

## Datacenter / Residential IP-type terms

The two IP-type terms — **`datacenter`** (`highSpeed`, `ipTypeDataCenter`, …) and **`residential`** (`ipTypeResidential`, `residential`, `residentialCentre…`, `residentialEducation…`, `subscriptionPlanResidentialIPs`, …) — are **localized in every locale**, NOT kept English. The `IP` / `IPs` acronym always stays Latin; only the descriptor word is translated (native term) or transliterated (non-Latin scripts). Keep the two terms parallel within a locale (same strategy for both). Use these agreed forms:

| Locale | `datacenter` → | `residential` → | short label (`residential`) |
|---|---|---|---|
| en (source) | Datacenter IPs | Residential IPs | Residential |
| de | Datacenter-IPs | **Haushalts-IPs** | Haushalt |
| es | IP de centro de datos | **IP residenciales** | Residencial |
| fr | IP de centre de données | **IP résidentielles** | Résidentiel |
| it | IP datacenter | **IP residenziali** | Residenziale |
| pt / pt-BR | IPs de datacenter | **IPs residenciais** | Residencial |
| tr | Veri merkezi IP'leri | **Konut IP'leri** (case-suffix per sentence) | Konut |
| pl | IP z centrów danych | **IP mieszkaniowe** (declined per sentence) | Mieszkaniowe |
| id | IP datacenter | **IP residensial** | Residensial |
| ja | データセンター IP | **レジデンシャル IP** (katakana) | レジデンシャル |
| zh | 数据中心 IP | **住宅 IP** | 住宅 |
| hi | डेटासेंटर IPs | **आवासीय IPs** | आवासीय |
| ar | عناوين IP لمراكز البيانات | **عناوين IP سكنية** | سكني |

Established 2026-07: the app-repo owner explicitly decided residential must be localized everywhere (so it stops looking untranslated next to the already-localized datacenter). Do NOT revert either term to bare English in a translated locale.

## Validation Script

After producing a translated file, run:

```bash
python3 - <<'PY'
import json, re
src = json.load(open('resources/cleaned/en.cleaned.json'))
tgt = json.load(open('resources/cleaned/LOCALE.cleaned.json'))

missing = set(src) - set(tgt); extra = set(tgt) - set(src)
assert not missing, f"missing keys: {missing}"
assert not extra,   f"extra keys: {extra}"
assert list(src) == list(tgt), "key order differs"

# Strip ICU plural blocks before placeholder scan so arm content {Reenviar} isn't
# mistaken for a placeholder
icu_block = re.compile(r'\{[a-zA-Z]+,\s*plural,.*?\}\}', re.DOTALL)
placeholder = re.compile(r'\{[a-zA-Z][a-zA-Z0-9_]*\}|\{\}')
icu_open = re.compile(r'\{[a-zA-Z]+,\s*plural,')

def phs(s):
    return sorted(placeholder.findall(icu_block.sub('', s)))

issues = []
for k in src:
    sv, tv = str(src[k]), str(tgt[k])
    if phs(sv) != phs(tv):
        issues.append(f"{k}: placeholders {phs(sv)} -> {phs(tv)}")
    if icu_open.search(sv) and not icu_open.search(tv):
        issues.append(f"{k}: ICU plural lost")
print("OK" if not issues else "\n".join(issues))
PY
```

## Red Flags — Stop and Rework

- A button translation > 1.5× source length → pick shorter synonym
- An acronym got expanded → revert
- A placeholder is missing or renamed → fix immediately
- An ICU plural block lost its structure → re-author
- Added "please/per favor/bitte" not in source → remove
- Switched to formal register without reason → revert to informal
