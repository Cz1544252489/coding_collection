#!/bin/bash
shopt -s nullglob nocaseglob

# exiftool -exif:all $(ls|head -n10) | grep "Create" | awk '{ print $4 "-" $5}' | sed -E "s/://g"


for f in *.jpg *.jpeg *.png; do
  # 尝试读取EXIF拍摄时间
  dt=$(exiftool -s3 -DateTimeOriginal "$f" 2>/dev/null)

  if [[ -n "$dt" ]]; then
    # 格式化EXIF时间为 yyyymmdd-HHMMSS
    ts=$(echo "$dt" | sed 's/[: ]//g' | cut -c1-8)'-'$(echo "$dt" | sed 's/[: ]//g' | cut -c9-14)
  else
    # 使用文件修改时间
    ts=$(date -r "$f" +%Y%m%d-%H%M%S)
  fi

  ext="${f##*.}"
  newname="${ts}.${ext,,}"

  # 避免重名
  count=1
  while [[ -e "$newname" ]]; do
    newname="${ts}_${count}.${ext,,}"
    ((count++))
  done

  mv -i -- "$f" "$newname"
  echo "Renamed: $f -> $newname"
done
