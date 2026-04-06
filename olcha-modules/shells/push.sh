#!/bin/bash

main_dir="/Users/elbekkhasanov/Documents/app/olcha-modules"

modules=(
"$main_dir/OlchaAuth:elbek"
"$main_dir/OlchaBalance:elbek"
"$main_dir/OlchaBankCards:elbek"
"$main_dir/OlchaCore:elbek"
"$main_dir/OlchaPayModule:main"
"$main_dir/OlchaResources:elbek"
"$main_dir/OlchaUtils:elbek"
"$main_dir/OlchaUI:elbek"
"$main_dir/OlchaPincode:main"
"$main_dir/OlchaVerification:main"
)

for module in "${modules[@]}"
do
  directory=$(echo "$module" | cut -d':' -f1)
  branch=$(echo "$module" | cut -d':' -f2)
  
  cd "$directory"
  git add .
  git commit -m "Commit with timer $directory"
  git push origin "$branch"
done
