# Gompile.sh a simple script to compile and archive Go binaries.

 This script is intended to be used with Go projects either with a single or multiple binaries.

# How to install
Simply clone this repository and add the script directory to your PATH, for example:
```bash
    $ cd /where/you/want/to/clone/the/repo
    $ git clone https://github.com/sviluppiamotutto/gompile.sh.git
    $ export PATH=$PATH:/where/you/want/to/clone/the/repo/gompile.sh
```

 ## Usage

 ```bash
    $ ./gompile.sh [OPTIONS]
```

if no options are provided, the script will compile the current directory for the current OS and architecture.

## Available options
- `-all` or `-a` to compile for all the supported OS and architectures.
- `-architecture` or `-arch` to compile for a specific architecture, for example `-arch amd64`, available architectures are: `go tool dist list`.
- `-archive` or `-A` to archive the compiled binaries in a tar.gz file.
- `-interactive` or `-i` to ask for the platform and architecture to compile for.
- `-output` or `-o` to specify the output directory, if not specified the path will be `./bin/PLATFORM/ARCHITECTURE`.
- `-path` or `-p` to specify the path to the main package, if not specified the path will be the current directory.
- `-platform` or `-os` to compile for a specific platform, for example `-os linux`, available platforms are: `go tool dist list`.
- `-version` or `-v` to show the script version.
- `-help` or `-h` to show the help message.

## Examples
- Compile for the current OS and architecture:
```bash
    $ ./gompile.sh
```

- Compile for all the supported OS and architectures:
```bash
    $ ./gompile.sh -all
```

- Compile for a specific OS and architecture:
```bash
    $ ./gompile.sh -os linux -arch amd64
```

- Compile for a specific OS and architecture and archive the binaries:
```bash
    $ ./gompile.sh -os linux -arch amd64 -archive
```

- Compile for a specific OS and architecture and specify the output directory:
```bash
    $ ./gompile.sh -os linux -arch amd64 -output /path/to/output
```

- Compile for a specific OS and architecture and specify the path to the main package:
```bash
    $ ./gompile.sh -os linux -arch amd64 -path /path/to/main/package
```

- Compile for a specific OS and architecture and specify the output directory and the path to the main package:
```bash
    $ ./gompile.sh -os linux -arch amd64 -output /path/to/output -path /path/to/main/package
```

- Compile interactively:
```bash
    $ ./gompile.sh -interactive
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
