# Git Commit Message Instructions

## Overview

Generate commit messages following the [Gitmoji](https://gitmoji.dev/) guide. All commit messages must use **actual emoji characters** (not shortcodes like `:sparkles:`).

## Format

```
<emoji> <subject>

[optional body]

[optional footer]
```

## Rules

1. **Emoji Usage**: Use actual emoji characters (e.g., ✨, 🐛, 📝) instead of shortcodes
2. **Code Formatting**: Wrap file names, package names, and code snippets in backticks
   - Examples: `package.json`, `eslint`, `someFunction()`, `README.md`
3. **Subject Line**:
   - Keep it concise (50 characters or less preferred)
   - Use imperative mood ("Add feature" not "Added feature")
   - Don't end with a period
4. **Body** (optional):
   - Explain what and why, not how
   - Wrap at 72 characters
   - Use backticks for technical terms
5. **Footer** (optional):
   - Reference issues/PRs if applicable
   - Breaking changes should be noted

## Examples

### Good Examples

```
✨ Add support for ESLint v9 in `index.ts`

Implement new flat config format for ESLint v9 compatibility.
Update `package.json` dependencies to support both v8 and v9.
```

```
🐛 Fix type error in `someFunction()` method

The `someFunction()` was throwing TypeScript error due to
incorrect return type annotation in `src/utils.ts`.
```

```
⬆️ Upgrade `eslint` from 8.x to 9.x

BREAKING CHANGE: Requires Node.js 18.18.0 or higher.
Migration guide: See `MIGRATION.md` for details.
```

```
📝 Update installation instructions in `README.md`
```

```
🔧 Update `tsconfig.json` with stricter type checking
```

```
♻️ Refactor `parseConfig()` to improve readability
```

### Bad Examples (DO NOT USE)

```
:sparkles: Add new feature
// ❌ Using shortcode instead of actual emoji
```

```
✨ update package.json
// ❌ Not using backticks around file name
// ❌ Not using imperative mood
```

```
🐛 fixed the bug in someFunction
// ❌ Not using backticks around function name
// ❌ Past tense instead of imperative
```

```
Updated stuff.
// ❌ No emoji
// ❌ Vague description
```

## Additional Guidelines

- Choose the most appropriate emoji from the Gitmoji guide
- When in doubt between multiple emojis, pick the one that best represents the primary purpose
- For dependency updates, use ⬆️ for upgrades, ⬇️ for downgrades, 📌 for pinning
- For breaking changes, consider using 💥 or mention "BREAKING CHANGE:" in the footer
- Keep commits atomic - one logical change per commit
- Always use backticks for technical terms: file names, package names, functions, classes, etc.

