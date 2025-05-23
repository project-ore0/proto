# Protocol Buffer Generator

This project provides a development environment for generating Protocol Buffer files for both C (using nanopb) and TypeScript.

## Setup

This project uses VS Code's Dev Containers for development. To get started:

1. Install [Docker](https://www.docker.com/products/docker-desktop) and [VS Code](https://code.visualstudio.com/)
2. Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code
3. Clone this repository
4. Open the repository in VS Code
5. When prompted, click "Reopen in Container" or run the "Remote-Containers: Reopen in Container" command from the command palette

## Usage

### Generating Protocol Buffer Files

To generate the Protocol Buffer files, run:

```bash
./generate.sh
```

This will generate:
- C files in the `generated/c/` directory
- TypeScript files in the `generated/ts/` directory

### Adding New Protocol Buffer Definitions

1. Create a new `.proto` file in the root directory
2. Run `./generate.sh` to generate the corresponding C and TypeScript files

### Project Structure

- `*.proto` - Protocol Buffer definition files
- `generated/c/` - Generated C files
- `generated/ts/` - Generated TypeScript files
- `nanopb/` - The nanopb library (as a Git submodule)
- `.devcontainer/` - Dev Container configuration

## License

This project is licensed under the MIT License - see the LICENSE file for details.
