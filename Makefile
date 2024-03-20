SUBS := $(dir $(wildcard libs/*/))
SUBS += $(dir $(wildcard custom/plugins/*/))

.PHONY: all update $(SUBS) zshrc

all: update install_fzf zshrc tmux vim install_zo install_starship

update: $(SUBS)

$(SUBS):
	@echo "[Updating] $@"
	-@cd $@ && git checkout master > /dev/null 2>&1 || git checkout main > /dev/null 2>&1
	-@cd $@ && git pull origin --ff-only
	@echo "[Done] $@"

install_fzf: libs/fzf/
	@echo "[Installing] fzf"
	@libs/fzf/install --all --no-update-rc > /dev/null
	@echo "[Done] fzf"

install_zo:
	@echo "[Installing] zoxide"
	@curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash  > /dev/null
	@echo "[Done] zoxide"

install_starship: export BIN_DIR=$(HOME)/.local/bin
install_starship:
	@echo "[Installing] starship"
	@mkdir -p $(HOME)/.local/bin
	@curl -sS https://starship.rs/install.sh | sh -s -- -f  > /dev/null
	@mkdir -p $(HOME)/.config
	@cp -f scripts/starship.toml $(HOME)/.config/
	@echo "[Done] starship"

zshrc:
	@echo "[Installing] zshrc"
	@./install.zsh
	@echo "[Done] zshrc"

tmux:
	@echo "[Installing] tmux-config"
	@ln -s -f `pwd`/tmux.conf ~/.tmux.conf
	@echo "[Done] tmux-config"

vim:
	@echo "[Installing] vim-config"
	@ln -s -f `pwd`/vimrc ~/.vimrc
	@echo "[Done] vim-config"
