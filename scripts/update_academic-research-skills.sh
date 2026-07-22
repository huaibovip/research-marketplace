#!/usr/bin/env bash

PLUGIN_NAME="academic-research-skills"
PLUGIN_DESCRIPTION="Production-grade academic research pipeline: research → write → review → revise → finalize."
PLUGIN_AUTHOR_NAME="Cheng-I Wu"
PLUGIN_HOMEPAGE="https://github.com/Imbad0202/academic-research-skills"
PLUGIN_REPOSITORY="https://github.com/Imbad0202/academic-research-skills"
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

SRC_REPO="https://github.com/Imbad0202/academic-research-skills.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_transform() {
  local plugin_dir="$1"

  mp_remove_paths "$plugin_dir" \
    .git \
    .claude-plugin \
    .codex-plugin \
    .github \
    .claude \
    .codex \
    docs \
    tests \
    tools \
    skills \
    scripts/fixtures \
    scripts/test_*.py \
    scripts/check_*.py \
    CHANGELOG.md

  mp_ensure_dir "$plugin_dir/skills"
  mp_move_path "$plugin_dir/academic-paper-reviewer" "$plugin_dir/skills/academic-paper-reviewer"
  mp_move_path "$plugin_dir/academic-paper" "$plugin_dir/skills/academic-paper"
  mp_move_path "$plugin_dir/academic-pipeline" "$plugin_dir/skills/academic-pipeline"
  mp_move_path "$plugin_dir/deep-research" "$plugin_dir/skills/deep-research"
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
