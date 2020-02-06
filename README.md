# Create Sudo user
STEP 1. ssh into your server.
```
ssh root@<server ip>
```

STEP 2. Use the adduser command to add a new user to your system and set the password for the user
```
adduser texttrack
```

STEP 3. Use the usermod command to add the user to the sudo group.
```
usermod -aG sudo texttrack
```

STEP 4. Test sudo access on new user account. Use the su command to switch to the new user account.
```
su texttrack or su - texttrack
```
Then execute any command with sudo to test the user.
```
sudo mkdir abc
```
# Installing Ruby
Make sure you are logged in with new sudo user (not as root user)

Adding Node.js 10 repository
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
```

Adding Yarn repository
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo add-apt-repository ppa:chris-lea/redis-server
```
Refresh packege
```
sudo apt-get update
```
Install our dependencies for compiiling Ruby along with Node.js and Yarn
```
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

# Install Rbenv
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
exec $SHELL
rbenv install 2.6.3
sudo chown -R texttrack.texttrack ~/.rbenv
rbenv global 2.6.3
ruby -v
#ruby 2.6.3
```

This installs the latest Bundler, currently 2.x.
```
gem install bundler
```

For older apps that require Bundler 1.x, you can install it as well.
```
gem install bundler -v 1.17.3
```

Test and make sure bundler is installed correctly, you should see a version number.
```
bundle -v
#Bundler version 2.0
```

Install rails
```
gem install rails
```

# Some errors and solutions.
for example,
Rails application : deepspeech-web  (rails root dir)
sudo user : texttrack

```
Error: if you get error related .ruby-version file
solution: delete .ruby-version file from your rails application root directory

Error: Your Ruby version is 2.6.3, but your Gemfile specified 2.6.1
solution: open your Gemfile and change the Gemfile version to 2.6.3

Error: There was an error while trying to write to `<path-to-rails-app>/deepspeech-web/Gemfile.lock`. It is likely that you need to grant write permissions for that path.

solution
sudo chown -R <user>:<user> path-to-rails_root

Example:
sudo chown -R texttrack:texttrack /usr/local/deepspeech-web
```

# Running Rails Application
Go to rails root directory and execute following commands

Install dependencies
```
bundle install
```

Execute migration to create database
```
rake db:migrate
```

# Security
** Create credentials and add apikey
```
touch credentials.yaml

* you can generate your own apikey. You don't need to go anywhere to get apikey.
sudo nano credentials.yaml (refer example-credentails.yaml in the working dir)

```

You can use port_number = 3000 or 4000

# Install Mozilla deepspeech
1. Install dependencies
```
sudo apt-get install build-essential
sudo apt-get install aptitude
sudo apt-get install libstdc++6
sudo apt-get install libsox-dev
cd /usr/lib/x86_64-linux-gnu
sudo ln -s libsox.so.3 libsox.so.2
export PATH="$PATH:/usr/lib/x86_64-linux-gnu"
```

2. Install Python
```
sudo apt-get install python3-dev

#other dependencies
sudo apt-get install pkg-config zip g++ zlib1g-dev unzip wget
export PYTHON_INCLUDE_PATH="/usr/include/python3.6m"
export PYTHON_BIN_PATH="/usr/bin/python3.6"
```

3. Install Bazel and update PATH variable
3.1 Download Bazel 0.15 compatible to tensorflow 1.12.0
 
 Create installation dir called deepspeech
```
sudo mkdir deepspeech
cd deepspeech
sudo mkdir temp
sudo apt-get install wget
sudo wget https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-installer-linux-x86_64.sh
```

3.2 Run the Bazel installer
```
sudo chmod +x bazel-0.15.0-installer-linux-x86_64.sh
sudo ./bazel-0.15.0-installer-linux-x86_64.sh –-user --bin=$HOME/bin

#if you get an error in above command then remove user flag
$user/deepspeech: sudo ./bazel-0.15.0-installer-linux-x86_64.sh
$user/deepspeech: export PATH="$PATH:/home/<user>/bin"
#you will get path after successfully executing command
#for example: make sure you have /home/user/bin dir in your system
#The --user flag installs Bazel to the $HOME/bin directory on your system and sets the .bazelrc path to $HOME/.bazelrc.
```

3.3 Set up your environment
```
export PATH="$PATH:$HOME/bin"
```

4. Build deepspeech native
4.1 DeepSpeech clone and checkout
```
sudo apt-get install git
sudo git clone https://github.com/dabinat/DeepSpeech.git
cd DeepSpeech/
sudo git checkout timing-info
cd ..
```

4.2 Tensorflow clone and checkout
```
sudo git clone https://github.com/mozilla/tensorflow.git
cd tensorflow/
sudo git checkout origin/r1.12
```
4.3 create a symbolic link to the DeepSpeech native_client directory.
```
sudo ln -s ../DeepSpeech/native_client ./
```

5. Build DeepSpeech
5.1 make sure you have a python
```
sudo apt-get install python
```

5.2 execute build command and have a cup of tea because usually it takes 20-25 mins to build. However, time is depending on server  configurations
```
sudo bazel build --config=monolithic -c opt --copt=-O3 --copt="-D_GLIBCXX_USE_CXX11_ABI=0" --copt=-fvisibility=hidden //native_client:libdeepspeech.so //native_client:generate_trie
```

5.3 set environment variable
```
export TFDIR=~/workspace/tensorflow
```

5.4 make sure you have deepspeech file in your DeepSpeech dir and tensaflow dir. If file exist in both dir then execute following command.
```
cd ../DeepSpeech/native_client
make deepspeech
```

6. Copy binaries into deepspeech/temp folder
```
cp deepspeech ~/deepspeech/temp/deepspeech
cp ~/deepspeech/tensorflow/bazel-bin/native_client/libdeepspeech.so ~/deepspeech/temp/libdeepspeech.so
cd ~/deepspeech/temp
```

7. Download model and audio files
```
sudo curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/deepspeech-0.6.1-models.tar.gz
sudo tar xvf deepspeech-0.6.1-models.tar.gz
sudo curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/audio-0.6.1.tar.gz
sudo tar xvf audio-0.6.1.tar.gz
```

8. If you want to update the deepspeech version in future (depending on if you want to use the gpu or not - only install 1 `both pip & pip3`)
```
pip install deepspeech==0.6.1
pip3 install deepspeech==0.6.1

pip install deepspeech-gpu==0.6.1
pip3 install deepspeech-gpu==0.6.1
```

Now we need to replace our old deepspeech with the new one in `home/deepspeech/temp`
```
cd /home/deepspeech/temp
sudo mv deepspeech deepspeech_old
which deepspeech
```
which deepspeech will give you the link to where the new one is located (now to copy that to `/home/deepspeech/temp`)
```
sudo cp /home/texttrack/.local/bin/deepspeech /home/deepspeech/temp
```

9. Check if deepspeech native is working
```
cd /home/deepspeech/temp
./deepspeech --model deepspeech-0.6.1-models/output_graph.pbmm --lm deepspeech-0.6.1-models/lm.binary --trie deepspeech-0.6.1-models/trie --audio audio/2830-3980-0043.wav

* if you have installed models on the different path then you need to update the setting.yaml file
```

At this point, you should get words for sample audios inside the temp/audio directory.
# Redis server
```
sudo apt-get update
sudo apt-get upgrade
```

1. Install & enable Redis server
```
sudo apt-get install redis-server
sudo systemctl enable redis-server.service
```

2. Configure redis server
```
sudo vim /etc/redis/redis.conf
#you can use nano instead of vim
#copy following lines or find and remove comments for these lines
maxmemory 256mb
maxmemory-policy allkeys-lru
#save and exit
```

3. Restart service
```
sudo systemctl restart redis-server.service
```

4. Install redis php extension
```
sudo apt-get install php-redis
```

5. Test the connection
```
redis-cli ping
#you should get response "PONG"
```

6. Important commands
```
#restart redis server
sudo systemctl restart redis
#redis-cli commands
redis-cli info
redis-cli stats
redis-cli server
```

# Install faktory worker
```
sudo wget https://github.com/contribsys/faktory/releases/download/v1.0.1-1/faktory_1.0.1-1_amd64.deb

sudo dpkg -i faktory_1.0.1-1_amd64.deb

sudo cat /etc/faktory/password (Manually find password if ever needed)
```

# Set password for worker and Service

Find password
```
cat /etc/faktory/password
```
# Set password
Open working_dir/service/deepspeech_worker.service and find this line given below.
`Environment=LANG=en_US.UTF-8 FAKTORY_PROVIDER=FAKTORY_URL FAKTORY_URL=tcp://:<password>@localhost:7419`
Replace your pasword with <password> . save & exit
Do the same thing for `working_dir/service/deepspeech_service.service`


# Copy /usr/local/deepspeech-web/service/<all-files>.service to /etc/systemd/system
```
cd /usr/local/deepspeech-web/service/
sudo cp *.service /etc/systemd/system
```

# Start all services
```
sudo systemctl enable deepspeech_rails
sudo systemctl start deepspeech_rails

sudo systemctl enable deepspeech_service
sudo systemctl start deepspeech_service

sudo systemctl enable deepspeech_worker
sudo systemctl start deepspeech_worker
```

# Restart/stop services
```
sudo systemctl restart service-name
sudo systemctl stop service-name
```

# Check status
```
sudo systemctl status service-name
```

# Edit service
```
sudo systemctl edit service-name --full
sudo systemctl daemon-reload (After editing)
sudo journalctl -u service-name.service
```

# Check logs
```
sudo journalctl -u service-name.service
```

# Clear logs
```
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
```

# Keep your code clean with Rubocop
1. Install rubocop
```
gem install rubocop
```
2. Run rubocop to find coding offences
```
cd <working_dir>
rubocop
```
3. Safe auto corrections
```
rubocop --safe-auto-correct --disable-uncorrectable
```
