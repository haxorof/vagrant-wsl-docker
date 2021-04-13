# Use docker client in WSL1 from Windows

*DISCLAIMER - USE THESE SCRIPTS AT YOUR OWN RISK!*

Since Docker does not provide any Windows binaries for the docker client separately then these scripts will allow you
to run simpler docker commands directly from Windows but it will use your docker client installed in your WSL1 environment
as described in this repositories main readme file.

## Installation

1. Create a new directory in Windows.
2. Copy the scripts to your newly created directory.
3. Add your newly created diretory into your PATH environment variable.
4. Add environment variable `DOCKER_HOST` and set it to for example `tcp://127.0.0.1:2375`.
5. Add/Update environment variable `WSLENV` with `DOCKER_HOST/u`.
6. Done!

Now if you have started setup the Docker VM as described in this repository and installed the docker client in your WSL then
you shall now be able to run docker from your Command Prompt in Windows.

*Note!* If you use Microsoft Visual Studio Code (vscode) then the Docker plugin also should work as expected for simpler use cases.