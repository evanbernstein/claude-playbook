# Docstring style: focus on why

Every class, interface, and method should have a docstring. The summary line should focus on **why** the code exists, how it should be used, and what problems it solves. Don't describe what the code is doing; that should be clear from reading it.

If you need to explain what the code does, that usually means the code should be made easier to read instead. Reserve "what" explanations for genuinely complex logic that can't be simplified.

**Argument docs** should explain what the argument represents and why it's needed, especially non-obvious constraints, valid values, or when a parameter is conditionally required. Types belong in the signature, not the docstring (in languages that support type annotations).

**Test docstrings** should provide detailed summaries explaining the scenario setup, what happens, and why, not terse one-liners. Focus on what the test proves, not the mechanical details of how the test is set up. Omit unnecessary precision: skip details that don't bear on what the test proves. **Never document test parameters.**

**Why:** Comments that narrate what the code is doing rot fast and add noise. Comments that explain intent, constraints, and motivation stay useful and help future readers make judgment calls.

**How to apply:**

- Before presenting any new class/method, add a docstring.
- If you can't write anything except "what this does," either the code is self-explanatory (skip the docstring's "what" part and just add "why" context if any) or the code itself needs simplification.
- For tests, describe the scenario and the claim it proves, not the setup mechanics.
- Methods that implement/override a parent class's method don't need their own docstring; the parent's is sufficient.

## Style: Python (Google docstrings)

```python
def normalize_show_date(date_string: str, *, allow_partial: bool) -> str:
    """Normalize show dates into a consistent format.

    Concert listings come in from multiple sources with inconsistent formatting
    (`YYYY-MM-DD`, `M/D/YY`, "April 5, 2019"). This is the single point where
    that variance is collapsed before downstream code touches it.

    Args:
        date_string: Raw date as provided by the source. Must contain at least a year.
        allow_partial: When True, returns a partial date (e.g. just the year)
            rather than raising. Used during backfills where some sources
            historically dropped the day.

    Returns:
        ISO-format date string.

    Raises:
        ValueError: When the string cannot be parsed and `allow_partial=False`.
    """
```

Note: types go in the signature, not in the docstring.
