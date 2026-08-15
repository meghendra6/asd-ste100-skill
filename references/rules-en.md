# English Rewrite Rules

The rule tables for English target text. `SKILL.md` defines the process, the two modes, the output format, the project-glossary mechanism, and the structural/lexical split these tables follow. This file supplies what to flag.

## Structural rules — apply these

| Rule | Do | Don't |
|---|---|---|
| Main point first | "Stop the job. The queue is full, and a full queue drops new tasks." — the result, command, or warning opens the paragraph | Build-up that delivers the point in the last sentence — the reader must finish the paragraph to learn what it is about. (This generalizes STE's own rule that a safety instruction must open with a clear command or condition.) |
| Active voice | "The agent deletes the file." | "The file is deleted (by the agent)." — unless the actor is genuinely unknown or irrelevant |
| No phrasal verbs (Rule 9.3) | "Remove the panel." / "Start the job." | "Take off the panel." / "Spin up the job." — a two-word verb has meanings the parts do not predict |
| One instruction per sentence | "Open the file. Read line 3." | "Open the file and read line 3, then check if it matches." |
| Sentence length | ≤20 words for instructions/procedures, ≤25 words for descriptions | Long compound/subordinate-clause sentences |
| No semicolons (Rule 8.1) | Split into separate sentences | Any semicolon at all — STE bans the mark outright, not only as a clause join. (Rule 8.1 permits every other standard punctuation mark; the em dash is *not* banned by STE, though it often signals a sentence that should be split.) |
| Noun clusters | ≤3 words stacked as a noun phrase ("fuel pump valve") | 4+ word noun stacks ("high pressure fuel pump inlet valve assembly") |
| No ellipsis | Keep the subject, verb, and article explicit even if it reads longer | Drop words to save space ("Files not backed up will be lost" → ambiguous which files) |
| Keep modality | "The request **may have** failed." stays "may have" | Promote a hedge to a fact ("The request failed.") or invent a certainty the source did not state |
| Paragraph limits | One topic per paragraph, ≤6 sentences | Multi-topic paragraphs |
| Lists for sequences | Use a numbered or bulleted list for 3+ steps or conditions | Bury a sequence inside one prose sentence |

## Lexical rules — direction of travel only

| Rule | Do | Don't | Why it is weaker here |
|---|---|---|---|
| One word, one meaning | Pick one verb for one action and reuse it every time (e.g. always "check", never mix "check"/"verify"/"confirm" for the same action) | Rotate synonyms for the same idea across a document | Consistency within a document is checkable. Which word is the *approved* one is not, without the dictionary. |
| One part of speech per word | "Apply oil to the valve" (oil = noun) | "Oil the valve" (oil = verb) | Whether "oil" is approved as a noun only is a dictionary fact. Prefer the noun form when both read equally well; do not claim compliance. |
| Verb, not noun (Rule 3.7) | "Analyze the log." | "Perform an analysis of the log." — a noun form of an action makes the sentence longer and hides who acts | Rule 3.7 says "use an **approved** verb to describe an action." Preferring the verb form is safe to apply anywhere; knowing which verb is the approved one needs the dictionary. |
| Domain terms | Keep necessary technical nouns/verbs, but define them once if not common English (STE allows a project-specific glossary beyond its base dictionary) | Use jargon without ever defining it | The glossary allowance is real STE, but the base dictionary it extends is absent. |

## Simple tenses — apply with one exception

STE permits infinitive, imperative, simple present, simple past, simple future, and past participle as adjective. It excludes present perfect and other compound forms: "we received the report", not "we have received the report".

Aircraft manuals never need present perfect, so the exclusion costs the standard nothing. Other text is not always so lucky. "The job has completed" (and its output is available now) and "the job completed" (at some past point) are different statements, and status text frequently needs the first. **Where the compound form carries information the simple form cannot — current relevance, or a hedge as in "may have failed" — keep it and flag the departure.** Elsewhere, follow the rule.

## Scan Checklist

These nine habits cover most of what makes machine-written English hard to parse. Seven are mechanical: you can point at the exact word, punctuation mark, or sentence position that breaks the rule, with no judgment call. Items 8 and 9 need one judgment on top of the scan — whether the rejected claim is worth naming, and whether a term counts as established. Scan for all nine before you rewrite anything.

1. **Synonym rotation** — the same thing gets several names in one document ("the user", "the customer", "the client"). The reader cannot tell whether they are one thing or three. Fix: pick one name, use it every time.
2. **Hedge stacking** — helper verbs and qualifiers pile up until the sentence asserts nothing ("it is important to note that this may potentially help to improve"). Fix: state the claim, or delete it.
3. **Nominalization** — an action frozen into a noun ("perform an analysis of", "provides assistance to"). Fix: use the verb ("analyze", "helps").
4. **Marketing adjectives and candor markers** — words that claim quality instead of showing it: seamless, robust, powerful, cutting-edge, effortless, blazing-fast. The same failure with sincerity instead of quality: honestly, frankly, to be clear, the hard truth is. Fix: delete, or replace with the measurement that earns the claim — the sentence must carry the claim on its own.
5. **Run-on sentences** — several ideas joined by semicolons or em dashes. Fix: one idea per sentence.
6. **Soft phrasal verbs** — spin up, reach out, dive into, kick off. Fix: use the single plain verb (start, contact, read, begin).
7. **Buried lede** — the paragraph's claim, command, or warning arrives in the last sentence, after the build-up. Fix: move it to the first sentence and let the explanation follow.
8. **"It's not X, it's Y" framing** — the sentence spends its first half on a claim it then rejects ("It's not a cache problem, it's a race condition."). Fix: state the positive claim ("It is a race condition."). Keep the contrast only when the misconception is real, named, and worth correcting.
9. **Coined labels** — a new term invented and then used as if established ("the trust ladder", "the evidence boundary"). Fix: replace it with a plain description, or define it once at first use and reuse it unchanged.
