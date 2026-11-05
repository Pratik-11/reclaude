#!/usr/bin/env bash
# Self-check against a fake $HOME: save, list, skip-running, pick, and the terminal hand-off.
set -euo pipefail
R=$(readlink -f "$(dirname "$0")/reclaude")
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
export HOME="$T" DISPLAY=:0 TERMINAL="$T/fake-term"
mkdir -p "$T/.claude/sessions" "$T/a" "$T/b"

sleep 60 & LIVE=$!; trap 'kill $LIVE; rm -rf "$T"' EXIT
echo "{\"kind\":\"interactive\",\"sessionId\":\"id-live\",\"cwd\":\"$T/a\",\"name\":\"alive\"}" > "$T/.claude/sessions/$LIVE.json"
echo "{\"kind\":\"interactive\",\"sessionId\":\"id-dead\",\"cwd\":\"$T/b\",\"name\":\"dead\"}" > "$T/.claude/sessions/999999.json"
echo "{broken" > "$T/.claude/sessions/$$.json"   # half-written file must not break save

"$R" save
[[ "$(cut -f2 "$T/.claude/reclaude.tsv")" == id-live ]] || { echo "FAIL save"; exit 1; }

# pretend both were open before a reboot
printf '%s\tid-live\talive\n%s\tid-gone\tgone\n%s\tid-b\tbee\n' "$T/a" "$T/nope" "$T/b" > "$T/.claude/reclaude.tsv"
grep -q 'alive.*(running)' <<<"$("$R" list)" || { echo "FAIL list"; exit 1; }

printf '#!/bin/sh\necho "$@" >> %s/opened\n' "$T" > "$TERMINAL"; chmod +x "$TERMINAL"
out=$("$R")
grep -q 'skip alive: already running' <<<"$out" || { echo "FAIL skip running"; exit 1; }
grep -q 'skip gone: .* no longer exists' <<<"$out" || { echo "FAIL skip missing dir"; exit 1; }
wait_for() { for _ in 1 2 3 4 5 6 7 8 9 10; do [[ -s "$T/opened" ]] && return; sleep 0.1; done; }
wait_for
grep -q -- "-e $R _run $T/b id-b" "$T/opened" || { echo "FAIL open"; cat "$T/opened"; exit 1; }

rm "$T/opened"; "$R" 1 >/dev/null   # pick only #1, which is running -> nothing opens
sleep 0.3; [[ ! -e "$T/opened" ]] || { echo "FAIL pick"; exit 1; }
echo "all ok"
