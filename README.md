# surf.nvim

*Surf on the web with a single keystroke.*

## Features

- Search anything on any search engine.
- Custom bangs (!), similar to DuckDuckGo's at the beginning of queries.
- Fuzzyfinding through search history.
- Cross-platform compatibility.

And more upcoming features...

## Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "cfung89/surf.nvim",
  config = function()
    require("surf").setup()  -- For default options
  end
}
```

## Configuration

```lua
require("embrace").setup({
  --- default configuration
  keymaps = {
    search = "<leader>o", -- toggle Surf window
  },

  search_history_limit = 500, -- limit length of search history in cached file
  default_engine = "Google",

  -- Engines must be of the form:
  -- engine_name = { bang = "!<shortcut>", url = "<url which includes '%s' for search query>" }
  engines = {
    Google = {
      bang = "!g",
      url = "https://www.google.com/search?q=%s",
    },
    Brave = {
      bang = "!br",
      url = "https://search.brave.com/search?q=%s&source=desktop",
    },
    DuckDuckGo = {
      bang = "!ddg",
      url = "https://duckduckgo.com/?q=%s&ia=web",
    },
    Bing = {
      bang = "!b",
      url = "https://www.bing.com/search?q=%s",
    },
    Youtube = {
      bang = "!yt",
      url = "https://www.youtube.com/results?search_query=%s",
    },
  },

  -- Picker mappings will be passed to the map function given at the
  -- attach_mappings property of Telescope's pickers.
  -- These define the keymaps specific to the Surf UI.
  -- Entries in this table must be of the form:
  -- { "mode", "keymap", function(prompt_bufnr, map, actions, action_state) }
  picker_mappings = {
    -- Examples (not the full default implementation)
    { "i", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
    { "n", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
  },

})
```

## Usage

Type `<leader>o` to open the Surf UI, and search!

You can use bangs at the beginning of your queries to search on a specific search engine.
Example: `!br foo bar` to search "foo bar" on Brave Search.

Navigate through the history with `<C-n>` and `<C-p>`, accept with `<C-y>` when in insert mode.
You can also navigate using normal mode (as in normal Telescope UIs).

## Inspirations

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master)
- [browse.nvim](https://github.com/lalitmee/browse.nvim/tree/main)

- [Microsoft PowerToys](https://github.com/microsoft/PowerToys)
- [Raycast](https://www.raycast.com/)
