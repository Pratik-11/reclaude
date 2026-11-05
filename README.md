<h1 align="center">reclaude</h1>

<p align="center">
  <b>Crashed? Battery died? Shut down by accident?<br>All your Claude sessions are now one command away.</b>
</p>

<p align="center">
  <img alt="Linux" src="https://img.shields.io/badge/platform-Linux-informational?logo=linux&logoColor=white">
  <img alt="Bash" src="https://img.shields.io/badge/written%20in-bash-4EAA25?logo=gnubash&logoColor=white">
  <img alt="Size" src="https://img.shields.io/badge/size-1%20file-blue">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green">
  <a href="https://github.com/Pratik-11/reclaude/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/Pratik-11/reclaude?style=flat"></a>
  <a href="https://github.com/Pratik-11/reclaude/issues"><img alt="Issues" src="https://img.shields.io/github/issues/Pratik-11/reclaude"></a>
  <a href="CONTRIBUTING.md"><img alt="PRs welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen"></a>
</p>

---

You have five Claude Code sessions open across five projects. Your PC restarts for an update, crashes, or you just shut it down for the night. Now you have to remember which folders you were in and dig out each session to resume.

**reclaude** remembers for you. After a reboot, run `reclaude` and every session comes back in its own terminal tab, in the right folder, with the conversation where you left it.

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

This puts `reclaude` in `~/.local/bin` and adds a cron job that saves your open sessions once a minute.

**Requires:** Linux, [Claude Code](https://docs.claude.com/en/docs/claude-code), `jq` and `cron`.

## Usage

| Command | What it does |
|---|---|
| `reclaude` | Reopen every saved session |
| `reclaude 1 3` | Reopen only sessions 1 and 3 |
| `reclaude --tmux` | Reopen everything inside one tmux session (works over SSH) |
| `reclaude list` | Show saved sessions and which ones are running |
| `reclaude clear` | Forget the saved list |
| `reclaude autostart on` | Reopen sessions automatically when you log in |
| `reclaude autostart off` | Turn that off again |

```
$ reclaude list
 1  pratikworks-42           ~/pratikworks
 2  pratikdoesnt-13          ~/pratikdoesnt  (running)
 3  finally-shipping-it-07   ~/side-projects/finally-shipping-it
 4  billion-dollar-idea-99   ~/side-projects/billion-dollar-idea
```

It never opens duplicates. A session that is already running is skipped, and so is one whose folder has been deleted.

## How it works

1. Claude Code writes a small file for each running session in `~/.claude/sessions/`, including its folder and session ID.
2. Every minute, cron runs `reclaude save`. That copies the live sessions into `~/.claude/reclaude.tsv`. When nothing is running (during boot or shutdown), the saved list is left untouched.
3. `reclaude` reads that list and runs `claude --resume <id>` in the right folder, in a new tab for each session.

That's it: one Bash script, no daemon, nothing running in the background except a one-line cron job.

## Terminals

reclaude opens tabs in the terminal you run it from. If it can't tell, it uses the first one it finds installed:

gnome-terminal · konsole · kitty · wezterm · ghostty · xfce4-terminal · tilix · terminator · alacritty · foot · xterm

To choose one yourself, set `TERMINAL`:

```sh
TERMINAL=alacritty reclaude
```

With no desktop (SSH or a plain console), it falls back to tmux automatically.

> **kitty:** sessions open as tabs only if `allow_remote_control yes` is set in `kitty.conf`. Otherwise each opens in its own window.

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

The test runs against a fake home folder with a fake terminal, so it never touches your real sessions.

## Contributing

Ideas, bug reports and pull requests are welcome.

- 🐛 **Something broke?** [Report a bug](https://github.com/Pratik-11/reclaude/issues/new?template=bug_report.md)
- 💡 **Have an idea?** [Request a feature](https://github.com/Pratik-11/reclaude/issues/new?template=feature_request.md)
- 🛠️ **Want to code?** Read [CONTRIBUTING.md](CONTRIBUTING.md) and open a pull request

If reclaude saved your sessions, a ⭐ helps other people find it.

## Contributors

<a href="https://github.com/Pratik-11/reclaude/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Pratik-11/reclaude" alt="Contributors">
</a>

## License

[MIT](LICENSE)
