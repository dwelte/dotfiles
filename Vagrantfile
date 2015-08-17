# -*- mode: ruby -*-
# vi: set ft=ruby :
#
$ssh_config_file = <<CONFIG
Host *
  User dwelte
  IdentityFile /home/vagrant/.ssh/dwelte_id_rsa
CONFIG

$script = <<SCRIPT
echo 'eval `ssh-agent -s`' >> /home/vagrant/.bash_profile
echo 'ssh-add /home/vagrant/.ssh/dwelte_id_rsa' >> /home/vagrant/.bash_profile
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
sh -c "echo deb https://get.docker.io/ubuntu docker main  >> /etc/apt/sources.list.d/docker.list"
apt-get update
apt-get --force-yes -y install tcc-devops-utilities ruby ruby-dev puppet python-pip python-pynag lxc-docker expect
eval `ssh-agent -s`
expect -c 'set timeout 20;
spawn ssh-add /home/vagrant/.ssh/dwelte_id_rsa;
expect "Enter passphrase for /home/vagrant/.ssh/dwelte_id_rsa:";
send "#{ENV['KEY_PASSWORD']}\n";
expect eof;'
pip install awscli
mkdir /home/vagrant/dev
echo 'ssh -i /home/vagrant/.ssh/dwelte_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $*' > /tmp/git-ssh
chmod u+x /tmp/git-ssh
bash -c "GIT_SSH='/tmp/git-ssh' git clone ssh://git@stash.ci.climatedna.net:7999/~dwelte/puppet.git /home/vagrant/dev/puppet"
rm /tmp/git-ssh
chown -R vagrant:vagrant /home/vagrant/dev
sudo -H -u vagrant envmgr --repo /home/vagrant/dev/puppet -e qa1 -w
SCRIPT

Vagrant.configure(2) do |config|

  config.ssh.shell = "/bin/sh"
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "dwelte-vm"

  config.vm.network :forwarded_port, guest: 22, host: 1238

  config.vm.synced_folder "~/.aws", "/home/vagrant/.aws"

  #config.ssh.private_key_path = "~/.ssh/id_rsa"

  if File.directory?(File.expand_path("~/bin"))
    config.vm.synced_folder "~/bin", "/home/vagrant/bin"
  end


  config.vm.provision "file", source: File.expand_path("~/.ssh/id_rsa"), destination: "/home/vagrant/.ssh/dwelte_id_rsa"
  config.vm.provision :shell, inline: "echo '#{$ssh_config_file}' > /home/vagrant/.ssh/config"
  config.vm.provision :shell, privileged: false, path: "https://xdeps.ci.climatedna.net/misc/shell-scripts/skel.sh"
  config.vm.provision :shell, path: "https://xdeps.ci.climatedna.net/misc/shell-scripts/apt-repo.sh"

  # provision dotfiles out of host homedir when they exist
  dotfiles = %w{ gitconfig gitignore
                 profile login logout
                 bashrc bash_profile bash_aliases
                 zshrc zprofile }
  dotfiles.each do |dotfile|
    dotfile_full = File.expand_path("~/.#{dotfile}")
    if File.exists?(dotfile_full)
      config.vm.provision "file", source: dotfile_full, destination: "/home/vagrant/.#{dotfile}"
    end
  end

  config.vm.provision :shell, inline: $script

end
