# sdtree v1.2.0 – Minimal directory tree viewer using shell and find
# MIT License – © Soroush Ataee <ataeesoroush.dev@gmail.com>

sdtree() {
  local dir="."
  local depth=3
  local show_hidden=false
  local positional_dir=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--version)
      echo "sdtree version 1.2.0"
      return 0
      ;;
    -h|--help)
      echo "Usage: sdtree [DIR] [OPTIONS]"
      echo ""
      echo "  DIR             Optional positional directory to scan (default: .)"
      echo "  -d, --dir DIR   Directory to scan (same as positional DIR)"
      echo "      --dir=DIR   Directory to scan"
      echo "  -l, --level N   Depth to display (default: 3)"
      echo "      --level=N   Depth to display"
      echo "  -a, --all       Show hidden files"
      echo "      --no-all    Hide hidden files (default)"
      echo "  -v, --version   Show version number"
      echo "  -h, --help      Show this help message"
      return 0
      ;;
    --dir=*)
      dir="${1#*=}"
      shift
      ;;
    --level=*)
      depth="${1#*=}"
      shift
      ;;
    -d|--dir)
      if [[ -z "$2" || "$2" == -* ]]; then
        echo "Error: --dir requires a directory argument."
        return 1
      fi
      dir="$2"
      shift 2
      ;;
    -l|--level)
      if [[ -z "$2" || "$2" == -* ]]; then
        echo "Error: --level requires a numeric value."
        return 1
      fi
      depth="$2"
      shift 2
      ;;
    -a|--all)
      show_hidden=true
      shift
      ;;
    --no-all)
      show_hidden=false
      shift
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        if [[ -n "$positional_dir" ]]; then
          echo "Error: only one positional directory is allowed."
          return 1
        fi
        positional_dir="$1"
        shift
      done
      ;;
    -*)
      echo "Unknown option: $1"
      echo "Run 'sdtree --help' for usage."
      return 1
      ;;
    *)
      if [[ -n "$positional_dir" ]]; then
        echo "Error: only one positional directory is allowed."
        return 1
      fi
      positional_dir="$1"
      shift
      ;;
  esac
done

  if [[ -n "$positional_dir" ]]; then
    dir="$positional_dir"
  fi

  if [[ "$dir" != "." && ! -d "$dir" ]]; then
    echo "Error: '$dir' is not a directory."
    return 1
  fi

  if [[ ! "$depth" =~ ^[0-9]+$ ]]; then
    echo "Error: --level must be a non-negative integer."
    return 1
  fi

  _sdtree_print_line() {
    local entry_path="$1"
    local entry_depth="$2"
    local branch_prefix="$3"
    local base_name="${entry_path##*/}"

    if [[ "$entry_depth" -eq 0 ]]; then
      if [[ "$entry_path" == "." ]]; then
        echo "."
      else
        echo "${base_name}"
      fi
      return 0
    fi

    echo "${branch_prefix}|____${base_name}"
  }

  _sdtree_walk() {
    local current_path="$1"
    local current_depth="$2"
    local branch_prefix="$3"
    local has_next_sibling="$4"
    local child_path=""
    local previous_child=""
    local child_prefix=""

    _sdtree_print_line "$current_path" "$current_depth" "$branch_prefix"

    if (( current_depth >= depth )); then
      return 0
    fi

    child_prefix="$branch_prefix"
    if (( current_depth == 0 )); then
      child_prefix="$branch_prefix"
    elif [[ "$has_next_sibling" == true ]]; then
      child_prefix="${child_prefix}|    "
    else
      child_prefix="${child_prefix}     "
    fi

    while IFS= read -r child_path; do
      if [[ -n "$previous_child" ]]; then
        _sdtree_walk "$previous_child" "$((current_depth + 1))" "$child_prefix" true
      fi
      previous_child="$child_path"
    done < <(
      if [[ "$show_hidden" == true ]]; then
        find "$current_path" -mindepth 1 -maxdepth 1 -print 2>/dev/null
      else
        find "$current_path" -mindepth 1 -maxdepth 1 \( -path '*/.*' -prune \) -o -print 2>/dev/null
      fi \
      | while IFS= read -r entry; do
          entry_type=1
          if [[ -d "$entry" && ! -L "$entry" ]]; then
            entry_type=0
          fi
          entry_name="${entry##*/}"
          [[ -z "$entry_name" ]] && entry_name="$entry"
          printf '%s\t%s\t%s\n' "$entry_type" "$entry_name" "$entry"
        done \
      | sort -t $'\t' -k1,1n -k2,2f -k3,3f \
      | cut -f3-
    )

    if [[ -n "$previous_child" ]]; then
      _sdtree_walk "$previous_child" "$((current_depth + 1))" "$child_prefix" false
    fi
  }

  _sdtree_walk "$dir" 0 "" false
}
