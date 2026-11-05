<h1 align="center">reclaude</h1>

<p align="center">
  <b>Crashed? Battery died? Shut down by accident?<br>All your Claude sessions are now one command away.</b>
</p>

<p align="center">
  <img alt="Linux" src="https://img.shields.io/badge/platform-Linux-informational?logo=linux&logoColor=white">
  <img alt="Bash" src="https://img.shields.io/badge/written%20in-bash-4EAA25?logo=gnubash&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green">
  <a href="https://github.com/Pratik-11/reclaude/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/Pratik-11/reclaude?style=flat"></a>
  <a href="https://github.com/Pratik-11/reclaude/issues"><img alt="Issues" src="https://img.shields.io/github/issues/Pratik-11/reclaude"></a>
  <a href="CONTRIBUTING.md"><img alt="PRs welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen"></a>
</p>

---

If you work with Claude Code in a few projects at once, a reboot is annoying. The laptop dies or an update restarts it, and afterwards you have to remember which folders you had open and run `claude --resume` in each one, picking the right session out of a list every time.

reclaude keeps track of your open sessions while you work. After a reboot you run `reclaude`, and each session reopens in its own terminal tab, in its folder, with the conversation intact.

```
$ reclaude
opened pratikworks-42
opened pratikdoesnt-13
opened finally-shipping-it-07
opened billion-dollar-idea-99
```

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Pratik-11/reclaude/main/install.sh | bash
```

The installer copies `reclaude` to `~/.local/bin` and adds a cron job that saves your open sessions once a minute.

You need Linux, [Claude Code](https://docs.claude.com/en/docs/claude-code), `jq` and `cron`.

## Usage

| Command | What it does |
|---|---|
| `reclaude` | Reopen every saved session |
| `reclaude 1 3` | Reopen only sessions 1 and 3 |
| `reclaude --tmux` | Reopen everything in one tmux session (handy over SSH) |
| `reclaude list` | Show saved sessions and which ones are running |
| `reclaude clear` | Forget the saved list |
| `reclaude autostart on` | Reopen sessions automatically when you log in |
| `reclaude autostart off` | Stop doing that |

```
$ reclaude list
 1  pratikworks-42           ~/pratikworks
 2  pratikdoesnt-13          ~/pratikdoesnt  (running)
 3  finally-shipping-it-07   ~/side-projects/finally-shipping-it
 4  billion-dollar-idea-99   ~/side-projects/billion-dollar-idea
```

Sessions that are already running are skipped, so you won't end up with two copies of the same conversation. Sessions whose folder has been deleted are skipped too.

## How it works

1. Claude Code keeps a small file for each running session in `~/.claude/sessions/`. It holds the session ID and the folder it was started in.
2. Every minute, cron runs `reclaude save`, which copies the live sessions into `~/.claude/reclaude.tsv`. If nothing is running (during boot or shutdown, say), it leaves the old list alone.
3. `reclaude` reads that list and runs `claude --resume <id>` in the right folder, one tab per session.

The whole tool is a single Bash script. Apart from the cron job, it doesn't run anything in the background.

## Terminals

reclaude opens tabs in the terminal you run it from. If it can't work out which one that is, it uses the first one installed from this list:

gnome-terminal, konsole, kitty, wezterm, ghostty, xfce4-terminal, tilix, terminator, alacritty, foot, xterm

To pick one yourself, set `TERMINAL`:

```sh
TERMINAL=alacritty reclaude
```

On a machine with no desktop (over SSH, or on a plain console) it uses tmux instead.

kitty only opens tabs if `allow_remote_control yes` is set in `kitty.conf`. Without it, each session gets its own window.

## Uninstall

```sh
crontab -l | grep -v reclaude | crontab -
reclaude autostart off
rm ~/.local/bin/reclaude ~/.claude/reclaude.tsv
```

## Development

```sh
./test.sh
```

The test uses a fake home folder and a fake terminal, so it can't touch your real sessions.

## Contributing

Bug reports, feature ideas and pull requests are all welcome.

- [Report a bug](https://github.com/Pratik-11/reclaude/issues/new?template=bug_report.md) if something doesn't reopen the way it should.
- [Request a feature](https://github.com/Pratik-11/reclaude/issues/new?template=feature_request.md) if you have an idea.
- Read [CONTRIBUTING.md](CONTRIBUTING.md) before you open a pull request.

If reclaude has saved you some time, starring the repo helps other people find it.

## Contributors

<a href="https://github.com/Pratik-11/reclaude/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Pratik-11/reclaude" alt="Contributors">
</a>

## License

[MIT](LICENSE)
