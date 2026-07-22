#!/usr/bin/env python3

import json
import os
import sys
from pathlib import Path


def escape_json_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)[1:-1]


def main() -> int:
    if len(sys.argv) < 3:
        raise SystemExit("usage: write_json.py <template_path> <target_path> [keywords...]")

    template_path = Path(sys.argv[1])
    target_path = Path(sys.argv[2])
    keywords = sys.argv[3:]
    content = template_path.read_text(encoding="utf-8")

    replacements = {
        "<plugin_name>": escape_json_string(os.environ["PLUGIN_NAME"]),
        "<plugin_description>": escape_json_string(os.environ["PLUGIN_DESCRIPTION"]),
        "<plugin_version>": escape_json_string(os.environ["PLUGIN_VERSION"]),
        "<author_name>": escape_json_string(os.environ["PLUGIN_AUTHOR_NAME"]),
        "<plugin_homepage>": escape_json_string(os.environ["PLUGIN_HOMEPAGE"]),
        "<plugin_repository>": escape_json_string(os.environ["PLUGIN_REPOSITORY"]),
        "<plugin_license>": escape_json_string(os.environ["PLUGIN_LICENSE"]),
        "<plugin_keywords>": '",\n        "'.join(escape_json_string(keyword) for keyword in keywords),
    }

    for placeholder, value in replacements.items():
        content = content.replace(placeholder, value)

    target_path.write_text(content, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
