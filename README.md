## 環境構築

### クローンする

```shell
git clone git@github.com:zoshigayan/dotfiles.git ~/dotfiles
```

### zshの設定パスを指定する

```shell
touch ~/.zshenv
echo "export ZDOTDIR=${HOME}/dotfiles/zsh" >> ~/.zshenv
```

### neovimの設定をシンボリックリンク化する

```shell
ln -s ~/dotfiles/nvim ~/.config
```

### asdfの設定をシンボリックリンク化する

```shell
ln -s ~/dotfiles/asdf/.tool-versions ~
```

## インストールしておくもの

* 全環境共通
  * [asdf](https://github.com/asdf-vm/asdf)
  * [ghq](https://github.com/x-motemen/ghq)
  * [fzf](https://github.com/junegunn/fzf)
  * [ripgrep](https://github.com/BurntSushi/ripgrep)
  * [bat](https://github.com/sharkdp/bat)
* WSL環境のみ
  * [win32yank](https://github.com/equalsraf/win32yank)
