# ~/.config/waybar/workspace_windows.sh
#!/bin/bash
hyprctl clients -j | jq -r '
  group_by(.workspace.id)[] | 
  "Workspace \([.[0].workspace.id]):\n" + 
  (map("- " + .title) | join("\n")) + "\n"
'
