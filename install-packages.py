#!/usr/bin/env python3
"""Installs package IDs declared by platform and package-manager directories."""

import logging
import pathlib
import platform
import re
import subprocess


def detect_platform() -> str:
    """Returns the Linux distribution ID or lowercase operating system name."""
    system = platform.system().lower()
    if system == 'linux':
        return platform.freedesktop_os_release()['ID']
    return system


def run(command: list[str]) -> None:
    """Runs a command with native streams, warning on failure."""
    try:
        result = subprocess.run(command, check=False)
    except OSError as error:
        logging.warning('Could not run %r: %s', command, error)
        return

    if result.returncode != 0:
        logging.warning(
            'Command %r failed with exit code %s.',
            command, result.returncode,
        )


def main() -> None:
    """Installs each declared tool using its directory's package manager."""
    try:
        root = pathlib.Path(__file__).resolve().parent
        platform_dir = root / detect_platform()
        if not platform_dir.is_dir() or platform_dir.is_symlink():
            logging.warning(
                'Create a real platform directory at %s.', platform_dir,
            )
            return
        managers = sorted(
            entry for entry in platform_dir.iterdir()
            if not entry.name.startswith('.')
            and entry.is_dir() and not entry.is_symlink()
        )
    except (OSError, KeyError) as error:
        logging.warning('Could not read the platform inventory: %s', error)
        return

    for manager in managers:
        tools = manager / 'tools'
        try:
            if not tools.is_dir() or tools.is_symlink():
                logging.warning('Create a real tools directory at %s.', tools)
                continue
            packages = sorted(
                entry.name for entry in tools.iterdir()
                if not entry.name.startswith('.')
                and entry.is_dir() and not entry.is_symlink()
            )
        except OSError as error:
            logging.warning('Could not read tools in %s: %s', tools, error)
            continue

        if not packages:
            continue
        match manager.name:
            case 'apt':
                install_command = ['sudo', 'apt-get', 'install', '-y']
                run(['sudo', 'apt-get', 'update'])
            case 'winget':
                install_command = [
                    'winget', 'install', '--exact', '--source', 'winget',
                    '--interactive', '--no-upgrade', '--id',
                ]
            case _:
                logging.warning('Unsupported package manager: %s', manager.name)
                continue

        for package in packages:
            if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9._+-]*', package):
                logging.warning(
                    'Skipping invalid package folder name: %r', package,
                )
                continue
            run(install_command + [package])


if __name__ == '__main__':
    main()
