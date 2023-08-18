{ config, pkgs, ... }:

let
  # Correctly handle markdown hyperlinks
  # https://github.com/wez/wezterm/issues/3803#issuecomment-1608954312
  hyperlink_rules = ''
    {
      -- Matches: a URL in parens: (URL)
      {
        regex = '\\((\\w+://\\S+)\\)',
        format = '$1',
        highlight = 1,
      },
      -- Matches: a URL in brackets: [URL]
      {
        regex = '\\[(\\w+://\\S+)\\]',
        format = '$1',
        highlight = 1,
      },
      -- Matches: a URL in curly braces: {URL}
      {
        regex = '\\{(\\w+://\\S+)\\}',
        format = '$1',
        highlight = 1,
      },
      -- Matches: a URL in angle brackets: <URL>
      {
        regex = '<(\\w+://\\S+)>',
        format = '$1',
        highlight = 1,
      },
      -- Then handle URLs not wrapped in brackets
      {
        -- Before
        --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
        --format = '$0',
        -- After
        regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
        format = '$1',
        highlight = 1,
      },
      -- implicit mailto link
      {
        regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
        format = 'mailto:$0',
      },
    }
  '';
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local act = wezterm.action

      return {
        disable_default_key_bindings = true,
        keys = {
          -- TODO move tab with mouse :)
          { key = 'q', mods = 'ALT|SHIFT', action = act.CloseCurrentPane { confirm = false } },
          { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
          { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
          { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
          { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection' },
          { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
          { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
          { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
          { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
          { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
          { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
          { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
          { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
          { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
          { key = 'LeftArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
          { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
          { key = '_', mods = 'SHIFT|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
          { key = '|', mods = 'SHIFT|ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
          { key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Left' },
          { key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Down' },
          { key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Up' },
          { key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Right' },
          { key = 'f', mods = 'SHIFT|ALT', action = act.TogglePaneZoomState },
          -- { key = 'l', mods = 'SHIFT|ALT', action = wezterm.action.ShowDebugOverlay }, -- Conflicts with `ActivatePaneDirection 'Right'`
        },
        -- color_scheme = "Sonokai (Gogh)",
        -- color_scheme = "Aura (Gogh)",
        color_scheme = "github_dark_dimmed",
        default_prog = { '${pkgs.fish}/bin/fish', '-l' },
        cursor_blink_rate = 0,
        default_cursor_style = 'BlinkingBlock',
        hide_mouse_cursor_when_typing = false,
        force_reverse_video_cursor = true,
        inactive_pane_hsb = { brightness = 0.7 },
        -- window_background_image = '${config.home.sessionVariables.WALLPAPERS_DIR}/1.png',
        -- window_background_image_hsb = { brightness = 0.07 },
        -- warn_about_missing_glyphs = false,
        hyperlink_rules = ${hyperlink_rules},
      }
    '';

    colorSchemes.github_dark_dimmed = {
      # https://github.com/projekt0n/github-theme-contrib/blob/main/themes/wezterm/github_dark_dimmed.toml
      background = "#22272e";
      foreground = "#adbac7";

      cursor_bg = "#adbac7";
      cursor_border = "#adbac7";
      cursor_fg = "#22272e";

      selection_bg = "#2e4c77";
      selection_fg = "#adbac7";

      ansi = [
        "#545d68"
        "#f47067"
        "#57ab5a"
        "#c69026"
        "#539bf5"
        "#b083f0"
        "#39c5cf"
        "#909dab"
      ];
      brights = [
        "#636e7b"
        "#ff938a"
        "#6bc46d"
        "#daaa3f"
        "#6cb6ff"
        "#dcbdfb"
        "#56d4dd"
        "#cdd9e5"
      ];
    };
  };
}
