# nixos-dotfiles

Create config symlinks

```sh
cd /path/to/nixos-dotfiles

# backup existing configs
mv ~/.config/fuzzel ~/.config/fuzzel.bak
mv ~/.config/niri ~/.config/niri.bak
mv ~/.config/waybar ~/.config/waybar.bak

# Create the symlinks
ln -sfn "$PWD/config/fuzzel" ~/.config/fuzzel
ln -sfn "$PWD/config/niri" ~/.config/niri
ln -sfn "$PWD/config/waybar" ~/.config/waybar
```
