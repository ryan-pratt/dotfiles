
function SetColors(color)
	color = color or "kanagawa"

  require('kanagawa').setup({
    -- dimInactive = true,
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none" -- transparent line number gutter
          }
        }
      }
    },
    overrides = function(colors)
      local theme = colors.theme
      return {

        -- Borderless Telescope
        TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

        -- Dark completion menu
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },

      }
    end
  })

	vim.cmd.colorscheme(color)
end

SetColors()
