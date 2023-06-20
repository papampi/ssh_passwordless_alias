## SSH Passwordless Alias Script

This script sets up passwordless SSH access to a remote server and creates an alias for the server in the `~/.bash_aliases` file on the client machine. It prompts the user for the necessary input, including the SSH credentials for the remote server, the IP address of the server, the SSH port to use, and an alias name for the server.

The script checks the operating system and installs `sshpass` using the appropriate package manager if necessary. It then checks if the SSH key pair already exists on the client machine. If the key pair does not exist, the script generates a new key pair. If the public key is not available on the remote server, the script copies the public key to the remote server to enable passwordless SSH authentication.

Finally, the script adds an alias for the remote server to the `~/.bash_aliases` file on the client machine, allowing the user to easily connect to the server by typing the alias in the terminal.

**Operating System Support:** This script has been tested on Linux and macOS. It should work on other Unix-based operating systems as well, as long as the necessary dependencies are installed.

Feel free to modify and use this script as needed for your own purposes.
