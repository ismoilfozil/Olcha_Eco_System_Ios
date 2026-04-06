

#!/bin/bash

main_dir="/Users/elbekkhasanov/Documents/app/Olcha"

modules=(
  "$main_dir/olcha-modules/OlchaMarketModule"
  "$main_dir/olcha-modules/ModuleGenerator"
)

cd "$main_dir"
git add .
git commit -m "Commit with timer $main_dir"
git push origin ModuleUI

for module in "${modules[@]}"
do
  cd "$module"
  git add .
  git commit -m "Commit with timer $module"
  git push origin main
done

