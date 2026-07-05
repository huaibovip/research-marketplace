# !/bin/bash

# config
PLUGIN_NAME="research-writing-assistant"

SRC_REPO="https://github.com/Norman-bury/research-writing-skill.git"
SRC_BRANCH="main"

PLUGIN_REPO="https://github.com/huaibovip/research-marketplace.git"
PLUGIN_BRANCH=$PLUGIN_NAME


# create plugin directory
mkdir -p ./plugins
rm -rf ./plugins/$PLUGIN_NAME


# clone repository
#################################################################################
git clone -b $SRC_BRANCH --single-branch $SRC_REPO ./plugins/$PLUGIN_NAME
rm -rf ./plugins/$PLUGIN_NAME/.git
rm -rf ./plugins/$PLUGIN_NAME/.claude-plugin
rm -rf ./plugins/$PLUGIN_NAME/.codex-plugin
rm -rf ./plugins/$PLUGIN_NAME/.github/plugin
rm -rf ./plugins/$PLUGIN_NAME/.codex
rm -rf ./plugins/$PLUGIN_NAME/.cursor-plugin
rm -rf ./plugins/$PLUGIN_NAME/.opencode
rm -rf ./plugins/$PLUGIN_NAME/modules
rm -rf ./plugins/$PLUGIN_NAME/GEMINI.md
rm -rf ./plugins/$PLUGIN_NAME/SKILL.md
#################################################################################


# plugin.json
mkdir -p ./dep
git clone -b $PLUGIN_BRANCH --single-branch $PLUGIN_REPO ./dep/$PLUGIN_NAME

mkdir -p ./plugins/$PLUGIN_NAME/.claude-plugin
cp -a ./dep/$PLUGIN_NAME/plugins/template/.claude-plugin/plugin.json plugins/$PLUGIN_NAME/.claude-plugin

mkdir -p ./plugins/$PLUGIN_NAME/.codex-plugin
cp -L ./dep/$PLUGIN_NAME/plugins/template/.codex-plugin/plugin.json plugins/$PLUGIN_NAME/.codex-plugin

mkdir -p ./plugins/$PLUGIN_NAME/.github/plugin
cp -L ./dep/$PLUGIN_NAME/plugins/template/.github/plugin/plugin.json plugins/$PLUGIN_NAME/.github/plugin

cp -a ./dep/$PLUGIN_NAME/plugins/template/.gitignore plugins/$PLUGIN_NAME

rm -rf ./dep/$PLUGIN_NAME