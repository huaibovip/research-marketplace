#!/usr/bin/env bash

PLUGIN_NAME="zotero-cli"
PLUGIN_DESCRIPTION="Zotero command-line interface for managing references."
PLUGIN_AUTHOR_NAME="Agents365-ai"
PLUGIN_HOMEPAGE="https://github.com/Agents365-ai/zotero-cli-cc"
PLUGIN_REPOSITORY="https://github.com/Agents365-ai/zotero-cli-cc"
PLUGIN_LICENSE="AGPL-3.0"
PLUGIN_KEYWORDS=(
  academic
  research
  zotero
  cli
)

SRC_REPO="https://github.com/Agents365-ai/zotero-cli-cc.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_import_layout() {
  local source_dir="$1"
  local plugin_dir="$2"

  mp_copy_path "$source_dir/skill" "$plugin_dir/skills"
  mp_copy_path "$source_dir/README.md" "$plugin_dir/README.md"
  mp_copy_path "$source_dir/README_CN.md" "$plugin_dir/README_CN.md"
  mp_copy_path "$source_dir/LICENSE" "$plugin_dir/LICENSE"
  mp_copy_path "$source_dir/LICENSE-COMMERCIAL" "$plugin_dir/LICENSE-COMMERCIAL"
  mp_copy_path "$source_dir/.gitignore" "$plugin_dir/.gitignore"

  mp_move_path "$plugin_dir/skills/zotero-cli-cc" "$plugin_dir/skills/zotero-cli"
  mp_replace_in_file "$plugin_dir/skills/zotero-cli/SKILL.md" "zotero-cli-cc" "zotero-cli"
}

main() {
  mp_enable_strict_mode
  mp_setup_cleanup_trap
  mp_require_cmd git
  mp_init_repo_context

  PLUGIN_VERSION="$(get_repo_version "$SRC_REPO")"

  mp_update_via_selective_copy \
    "$PLUGIN_NAME" \
    "$SRC_REPO" \
    "$SRC_BRANCH" \
    plugin_import_layout
}

main "$@"
