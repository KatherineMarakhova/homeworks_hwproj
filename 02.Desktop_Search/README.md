[![ShellCheck](https://github.com/KatherineMarakhova/homeworks_hwproj/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/KatherineMarakhova/homeworks_hwproj/actions/workflows/shellcheck.yml)

# SPbU Source Downloader

This script automates downloading educational resources from the St. Petersburg University server

## Before use
```bash
sudo apt-get update
sudo apt-get install unar
sudo apt-get install recoll
recollindex
```

## Usage

```bash
./import_spbu_umd.bash -s 'https://spbu.ru/sveden/education' -d './folder_to_download_to' [-p]
-s URL to download from.
-d Directory path to save the downloaded files.
-p Optional: Download 10 random files if specified.
```

## Recoll usage
```bash
recoll -t "your text for search"
```
