# Playbook tasks. `make test` is auto-approved by the existing Bash(make:*)
# allowlist entry in claude/settings.json, so the shell test suites run without
# a permission prompt.

.PHONY: test
test:
	@fail=0; \
	for t in $$(find claude -name '*.test.sh' | sort); do \
		echo "== $$t"; \
		bash "$$t" || fail=1; \
	done; \
	exit $$fail
