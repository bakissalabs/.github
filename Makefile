.PHONY: setup-hooks

# Active les hooks du dépôt (attribution, gitleaks) ; règle dans le CLAUDE.md de bakissalabs/bakissa.
setup-hooks:
	git config core.hooksPath .githooks
	chmod +x .githooks/commit-msg .githooks/pre-push
	@command -v gitleaks >/dev/null 2>&1 || echo "gitleaks absent : le pre-push ne scanne pas les secrets (brew install gitleaks) ; la CI le fera."
