## 環境構築

```shell
# クローンする
git clone git@github.com:zoshigayan/dotfiles.git ~/dotfiles

# zsh の設定パスを指定する
touch ~/.zshenv
echo "export ZDOTDIR=${HOME}/dotfiles/zsh" >> ~/.zshenv

# nvim の設定をシンボリックリンク化する
ln -s ~/dotfiles/nvim ~/.config

# asdf の設定をシンボリックリンク化する
ln -s ~/dotfiles/asdf/.tool-versions ~
```
