#!/bin/bash

# Function to check if a line exists in the .bashrc file
line_exists_in_bashrc() {
  grep -Fxq '$1' ~/.bashrc
}
# Function to add lines to the .bashrc file if they don’t exist

add_to_bashrc() {
  if ! line_exists_in_bashrc '$1'; then
    echo '$1' >> ~/.bashrc
  fi
}

# Function to install ruby
install_ruby() {
# Check if ruby command is available
  if ! command -v ruby &>/dev/null; then
    echo “Installing Ruby...”
    sudo apt update -y
	sudo apt install ruby-full build-essential zlib1g-dev -y
  else
    echo “Ruby is already installed.”
  fi
}


# Common Developer tools for system
install_dev_tools() {
  echo “Installing Developer Tools...”

  # Common GNU tools
  sudo apt install build-essential -y
  sudo apt install make -y

  # Install Jekyll Development tools
  gem install jekyll bundler -y
}

# The environment_activate function effectively sets up the required environment configurations by adding lines to the .bashrc file only if they don’t already exist. This ensures that the modifications to the .bashrc file are performed only once and avoids duplication.
setup_conda_environment() {
  add_to_bashrc `# local environment requirement`
  add_to_bashrc ‘export PATH=“$HOME/miniconda/bin:$PATH”’
  add_to_bashrc ‘export GEM_HOME=“$HOME/gems”’
  add_to_bashrc ‘export PATH=“$HOME/gems/bin:$PATH”’
  conda init bash
}

# Specific Developer tools for GitHub Pages and Jupyter Notebooks
install_dev_tools_in_conda() {
  echo “Activate conda”
  source ~/.bashrc

  # Install Jupyter Development tools and nbconvert
  echo "Installing Jupyter Notebooks and nbconvert..."
  conda install -n base -y jupyter nbconvert
}

# Main script
install_ruby
install_dev_tools
setup_conda_environment
install_dev_tools_in_conda