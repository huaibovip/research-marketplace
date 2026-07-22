# scripts

这个目录用于同步上游 plugin 仓库，并把它们转换成 marketplace 使用的标准 plugin 结构。

## 目录结构

- `scripts/update_*.sh`
- [scripts/lib/plugin-common.sh](lib/plugin-common.sh)
- [scripts/lib/write_json.py](lib/write_json.py)

其中：
- `scripts/update_*.sh` 是实际入口脚本
- `scripts/lib/plugin-common.sh` 是共享函数库，只能被 `source`，不能直接执行
- `scripts/lib/write_json.py` 负责把模板 `plugin.json` 渲染成最终 marketplace 元数据

## 两种 updater 模式

### 1. Direct clone mode

流程：
1. clone 上游仓库到 `plugins/<name>`
2. 运行插件专属清理/重组逻辑
3. 用本仓库 `template/` 下的模板恢复标准元数据

适用于：上游仓库结构已经基本接近目标 plugin 结构，只需要删除部分文件或移动少量目录。

当前使用这个模式的脚本：
- [update_academic-research-skills.sh](update_academic-research-skills.sh)
- [update_academic-research-suite.sh](update_academic-research-suite.sh)
- [update_nature-skills.sh](update_nature-skills.sh)
- [update_research-writing-assistant.sh](update_research-writing-assistant.sh)

对应高层 helper：
- `mp_update_via_direct_clone`

### 2. Selective copy mode

流程：
1. clone 上游仓库到临时目录
2. 只把需要的文件/目录复制到 `plugins/<name>`
3. 运行插件专属重组逻辑
4. 用本仓库 `template/` 下的模板恢复标准元数据

适用于：上游仓库结构和目标 plugin 结构差异较大，不能直接整仓导入。

当前使用这个模式的脚本：
- [update_zotero-cli.sh](update_zotero-cli.sh)

对应高层 helper：
- `mp_update_via_selective_copy`

## 共享函数怎么复用

### 高层主流程 helper

入口脚本应该优先只调用下面两种之一：

- `mp_update_via_direct_clone <plugin_name> <src_repo> <src_branch> <transform_fn>`
- `mp_update_via_selective_copy <plugin_name> <src_repo> <src_branch> <import_fn>`

约定：
- `transform_fn` 只接收一个参数：`<plugin_dir>`
- `import_fn` 接收两个参数：`<source_dir> <plugin_dir>`
- 两个高层 helper 都会自动从仓库根目录的 `template/` 读取 marketplace 模板文件

### 元数据约定

如果 updater 需要生成 marketplace 的 `.claude-plugin/plugin.json`，入口脚本需要声明：

- `PLUGIN_NAME`
- `PLUGIN_DESCRIPTION`
- `PLUGIN_VERSION`
- `PLUGIN_AUTHOR_NAME`
- `PLUGIN_HOMEPAGE`
- `PLUGIN_REPOSITORY`
- `PLUGIN_LICENSE`
- `PLUGIN_KEYWORDS=(...)`

其中：
- `PLUGIN_VERSION` 可以手写固定值，也可以像 `update_academic-research-skills.sh` 一样，通过 `get_repo_version "$SRC_REPO"` 自动读取上游 release/tag
- `PLUGIN_KEYWORDS` 必须是 Bash 数组，至少包含一个关键词

### 常用基础 helper

这些函数用于写插件专属转换逻辑：

- `mp_remove_paths <base_dir> <path...>`
  - 删除一组相对路径
- `mp_move_path <src> <dest>`
  - 移动文件/目录，目标父目录不存在时会自动创建
- `mp_copy_path <src> <dest>`
  - 复制文件/目录，目标父目录不存在时会自动创建
- `mp_ensure_dir <dir>`
  - 创建目录
- `mp_replace_in_file <file> <from> <to>`
  - 在文件中做简单文本替换
- `get_repo_version <repo_url>`
  - 优先读取 GitHub latest release，失败时回退到最新 tag，再失败时返回 `commit`

共享库也负责：
- repo root 定位
- 严格模式启用
- 依赖检查
- 临时目录清理
- 恢复标准 plugin 元数据：
  - `.claude-plugin/plugin.json`
  - `.codex-plugin/plugin.json`
  - `.github/plugin/plugin.json`
  - `.gitignore`

## 新增一个 updater 的最小模板

### Direct clone 示例

```bash
#!/usr/bin/env bash

PLUGIN_NAME="example-plugin"
PLUGIN_DESCRIPTION="Example plugin description."
PLUGIN_AUTHOR_NAME="Example Author"
PLUGIN_HOMEPAGE="https://github.com/example/example-plugin"
PLUGIN_REPOSITORY="https://github.com/example/example-plugin"
PLUGIN_LICENSE="MIT"
PLUGIN_KEYWORDS=(example plugin)

SRC_REPO="https://github.com/example/example-plugin.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_transform() {
  local plugin_dir="$1"

  mp_remove_paths "$plugin_dir" .git .github
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
```

### Selective copy 示例

```bash
#!/usr/bin/env bash

PLUGIN_NAME="example-selective-plugin"
PLUGIN_DESCRIPTION="Example selective-copy plugin description."
PLUGIN_AUTHOR_NAME="Example Author"
PLUGIN_HOMEPAGE="https://github.com/example/example-selective-plugin"
PLUGIN_REPOSITORY="https://github.com/example/example-selective-plugin"
PLUGIN_LICENSE="MIT"
PLUGIN_KEYWORDS=(example selective-copy)

SRC_REPO="https://github.com/example/example-selective-plugin.git"
SRC_BRANCH="main"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/plugin-common.sh"

plugin_import_layout() {
  local source_dir="$1"
  local plugin_dir="$2"

  mp_copy_path "$source_dir/skill" "$plugin_dir/skills"
  mp_copy_path "$source_dir/README.md" "$plugin_dir/README.md"
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
```

## 编写约定

- 入口脚本尽量保持“薄”：配置 + 插件专属函数 + 调用一个高层 helper
- 不要把插件专属逻辑再抽象成复杂配置格式，显式 Bash 操作更好维护
- 只有在上游结构明显不适合整仓导入时，才使用 selective copy mode
- 优先复用共享 helper，不要在入口脚本里重复写 clone、metadata restore、temp cleanup
- 如果需要 marketplace 元数据，统一通过模板渲染生成，不要在 updater 里手写 `plugin.json`

## CI 约定

GitHub Actions 只会执行：
- `scripts/update_*.sh`

因此：
- helper 文件要放在 `scripts/lib/`
- 文档文件放在 `scripts/` 下不会被执行
