#!/usr/bin/env zsh

update_submodules() {
    echo "Updating submodules..."
    git submodule foreach 'git checkout master || git checkout main' #> /dev/null 2>&1
    git submodule foreach git pull origin --ff-only #> /dev/null 2>&1
}

install_submodules() {
    # install autojump
    echo "Installing autojump"
    mkdir -p autojump
    autojump_path=$PWD/autojump

    cd libs/autojump
    ./install.py -d $autojump_path > /dev/null
    cd -

    # install fzf
    echo "Installing fzf"
    libs/fzf/install --all --no-update-rc > /dev/null
}

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

update_submodules;
install_submodules;
backup_zshrc;
install_zshrc;

echo "Done!"
