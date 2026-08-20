# ASD-STE100 Skill — Simplified Technical English for Agent Output

A Claude Code skill that rewrites dense, ambiguous English into [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/) (STE) — the controlled-language standard the aerospace and defense industry built so aircraft maintenance instructions cannot be misread. It applies the same discipline to Korean text through a ruleset built for this skill (see Korean Support below).

This skill repurposes that same discipline for a different reader: an **AI agent** parsing another agent's output, a tool description, an error message, or an inter-agent instruction, with no human in the loop to resolve ambiguity.

## Why STE, and Why for Agents

STE exists because a misread instruction on an aircraft can kill people, and the intended readers were often not native English speakers with no author to call for clarification. The standard's fix: one meaning per word, active voice, simple tenses, one instruction per sentence, short sentences, no dropped words.

An LLM agent parsing another agent's output is in a strikingly similar position — no back-channel, no way to ask "did you mean X or Y?" The same rules that keep a mechanic from misreading a torque spec keep a downstream agent from misreading a tool description or an inter-agent message.

## Before / After

| Before | After |
|---|---|
| "This tool will attempt to synchronize state across the various backends that have been configured, and if a conflict is detected it may resolve it automatically depending on the strategy that has been set, or otherwise it will surface the conflict for manual review." | "The tool synchronizes state across the configured backends. If it finds a conflict, it checks the current strategy. If the strategy allows automatic resolution, the tool resolves the conflict. If not, the tool reports the conflict for manual review." |
| "An error may have occurred while processing your request due to a possible mismatch in the expected data format, which could be caused by an outdated client version." | "The request failed. The data format did not match what the server expected. Check your client version — an outdated client is the most common cause." |

More examples, including illustrations of the official STE rules themselves, in [`examples/before-after.md`](examples/before-after.md).

## What This Skill Does

1. Picks the ruleset by the language of the **target text** — [`references/rules-ko.md`](references/rules-ko.md) for Korean, [`references/rules-en.md`](references/rules-en.md) for English. A Korean conversation that asks for an English error message gets the English rules.
2. Picks a mode — **Strict** for procedures, error messages, and tool descriptions. **STE-flavored**, for READMEs, PR descriptions, and explanatory prose, keeps the sentence discipline but not the fixed-vocabulary lockdown.
3. Reads the input text for meaning.
4. Flags every rule violation sentence-by-sentence: ambiguous word choice, present-perfect/complex tense, passive voice with an unclear actor, multi-instruction sentences, oversized noun clusters, dropped words, sentences over length, phrasal verbs, nominalized actions, semicolons, hedge stacks, marketing adjectives and candor markers, buried conclusions, "it's not X, it's Y" framing, and coined labels used without definition.
5. Rewrites each flagged sentence — without dropping any fact, condition, or scope qualifier from the original. If a shorter phrasing would lose required precision, it keeps the longer phrasing and flags the trade-off instead of silently simplifying. If a sentence has two readings that context cannot resolve, it does not pick one — choosing a reading adds a claim the source did not make. One narrow exception, for instructions only: when the source states a risk but no action, the rewrite may add the action that makes the warning executable — always disclosed, never silent.
6. Outputs the rewritten text on its own — no preamble, no mode announcement, no change summary — plus a one-line `Kept as-is:` note when it deliberately left something unsimplified, a one-line `Ambiguous:` note naming both readings when the source is genuinely ambiguous, and a one-line `Added:` note naming any action added under the instruction exception. Korean output uses the localized labels `유지:`, `중의성:`, and `추가:`.

Ask for the reasoning ("show the diff", "which rules did it break") and it outputs a before/after table naming each rule instead.

The structural rules it checks are mechanical — you can point at the word or punctuation mark that breaks each one. The rules that depend on ASD's dictionary are flagged as advisory rather than enforced, and the rules that need taste are left to you.

It does **not** reproduce ASD's official ~900-word approved dictionary. The standard is free to obtain but not free to redistribute: Issue 9 permits reproduction only with ASD's written authority, or by eight listed categories of organisation that this project does not belong to. This skill applies the underlying *principle* (plainest available word, used the same way every time) rather than checking against a fixed word list. For certified STE-compliant documentation, use the real standard.

Full rule summary and citations: [`references/writing-rules.md`](references/writing-rules.md).

## Korean Support

STE is an English-only standard — its dictionary layer (900 approved English words) has no Korean counterpart, and no official Korean controlled-language standard exists. So the Korean side of this skill is an **adaptation, not a translation**: [`references/rules-ko.md`](references/rules-ko.md) transfers STE's structural discipline to Korean grammar and adds rules for the ambiguity sources Korean has and English does not:

- **주어·목적어 명시** — Korean drops subjects and objects grammatically, which makes omission the language's biggest ambiguity source for a machine reader.
- **연결어미 분리** — clause chains built on "-고", "-며", "-는데" get split into single-claim sentences.
- **이중피동 금지** — the double passive ("~되어지다") is banned outright, and plain passives need a genuinely unknown actor.
- **번역투 대응표** — a replacement table for translationese ("~하는 것을 가능하게 합니다" → "~할 수 있습니다").
- **기술 용어는 영어 그대로** — technical terms (scheduler, prefill, worker) stay in English script, and awkward Hangul transliterations (워커, 다운스트림) get rewritten back to English. Only fully established ones (에이전트, 큐) stay in Hangul. Public-sector plain-Korean guidelines recommend translating terms into Korean. This skill deliberately does not follow that recommendation, because forced translation cuts the link to source material and adds ambiguity in technical writing.

The ruleset's top principle is naturalness: a rewrite that reads like translated Korean is a failed rewrite, even when every mechanical rule passes. Imperatives use "~하세요", not the stiff "~하십시오".

Sentence-length caps are counted in 어절 (지시문 ≤12, 설명문 ≤20) — the skill's own calibration, mirroring STE's 20/25-word caps. Korean output uses localized labels: `유지:` for `Kept as-is:`, `중의성:` for `Ambiguous:`, `추가:` for `Added:`. Worked examples: [`examples/before-after-ko.md`](examples/before-after-ko.md).

## Installation

```bash
git clone https://github.com/meghendra6/asd-ste100-skill
cd asd-ste100-skill
./install.sh ko        # or: en, or both
```

The script installs all three layers described in Making It the Default: the skill into `~/.claude/skills/asd-ste100/` (runtime files only — no `.git`, no repo docs), the distilled always-on block (header stripped) into `~/.claude/rules/`, and the re-anchor command into `~/.claude/commands/`. It refuses to overwrite existing files unless you pass `--force`, and `--no-skill` / `--no-rules` / `--no-command` skip layers. If you already keep the always-on block under another file name, skip the rules layer — loading the same block twice wastes tokens every session.

Manual alternative: clone anywhere and copy the pieces yourself as described in Making It the Default.

## Usage

Trigger with a request to simplify or clarify English or Korean text:

```
Disambiguate this tool description
Rewrite this error message so an agent can't misparse it
Apply ASD-STE100 to this instruction
이 에러 메시지를 기계가 오독하지 않게 고쳐줘
이 도구 설명의 중의성을 제거해줘
```

The language of the text you hand it — not the language you ask in — selects the ruleset.

Or paste text and ask Claude to "disambiguate this" / "apply STE100 to this" / "reduce ambiguity in this output."

You get the rewritten text back and nothing else. To see which rules were applied, add "show the diff" or "explain the changes" to the request.

### Project Glossary

The lexical rules (one word per meaning) are weak without a word list. Give your project one: copy [`assets/glossary-template.md`](assets/glossary-template.md) into your project's `CLAUDE.md` and fill in the approved words. When a glossary exists, the skill enforces it as a hard rule in both directions — rewrites use only the approved word, and any listed synonym in the source is a violation.

## Making It the Default

A skill triggers when the model matches your request against its description — a probabilistic mechanism. If you want this discipline on every answer, do not rely on triggering. Do not rely on name-dropping either: practitioners who tried a bare "use ASD-STE-100" line in `CLAUDE.md` report that it rarely changes model behavior for long, because the model needs the rules in its context, not a reference to them. Style instructions also decay as a session grows — one field report saw output drift back toward old habits after roughly 100k tokens of context.

The reliable setup is three layers:

1. **Always-on distilled rules.** Copy the rules block from [`assets/distilled-rules.md`](assets/distilled-rules.md) — everything below its `---` line — into your project's `CLAUDE.md`, or save it under `~/.claude/rules/` to apply globally. It is the STE-flavored core only. Do not make the always-on layer Strict — a globally strict register flattens conversational answers and is wrong for creative text (see Scope).
2. **A re-anchor command.** Copy [`assets/ste-refresh.md`](assets/ste-refresh.md) to `~/.claude/commands/ste.md`. When a long session drifts, run `/ste` to re-assert the rules without restarting.
3. **The full skill, on demand.** Keep the skill installed for explicit Strict rewrites — tool descriptions, error messages, inter-agent instructions — where the full rule set earns its cost.

Korean-primary users: use [`assets/distilled-rules-ko.md`](assets/distilled-rules-ko.md) and [`assets/ste-refresh-ko.md`](assets/ste-refresh-ko.md) instead. The Korean distilled block includes a short English appendix, because commit messages, code comments, and error strings stay English inside a Korean session.

Why not a hook that injects the rules into every prompt? It works, but it spends tokens every turn to do what a `CLAUDE.md` block does once per session.

## Verifying It Works

Do not ask the model "repeat what you would have said without these rules" — it cannot know, and the answer proves nothing. Test with fresh context instead: run the same prompt in a new session with the rules installed and in a new session without them, then compare the outputs. Keep a few saved before/after pairs. Drift over a long session is normal. That is what `/ste` is for.

The repo ships fixed regression inputs under [`tests/`](tests/) — one file per language, each case naming the properties its output must satisfy. Run them in a fresh session after any rule change. [`MAINTENANCE.md`](MAINTENANCE.md) maps which files carry which rule, so a rule change propagates to every layer.

## Scope

Built for: agent-to-agent messages, tool/function descriptions, error messages, system prompts, inter-agent instructions — any English or Korean text a machine or non-native reader has to parse without a human to ask.

Not built for: creative writing, marketing copy, or anything where voice and nuance are the point — STE is deliberately flat and literal by design.

One limit worth stating up front: this fixes the form of a text, not its substance. A paragraph with nothing to say comes out short, clean, and still empty.

STE is also one point on a spectrum. For human-facing general documentation, ISO 24495-1 (plain language) and the Google/Microsoft style guides are often the better fit — see the Related Standards note in [`references/writing-rules.md`](references/writing-rules.md).

## Sources

- [ASD-STE100 official site](https://www.asd-ste100.org/)
- [ASD-STE100 — About STE](https://www.asd-ste100.org/about_STE.html)
- [ASD Europe — Simplified Technical English](https://www.asd-europe.org/standards-specifications/simplified-technical-english/)
- [Simplified Technical English — Wikipedia](https://en.wikipedia.org/wiki/Simplified_Technical_English)
- [TechScribe — ASD-STE100 Simplified Technical English](https://www.techscribe.co.uk/techw/asd-simplified-technical-english.htm)

## License

MIT — see [LICENSE](LICENSE).
