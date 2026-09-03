return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        fuzzy_finder_mappings = {
          -- Default Enter submits straight to the node under the cursor, but the
          -- cursor doesn't move to the first match until the debounced filter
          -- refresh fires (~400ms) — so a quick Enter opens a stale node.
          -- Here: if the cursor sits on a node the filter has hidden, jump to
          -- the first visible file (or directory); then open what's under it.
          ["<CR>"] = function(state)
            local renderer = require("neo-tree.ui.renderer")

            local visible = renderer.get_all_visible_nodes(state.tree)
            local visible_ids = {}
            for _, n in ipairs(visible) do
              visible_ids[n:get_id()] = true
            end

            local ok, node = pcall(state.tree.get_node, state.tree)
            if not ok or not node or not visible_ids[node:get_id()] then
              node = nil
              local dir_fallback
              for _, n in ipairs(visible) do
                if n.type == "file" then
                  renderer.focus_node(state, n:get_id(), true)
                  node = n
                  break
                elseif n.type == "directory" and not dir_fallback then
                  dir_fallback = n
                end
              end
              if not node and dir_fallback then
                renderer.focus_node(state, dir_fallback:get_id(), true)
                node = dir_fallback
              end
            end

            if not node then
              return -- no visible files (e.g. "no results" message node)
            end

            local path = node:get_id()
            if node.type == "directory" then
              path = path:gsub("/$", "")
              require("neo-tree.sources.filesystem").navigate(state, nil, path, function()
                pcall(renderer.focus_node, state, path, false)
              end)
            else
              require("neo-tree.utils").open_file(state, path)
            end
          end,
        },
      },
    },
  },
}
