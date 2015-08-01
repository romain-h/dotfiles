#! /usr/bin/env bash

# If reattach-to-user-namespace is not available, just run the command.
if [ -n "$(command -v reattach-to-user-namespace)" ]; then
  reattach-to-user-namespace pbcopy
else
  # Clipper port
  nc localhost 8377
fi
