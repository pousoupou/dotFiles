#!/bin/zsh

# Define the path to your Stow directory (adjust if needed)
STOW_DIR="$HOME/dotFiles"

# Function to get a list of files and directories from the Stow packages
get_stow_targets() {
  # Read ignore patterns from .stow-local-ignore if it exists
  local ignore_file="$STOW_DIR/.stow-local-ignore"
  local find_args=()
  
  if [ -f "$ignore_file" ]; then
    # Build find arguments to exclude ignored patterns
    while IFS= read -r pattern; do
      # Skip empty lines and comments
      if [[ -n "$pattern" && ! "$pattern" =~ ^[[:space:]]*# ]]; then
        find_args+=(-not -path "*/$pattern" -not -path "*/$pattern/*")
      fi
    done < "$ignore_file"
  fi
  
  # Find files and links, excluding ignored patterns
  find "$STOW_DIR" "${find_args[@]}" -type f -o "${find_args[@]}" -type l | sed "s|$STOW_DIR/||"
}

# Function to delete existing files or directories
remove_files() {
  for file in $(get_stow_targets); do
    TARGET="$HOME/$file"
      
    # Check if the target file or symlink exists
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
      echo "Removing $TARGET..."
      rm -rf "$TARGET"
    else
      echo "$TARGET does not exist, skipping..."
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
echo "Unlinking existing dotfiles..."
stow -D .
echo "Done!!"

echo "Removing unlinked dotfiles..."
remove_files
echo "Done!!"

# Run Stow to symlink your dotfiles
echo "Running GNU Stow..."
stow .
echo "Done!!"

echo "All done!"
