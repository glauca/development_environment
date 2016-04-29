## basics

### install and setup

~~~bash
su - git
mkdir -p ~/bin

git clone git://github.com/sitaramc/gitolite
gitolite/install -ln ~/bin          # please use absolute path here
gitolite setup -pk yourname.pub
~~~