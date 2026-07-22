#!/usr/bin/env bash

PLUGIN_NAME="research-writing-assistant"
PLUGIN_DESCRIPTION="面向中文科研论文的AI写作助手: 支持头脑风暴、章节写作、文献综述、Python图表、LaTeX输出"
PLUGIN_AUTHOR_NAME="Norman-bury"
PLUGIN_HOMEPAGE="https://github.com/Norman-bury/research-writing-skill"
PLUGIN_REPOSITORY="https://github.com/Norman-bury/research-writing-skill"
PLUGIN_LICENSE="MIT"
PLUGIN_KEYWORDS=(
  research
  writing
  thesis
  paper
  academic
  chinese
  latex
  literature-review
)

SRC_REPO="https://github.com/Norman-bury/research-writing-skill.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_transform() {
  local plugin_dir="$1"

  mp_remove_paths "$plugin_dir" \
    .git \
    .claude-plugin \
    .codex-plugin \
    .github \
    .codex \
    .cursor-plugin \
    .opencode \
    modules \
    GEMINI.md \
    SKILL.md
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
