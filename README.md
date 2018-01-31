[![Build Status](https://img.shields.io/travis/marcosgz/obfusc.svg?style=flat)](https://travis-ci.org/marcosgz/obfusc)

# obfusc
Simple command line tool to obfuscate a recursive tree of files. Basically just rename a list of files using a randon and reversive pattern. Probably no one will use it. It's something that I'd be interested in when I was a teenager and tried to hide inappropriate files on my PC.

** Also. Always preferer "copy" command over "move". Unless you know exactly what are you doing.**

## Installation
Just install this gem by running

```
gem install obfusc
```

## Configuration
First thing you will need to create a `$HOME/.obfusc.cnf` with with `secret` and `token` keys.

```
obfusct config generate
```

Here is an example of generated file:
```
$ cat ~/.obfusc.cnf
---
token: "@l(piZ3ynEz8tjs ,v7DUGP}SmrNMF:f=k4hbBc[dYWIo_uLJq|a9O]5gRK-T6AeXwQ);C{x1H02V"
secret: "-A:z0rH2Zc4Gb6L@;Cwyd3g)l7JRIa[x]hWsoUD_Epe5O}jifu QqM{89FT=SvVBn1t,|P(NmXKkY"
```

It's recommended to make a backup of this file before start using this script. All obfuscated files can only be reverted with this config file.

## Usage

Use `obfusc --help` to show basic usage and all commands available.

```
obfusc <command> <arguments> <options>
```

#### Commands
* setup
* crypt
* decrypt

#### Options
```
-c, --config FILENAME            Using a different ".obfusc.cnf" filename (Default to $HOME/.obfusc.cnf)
-e, --extension STRING           Specify a custom file extension. (Default to "obfc")
-v, --[no-]verbose               Run verbosely
-s, --[no-]simulate              Do a simulate run without executing actions
```
