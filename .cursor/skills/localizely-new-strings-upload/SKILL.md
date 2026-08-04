---
name: localizely-new-strings-upload
description: >-
  Add new UI copy to every lib/l10n/intl_*.arb locale with translations, upload
  EN + all other locales to Localizely, then sync. Use when the user asks to add
  localization keys, translate new feature strings, prepare Localizely strings,
  or wire S.current for new copy.
---

# Localizely new strings (full pipeline)

Personal / Cursor preference. This overrides the upload-pack-oriented skill
under `.claude/skills/` when working in Cursor.

**Always** (unless the user says otherwise): translate every locale → write
`lib/l10n` → generate → upload EN + all other languages → sync. Do not leave
empty non-EN values on Localizely or hand sync back to the user.

## Related skills (read when needed)

- **Stack / tooling:** `.claude/skills/flutter-setup-localization/SKILL.md`
- **Translation quality:** `.claude/skills/translate-mysterium-locales/SKILL.md`

Live locale files: `lib/l10n/intl_*.arb`.

## Default target locales

`en`, `de`, `pt`, `pl`, `fr`, `tr`, `ar`, `es`, `id`, `it`, `ja`, `zh`, `pt_BR`, `hi`

## End-to-end workflow (default)

1. **Confirm** — Short table (English → key → UI context) unless the user already gave exact copy/key.
2. **Translate** — All non-EN locales via **translate-mysterium-locales**. Keep `{placeholders}` / ICU. Informal tone. `pt` vs `pt_BR` differences.
3. **Write `lib/l10n/`** — New key(s) in **every** locale ARB (never EN-only). Prefer `"@key": {}` like `pausedUntil` / `renewsOn`. Same key order everywhere.
4. **Wire + generate** — `S.current.*` if needed, then `make localizely-generate`.
5. **Upload EN** — `make localizely-upload` (add-only; does **not** push other languages).
6. **Upload other locales** — Localizely REST API, **partial ARBs containing only the new key(s)**:

   ```bash
   # token from LOCALIZELY_API_TOKEN or .env.localizely
   # project_id from pubspec.yaml flutter_intl.localizely.project_id
   POST https://api.localizely.com/v1/projects/{project_id}/files/upload?lang_code={code}&overwrite=false&reviewed=false
   Header: X-Api-Token
   Form file: partial Flutter ARB (new keys only)
   ```

   - `lang_code`: `pt_BR` → `pt-BR`; others as-is (`de`, `ja`, …).
   - Default `overwrite=false` (add new keys only).
   - If Localizely already has the key with an **empty** value, re-upload that **partial** file with `overwrite=true` so empties get filled. Never upload a full `intl_*.arb` with `overwrite=true`.
7. **Verify uploads** — HTTP 200 for each locale; spot-check non-EN values are non-empty.
8. **Sync** — `make localizely-sync` only **after** step 7 succeeds. Confirm new keys still have real translations (not `""`).
9. **Hand off** — Summarize keys added + that Localizely is updated.

### Order that must not be broken

```
write all locales → generate → upload EN → upload other langs (partial) → sync
```

**Never** `make localizely-sync` (or fetch) before non-EN uploads finish — sync will pull empty strings and wipe local translations.

## Undesired results / risks

| Action | Risk | Mitigation |
|---|---|---|
| Sync before non-EN upload | Empties overwrite good local strings | Upload all langs first; sync last |
| `overwrite=true` on a **full** locale ARB | Can replace unrelated Localizely translations | Partial ARBs with **only** new keys |
| Sync after successful upload | May also pull unrelated Localizely edits into the working tree (other keys translators changed) | Expected if Localizely is source of truth; review `git diff lib/l10n` after sync |
| EN-only `make localizely-upload` | Other langs stay empty on the platform | Always follow with per-locale partial uploads |
| Skipping generate | `S.current.key` missing / analyze errors | Always `make localizely-generate` after ARB edits |

Sync itself is fine and desired once Localizely has complete translations — it aligns the repo with the platform. The failure mode we hit was syncing **incomplete** Localizely state.

## Key naming

- Suffixes: `Btn`, `Lbl`, `Title`, `Desc`, `Hint`, `Error`, `Action`, `Subtitle`, `Disclaimer`
- CamelCase; feature prefix when helpful
- Reuse existing keys when English already exists

## Include / exclude when extracting

**Include:** product UI copy. **Exclude:** wired `S.current.*` / `Tr.byKey`, test placeholders, QA/dig tools, analytics ids.

## Invocations

- “Add Access available until {date} as accessUntil”
- “Translate these strings for Localizely”
- “New feature strings → Localizely”
