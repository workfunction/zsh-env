current_path=$(realpath .)

# update submodules
echo "Updating submodules..."
git submodule foreach git pull --ff-only > /dev/null

# install autojump
mkdir -p autojump
autojump_path=$current_path/autojump

cd libs/autojump
./install.py -d $autojump_path > /dev/null
cd -

# backup old zshrc
mkdir -p backups
backup_path=$current_path/backups
latest=$backup_path/$(ls -t1 $backup_path |  head -n 1)
backup=$backup_path/zshrc.$(mktemp -u | grep -oP "\.\K.*")

[ ! -f $latest ] && touch $backup && latest=$backup

[ -f $HOME/.zshrc ] && \
! grep -q "###### auto generated .zshrc" $HOME/.zshrc && \
! diff $HOME/.zshrc $latest > /dev/null && \
cp $HOME/.zshrc $backup && \
echo "Old .zshrc backup to $backup..."

# create new zshrc
echo "Creating new zshrc file"
sed "s|###PWD###|$current_path|g" scripts/configs.zsh-template > $HOME/.zshrc
cat scripts/zshrc.zsh-template >> $HOME/.zshrc

echo "Done!"
