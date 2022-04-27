backup_zshrc() {
    mkdir -p backups
    backup_path=$PWD/backups
    latest=$backup_path/$(ls -t1 $backup_path |  head -n 1)
    backup=$backup_path/zshrc.$(mktemp -u | grep -oP "\.\K.*")

    # check if no previous backups
    [ ! -f $latest ] && touch $backup && latest=$backup

    [ -f $HOME/.zshrc ] && \
    ! diff $HOME/.zshrc $latest > /dev/null && \
    cp $HOME/.zshrc $backup && \
    echo "Old .zshrc backup to $backup..."
}

install_zshrc() {
    echo "Creating new zshrc file"
    sed "s|###PWD###|$PWD|g" scripts/configs.zsh-template > $HOME/.zshenv_configs

    user_conf="$(sed -e '1,/# Put your custom scripts below/d' $HOME/.zshrc)"
    sed "s|###PWD###|$PWD|g" scripts/zshrc.zsh-template > $HOME/.zshrc
    echo "$user_conf" >> $HOME/.zshrc
}

backup_zshrc;
install_zshrc;

echo "Done!"
