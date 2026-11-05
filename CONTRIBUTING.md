# Contributing to reclaude

Thanks for taking a look. Bug reports, support for more terminals, feature ideas and fixes are all welcome.

## Reporting a bug

[Open a bug report](https://github.com/Pratik-11/reclaude/issues/new?template=bug_report.md) and include:

- your distro and terminal (`echo $XDG_CURRENT_DESKTOP; ps -o comm= -p $PPID` prints both)
- the output of `reclaude list` and `crontab -l | grep reclaude`
- what you expected to happen and what happened instead

## Suggesting a feature

[Open a feature request](https://github.com/Pratik-11/reclaude/issues/new?template=feature_request.md). Start with the problem you ran into, not the solution you have in mind. Small ideas are the easiest to get merged.

## Sending a pull request

1. Fork the repo and create a branch: `git checkout -b my-change`
2. Make your change in `reclaude`. Please keep it as one script.
3. Run the checks:
   ```sh
   bash -n reclaude install.sh
   ./test.sh
   ```
   If you have [ShellCheck](https://www.shellcheck.net/) installed, run `shellcheck reclaude` as well.
4. If you changed how something behaves, add a check to `test.sh` and update the README.
5. Open the pull request and say what you changed and why.

## Ground rules

reclaude is one Bash script, and `jq` is its only extra dependency. A new dependency needs a strong reason.

`test.sh` runs in a fake home folder so it can never touch anyone's real sessions. New tests should do the same.

To add a terminal, add it to `pick_term`. If it takes different arguments from the usual `-e`, add a case for it in `open_one` too. Then add it to the list in the README.
