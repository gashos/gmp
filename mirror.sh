#!/bin/sh

mkdir git-remotes

git clone https://github.com/felipec/git-remote-bzr git-remote-bzr/
git clone https://github.com/felipec/git-remote-hg git-remote-hg/

eval "$(ssh-agent -s)"
openssl aes-256-cbc -K $encrypted_4f8fe12bc84e_key -iv $encrypted_4f8fe12bc84e_iv -in key.enc -out key.dec -d

chmod 600 key.dec
ssh-add key.dec

cd git-remotes
chmod +x ../git-remote-bzr/git-remote-bzr
ln -s ../git-remote-bzr/git-remote-bzr git-remote-bzr
chmod +x ../git-remote-bzr/git-remote-hg
ln -s ../git-remote-hg/git-remote-h git-remote-hg
PYTHONPATH="usr/local/bin/bzr:${PYTHONPATH}"
PATH=$PATH:$(pwd)
cd ..

mkdir mirrors
cd mirrors

git clone bzr::http://bazaar.launchpad.net/~intltool/intltool/trunk/ intltool
cd intltool
git remote set-url origin git@github.com:gashos/intltool.git
git push -f --mirror
cd ..

git init expect
cd expect
fossil clone http://core.tcl.tk/expect /tmp/expect.fossil
fossil export --git /tmp/expect.fossil | git fast-import
git remote add origin git@github.com:gashos/expect.git
git push -fu --mirror origin
cd ..

git clone hg::https://gmplib.org/repo/gmp/ gmp
cd gmp
git remote set-url origin git@github.com:gashos/gmp.git
git push -f --mirror
cd ..
