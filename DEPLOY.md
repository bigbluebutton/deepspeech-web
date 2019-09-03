# Create Sudo user
STEP 1. ssh into your server.
```
ssh root@<server ip>
```

STEP 2. Use the adduser command to add a new user to your system and set the password for the user
```
adduser <username>
```

STEP 3. Use the usermod command to add the user to the sudo group.
```
usermod -aG sudo <username>
```

STEP 4. Test sudo access on new user account. Use the su command to switch to the new user account.
```
su <username> or su - <username>
```
Then execute any command with sudo to test the user.
```
sudo mkdir abc
```
# Installing Ruby
make sure you are logged in with new sudo user (not as root user)

Adding Node.js 10 repository
```
$user: curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
```

Adding Yarn repository
```
$user: curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$user: echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$user: sudo add-apt-repository ppa:chris-lea/redis-server
```
Refresh packege
```
$user: sudo apt-get update
```
Install our dependencies for compiiling Ruby along with Node.js and Yarn
```
$user: sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

# install Rbenv
```
$user: git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$user: echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$user: echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$user: git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
$user: echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
$user: git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
$user: exec $SHELL
$user: rbenv install 2.6.3
$user: rbenv global 2.6.3
$user: ruby -v
#ruby 2.6.3
```

This installs the latest Bundler, currently 2.x.
```
$user: gem install bundler
```

For older apps that require Bundler 1.x, you can install it as well.
```
$user: gem install bundler -v 1.17.3
```

Test and make sure bundler is installed correctly, you should see a version number.
```
$user: bundle -v
#Bundler version 2.0
```

install rails
```
$user:gem install rails
```

# Some errors and solutions.
for example,
Rails application : deepspeech-web  (rails root dir)
sudo user : ubuntu

```
Error: if you get error related .ruby-version file
solution: delete .ruby-version file from your rails application root directory

Error: Your Ruby version is 2.6.3, but your Gemfile specified 2.6.1
solution: open your Gemfile and change the Gemfile version to 2.6.3

Error: There was an error while trying to write to `<path-to-rails-app>/deepspeech-web/Gemfile.lock`. It is likely that you need to grant write permissions for that path.

solution
$ubuntu:sudo chown -R <user>:<user> path-to-rails_root

Example:
$ubuntu:sudo chown -R ubuntu:ubuntu /usr/local/deepspeech-web
```

# Running Rails Application
Go to rails root directory and execute following commands
```
install dependencies
$user: bundle install

execute migration to create database
$user: rake db:migrate

start server on specific port
$user: rails s -b 0.0.0. -p <port_number>
```
You can use port_number = 3000 or 4000

# Install Mozilla deepspeech
1. install dependencies
```
$user: sudo apt-get install build-essential
$user: sudo apt-get install aptitude
$user: sudo apt-get install libstdc++6
$user: sudo apt-get install libsox-dev
$user: cd /usr/lib/x86_64-linux-gnu
$user: sudo ln -s libsox.so.3 libsox.so.2
$user: export PATH="$PATH:/usr/lib/x86_64-linux-gnu"
```

2. Install Python
```
$user: sudo apt-get install python3-dev

#other dependencies
$user: sudo apt-get install pkg-config zip g++ zlib1g-dev unzip wget
$user: export PYTHON_INCLUDE_PATH="/usr/include/python3.6m"
$user: export PYTHON_BIN_PATH="/usr/bin/python3.6"
```

3. Install Bazel and update PATH variable
3.1 Download Bazel 0.15 compatible to tensorflow 1.12.0
```
#create installation dir called deepspeech
$user: sudo mkdir deepspeech
$user: cd deepspeech
$user/deepspeech: sudo mkdir temp
$user/deepspeech: sudo apt-get install wget
$user/deepspeech: sudo wget https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-installer-linux-x86_64.sh
```

3.2 Run the Bazel installer
```
$user/deepspeech: sudo chmod +x bazel-0.15.0-installer-linux-x86_64.sh
$user/deepspeech: sudo ./bazel-0.15.0-installer-linux-x86_64.sh –-user --bin=$HOME/bin

#The --user flag installs Bazel to the $HOME/bin directory on your system and sets the .bazelrc path to $HOME/.bazelrc.
```

3.3 Set up your environment
```
export PATH="$PATH:$HOME/bin"
```

4. Build deepspeech native
4.1 DeepSpeech clone and checkout
```
$user/deepspeech: sudo apt-get install git
$user/deepspeech: sudo git clone https://github.com/dabinat/DeepSpeech.git
$user/deepspeech/Deepspeech: cd DeepSpeech/
$user/deepspeech/Deepspeech: sudo git checkout timing-info
$user/deepspeech/Deepspeech: cd ..
```

4.2 Tensorflow clone and checkout
```
$user/deepspeech: sudo git clone https://github.com/mozilla/tensorflow.git
$user/deepspeech: cd tensorflow/
$user/deepspeech/tensorflow: sudo git checkout origin/r1.12
```
4.3 create a symbolic link to the DeepSpeech native_client directory.
```
$user/deepspeech/tensorflow: sudo ln -s ../DeepSpeech/native_client ./
```

5. Build DeepSpeech
5.1 make sure you have a python
```
$user/deepspeech/tensorflow: sudo apt-get install python
```

5.2 execute build command and have a cup of tea because usually it takes 20-25 mins to build. However, time is depending on server  configurations
```
$user/deepspeech/tensorflow: sudo bazel build --config=monolithic -c opt --copt=-O3 --copt="-D_GLIBCXX_USE_CXX11_ABI=0" --copt=-fvisibility=hidden //native_client:libdeepspeech.so //native_client:generate_trie
```

5.3 set environment variable
```
$user/deepspeech/tensorflow: export TFDIR=~/workspace/tensorflow
```

5.4 make sure you have deepspeech file in your DeepSpeech dir and tensaflow dir. If file exist in both dir then execute following command.
```
$user/deepspeech/tensorflow: cd ../DeepSpeech/native_client
$user/deepspeech//DeepSpeech/native_client: make deepspeech
```

6. Copy binaries into deepspeech/temp folder
```
$user/deepspeech/DeepSpeech/native_client: cp deepspeech ~/deepspeech/temp/deepspeech
$user/deepspeech/DeepSpeech/native_client: cp ~/deepspeech/tensorflow/bazel-bin/native_client/libdeepspeech.so ~/deepspeech/temp/libdeepspeech.so
$user/deepspeech/DeepSpeech/native_client: cd ~/deepspeech/temp
```

7. Download model and audio files
```
$user/deepspeech/temp: sudo wget https://github.com/mozilla/DeepSpeech/releases/download/v0.4.1/deepspeech-0.4.1-models.tar.gz
$user/deepspeech/temp: sudo tar xvf deepspeech-0.4.1-models.tar.gz
$user/deepspeech/temp: sudo wget https://github.com/mozilla/DeepSpeech/releases/download/v0.4.1/audio-0.4.1.tar.gz
$user/deepspeech/temp: sudo tar xvf audio-0.4.1.tar.gz
```

8. check if deepspeech native is working
```
$user/deepspeech/temp: ./deepspeech --model models/output_graph.pbmm --alphabet models/alphabet.txt --lm models/lm.binary --trie models/trie --audio audio –e
```

At this point, you should get words for sample audios inside the temp/audio directory.
