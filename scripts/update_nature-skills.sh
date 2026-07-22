#!/usr/bin/env bash

PLUGIN_NAME="nature-skills"
PLUGIN_DESCRIPTION="A growing collection of academic workflow bundles for producing work at Nature-journal standard."
PLUGIN_AUTHOR_NAME="Yuan1z0825"
PLUGIN_HOMEPAGE="https://github.com/Yuan1z0825/nature-skills"
PLUGIN_REPOSITORY="https://github.com/Yuan1z0825/nature-skills"
PLUGIN_LICENSE="MIT"
PLUGIN_KEYWORDS=(
  nature
  academic
  science
  figure
  writing
  citation
  publication
)

SRC_REPO="https://github.com/Yuan1z0825/nature-skills.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_transform() {
  local plugin_dir="$1"

  mp_remove_paths "$plugin_dir" \
    .git \
    .claude-plugin \
    .codex-plugin \
    .github \
    scripts
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
