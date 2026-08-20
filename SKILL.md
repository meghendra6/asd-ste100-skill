---
name: asd-ste100
description: "Use when English or Korean text must be parsed without a human to resolve ambiguity — tool descriptions, error messages, inter-agent instructions, prompts, status reports — and misreading has a real cost, or when text reads as dense, hedged, or easy to misparse. Triggers: disambiguate, STE100 rewrite, apply Simplified Technical English, plain-language rewrite, rewrite so an agent cannot misread this, 문장 다듬기, 쉬운 한국어로, 중의성 제거, 기계가 오독하지 않게. Not for creative or marketing copy."
version: 0.9.0
---

# Simplified Technical English (ASD-STE100) — English and Korean

ASD-STE100 is a controlled-language standard built by the aerospace and defense industry (ASD, the AeroSpace and Defense Industries Association of Europe) to stop maintenance technicians from misreading English instructions. The standard removes the two biggest sources of misreading: words with more than one meaning, and sentences with more than one possible structure.

This skill borrows that same discipline for a different reader: an **AI agent or a downstream system** that has to parse a string — an error message, a tool description, an inter-agent instruction, a status report — without a human in the loop to resolve ambiguity. If a maintenance technician can misread "close the valve" as an adjective ("the valve that is near") instead of a command, so can a language model.

STE itself is English-only. This skill extends the same discipline to Korean through a ruleset built for this skill — see Language Dispatch and `references/rules-ko.md`.

## When to Use This Skill

- An agent's output (explanation, instruction, log message, tool description) reads as dense, jargon-heavy, or ambiguous.
- Text will be consumed by another agent, a translation pipeline, or a non-native reader, and misparsing has a real cost.
- You are writing a prompt, system message, or tool description and want to remove ambiguity before a model ever sees it.
- You want a **before/after** comparison showing exactly which rule was violated and how the rewrite fixes it. Ask for it — the default output is the rewritten text alone (see Output Format).

This skill is not for creative or marketing copy — STE is deliberately flat and literal. Do not apply it to text where voice, nuance, or persuasion is the point.

## Language Dispatch

The process, modes, output format, and boundaries in this file are language-neutral. The rule tables are per-language:

- Korean target text → read `references/rules-ko.md`.
- English target text → read `references/rules-en.md`.

The language of the **target text** — the text to rewrite, or the text the user asks you to produce — selects the file, not the language of the conversation. A Korean conversation that asks for an English error message uses the English rules. For mixed documents, select per sentence and read both files. Read only the file or files you need.

## Two Modes

Pick a mode before rewriting. If the user does not say which, infer from the text type and state the choice in one line.

**Strict** — procedures, error messages, tool and function descriptions, inter-agent instructions, safety text. Anywhere a wrong reading has a cost. Apply every rule in the language rule file, including the hard length caps and one-word-one-meaning discipline.

**STE-flavored** — READMEs, PR descriptions, changelogs, explanatory prose. Apply the structural rules in full and treat the lexical rules as advisory (see Rule Structure for that split). In practice that means keeping the length caps, active voice, explicit actors, main-point-first order, and single-claim sentences, while dropping the one-word-one-meaning lockdown: prose needs some range, and a strict rewrite of prose reads as a personality transplant rather than a clarification.

The two modes and the structural/lexical split are the same distinction seen from two directions. The split says which rules this skill can verify without a fixed word list. The modes say which of them to enforce for a given kind of text.

## Source and Scope

This skill encodes the **rule categories** of ASD-STE100 Issue 9 (Jan 2025): 53 writing rules across 9 sections, backed by a dictionary of ~900 approved words (one meaning, one part of speech each). It does **not** reproduce that dictionary: the standard is free to obtain but not free to redistribute, so this skill applies the underlying principle — pick the plainest, most common word available and use it the same way every time — instead of checking a fixed word list. When exact ASD-approved wording matters (e.g. actual aircraft maintenance documentation), check word-by-word against [the official standard](https://www.asd-ste100.org/STE_downloads.html). The full rule summary, citations, and the redistribution terms that keep the dictionary out of this repo: `references/writing-rules.md`.

**The Korean ruleset is this skill's own adaptation, not a standard.** There is no Korean edition of ASD-STE100 and no equivalent Korean controlled-language standard. `references/rules-ko.md` transfers STE's structural discipline to Korean grammar and adds rules for ambiguity sources Korean has and English does not (omitted subjects and objects, clause chaining, the double passive), plus failure modes specific to machine-written Korean (particle-dropping telegraphic compression, noun-phrase sentence endings, em-dash overuse, metaphorical wording). It deliberately does not follow public-sector plain-Korean guidelines on points where they conflict with technical writing — most visibly, it keeps established technical terms in English instead of translating them into Korean.

## Rule Structure

Both rule files split their rules the same way, and this skill can only fully deliver one side of the split. **Structural rules** are self-contained: they describe sentence shape, and you can apply them from the description alone. **Lexical rules** need a word list to be checkable. For English, that list is ASD's dictionary, which this skill does not reproduce. For Korean, no such list exists. Without a list, the lexical rules degrade from a checkable standard into a preference for plain, consistent words.

Apply the structural rules with confidence. Apply the lexical rules as a direction of travel, and say so in your output rather than implying compliance you cannot verify. Each rule file also carries a nine-item scan checklist of the habits that most often make machine-written text hard to parse — scan for all nine before you rewrite anything.

### Project glossary — restores the lexical layer

The lexical rules are weak without a word list. A project can supply its own: a table of approved words and the synonyms they replace, kept in the project's `CLAUDE.md` or in a file the user names. When such a table exists, enforce it as a hard rule, not a preference. This goes beyond what STE's terminology allowance formally covers (domain-specific terms the base dictionary lacks) — it is a pragmatic substitute for the base dictionary this skill cannot reproduce.

```markdown
| Use | Instead of |
|---|---|
| start | initiate, commence, spin up, kick off |
| check | verify, validate, confirm |
| remove | delete, detach, take off |
```

Enforce it in both directions: use only the approved word in rewrites, and treat any listed synonym in the source as a violation to rewrite. The same mechanism fixes Korean synonym rotation across 한자어, 외래어, and 고유어 — for example, approve 확인 and list 체크 and 검증 as words to replace.

## Process

1. Identify the target text's language and read the matching rule file (see Language Dispatch).
2. Pick the mode (Strict or STE-flavored). Say which only when the user asked for the rule table — see Output Format.
3. Read the input text once for meaning — do not start rewriting before you understand what it must still say afterward.
4. Walk it sentence by sentence. Flag every violation of the rule file's tables and every habit on its scan checklist. In STE-flavored mode, flag the lexical rules but do not enforce them.
5. Rewrite each flagged sentence to fix the violation while preserving the original meaning exactly. If a rewrite would drop necessary precision (a safety condition, a scope qualifier, a number), keep the longer phrasing and flag it instead of silently simplifying.
   - **Check modality before you commit to a rewrite.** Hedges ("may", "could", "sometimes", "~일 수 있다", "~로 추정된다") carry the author's confidence, and confidence is content. A shorter sentence that upgrades a hedge to a fact is not a simplification — it is a different claim. This is the most common way a well-intentioned rewrite goes wrong, because hedges are exactly what a length cap tempts you to cut.
   - Never add a fact the source did not state. A rewrite that reads better because it supplies a cause, a frequency, or a mechanism has stopped being a rewrite. One narrow exception, for instructions only: when the source states a risk but no action, you may add the action that makes the warning executable — and you must disclose it with an `Added:` line (see Output Format). The exception covers actions, never facts.
   - **Never resolve a genuine ambiguity by choosing a reading.** When a sentence has two readings, picking the more plausible one adds a claim the source did not make — the same failure as inventing a fact, in quieter form. The test: context resolves an ambiguity only when the other readings produce text that is self-contradictory or clearly nonsensical. When two readings both make sense, first look for a phrasing that stays true and complete under both — Example A in `examples/before-after.md` does this (Korean counterpart: 예제 A in `examples/before-after-ko.md`). If every both-readings phrasing works only by dropping the disputed information (as a passive drops the actor), keep the ambiguity visible with an `Ambiguous:` line instead (see Output Format).
6. Output the rewritten text (see Output Format). Keep the mode choice and the rule analysis internal unless the user asked to see them.
7. If the input already complies, say so — do not force changes onto compliant text.

## Output Format

**Default: the rewritten text, and nothing else.** Most callers want a result they can paste straight into a tool description, an error string, or a prompt. Print the simplified text on its own. Do not add a preamble about this skill, a mode announcement, a violation count, a summary of what changed, a rule table, or a closing offer to explain further.

Three permitted additions, each a single line after the text, omitted when there is nothing to report:

- `Kept as-is:` — step 5 kept a longer phrasing on purpose. Name the phrase and the precision that would have been lost.
- `Ambiguous:` — the source has a sentence with two readings that context cannot resolve, and no phrasing covers both. Name both readings. Do not silently rewrite to one of them — choosing a reading adds a claim the source did not make.
- `Added:` — the instruction exception in step 5 added an action the source did not state. Name the added sentence and the condition for removing it (usually: the source's silence was deliberate). Never add anything without this line.

Labels follow the output language: Korean output uses `유지:` for `Kept as-is:`, `중의성:` for `Ambiguous:`, and `추가:` for `Added:`. Meaning and conditions are identical.

**On request: the rule table.** When the user asks to see the reasoning — "show the diff", "which rules did it break", "explain the changes", "before/after" — output this table instead:

```markdown
| Rule violated | Original | Simplified |
|---|---|---|
| Present perfect tense | "We have received your request." | "We received your request." |
| Noun cluster (4+ words) | "the agent task queue priority handler" | "the handler that sets task-queue priority" |

Mode: Strict. 7 violations found.
```

Follow the table with a one-line note on anything you deliberately did **not** simplify, and why (usually: simplifying would lose required precision).

## Boundaries

**Will:**
- Rewrite ambiguous or dense English or Korean into short, single-meaning, active-voice sentences, using the rule file for the target text's language.
- Return the rewritten text alone by default, and name the rules it applied when the user asks.
- Preserve every fact, condition, and scope qualifier in the original.
- Preserve the strength of every hedge, and add no claim the source did not make. The one permitted addition — an action that makes a stated warning executable, in instructions only — always carries an `Added:` line.
- Suggest a one-line glossary entry for domain terms that must stay.

**Will not:**
- Reproduce ASD's official ~900-word dictionary as if it were memorized verbatim — always treat the official download as the source of truth for exact approved wording.
- Present the Korean ruleset as ASD-STE100 or as any official standard. STE is English-only. The Korean rules transfer its discipline, and the output must not claim more.
- Simplify creative, marketing, or persuasive copy where voice and nuance are the point.
- Silently drop a safety condition, exception, or scope qualifier to shorten a sentence — it will flag the trade-off instead.
- Add content without disclosure. Facts (a cause, a frequency, a mechanism) are never added. Actions are added only under the instruction exception in Process step 5, and always with an `Added:` line.
- Resolve a genuine ambiguity by picking the more plausible reading — the output covers both readings in one phrasing, or flags them with `Ambiguous:` (the test is in Process step 5).
- Guarantee an aerospace/defense-grade STE-compliant document. This is a general-purpose clarity tool inspired by STE, not a certified STE authoring tool.
- Make weak content true or useful. These rules fix a text's *form*, not its substance — a hollow paragraph comes out clean, short, and still hollow. Say so instead of polishing it.
- Shorten past the point of clarity. The goal is removing ambiguity, not cutting words — stop when the sentence is unambiguous, not when it is shortest.

## Additional Resources

- **`references/rules-ko.md`** — the Korean rule tables: 구조 규칙, 어휘 규칙, 번역투 대응표, 스캔 체크리스트, and the localized output labels.
- **`references/rules-en.md`** — the English rule tables: structural rules, lexical rules, tense rules, and the nine-item scan checklist.
- **`references/writing-rules.md`** — fuller summary of the official standard's 9 rule sections and dictionary structure, with citations.
- **`examples/before-after.md`** — worked English examples, including official STE examples and agent-output examples built for this skill.
- **`examples/before-after-ko.md`** — worked Korean examples built for this skill.
