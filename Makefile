SUBS := $(dir $(wildcard libs/*/))
SUBS += $(dir $(wildcard custom/plugins/*/))

.PHONY: all update $(SUBS) zshrc

all: update install_jump install_fzf zshrc tmux vim

update: $(SUBS)

$(SUBS):
	@echo "[Updating $@]"
	-@cd $@ && git checkout master > /dev/null 2>&1 || git checkout main > /dev/null 2>&1
	-@cd $@ && git pull origin --ff-only

install_jump: libs/autojump/
	@echo "[Installing autojump]"
	@mkdir -p autojump

	@cd libs/autojump && ./install.py -d $(PWD)/autojump > /dev/null

install_fzf: libs/fzf/
	@echo "[Installing fzf]"
	@libs/fzf/install --all --no-update-rc > /dev/null

zshrc:
	@echo "[Installing zshrc]"
	@./install.zsh
	
tmux:
	@echo "[Installing tmux config]"
	@ln -s -f `pwd`/tmux.conf ~/.tmux.conf

vim:
	@echo "[Installing vim config]"
	@ln -s -f `pwd`/vimrc ~/.vimrc

