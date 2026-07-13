---
name: localizely-new-strings-upload
description: Extract hardcoded UI strings from a new Flutter feature, confirm sources with the user, translate into all supported locales, and generate partial Flutter ARB files for Localizely upload (add-only, no overwrite). Use when the user asks to prepare Localizely uploads, translate new feature strings, extract literal strings for localization, or create ARB upload packs for new keys.
---

# Localizely new-strings upload pack

End-to-end workflow for shipping **new** UI copy to Localizely after a feature lands with hardcoded English strings.

## Related skills (read when needed)

- **Stack / tooling:** `.claude/skills/flutter-setup-localization/SKILL.md` — ARBs live in `lib/l10n/intl_*.arb`, access via `S.current`, `make localizely-*`.
- **Translation quality:** `.claude/skills/translate-mysterium-locales/SKILL.md` — glossary, brevity, tone, ICU plurals, call-site context. Follow it for every non-EN locale.

Live locale files are `lib/l10n/intl_*.arb` (not the legacy `resources/` paths in the translate skill).

## Default target locales

`de`, `pt`, `pl`, `fr`, `tr`, `ar`, `es`, `id`, `it`, `ja`, `zh`, `pt_BR`, `hi` (+ English source). Match existing `lib/l10n/intl_*.arb` set unless the user lists a subset.

## Upload safety (always tell the user)

| Setting | Effect |
|---|---|
| `overwrite=false` (Localizely default; this repo’s `make localizely-upload`) | **Adds** new keys only; existing Localizely values stay |
| `overwrite=true` | Can replace values for keys present in the upload file |

**Always emit partial ARBs** (new keys only) under:

`resources/localizely-upload/<feature-slug>/intl_<locale>.arb`

Never upload a full locale file unless the user explicitly asks. Include a short `README.md` in that folder with upload steps and the overwrite warning.

Format: **Flutter ARB** (also acceptable on Localizely: flat Key-Value JSON — prefer ARB here).

## Workflow (do in order)

### 1. Scope

Ask which feature/files if unclear. Prefer the user’s open files / mentioned paths. Scan `lib/**/*.dart` (exclude `lib/generated/`) for user-facing string literals.

**Include:** dialog titles, body copy, buttons, hints, labels, errors shown in product UI.

**Exclude:**
- Already wired `S.current.*` / `S.of(context).*` / `Tr.byKey`
- Placeholder/test data (`Maz Product`, `Feature 1`, fake dates/prices)
- Commented-out / dead code
- QA Toolbox, network logger, other dig-only tools
- Analytics identifiers, enum `.name` values, non-UI logs

**Reuse existing keys** when the English text already exists in `lib/l10n/intl_en.arb` (e.g. `continueBtn`, `back`, `noneLbl`, `skipBtn`). Do not duplicate them in the upload pack.

### 2. Confirm with the user (required gate)

Before translating, show a summary table and **wait for confirmation**:

| # | English text | File | UI context | Proposed key |
|---|---|---|---|---|
| … | … | `path.dart` (`Widget`) | button / title / … | `camelCaseSuffix` |

Also list: **reuse existing keys**, **excluded** strings (with why).

Do not generate translations or ARB files until the user confirms (or edits the list).

### 3. Key naming

Match `intl_en.arb` conventions:

- Suffixes: `Btn`, `Lbl`, `Title`, `Desc`, `Hint`, `Error`, `Action`, `Subtitle`, `Disclaimer`
- CamelCase; feature prefix when helpful (`cancelSubscriptionTitle`, `freezeForMonths`)
- ICU plurals: declare `@key.placeholders` with `{ "count": { "type": "num" } }` when needed
- Same English for title + button → prefer two keys if register may diverge later; otherwise one key is fine

### 4. Translate

Read and apply **translate-mysterium-locales** (glossary, brevity, formality, ICU arms for `ar` / `pl` / `ja` / `zh`, brand terms).

Check call-site context in `lib/` before translating ambiguous one-word verbs/nouns.

### 5. Write partial ARBs

For each locale, write only the new keys (+ `@` metadata). Structure:

```json
{
  "@@locale": "en",
  "someKey": "…",
  "@someKey": {},
  "freezeForMonths": "{count, plural, one{…} other{…}}",
  "@freezeForMonths": {
    "placeholders": { "count": { "type": "num" } }
  }
}
```

Rules:

- 2-space indent, UTF-8, no ASCII-escaping of non-ASCII, trailing newline
- Same key order across all locale files (EN order)
- Preserve placeholders and ICU structure
- `pt` vs `pt_BR`: keep natural differences (e.g. *subscrição* vs *assinatura*) when both exist

### 6. Validate

Run a quick check across the pack: same key set/order as EN; placeholders match after stripping ICU plural blocks; ICU present where EN has it; `{count}` still in plural strings.

### 7. Hand off

Tell the user:

1. Folder path to upload
2. Upload as **Flutter ARB**, language per file, **Overwrite unchecked**
3. Upload `intl_en.arb` first, then other locales
4. Optional next steps (only if asked): merge keys into `lib/l10n/intl_en.arb`, wire `S.current.*` in Dart, `make localizely-generate` / `make localizely-fetch`

Do **not** upload to Localizely or mutate `lib/l10n/` unless the user asks.

## Invocations (examples)

- “Extract new strings from this feature and make a Localizely upload pack”
- “Translate these hardcoded strings for Localizely”
- “Prepare ARBs for the cancel-subscription dialog”
- “New feature strings → Localizely”
