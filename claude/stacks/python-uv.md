# Python with uv and ruff

Conventions for Python projects using `uv` as the package manager and `ruff` + `ty` as the toolchain.

## Tooling

- **Always use `uv`** for Python tooling; never `pip`.
- **Use `uv add` for dependencies**, never `uv pip install`, `uv pip list`, or `uv pip show`. This project uses uv's project-level dependency management, not pip-style subcommands.
  - Add: `uv add <package>`
  - Sync: `uv sync`
  - Run: `uv run <command>`
- **Pin dependency versions with `==`** in `pyproject.toml` (except `requires-python`, which uses `>=`).
- **No build system.** No hatchling, no setuptools. Just `pyproject.toml` with dependencies.
- **Flat package layout:** `<package_name>/` at project root, not `src/<package_name>/`.

## Formatting and linting

- **Formatting:** `uv run ruff format <file>` after editing any Python file. Don't leave hand-formatted code behind. (Some projects use `uv run yapf -r -i` instead; match what the project's `pyproject.toml` defines.)
- **Linting:** `uv run ruff check` (often configured with `select = ['ALL']` and explicit ignores).
- **Quotes:** Single quotes everywhere. Configure ruff format with `quote-style = 'single'`. The `flake8-quotes.inline-quotes` setting must match.

## Type checking

- Use `ty` for type checking: `uv run ty check`.
- Project tasks usually expose `check-types`, `test`, `lint`, and `all-tests` via `poethepoet`:
  - `uv run poe test`
  - `uv run poe lint`
  - `uv run poe check-types`
  - `uv run poe all-tests`: run on every change before considering a task done.

## Testing

- Use `pytest`.
- **Prefer `mocker` (from pytest-mock) over `monkeypatch`** for patching. Use `mocker.patch(...)` instead of `monkeypatch.setattr(...)`.

## Package structure

Every package should have a clear public API. Code outside a package imports from the package; code inside the package imports from its internal modules directly. Without a clear boundary, internals leak into the rest of the codebase, refactoring becomes risky, and circular imports proliferate.

1. Every package's `__init__.py` exports only classes/functions/constants that are actually imported from outside the package, with an explicit `__all__`. Don't export items that are only used internally or by tests/scripts.
2. A parent package re-exports its subpackage's public API; consumers import from the top-level package (e.g. `from myapp.model import Card`, not `from myapp.model.cards import Card`).
3. Code outside a package imports from the package, not from internal module files.
4. Code inside a package (including subpackages) imports from internal modules directly, never through the package's own `__init__.py`. This avoids circular imports.
5. Tests may reach into packages to test implementation details; don't export something publicly just because a test needs it.

```python
# Outside the package: use the public API
from myapp.model import Game, Player, Card

# Inside the package (myapp/model/cards/card.py): use direct module imports
from myapp.model.treasure import Treasure
```

## Anti-patterns

- **Never use `from __future__ import annotations`.** Not needed on supported Python versions, and breaks some type-introspection tooling.
- **Never add `# noqa` comments without asking permission first.** Fix the root cause of the lint warning instead. The only exception is `# noqa: ARG` for interface parameters that are intentionally unused in a specific implementation, when that's an established pattern in the codebase.
