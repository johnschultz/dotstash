# DIRNAME=$(python -c "import os,sys; print os.path.realpath(sys.argv[1])" $(dirname $0))
DIRNAME=$(pwd)
git submodule update --init --recursive
ln -s vim/Vundle.vim vim/bundle/

if ! [[ -e ~/Library/"Application Support"/"Sublime Text 2"/Packages/User ]]; then
    mkdir -p ~/Library/"Application Support"/"Sublime Text 2"/Packages
    ln -s $DIRNAME/sublime_text_2 ~/Library/"Application Support"/"Sublime Text 2"/Packages/User
fi

cd $HOME
ln -s $DIRNAME/vim .vim
ln -s .vim/vimrc .vimrc
ln -s $DIRNAME/profile .bash_profile
ln -s $DIRNAME/ackrc .ackrc
ln -s $DIRNAME/gitconfig .gitconfig
ln -s $DIRNAME/hgrc .hgrc
ln -s $DIRNAME/tmux.conf .tmux.conf
ln -s $DIRNAME/ssh-config .ssh/config

echo "Don't forget to source ~/.profile"
echo "Don't forget to :PluginInstall in Vim"
echo "Run ./dotstash/install-oh-my-zsh.sh if you want that jazz"
