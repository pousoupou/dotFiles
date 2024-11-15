#!/usr/bin/zsh

# Define the path to your Stow directory (adjust if needed)
STOW_DIR="$HOME/dotFiles"

# Function to get a list of files and directories from the Stow packages
get_stow_targets() {
  find "$STOW_DIR" -type f -o -type l | sed "s|$STOW_DIR/||" | awk -F'/' '{print $2}'
}

# Function to delete existing files or directories
remove_files() {
  for file in $(get_stow_targets); do
    if ! [ $file = ".git" ] then
      TARGET="$HOME/$file"
      
      # Check if the target file or symlink exists
      if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        echo "Removing $TARGET..."
        rm -rf "$TARGET"
      else
        echo "$TARGET does not exist, skipping..."
      fi
    fi
  done
}

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "Error: GNU Stow is not installed. Please install it first."
  exit 1
fi

# Change to the Stow directory
cd "$STOW_DIR" || { echo "Error: Stow directory not found"; exit 1; }

# Remove files
echo "Cleaning up existing dotfiles..."
remove_files

# Run Stow to symlink your dotfiles
echo "Running GNU Stow..."
stow .

echo "All done!"
