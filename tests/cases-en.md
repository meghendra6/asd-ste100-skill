# English Regression Test Cases

Run each case in a fresh session and check every pass criterion. How to run:
`tests/README.md`.

## E1 — Dense error message (hedge preservation)

**Prompt:**

> Rewrite this error message so an agent can't misparse it:
>
> The export may have failed due to a possible timeout in the storage layer; please try again later.

**Pass criteria:**

- [ ] "may have failed" survives. "The export failed" is a promotion and fails the case.
- [ ] The timeout stays possible, not established. No invented cause, frequency, or mechanism.
- [ ] No semicolon.
- [ ] One claim per sentence.
- [ ] Output is the rewritten text only: no preamble, no mode announcement, no change summary.

## E2 — Tool description (tense + noun cluster)

**Prompt:**

> Disambiguate this tool description:
>
> This endpoint has been designed to handle the user session token refresh workflow and returns the updated credentials once the validation process has been completed.

**Pass criteria:**

- [ ] No present perfect where a simple tense carries the same meaning.
- [ ] The 5-word noun cluster ("user session token refresh workflow") is unstacked.
- [ ] Active voice with the endpoint as the named actor.
- [ ] Sentences are at or under the 25-word descriptive cap.

## E3 — Genuine ambiguity (the `Ambiguous:` line)

**Prompt:**

> Rewrite this so an agent can't misread it:
>
> The scheduler notifies the worker before it flushes the queue.

**Pass criteria:**

- [ ] The output carries an `Ambiguous:` line naming both readings (the scheduler flushes / the worker flushes).
- [ ] The body does not pick an actor for the flush.
- [ ] No passive dodge ("before the queue is flushed") that hides the missing actor.

## E4 — Warning without an action (the `Added:` discipline)

**Prompt:**

> Clean up this instruction:
>
> Run the cleanup job. Note that stale locks can remain after an interrupted run.

**Pass criteria:**

- [ ] The warning is a clear warning sentence, not buried in "note that".
- [ ] The hedge ("can remain") survives.
- [ ] One of the two: (a) no action the source did not state is added, or (b) an action is added and an `Added:` line names the added sentence and the removal condition.
- [ ] A silent addition (an added action with no label) fails the case.

## E5 — Already-compliant input

**Prompt:**

> Apply STE100 to this:
>
> Stop the deploy. The health check failed three times. Roll back to version 12.

**Pass criteria:**

- [ ] The output keeps the text as-is, or states that it already complies.
- [ ] No forced changes. Rewriting compliant text fails the case.

## E6 — Precision under length pressure

**Prompt:**

> Clean up this instruction:
>
> Retries must only be performed for idempotent requests that did not receive a response, unless the circuit breaker is open.

**Pass criteria:**

- [ ] All three conditions survive: idempotent request, no response received, circuit breaker not open.
- [ ] The passive ("must only be performed") becomes an imperative or an active sentence.
- [ ] No condition is dropped to meet the length cap. Splitting into sentences is the correct fix.
- [ ] If a sentence stays long to hold a condition, a `Kept as-is:` line says so (conditional: no label needed if splitting resolved it).
