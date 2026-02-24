#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

trap cleanup EXIT INT TERM

cleanup() {
    kill "$EVTEST_PID" 2>/dev/null
    lipc-set-prop -i com.lab126.powerd preventScreenSaver 0
}
lipc-set-prop -i com.lab126.powerd preventScreenSaver 1

# === Configuration ===
# KP3 has 1072x1448px but eips works with cols and rows that depend on font size
MAX_COL=66
MAX_ROW=59
MAX_TOUCHES=10
DEVICE="/dev/input/event1"

eips -f -c > /dev/null
eips 5 5 "Listening for touches through evtest (max $MAX_TOUCHES touches)..." > /dev/null
echo "Listening for touches through evtest (max $MAX_TOUCHES touches)..."

COUNT=0
PREV_X=0
PREV_Y=0
PREV_TEXT_LENGTH=0
TOUCH_ACTIVE=0

# Use a FIFO instead of a pipe so you control both ends
FIFO=$(mktemp -u)
mkfifo "$FIFO"

"$SCRIPT_DIR/evtest" --grab "$DEVICE" > "$FIFO" < /dev/null &
EVTEST_PID=$!

while read -r line < "$FIFO"; do
    case "$line" in
        *"type 1 (EV_KEY), code 330 (BTN_TOUCH), value 1"*)
            echo "Touch Down"
            TOUCH_ACTIVE=1
            ;;
        *"type 1 (EV_KEY), code 330 (BTN_TOUCH), value 0"*)
            if [ "$TOUCH_ACTIVE" -eq 1 ]; then
                echo "Touch Up"
                TOUCH_ACTIVE=0
                COUNT=$((COUNT + 1))
                echo "Count increased to $COUNT"
                # Clear previous message
                eips "$PREV_X" "$PREV_Y" "$(printf '%*s' "$PREV_TEXT_LENGTH" "")" > /dev/null

                # Generate new random coordinates
                TEXT="Touch detected (number $COUNT)"
                X=$((RANDOM % ((MAX_COL-${#TEXT}))))
                Y=$((RANDOM % MAX_ROW))

                # Show the message
                eips "$X" "$Y" "$TEXT" > /dev/null

                # Save coordinates for next clear
                PREV_X=$X
                PREV_Y=$Y
                PREV_TEXT_LENGTH=${#TEXT}
            fi
            ;;
    esac

    if [ "$COUNT" -ge "$MAX_TOUCHES" ]; then
        break
    fi
done

rm -f "$FIFO"

echo "Finished detecting $MAX_TOUCHES touches."
eips -f -c > /dev/null
lipc-set-prop com.lab126.appmgrd start app://com.lab126.booklet.home