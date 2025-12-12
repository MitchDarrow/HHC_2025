#!/bin/bash
# Convert Markdown tables and Markdown inside <details> into HTML

REPO_DIR="${1:-.}"

convert_table() {
  local line="$1"
  # Strip leading/trailing pipes and spaces
  line=$(echo "$line" | sed 's/^[[:space:]]*|//;s/|[[:space:]]*$//')
  IFS='|' read -ra cols <<< "$line"

  # Check if it's a separator row (---)
  sep=1
  for c in "${cols[@]}"; do
    if [[ ! "$c" =~ ^[[:space:]]*-+[[:space:]]*$ ]]; then
      sep=0
    fi
  done

  if [[ $sep -eq 1 ]]; then
    echo "<tr>"
    for c in "${cols[@]}"; do
      echo "  <th></th>"
    done
    echo "</tr>"
  else
    echo "<tr>"
    for c in "${cols[@]}"; do
      echo "  <td>${c// /}</td>"
    done
    echo "</tr>"
  fi
}

process_file() {
  local file="$1"
  echo "Processing $file"
  tmp=$(mktemp)

  inside_details=0
  inside_table=0

  while IFS= read -r line; do
    if [[ "$line" =~ \<details\> ]]; then
      inside_details=1
      echo "<details>" >> "$tmp"
      continue
    fi
    if [[ "$line" =~ \</details\> ]]; then
      inside_details=0
      echo "</details>" >> "$tmp"
      continue
    fi
    if [[ "$line" =~ \<summary\> ]]; then
      echo "$line" >> "$tmp"
      continue
    fi

    # Detect table lines
    if [[ "$line" =~ ^[[:space:]]*\|.*\|[[:space:]]*$ ]]; then
      if [[ $inside_table -eq 0 ]]; then
        echo "<table>" >> "$tmp"
        inside_table=1
      fi
      convert_table "$line" >> "$tmp"
      continue
    else
      if [[ $inside_table -eq 1 ]]; then
        echo "</table>" >> "$tmp"
        inside_table=0
      fi
    fi

    # Default: copy line
    echo "$line" >> "$tmp"
  done < "$file"

  # Close any open table
  if [[ $inside_table -eq 1 ]]; then
    echo "</table>" >> "$tmp"
  fi

  mv "$tmp" "$file"
}

export -f process_file convert_table

find "$REPO_DIR" -type f -name "*.md" -print0 | xargs -0 -n1 -I{} bash -c 'process_file "$@"' _ {}
echo "Conversion complete."
