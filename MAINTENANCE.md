# Maintenance Guide

For maintainers of this repo. Nothing in this file loads at runtime.

## File roles and load timing

| File | Role | Loaded when |
|---|---|---|
| `SKILL.md` | skill body: process, modes, output format, glossary mechanism | every skill trigger |
| `references/rules-en.md`, `rules-ko.md` | per-language rule tables | on trigger, after language dispatch |
| `references/writing-rules.md` | official-standard summary and citations | on demand only |
| `examples/before-after.md`, `before-after-ko.md` | worked examples | on demand only |
| `assets/distilled-rules.md`, `-ko.md` | always-on block masters (the part below `---`) | never by the skill; once per session after install |
| `assets/ste-refresh.md`, `-ko.md` | re-anchor command masters | never by the skill; on `/ste` after install |
| `assets/glossary-template.md` | project glossary starter | never |
| `tests/` | regression fixtures and results | never |
| `install.sh`, `MAINTENANCE.md`, `README.md`, `references/fluent-korean/` | tooling, docs, vendored reference | never |

## Rule sync matrix

The same rule lives in up to six files at different densities. When you change
a rule, walk its row and update every ● file, then run `tests/`.

Legend: ● present, — absent. "부록" = present only in the file's English
appendix (rules for English text inside a Korean session).

| Rule | rules-en | rules-ko | distilled-en | distilled-ko | refresh-en | refresh-ko |
|---|---|---|---|---|---|---|
| Main point / warning first | ● | ● | ● | ● | ● | ● |
| One claim or instruction per sentence | ● | ● | ● | ● | ● | ● |
| Numeric sentence-length caps | ● 20/25w | ● 12/20어절 | ● ~25w | — (split-when-long) | ● ~25w | — (split-when-long) |
| Active voice, named actor / explicit arguments | ● | ● | ● | ● | ● | ● |
| Hedge/modality preservation | ● | ● | ● | ● | ● | ● |
| Disclose genuine ambiguity, never pick a reading | SKILL.md | SKILL.md | ● | ● | ● | ● |
| Nominalization → verb | ● | ● | ● | ● | ● | ● |
| One name per thing | ● | ● | ● | ● | ● | ● |
| Marketing adjectives / candor markers ban | ● | ● | ● | ● | ● | ● |
| "not X but Y" framing ban | ● | ● | ● | ● | ● | ● |
| Coined-label ban | ● | ● | ● | ● | ● | ● |
| Lists for 3+ steps or conditions | ● | ● | ● | ● | — | — |
| No semicolons | ● | ● | ● | 부록 | ● | 부록 |
| No phrasal verbs | ● | — | ● | 부록 | ● | 부록 |
| Noun-cluster / 압축 명사구 limit | ● | ● | — | — | — | — |
| No dropped words / telegraphic (전보체) ban | ● (ellipsis) | ● | — | ● | — | ● |
| Simple tenses (with modality exception) | ● | — | — | — | — | — |
| One part of speech per word | ● | — | — | — | — | — |
| Paragraph limits | ● | — | — | — | — | — |
| Double passive (이중피동) ban | — | ● | — | ● | — | ● |
| Clause-chain (연결어미) limit | — | ● | — | ● | — | ● |
| Demonstrative (지시어) ban — name the referent | — | ● | — | ● | — | — |
| Speech-level consistency, "~하세요" not "~하십시오" | — | ● | — | ● | — | ● |
| Double negative ban | — | ● | — | — | — | — |
| "-겠-" restriction | — | ● | — | — | — | — |
| Em-dash restraint | — (note) | ● | — | ● | — | ● |
| Technical terms in English script | — | ● | — | ● | — | ● |
| Translationese replacement table | — | ● | — | ● (부분) | — | ● (한 줄) |
| Metaphor / low-frequency vocab restraint | — | ● | — | ● | — | ● |
| Concrete word choice | — | ● | — | ● | — | ● |
| Positive morphology (부사·보조용언·선어말어미) | — | ● | — | ● | — | ● |
| Explanation pacing + single-fact clamp | — | — | — | ● | — | ● |
| No tone mirroring | — | — | — | ● | — | ● |
| Subagent prompt/relay coverage | — | — | — | ● | — | ● |
| Output labels (`Kept as-is:`/`Ambiguous:`/`Added:`) | SKILL.md | + rules-ko 출력 라벨 | — | — | — | — |

Label changes also touch both example files (`examples/before-after*.md`) and
the README's process summary.

## Change checklist

1. Edit the rule in its primary file (`rules-en.md` or `rules-ko.md` for skill
   behavior; `distilled-*.md` for the always-on layer).
2. Walk the matrix row. Update every file marked ●.
3. Output-label changes propagate to: `SKILL.md` (Output Format, Process step 5,
   Boundaries), `rules-ko.md` (출력 라벨), both example files, README.
4. Run the `tests/` cases in fresh sessions. Record results under
   `tests/results/` as date-stamped markdown.
5. Bump `version` in `SKILL.md` frontmatter.
6. Always-on block (`distilled-*.md`) content changes need blind A/B evidence
   before merging — see commit 3e20328 for the method (fresh sessions, isolated
   system prompts, user-judged, multiple rounds). Form matters as much as
   content: keep `distilled-ko.md` in prose form (list-form blocks measurably
   primed stilted output), and do not re-summarize it into a list.

## Open items

- `distilled-rules.md` (English) is still list-form. The prose-form win
  (commit 3e20328) was measured on Korean output only. Run an English blind A/B
  before converting — do not convert on the Korean evidence alone.
- `ste-refresh-ko.md` omits the 지시어 (demonstrative) rule its master carries.
  Both refresh files also omit the lists-for-3+ rule — that pair looks
  deliberate (brevity), the 지시어 omission may not be. Review on the next
  refresh-layer A/B.
- `rules-en.md` has no concrete-word-choice rule; `rules-ko.md` does. Decide
  whether the asymmetry is intentional (English STE vocabulary discipline
  partially covers it) or a gap.
- A/B evidence lives in commit messages (3e20328, d33d9dc). Future runs: save
  the comparison documents under `tests/results/` so evidence outlives the
  commit log.
