# 🗂️ sdtree

> A lightweight shell function that mimics the `tree` command using `find` and `sed`, with no dependencies.

`sdtree` is a minimal directory viewer that prints a tree-like structure of folders and files using standard POSIX tools. It’s ideal for macOS and Unix-like environments where installing the `tree` command via `brew`, other package managers, or compiling from source is undesirable.

---

## 📦 Installation

### 1. For Zsh, Bash, and similar compatible shells

If your shell supports `source` and Zsh/Bash-style syntax (e.g., `local`, `[[ ... ]]`), you can install `sdtree` with:

1. **Download the script**

```bash
curl -LO https://raw.githubusercontent.com/ShieldInTheField/sdtree/master/sdtree.sh
```

2. **Source it in your shell’s config file**

```bash
echo 'source ~/path/to/sdtree.sh' >> ~/path/to/shell_config_file 
source ~/path/to/shell_config_file
```

> Replace the first `~/path/to` with the actual location where you saved `sdtree.sh`.
> and the second `~/path/to` with the actual location of your actual shell config file `shell_config_file` (e.g., `.zshrc` or `.bashrc`).

For Zsh:
```bash
echo 'source ~/path/to/sdtree.sh' >> ~/.zshrc
source ~/.zshrc
```

---

### 2. For shells that do **not** support `source` but understand the syntax

Some shells (e.g. older `ksh`, restricted shells, certain environments) may not support `source` or `.` reliably, but **still understand** the required syntax (`local`, `[[ ... ]]`).

In this case, you can still use `sdtree` by manually **copying and pasting** the function into your interactive session or your shell's config file:

1. Open the file [sdtree](https://github.com/ShieldInTheField/sdtree/blob/master/sdtree)
2. Copy the entire function definition
3. Paste it directly into your shell session or config (e.g., `.bashrc`, `.profile`, etc.)

This works as long as the shell supports the syntax, even if `source` itself is unavailable.

---

### 3. Incompatible shells

Shells like `dash`, `sh`, or `busybox sh` that **do not support `local` or `[[ ... ]]`** will not work with `sdtree` unless rewritten for strict POSIX compliance.

---

## Usage

```bash
sdtree [DIR] [OPTIONS]
```

### Options

| Flag              | Description                                               | Default       |
|-------------------|-----------------------------------------------------------|---------------|
| `DIR`             | Optional positional directory to scan                     | `.`           |
| `-d`, `--dir`     | Directory to scan (same as positional `DIR`)              | `.`           |
| `--dir=DIR`       | Directory to scan                                         | `.`           |
| `-l`, `--level`   | Depth to display                                          | `3`           |
| `--level=N`       | Depth to display                                          | `3`           |
| `-a`, `--all`     | Show hidden files                                         | `false`       |
| `--no-all`        | Hide hidden files                                         | `false`       |
| `-v`, `--version` | Show version number                                       |               |
| `-h`, `--help`    | Show usage help                                           |               |

Output is sorted by:
1. type (`directory` first, then `file`)
2. name (case-insensitive)

---

### Examples

```bash
sdtree                        # Current directory, depth 3, no hidden files
sdtree ~/Projects             # Scan ~/Projects (positional DIR)
sdtree -d ~/Projects          # Scan ~/Projects
sdtree --dir=~/Projects       # Scan ~/Projects (equals form)
sdtree -l 2 -a                # Show hidden files, depth 2
sdtree --level=2 --no-all     # Hide hidden files, depth 2
sdtree --version              # Show version number
```

Sample output style (v1.2.0):

```text
.
|____folder-1
|    |____folder-2
|    |    |____folder-3
|    |____file-2-1
|____file-1-1
```

When scanning an explicit directory, the root is printed as its plain name:

```text
test
|____folder-1
|    |____folder-2
|____file-1-1
```

---

## Why dashed lines?

`sdtree` uses ASCII dashed connectors (`|____`) for broad shell compatibility and readability.  

---

## 📜 License

MIT © [Soroush Ataee](https://github.com/ShieldInTheField)

---

## Contributions

Contributions and suggestions are welcome. Feel free to open issues or pull requests, or fork and adapt the script to your needs.
