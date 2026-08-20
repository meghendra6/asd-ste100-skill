# Regression Tests

Fixed inputs for verifying the skill after any rule change. Each case names the
properties its output must satisfy. The texts are fixtures built for testing.
They are deliberately different from `examples/`: the example files load into
context with the skill, so a match against them proves recall, not
rule-following.

## How to run a case

1. Start a fresh session with the skill installed. Fresh means no earlier
   conversation in context.
2. Paste the case's prompt verbatim.
3. Check the output against the case's pass criteria. Every criterion must hold.

For an A/B comparison (does the skill change behavior at all), run the same
prompt in a fresh session without the skill and diff the two outputs.

## When to run

- After any edit to `SKILL.md`, `references/rules-*.md`, or `examples/`.
- Before bumping the version in `SKILL.md`.

Record each run as a date-stamped markdown file under `tests/results/`, so the
next change can compare against the last known-good run.

## Case files

- [`cases-en.md`](cases-en.md) — English target text, cases E1–E6.
- [`cases-ko.md`](cases-ko.md) — Korean target text, cases K1–K6.

Each language covers the same six behaviors: telegraphic/dense input repair,
lexical-rule violations, genuine ambiguity (`Ambiguous:`/`중의성:`), the
instruction exception (`Added:`/`추가:`), already-compliant input, and
precision preservation under length pressure.
