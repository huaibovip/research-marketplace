#!/usr/bin/env bash

PLUGIN_NAME="academic-research-suite"
PLUGIN_DESCRIPTION="Production-grade academic research pipeline (Codex): research → write → review → revise → finalize."
PLUGIN_AUTHOR_NAME="Cheng-I Wu"
PLUGIN_HOMEPAGE="https://github.com/Imbad0202/academic-research-skills-codex"
PLUGIN_REPOSITORY="https://github.com/Imbad0202/academic-research-skills-codex"
PLUGIN_LICENSE="CC-BY-NC-4.0"
PLUGIN_KEYWORDS=(
  academic
  research
  writing
  review
  deep-research
  literature-review
  systematic-review
  peer-review
  scholarly-publishing
)

SRC_REPO="https://github.com/Imbad0202/academic-research-skills-codex.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_transform() {
  local plugin_dir="$1"

  mp_remove_paths "$plugin_dir" \
    .git \
    .agents \
    .codex-plugin \
    .claude-plugin \
    .github \
    .claude \
    .codex \
    plugins \
    skills/academic-research-suite/ars/docs \
    skills/academic-research-suite/ars/tests \
    skills/academic-research-suite/ars/tools \
    skills/academic-research-suite/ars/scripts/fixtures \
    skills/academic-research-suite/ars/scripts/test_*.py \
    skills/academic-research-suite/ars/scripts/check_*.py \
    skills/academic-research-suite/codex/tests \
    CHANGELOG.md
}

main() {
  mp_enable_strict_mode
  mp_setup_cleanup_trap
  mp_require_cmd git
  mp_init_repo_context

  PLUGIN_VERSION="$(get_repo_version "$SRC_REPO")"

  mp_update_via_direct_clone \
    "$PLUGIN_NAME" \
    "$SRC_REPO" \
    "$SRC_BRANCH" \
    plugin_transform
}

main "$@"
