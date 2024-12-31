#!/usr/bin/env ruby
# frozen_string_literal: true

require "English"

# Helper to execute tmux commands
def tmux_command(command)
  # Unset TMUX variable to prevent nesting issues
  system("env -u TMUX #{command}")
  $CHILD_STATUS.success?
end

# Check if tmux session exists
def check_session(name)
  tmux_command("tmux has-session -t='#{name}' 2>/dev/null")
end

# Create a new tmux session
def create_session(name, dir_path)
  tmux_command("tmux new-session -d -s #{name} -c #{dir_path}")
end

# Split a pane vertically
def split_pane(session_name, dir_path)
  tmux_command("tmux split-window -v -t=#{session_name}:0 -c #{dir_path}")
end

# Send a command to a specific pane
def send_keys(session_name, pane, command)
  tmux_command("tmux send-keys -t=#{session_name}:0.#{pane} '#{command}' C-m")
end

# Detach from the current session and reattach to the new session
def reattach_to_session(name)
  tmux_command("tmux switch-client -t='#{name}'")
end

# Extract the session name from the directory path
def extract_session_name(path)
  raise 'Path name empty' if path.empty?

  File.basename(path)
end

raise 'Argument is not provided' unless ARGV.any?

dir_path = ARGV[0]

# Ensure the directory exists
raise "Directory does not exist: #{dir_path}" unless Dir.exist?(dir_path)

# Generate the session name based on the directory
session_name = extract_session_name(dir_path)

# If the session exists, reattach to it
if check_session(session_name)
  reattach_to_session(session_name)
  exit 0
end

# Create a new session in the specified directory
if create_session(session_name, dir_path)
  # Pane 0: Run vim
  send_keys(session_name, 0, "vim +NERDTree")

  # Pane 1: Split and run shell
  split_pane(session_name, dir_path)

  send_keys(session_name, 1, "tmux resize-pane -D 15")
  # Set layout for panes
  tmux_command("tmux select-layout tiled")

  # Reattach to the new session
  reattach_to_session(session_name)
else
  raise "Failed to create tmux session: #{session_name}"
end
