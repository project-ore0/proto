# Protocol Buffer Generator

This project provides a development environment for generating Protocol Buffer files for both C (using nanopb) and TypeScript.

## Docs

[Sequence Diagram](https://raw.githubusercontent.com/project-ore0/proto/refs/heads/docs/flow.png)

## Automated Generation

### Protocol Buffer Generation

This repository includes a GitHub workflow that automatically:
1. Runs when changes are pushed to the `proto/` directory, `Makefile`, or `.devcontainer/` directory
2. Can also be triggered manually from the GitHub Actions tab
3. Uses the same devcontainer environment as local development for consistency
4. Generates the Protocol Buffer files using `make clean && make all`
5. Pushes the generated files to a separate versioned branch (`generated-<commit_hash>`)
6. Updates the `generated` branch to always point to the latest version

### Documentation Generation

A separate workflow automatically builds documentation:
1. Runs when changes are pushed to PlantUML files in the `doc/` directory
2. Can also be triggered manually from the GitHub Actions tab
3. Converts all PlantUML diagrams to PNG images
4. Pushes the generated images to the `docs` branch

### Required Permissions

For these workflows to function properly, the GitHub Actions workflow needs write permissions to the repository. You can configure this in your repository settings:

1. Go to your repository on GitHub
2. Click on "Settings" > "Actions" > "General"
3. Under "Workflow permissions", select "Read and write permissions"
4. Click "Save"

This allows the workflows to push to the `generated`, `generated-<commit_hash>`, and `docs` branches.

To manually trigger either workflow:
1. Go to the GitHub repository
2. Click on the "Actions" tab
3. Select either the "Generate and Push Protocol Buffers Code" or "Build Documentation" workflow
4. Click "Run workflow" and select the branch to run it on

This allows you to:
- Keep generated files out of your main branch
- Have versioned generated files that correspond to specific commits
- Use the generated files as a git submodule in other projects

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

### Documentation

PlantUML diagrams in the `doc/` directory are automatically converted to PNG images by the GitHub workflow.

To generate PNG images locally, run:

```bash
./generate-docs.sh
```

This will generate PNG images in the `doc/images/` directory.

To add a new diagram:
1. Create a new `.puml` file in the `doc/` directory
2. Run `./generate-docs.sh` to generate the corresponding PNG image

### Project Structure

- `proto/*.proto` - Protocol Buffer definition files
- `generated/c/` - Generated C files
- `generated/ts/` - Generated TypeScript files
- `doc/*.puml` - PlantUML diagram files
- `nanopb/` - The nanopb library (as a Git submodule)
- `.devcontainer/` - Dev Container configuration
- `.github/workflows/` - GitHub Actions workflow files

## Using Generated Content

### Using Generated Protocol Buffer Files as a Submodule

To use the generated Protocol Buffer files in another project:

```bash
# Add the generated branch as a submodule
git submodule add -b generated https://github.com/username/this-repo.git path/to/generated

# Later, to update the submodule to the latest version
git submodule update --remote path/to/generated

# To update to a specific version
git -C path/to/generated checkout generated-<specific-commit-hash>
```

This approach allows you to:
1. Keep your main repository clean of generated files
2. Have precise control over which version of the generated files you're using
3. Update to newer versions when you're ready

### Using Documentation Images

The documentation images generated from PlantUML diagrams are available in the `docs` branch. You can:

1. View them directly on GitHub by browsing the `docs` branch
2. Reference them in your documentation with URLs like:
   ```
   https://raw.githubusercontent.com/username/this-repo/docs/images/flow.png
   ```
3. Clone the docs branch separately if you need the images locally:
   ```bash
   git clone -b docs https://github.com/username/this-repo.git docs-repo
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
