# All Vagrant files

## Vagrant Commands
> Adding a box to vagrant
```sh
$ vagrant box add ubuntu-trusty64 /path/to/vagrant-box.box
Example: vagrant box add ubuntu-trusty64 D:\\XXXX\\XXXXXX\\trusty-server-cloudimg-amd64-vagrant-disk1.box
Example: vagrant box add ubuntu/trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/20180201/trusty-server-cloudimg-amd64-vagrant-disk1.box
```
> Initialize the box
```sh
$ vagrant init ubuntu-trusty64
```
> Bring Up the box on VM Provider
```sh
$ vagrant up
```
> Enable Logging:
```sh
$ set VAGRANT_LOG=info
```
> Enable Debug
```sh
$ vagrant up --debug
```
> To save the debug logs to log file
> * In Linux
```sh
$ vagrant up --debug &> vagrant.log
```
> * In Windows
```sh
PS> vagrant up --debug > vagrant.log 2>&1
```
> See running VMs
```sh
$ vagrant global-status
```
> SSH to a running VM (Get the <ID> of the corresponding VM using above global-status command)
```sh
$ vagrant ssh <ID>
```
Pls Note: By default, all the VM's created by vagrant get the user and password as 'vagrant' to login.
> To Update/Install software on existing VM, use the **--provision** switch
```sh
$ vagrant up --debug --provision
```
> To connect to a VM from another VM created using vagrant, we can use SSH keys. Process as below:
1) Generate **ssh-keygent -t rsa** from the master machine
2) ssh-copy-id **vagrant@IP Address** will copy the ssh keys to nodes. You may have to input the password 'vagrant' for one last time to register your ssh keys.
3) Any later SSH connections to nodes will use SSH Keys and do not ask for password when connected from master machine.
