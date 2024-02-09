# SyncTool

SyncTool is a lightweight Bash script for automating file synchronization between local and remote directories. It utilizes inotify events and rsync over SSH for efficient and real-time updates.

## Features
- Monitors file system events (create, delete, modify, move) in the specified local folder.
- Automatically synchronizes changes to a remote folder on a server using rsync over SSH.
- Logs synchronization events and errors for easy troubleshooting.

## Requirements
- Linux-based operating system
- Bash shell
- inotify-tools
- rsync
- ssh

## SO Support
for now it works only over ubuntu/debian based systems

## Installation
```bash
curl -Ssl https://raw.githubusercontent.com/iagomussel/sshsync/main/install.sh | bash
```

## Usage
```bash
sshsync <origin_folder> <target_folder> <ssh_server>
```
- `<origin_folder>`: The local folder to monitor for changes.
- `<target_folder>`: The remote folder on the SSH server to synchronize changes to.
- `<ssh_server>`: The SSH server address.

## Example
```bash
sshsync /var/www/html /var/www/html ubuntu@someserver.com

```

## License
This project is licensed under the MIT License - see the LICENSE file for details.
Feel free to modify the README according to your project's specific details and requirements.
