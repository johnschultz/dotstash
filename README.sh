DIRNAME=$(python -c "import os,sys; print os.path.realpath(sys.argv[1])" $(dirname $0))
git submodule update --init --recursive
ln -s vim/Vundle.vim vim/bundle/

cp profile $HOME/.profile
cp ackrc $HOME/.ackrc
cp gitconfig $HOME/.gitconfig
cp hgrc $HOME/.hgrc
cp tmux.conf $HOME/.tmux.conf

if ! [[ -e ~/Library/"Application Support"/"Sublime Text 2"/Packages/User ]]; then
    mkdir -p ~/Library/"Application Support"/"Sublime Text 2"/Packages
    ln -s $DIRNAME/sublime_text_2 ~/Library/"Application Support"/"Sublime Text 2"/Packages/User
fi

cd $HOME
ln -s $DIRNAME/vim .vim
ln -s .vim/vimrc .vimrc

echo "Don't forget to source ~/.profile"
echo "Don't forget to :PluginInstall in Vim"
