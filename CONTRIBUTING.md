# Contributing to reclaude

Thanks for helping out! Bug reports, terminal support, ideas and fixes are all welcome.

## Found a bug?

[Open a bug report](https://github.com/Pratik-11/reclaude/issues/new?template=bug_report.md). Include:

- your distro and terminal (`echo $XDG_CURRENT_DESKTOP; ps -o comm= -p $PPID`)
- the output of `reclaude list` and `crontab -l | grep reclaude`
- what you expected and what happened

## Want a feature?

[Open a feature request](https://github.com/Pratik-11/reclaude/issues/new?template=feature_request.md) and describe the problem you're trying to solve. Small, focused ideas are the easiest to merge.

## Sending a pull request

1. Fork the repo and create a branch: `git checkout -b my-change`
2. Make your change in `reclaude`. It's one Bash script, keep it that way.
3. Run the checks:
   ```sh
   bash -n reclaude install.sh
   ./test.sh
   ```
   If you have [ShellCheck](https://www.shellcheck.net/), run `shellcheck reclaude` too.
4. If you changed behaviour, add a check to `test.sh` and update the README.
5. Open a pull request explaining what changed and why.

## Ground rules

- **Stay small.** reclaude is one script with `jq` as its only extra dependency. New dependencies need a very good reason.
- **Don't touch real sessions in tests.** `test.sh` runs in a fake home folder. Keep it that way.
- **Adding a terminal?** Add it to `pick_term` and, if it needs different arguments, to the `case` in `open_one`. Then list it in the README.
- Be kind. Everyone here is doing this for free.
