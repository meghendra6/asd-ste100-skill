# Project Glossary Template

Copy the table below into your project's `CLAUDE.md`, or into a file you name to
the skill. When a glossary exists, the skill enforces it as a hard rule in both
directions: rewrites use only the approved word, and any listed synonym in the
source text is a violation to rewrite. The mechanism is defined in `SKILL.md`
(Project glossary). This file is a template for humans — the skill never loads it.

Keep one row per action or object, and list only the synonyms your documents
actually rotate. A glossary of hypothetical synonyms is noise. Korean projects:
list 한자어, 외래어, and 고유어 variants in the same row — synonym rotation
across those three classes is the failure the glossary exists to stop.

---

## Project Glossary

| Use | Instead of |
|---|---|
| start | initiate, commence, spin up, kick off |
| check | verify, validate, confirm |
| remove | delete, detach, take off |
| 확인 | 체크, 검증, 점검 |
| 삭제 | 제거, 지우기 |
| scheduler | 스케줄러, 일정 처리기 |

Maintenance rules:

- One approved word per row. If two rows share a word, merge the rows.
- Technical terms that must stay in English script (scheduler, prefill) belong
  here when the team wavers between the English form and a transliteration.
- Review the table when a new synonym appears in real documents, not on a
  schedule.
