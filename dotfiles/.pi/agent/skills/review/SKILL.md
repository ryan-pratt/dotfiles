---
name: review
description: Reviews changes on the current git branch against its base branch. Opens hunk in a new herdr tab and leaves agent review notes on the diff.
---

# Branch Review

Review the current branch's changes against its base branch using Hunk in a new Herdr tab.

## Workflow

1. **Determine the base branch:**

   ```bash
   # Try upstream tracking branch first
   base=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null | sed 's|^origin/||')

   # If no upstream, find the merge-base with common default branches
   if [ -z "$base" ]; then
     for candidate in main master develop; do
       if git rev-parse --verify "$candidate" >/dev/null 2>&1; then
         base="$candidate"
         break
       fi
     done
   fi

   current=$(git rev-parse --abbrev-ref HEAD)
   echo "Reviewing $current against $base"
   ```

2. **Create a new Herdr tab and launch Hunk:**

   Use `herdr_layout` to create a new tab, then `herdr_pane run` to start hunk:

   ```bash
   hunk diff $base...$current
   ```

   Wait for hunk to fully load before proceeding.

3. **Review the changes:**

   Load the hunk-review skill from `/Users/rpratt/.pi/agent/skills/hunk-review/SKILL.md` and follow its workflow:

   - Use `hunk session review --repo . --json` to understand the file/hunk structure
   - Use `hunk session review --repo . --include-patch --json` to read diffs you need to analyze
   - Navigate through ALL files and hunks systematically
   - Be a critical reviewer—your job is to find problems, not approve code

4. **Summarize:** After adding notes, provide a brief summary of key findings.

## Review Priorities

Focus on finding real issues in this order:

1. **Bugs and correctness issues:**
   - Logic errors, off-by-one errors, null/undefined handling
   - Race conditions, deadlocks, resource leaks
   - Missing error handling, uncaught exceptions
   - Edge cases not covered
   - Incorrect assumptions about inputs or state

2. **Performance issues:**
   - Unnecessary allocations or copies
   - O(n²) or worse algorithms where O(n) is possible
   - Missing caching opportunities
   - Blocking operations in hot paths
   - Database N+1 queries, missing indexes
   - Unbounded growth (memory leaks, cache without eviction)

3. **Maintainability issues:**
   - Overly complex logic that should be simplified
   - Missing or misleading abstractions
   - Code duplication that should be extracted
   - Poor naming that obscures intent
   - Tight coupling that will make changes difficult
   - Magic numbers or hardcoded values that should be constants

4. **Test coverage:**
   - New code paths without corresponding tests
   - Edge cases not tested
   - Tests that don't actually verify behavior (weak assertions)
   - Missing integration tests for new integrations
   - Flaky test patterns (time-dependent, order-dependent)

5. **Idiomatic code:**
   - Non-idiomatic patterns for the language/framework
   - Reinventing standard library functionality
   - Ignoring language-specific best practices
   - Misuse of language features

## Guidelines

- **Be critical:** Your job is to find problems. Assume there are bugs until proven otherwise.
- **Be specific:** Point to exact lines and explain *why* something is wrong, not just *that* it's wrong.
- **Be actionable:** Suggest concrete fixes, not vague improvements.
- **Prioritize severity:** Focus on bugs and performance over style.
- **Skip the praise:** Don't comment just to say code looks good—only comment when there's an issue or concern.
- **Question assumptions:** If code assumes something about inputs, state, or environment, verify it's safe.
- Use `comment apply` for batches of notes when you have several ready
- Navigate before commenting so the user sees the relevant code
