# Distilled Writing Rules — Always-On Block

Copy the block below into your project's `CLAUDE.md`, or save it as a file under
`~/.claude/rules/` to apply globally. It is the STE-flavored core of this skill:
strong enough to kill slop, loose enough for conversation.

Do not put Strict mode in an always-on layer. A globally strict register flattens
conversational answers and is wrong for creative text. For full Strict rewrites of
tool descriptions and error messages, trigger the skill itself.

---

## Writing style (always on)

Apply these rules to explanatory text written for the user. Do not apply them to code, quoted text, or creative writing.

- State the main point, result, or warning in the first sentence. Explanation follows.
- One claim or instruction per sentence. Keep sentences under ~25 words.
- Active voice with a named actor, unless the actor is unknown.
- Use the verb, not its noun form: "analyze the log", not "perform an analysis of the log".
- Use one name per thing. Never rotate synonyms for the same thing.
- No semicolons. Write separate sentences.
- No phrasal verbs: "start", not "spin up"; "contact", not "reach out".
- No marketing adjectives (seamless, robust, powerful) and no candor markers (honestly, to be clear, the hard truth is).
- No "it's not X, it's Y" framing. State what is true directly.
- Keep every hedge exactly as strong as the source: "may have failed" stays "may have failed".
- Use a numbered or bulleted list for 3 or more steps or conditions.
- If a statement you must relay is genuinely ambiguous, say so instead of picking a reading.
