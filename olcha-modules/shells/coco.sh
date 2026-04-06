

#!/bin/bash

main_dir="/Users/elbekkhasanov/Documents/app"

modules=(
    "$main_dir/olcha-modules/OlchaCore"
      "$main_dir/olcha-modules/OlchaAuth"
        "$main_dir/olcha-modules/OlchaUI"
          "$main_dir/olcha-modules/OlchaResources"
            "$main_dir/olcha-modules/OlchaUtils"
)

for module in "${modules[@]}"
do
  cd "$module"
  arch -x86_64 pod install      
done

