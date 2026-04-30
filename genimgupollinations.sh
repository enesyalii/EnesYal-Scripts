#!/usr/bin/env bash

open_latest_image() {
  latest_image=$(find . -maxdepth 1 -type f \( -name 'gen-image*.jpg' -o -name 'generated_image.jpg' \) -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)

  if [[ -z "$latest_image" ]]; then
    echo "No generated image found."
    return
  fi

  echo "Latest image: $latest_image"

  if command -v xdg-open >/dev/null 2>&1; then
    read -rp "Open it now? [y/N]: " open_choice

    if [[ "$open_choice" == "y" || "$open_choice" == "Y" ]]; then
      xdg-open "$latest_image" >/dev/null 2>&1 &
    fi
  else
    echo "Open this file from your file manager to see it."
  fi
}

while true; do
  clear
  echo "===================="
  echo "      Pollinations AI Curl Generator"
  echo "===================="
  echo "1) Generate image"
  echo "2) Show images"
  echo "3) Exit"
  echo

  read -rp "Choose an option: " choice

  case "$choice" in
    1)
      read -rp "Enter image prompt: " prompt

      if [[ -z "$prompt" ]]; then
        echo "Using default prompt..."
        python3 main.py
      else
        echo "Generating image..."
        python3 main.py "$prompt"
      fi

      open_latest_image
      read -rp "Press Enter to continue..."
      ;;
    2)
      find . -maxdepth 1 -type f \( -name 'gen-image*.jpg' -o -name 'generated_image.jpg' \) -printf '%f\n' 2>/dev/null | sort
      read -rp "Press Enter to continue..."
      ;;
    3)
      exit 0
      ;;
    *)
      echo "Invalid option"
      sleep 1
      ;;
  esac
done
