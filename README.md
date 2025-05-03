# Custom PowerShell Commands

This repository provides a collection of custom PowerShell functions to enhance your command-line productivity. It includes:

- **`cdf`**: Navigate directories interactively using `fzf`.
- **`cdff`**: Navigate directories and open them in File Explorer.
- **`cdfc`**: Navigate directories and open them in VSCode.
- **`grep`**: Search files for patterns using `grep`-like functionality.

## Installation

You can install these functions using either of the following methods:

### 1. Clone the Repository

```powershell
git clone https://github.com/rafimaliki/custom-powershell-commands.git
cd custom-powershell-commands
```

Then, run the installation scripts:

```powershell
.\ps-customfzf-install.ps1
.\ps-grep-install.ps1
```

### 2. Use Invoke-WebRequest

Install the `cdf`, `cdff`, and `cdfc` functions:

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/rafimaliki/custom-powershell-commands/main/ps-customfzf-install.ps1 -OutFile ps-customfzf-install.ps1
.\ps-customfzf-install.ps1
```

Install the `grep` function:

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/rafimaliki/custom-powershell-commands/main/ps-grep-install.ps1 -OutFile ps-grep-install.ps1
.\ps-grep-install.ps1
```

After installation, restart your PowerShell session to apply the changes.

## Usage

- **`cdf`**: Launches an interactive directory selector using `fzf`. After selection, changes the current directory to the chosen path.

  ```powershell
  cdf
  ```

- **`cdff`**: Similar to `cdf`, but also opens the selected directory in File Explorer.

  ```powershell
  cdff
  ```

- **`cdfc`**: Similar to `cdf`, but also opens the selected directory in VSCode.

  ```powershell
  cdfc
  ```

- **`grep`**: Searches for a specified pattern within files in a given directory.

  ```powershell
  grep "searchPattern" "C:\path\to\search"
  ```

## Requirements

- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder. Ensure it's installed and accessible in your system's PATH.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
