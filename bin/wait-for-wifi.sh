#!/usr/bin/env sh

readonly TEST_IP="1.1.1.1"
readonly MAX_RETRIES=30

if [ -z "$TEST_IP" ]; then
  printf "Error: No test IP specified.\n" >&2
  exit 1
fi

wait_for_wifi() {
  target_ip="$1"
  counter=0

  # Evaluate the ping command directly in the loop condition
  # -W 1 sets a 1-second timeout so the ping doesn't hang indefinitely 
  until ping -c 1 -W 1 "$target_ip" >/dev/null 2>&1; do
    if [ "$counter" -ge "$MAX_RETRIES" ]; then
      printf "Error: Couldn't connect to Wi-Fi after %d attempts.\n" "$MAX_RETRIES" >&2
      exit 1
    fi
    
    counter=$((counter + 1))
    sleep 1
  done
}

# Pass the IP as an argument to keep the function self-contained
wait_for_wifi "$TEST_IP"

echo "Wi-Fi connected"