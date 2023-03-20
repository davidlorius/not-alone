# README  

# Getting Started with You Are Not Alone  

This README describes the steps needed to get up and running as a developer
of the project.  This project uses Rails 6, Postgres, and Bootstrap.  The
instructions below describe how you set up an ubuntu linux environment, including
linux running under vagrant on Windows.  The steps for Mac are similar except
that you do brew install.

# Configuring Vagrant if you are using it

Rails 6 uses Webpacker and Yarn.  As a result, it requires support in the
environment for symbolic links.  To enable this, add the following to your
Vagrantfile:

```
config.vm.provider "virtualbox" do |v|
      v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
```
You may already have the config.vm.provider block, in which case you add the
line described.  Then, bring down your vagrant environment with "vagrant halt"
if it is running, and close the Git Bash session.  Then, start a new Git Bash
session running it as the windows administrator.  Then do a "vagrant up".
From now on, whenever you do "vagrant up", you will need to do it from a Git
Bash session that was run as the windows administrator.

# Installing Prerequisites on Linux (and Vagrant)  

Do:

`sudo apt-get update`  
`sudo apt-get install postgresql`    
`sudo apt-get install postgresql-contrib`  
`sudo apt-get install libpq-dev`  
`sudo apt-get install yarn`  
`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash`   
`nvm install --lts`  
`sudo apt remove nodejs`  
`which node`  

The which command will return a filename like

`/home/vagrant/.nvm/versions/node/v14.15.1/bin/node`

You create a symbolic link to it via

`ln -s /usr/bin/nodejs /home/vagrant/.nvm/versions/node/v14.15.1/bin/node`

Be sure that the ln command is passed the actual location returned by which.
The node/nodejs stuff is not needed on mac.

# Installing Prerequisites on Mac OS  

Check if you are running Mac OS Catalina.  That is done by clicking on the apple icon in the upper
left corner of your screen, and then clicking on About This Mac.  If you are running
Catalina, which is the most current release, you will have to do the following steps:

`curl -sL https://github.com/nodejs/node-gyp/raw/master/macOS_Catalina_acid_test.sh | bash`

The above command may return an error.  If so, do the following:

`sudo rm -rf /Library/Developer/CommandLineTools` (You will have to enter your admin password)  
`sudo xcode-select --reset`  
`xcode-select --install`  

Then repeat the curl command above.  The error should go away. If it does not, stop!
and contact me.

Now we can actually install the prerequisites.  You should have installed brew when
you originally set up your Mac to run rails.  Check that it is there with this command:

`brew -v`

If you do not have brew, instructions for installing it are here: https://brew.sh/ .
Now, do the following commands:

`brew update`  
`brew doctor`  
`brew install postgresql`  
`brew services start postgresql`  
`brew install yarn`  

Each of these commands should complete without error.  If not, stop! and post to
the slack channel.

# Getting started with the git repository

In your browser, go to https://github.com/CodeTheDream/not-alone
Then fork that repository into your own github workspace.  Then clone your
not-alone workspace to your laptop, in an appropriate directory.  We will
use a git process as described here: https://learn.codethedream.org/midnight-train-git-workflow/
Please read the instructions at that link.  You may not understand them yet,
but you will.  The main point is that you have a triangular workflow, as
described in the document.  To set up the triangle, you need to do

git remote add upstream https://github.com/CodeTheDream/not-alone

# Setting up the not-alone application

You will do the following:

`yarn add bootstrap@4.5.3 jquery popper.js`  
`rvm install 2.7.0`  
`cd not-alone`  
`bundle install`    
`yarn install --checkfiles`    
`bin/rails db:create`  
`bin/rails db:migrate`  
`bin/rails db:migrate RAILS_ENV=test`  
`bin/rails db:seed`    
`rspec`  

Each of these commands should complete without failures, including Rspec.  Then
run  

`bin/rails s`

adding -b 0.0.0.0 if you are running in vagrant.  Then see if you can get to
the server at localhost:3000.

If any of this fails, post the problem in the slack channel.

## Dockerize App

This section is to know how to use this repository with Docker for a more straightforward installation process. Pre-requisites are only to have Docker working and have the docker-compose command installed.

On the root folder, you need to copy the `.env-template` file to `.env` and modify the values of the environment variables with what you need, but with the default values work fine.

```bash
cp .env-template .env
```

Finally, you need to run the `docker-compose` command and wait until the build process finish.

```bash
docker-compose up --build
```

### Architecture

The main idea is to have two containers running, one for the database (PostgreSQL) and the second for the project (Ruby/Rails/Nodejs); the database container uses the main PostgreSQL image from Docker Hub, and the second container is based on Alpine Linux distribution from Docker Hub, too. The essential files are:

- `./init.sql` # It contains the initial sql script to create and grant three databases: dev, test, and prod.
- `./entrypoint.sh` # It contains the command to start the web server rails exec rails s -b 0.0.0.0
- `./.env` # It contains the environment variables and their values
- `./Dockerfle` # It contains the definition of project, package installation and build commands
- `./docker-compose.yml` # It contains the Docker definitions, environment variables, volumes and ports usage

On the last file you can modify the main environment variable for Rails `RAILS_ENV`, by default the value is "development" but you cand change it for test or production based on your requirements.

### Automatic Build&Push the Docker image

We can use the Dockerhub or any other container registry to publish this Docker image and anyone can deploy it on their own local computer, VPS (virtual private
server) or any other cloud resource which can execute containers (GKE, ECS, AKS or something similar).

The firts step of GitHub Actions use the Docker official images to login, to build and push the image into the Dockerhub (container registry); so we need
to setup two initial secrets values into the [Github repository configuration](https://github.com/adrianagithub/mhproject/settings/secrets/actions) add
these variables:

- **DOCKERHUB_USERNAME** the value required here is the username of the Dockerhub account (for example `adrianaprojects`)
- **DOCKERHUB_TOKEN** the value required here is the [Access token from your account](https://hub.docker.com/settings/security)
