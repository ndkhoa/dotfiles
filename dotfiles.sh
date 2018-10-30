#!/bin/sh

mkdir -p $HOME/ndkhoa
DOTHOME="$HOME/ndkhoa/dotfiles"
BACKDIR="$HOME/ndkhoa/dotfiles-$(date "+%Y%m%d%H%M%S")"

main() {
  init_workspace
  link_dotfiles
  link_tmuxinator
}

init_workspace () {
  if [ -d "$DOTHOME" ]; then
    rm -rf $DOTHOME
  fi
  git clone https://github.com/ndkhoa/dotfiles.git $HOME/ndkhoa/dotfiles
}

link_dotfiles () {
  cd "$DOTHOME"

  # Read in Dotfiles
  while read file; do
    dest="$HOME/.$file"

    # Skip if link is the same
    # https://stackoverflow.com/questions/19860345/how-to-check-if-a-symlink-target-matches-a-specific-path
    if [ "$DOTHOME/$file" = "$(readlink $dest)" ]; then
      continue
    fi

    # Back up file if it exists
    if [ -e "$dest" ]; then
      echo "Move .$file into up $BACKDIR"
      mkdir -p "$BACKDIR"
      mv "$dest" "$BACKDIR"
    fi

    ln -s "$DOTHOME/$file" "$dest"
    echo "Created a symbolic link to $DOTHOME/$file"
  done < Dotfiles
}

link_tmuxinator () {
  cd "$DOTHOME"

  for dir in */ ; do
    # https://bytefreaks.net/gnulinux/bash/remove-the-last-character-from-a-bash-variable
    dir=${dir%?}

    dest="$HOME/.$dir"

    # Skip if link is the same
    if [ "$DOTHOME/$dir" = "$(readlink $dest)" ]; then
      continue
    fi

    # Back up directory if it exists
    if [ -d "$dest" ]; then
      echo "Move $dest into up $BACKDIR"
      mkdir -p "$BACKDIR"
      mv "$dest" "$BACKDIR"
    fi

    ln -s "$DOTHOME/$dir" "$dest"
    echo "Created a symbolic link to $DOTHOME/$dir"
  done
}

main
