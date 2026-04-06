#!/bin/bash

main_dir="/Users/elbekkhasanov/Documents/app/Olcha"

modules=(
  "$main_dir/olcha-modules/OlchaPayModule"
  "$main_dir/olcha-modules/OlchaMarketModule"
  "$main_dir/olcha-modules/OlchaResources"
  "$main_dir/olcha-modules/OlchaAuth"
  "$main_dir/olcha-modules/OlchaUtils"
  "$main_dir/olcha-modules/OlchaPay"
  "$main_dir/olcha-modules/OlchaCore"
  "$main_dir/olcha-modules/OlchaUI"
  "$main_dir/olcha-modules/ModuleGenerator"
)

cd "$main_dir"
while true
do
  git add .
  git commit -m "Commit with timer $main_dir"
  git pull --rebase=false origin ModuleUI
  if [ $? -eq 0 ]
  then
    break
  else
    read -p "Conflicts occurred in main directory. Press Enter to open opendiff or Terminal to resolve conflicts, then press Enter to retry pull."
    git mergetool -t opendiff || open -a Terminal.app .
  fi
done

for module in "${modules[@]}"
do
  cd "$module"
  while true
  do
    git add .
    git commit -m "Commit with timer $module"
    git pull --rebase=false origin main
    if [ $? -eq 0 ]
    then
      break
    else
      read -p "Conflicts occurred in module $module. Press Enter to open opendiff or Terminal to resolve conflicts, then press Enter to retry pull."
      git mergetool -t opendiff || open -a Terminal.app .
    fi
  done
done
