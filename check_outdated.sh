#!/usr/bin/env bash
pod outdated | sed -e 's/^- /warning: Dependency outdated:/'