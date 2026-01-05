# vm-basic-setup

Status of Last Deployment:<br>
<img src="https://github.com/AlexUkhov/vm-basic-setup/workflows/img/badge.svg?branch=master"><br>

This is script & absible playbook used to help you initial setup your VM's (For now only for Debian-family OS)

How to use:

- Login one of yours servers (Debian-family based) and clone this repo

- Start setup script: ./setup

- Enter quantity servers you may to setuo and ip-address/root-password (sent from provider)

- Script will made few steps:

    - Generate ssh key to access server later
    - Made new user with root privileges
    - Change login type to ssh instead of password
    - Update apt source

- Now youre VM's ready to work!

About sensitive data
- Login by your root password will discard by setup, but you shuld change it after fitst login.
- All your introduced sensitive data will deleted during script execution 

--- &#127279; Copyleft by Alex Ukhov 2026 ---