# sdtree - Simple directory tree viewer using find/sed
# Version: 1.0.1
# Author: Soroush Ataee <ataeesoroush@gmail.com>
# License: MIT

sdtree() {
  local dir="."
  local depth="3"
  local show_hidden="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
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
      if [[ -z "$2" || "$2" == -* ]]; then
        echo "Error: --all requires 'true' or 'false'."
        return 1
      fi
      show_hidden="$2"
      shift 2
      ;;
    -v|--version)
      echo "sdtree version 1.0.1"
      return 0
      ;;
    -h|--help)
      echo "Usage: sdtree [-d DIR] [-l LEVEL] [-a true|false]"
      echo ""
      echo "  -d, --dir       Directory to scan (default: .)"
      echo "  -l, --level     Depth to display (default: 3)"
      echo "  -a, --all       Show hidden files (true/false, default: false)"
      echo "  -v, --version   Show version number"
      echo "  -h, --help      Show this help message"
      return 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run 'sdtree --help' for usage."
      return 1
      ;;
  esac
done

  if [[ "$show_hidden" == "false" ]]; then
    find "$dir" -maxdepth "$depth" \( -path '*/.*' -prune \) -o -print 2>/dev/null \
      | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
  else
    find "$dir" -maxdepth "$depth" -print 2>/dev/null \
      | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
  fi
}