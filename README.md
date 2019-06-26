# Home
`home` is a simple, opinionated, personal package manager for your home directory.

Packages typically contain things like config files (dotfiles), binaries/scripts, and shell aliases/functions/completions.
A package is simply a GitHub repository with a specific directory structure and maybe some scripts to help build or handle special install cases.

In fact, `home` itself is a package! It can (and should) install and update itself.

> `home` was designed for my personal use.
> There are no guarantees that I will not make a change that breaks your environment.
> That said, you are free to use `home`, but I suggest making your own copy and working from that.


## Requirements
- Bash
- Git
- findutils (specifically `find`)

Also, if you have `hub` and `jq` installed, `home` will maintain a list of packages labeled with the topic `home-package` on GitHub.
These names will be used for bash-completion with the `add` action.


## Installation
Since `home` can install itself, that is an easy install path.

```
bash <(curl -s 'https://raw.githubusercontent.com/BrowncoatShadow/home/master/bin/home') add BrowncoatShadow/home
```

`home` clones the package's git repos using the ssh git protocol.
You can instead use https by setting `HOME_PROTOCOL=HTTPS`.


### Alternitive: Manual Git Installation
```
git clone https://github.com/BrowncoatShadow/home.git "${XDG_CACHE_HOME:-${HOME}/.cache}/home/packages/BrowncoatShadow/home"
"${XDG_CACHE_HOME:-${HOME}/.cache}/home/packages/BrowncoatShadow/home/bin/home" add BrowncoatShadow/home
```


### Bash Configuration
`home` uses a number of default for binary and bash file installations.
As part of the installation process, you probably want to include something like the following in your `~/.bashrc` file.

You can streamline this in the future by creating a bash configuration package that includes these configs and add that package when installing `home`.

```
# ~/.bashrc
export PATH="${XDG_BIN_HOME:-${HOME}/.local/bin}:${PATH}"

if [[ -d "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc.d" ]]; then
  for f in $(find "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc.d" -type f); do
    [[ -f "${f}" && -r "${f}" ]] && source "${f}"
  done
fi
```

If your system does not automatically load bash-completion, you will need to set that up in your bash environment as well.
`home` respects `BASH_COMPLETION_USER_DIR` the same way the bash-completion package does.


## Usage
```
home (add | rm) <package>...
home up [package]...
home ls
```

`home add <package>...`  
Install one or more packages.

`home rm <package>...`  
Uninstall one or more packages.

This action will also remove the package cache.

`home up [package]...`  
Update one or more packages.

If no package list is provided, all cached packages will be updated.

`home ls`  
List all packages that are cached.


## Packages
Packages are simply GitHub repos in the `Username/Repo` format.
If a package specified without the `Username/` portion, the value of the environment variable `GITHUB_USER` or a default username (mine) is used.


### Package Directories
Package files to be copied or removed are infered by a specified directory structure.

```
/
├── bin/         # Executible files
├── bash/        # Bash config/aliases/functions
└── completions/ # Bash completions, files should match commands using format: "${cmd}", "${cmd}.bash" or "_${cmd}"
```

### Package Scripts
Package installation and uninstallation can be managed using scripts.
Use of the scripts is a package is considered an explicit configuration and takes precidence over implicit directory structure.
This is useful for packages that have files not covered by the implicit directory structure, or need to be built first.

```
/
└── scripts/
    ├── build     # Always run before install
    ├── install   # Run when adding a package, run after update
    └── uninstall # Run when removing a package, run before update
```

### Package Examples
An explicitly configured package using only scripts might be structured something like this.

```
/
├── scripts/
│   ├── build
│   ├── install
│   └── uninstall
├── foo.c
├── foo.h
├── Makefile
└── README.md
```

An implicitly configured package using only directories might be structured something like this.

```
/
├── bin/
│   └── foo
├── completions/
│   └── _foo
└── README.md
```

You can also mix explicit and implicit hook behaviors.
Perhaps you want to provide a package for a third-party binary and want to include your own bash completions.
You could write a build script that downloads the latest binary of the package and places it in the `bin` directory of the package to be implicitly copied by the install hook along with your completion file.

```
/
├── bin/
├── completions/
│   └── _baz
├── script/
│   └── build
└── README.md
```


## Inspiration and Similar Projects
- [bpkg](https://github.com/bpkg/bpkg)
- [zplug](https://github.com/zplug/zplug)
- [A Crude Personal Package Manager « null program](https://nullprogram.com/blog/2018/03/27/)

