-- return {
--   {
--     "xeluxee/competitest.nvim",
--     dependencies = "MunifTanjim/nui.nvim",
--     config = function()
--       require("competitest").setup({
--         local_config_file_name = ".competitest.lua",
--         floating_border = "rounded",
--         floating_border_highlight = "FloatBorder",
--         picker_ui = {
--           width = 0.2,
--           height = 0.3,
--           mappings = {
--             focus_next = { "j", "<down>", "<Tab>" },
--             focus_prev = { "k", "<up>", "<S-Tab>" },
--             close = { "<esc>", "<C-c>", "q", "Q" },
--             submit = { "<cr>" },
--           },
--         },
--         editor_ui = {
--           popup_width = 0.4,
--           popup_height = 0.6,
--           show_nu = true,
--           show_rnu = false,
--           normal_mode_mappings = {
--             switch_window = { "<C-h>", "<C-l>", "<C-i>" },
--             save_and_close = "<C-s>",
--             cancel = { "q", "Q" },
--           },
--           insert_mode_mappings = {
--             switch_window = { "<C-h>", "<C-l>", "<C-i>" },
--             save_and_close = "<C-s>",
--             cancel = "<C-q>",
--           },
--         },
--         runner_ui = {
--           interface = "popup",
--           selector_show_nu = false,
--           selector_show_rnu = false,
--           show_nu = true,
--           show_rnu = false,
--           mappings = {
--             run_again = "R",
--             run_all_again = "<C-r>",
--             kill = "K",
--             kill_all = "<C-k>",
--             view_input = { "i", "I" },
--             view_output = { "a", "A" },
--             view_stdout = { "o", "O" },
--             view_stderr = { "e", "E" },
--             toggle_diff = { "d", "D" },
--             close = { "q", "Q" },
--           },
--           viewer = {
--             width = 0.5,
--             height = 0.5,
--             show_nu = true,
--             show_rnu = false,
--             close_mappings = { "q", "Q" },
--           },
--         },
--         popup_ui = {
--           total_width = 0.8,
--           total_height = 0.8,
--           layout = {
--             { 4, "tc" },
--             { 5, { { 1, "so" }, { 1, "si" } } },
--             { 5, { { 1, "eo" }, { 1, "se" } } },
--           },
--         },
--         split_ui = {
--           position = "right",
--           relative_to_editor = true,
--           total_width = 0.3,
--           vertical_layout = {
--             { 1, "tc" },
--             { 1, { { 1, "so" }, { 1, "eo" } } },
--             { 1, { { 1, "si" }, { 1, "se" } } },
--           },
--           total_height = 0.4,
--           horizontal_layout = {
--             { 2, "tc" },
--             { 3, { { 1, "so" }, { 1, "si" } } },
--             { 3, { { 1, "eo" }, { 1, "se" } } },
--           },
--         },
--
--         save_current_file = true,
--         save_all_files = false,
--         compile_directory = ".",
--         compile_command = {
--           c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "binaries/$(FNOEXT)" } },
--           cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "binaries/$(FNOEXT)" } },
--           rust = { exec = "rustc", args = { "$(FNAME)" } },
--           java = { exec = "javac", args = { "$(FNAME)" } },
--         },
--         running_directory = ".",
--         run_command = {
--           c = { exec = "./binaries/$(FNOEXT)" },
--           cpp = { exec = "./binaries/$(FNOEXT)" },
--           rust = { exec = "./binaries/$(FNOEXT)" },
--           python = { exec = "python", args = { "binaries/$(FNAME)" } },
--           java = { exec = "java", args = { "binaries/$(FNOEXT)" } },
--         },
--         multiple_testing = -1,
--         maximum_time = 5000,
--         output_compare_method = "squish",
--         view_output_diff = false,
--
--         testcases_directory = "./testcases",
--         testcases_use_single_file = false,
--         testcases_auto_detect_storage = true,
--         testcases_single_file_format = "$(FNOEXT).testcases",
--         testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
--         testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",
--
--         companion_port = 27121,
--         receive_print_message = true,
--         template_file = false,
--         evaluate_template_modifiers = false,
--         date_format = "%c",
--         received_files_extension = "cpp",
--         --received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
--         received_problems_path = "./problems/$(PROBLEM).$(FEXT)",
--         received_problems_prompt_path = false,
--         received_contests_directory = "$(CWD)",
--         received_contests_problems_path = "$(PROBLEM).$(FEXT)",
--         received_contests_prompt_directory = true,
--         received_contests_prompt_extension = true,
--         open_received_problems = true,
--         open_received_contests = true,
--         replace_received_testcases = false,
--       })
--     end,
--   },
-- }
return {
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      -- Workspace root for binaries is resolved per-file via the $(WORKSPACE) modifier below.

      -- Resolve the competitive-programming workspace root from the current file so
      -- compiled executables always land in <workspace>/binaries regardless of where
      -- Neovide was launched. Falls back to the file's own directory.
      require("competitest.utils").file_format_modifiers["WORKSPACE"] = function(filepath)
        local dir = vim.fn.fnamemodify(filepath, ":p:h")
        local root = dir
        while root ~= "/" and root ~= "" do
          if vim.fn.isdirectory(root .. "/Practices") == 1 then
            return root
          end
          local parent = vim.fn.fnamemodify(root, ":h")
          if parent == root then
            break
          end
          root = parent
        end
        return dir
      end

      require("competitest").setup({
        local_config_file_name = ".competitest.lua",
        floating_border = "rounded",
        floating_border_highlight = "FloatBorder",
        picker_ui = {
          width = 0.2,
          height = 0.3,
          mappings = {
            focus_next = { "j", "<down>", "<Tab>" },
            focus_prev = { "k", "<up>", "<S-Tab>" },
            close = { "<esc>", "<C-c>", "q", "Q" },
            submit = { "<cr>" },
          },
        },
        editor_ui = {
          popup_width = 0.4,
          popup_height = 0.6,
          show_nu = true,
          show_rnu = false,
          normal_mode_mappings = {
            switch_window = { "<C-h>", "<C-l>", "<C-i>" },
            save_and_close = "<C-s>",
            cancel = { "q", "Q" },
          },
          insert_mode_mappings = {
            switch_window = { "<C-h>", "<C-l>", "<C-i>" },
            save_and_close = "<C-s>",
            cancel = "<C-q>",
          },
        },
        runner_ui = {
          interface = "popup",
          selector_show_nu = false,
          selector_show_rnu = false,
          show_nu = true,
          show_rnu = false,
          mappings = {
            run_again = "R",
            run_all_again = "<C-r>",
            kill = "K",
            kill_all = "<C-k>",
            view_input = { "i", "I" },
            view_output = { "a", "A" },
            view_stdout = { "o", "O" },
            view_stderr = { "e", "E" },
            toggle_diff = { "d", "D" },
            close = { "q", "Q" },
          },
          viewer = {
            width = 0.5,
            height = 0.5,
            show_nu = true,
            show_rnu = false,
            -- close_mappings = { "q", "Q" },
          },
        },
        popup_ui = {
          total_width = 0.8,
          total_height = 0.8,
          layout = {
            { 4, "tc" },
            { 5, { { 1, "so" }, { 1, "si" } } },
            { 5, { { 1, "eo" }, { 1, "se" } } },
          },
        },
        split_ui = {
          position = "right",
          relative_to_editor = true,
          total_width = 0.3,
          vertical_layout = {
            { 1, "tc" },
            { 1, { { 1, "so" }, { 1, "eo" } } },
            { 1, { { 1, "si" }, { 1, "se" } } },
          },
          total_height = 0.4,
          horizontal_layout = {
            { 2, "tc" },
            { 3, { { 1, "so" }, { 1, "si" } } },
            { 3, { { 1, "eo" }, { 1, "se" } } },
          },
        },

        save_current_file = true,
        save_all_files = false,
        compile_directory = ".",
        compile_command = {
          c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(WORKSPACE)/binaries/$(FNOEXT)" } },
          -- Wrapped in `sh -c` so we can `mkdir -p` the binaries dir first.
          -- competitest spawns via luv.spawn(argv) — no shell — so without this
          -- the linker fails with "cannot open output file ... No such file or
          -- directory" the first time a workspace's binaries/ folder is missing.
          cpp = {
            exec = "sh",
            args = {
              "-c",
              "mkdir -p '$(WORKSPACE)/binaries' && clang++ -Wall -std=c++17 -g '$(FABSPATH)' -o '$(WORKSPACE)/binaries/$(FNOEXT)'",
            },
          },
          rust = { exec = "rustc", args = { "$(FNAME)" } },
          java = { exec = "javac", args = { "$(FNAME)" } },
        },
        running_directory = ".",
        run_command = {
          c = { exec = "$(WORKSPACE)/binaries/$(FNOEXT)" },
          cpp = { exec = "$(WORKSPACE)/binaries/$(FNOEXT)" },
          rust = { exec = "$(WORKSPACE)/binaries/$(FNOEXT)" },
          python = { exec = "python", args = { "$(WORKSPACE)/binaries/$(FNAME)" } },
          java = { exec = "java", args = { "$(WORKSPACE)/binaries/$(FNOEXT)" } },
        },
        multiple_testing = -1,
        maximum_time = 5000,
        output_compare_method = "squish",
        view_output_diff = false,

        testcases_directory = "testcases",
        testcases_use_single_file = false,
        testcases_auto_detect_storage = false,
        testcases_single_file_format = "$(FNOEXT).testcases",
        testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
        testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

        companion_port = 27121,
        receive_print_message = true,
        template_file = false,
        evaluate_template_modifiers = false,
        date_format = "%c",
        received_files_extension = "cpp",
        received_problems_path = "problems/$(PROBLEM).$(FEXT)",
        received_problems_prompt_path = false,
        received_contests_directory = "$(CWD)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        received_contests_prompt_directory = true,
        received_contests_prompt_extension = true,
        open_received_problems = true,
        open_received_contests = true,
        replace_received_testcases = false,
      })

      -- ============================================================
      -- Testcases stored at <workspace>/testcases/<problem>/ with
      -- FUZZY matching, instead of competitive's default rules.
      --
      -- competitive hardcodes the testcase dir as `filedir/testcases_directory`
      -- (i.e. NEXT TO the source file). We want them in the workspace root,
      -- one subfolder per problem, and we want to match whatever files you
      -- drop in there (input1.in, 1.in, sample1, 01.out, ...) — not just the
      -- exact names competitive generates.
      --
      -- Both path-aware functions below receive `filepath`, so we recompute the
      -- per-problem dir from it and ignore the (wrong) directory arg. This
      -- covers every call site: buf_get_testcases, buf_write_testcases, the
      -- companion receive path, add/edit/delete testcase, etc.
      -- ============================================================
      local tmods = require("competitest.testcases")
      local u = require("competitest.utils")
      local luv = vim.uv and vim.uv or vim.loop

      local function tc_workspace_root(filepath)
        local dir = vim.fn.fnamemodify(filepath, ":p:h")
        local root = dir
        while root ~= "/" and root ~= "" do
          if vim.fn.isdirectory(root .. "/Practices") == 1 then
            return root
          end
          local parent = vim.fn.fnamemodify(root, ":h")
          if parent == root then break end
          root = parent
        end
        return dir
      end

      -- <workspace>/testcases/<problem-stem>/ (stem = FNOEXT, e.g. "P1019 [NOIP 2000]")
      local function tc_dir(filepath)
        local stem = vim.fn.fnamemodify(filepath, ":t:r")
        return tc_workspace_root(filepath) .. "/testcases/" .. stem .. "/"
      end

      -- Heuristic: is this file an expected OUTPUT (answer) or an INPUT?
      local function is_output_file(name)
        local stem, ext = name:match("^(.-)%.([^.]+)$")
        if not stem then
          stem, ext = name, ""
        end
        ext = ext:lower()
        -- unambiguous extensions decide first
        if ext == "in" or ext == "inp" or ext == "input" then return false end
        if ext == "out" or ext == "ans" or ext == "expected" or ext == "output" then return true end
        -- ambiguous (.txt / no ext): inspect the stem
        local s = stem:lower()
        if s:match("out") or s:match("ans") or s:match("expect") or s:match("answer") then
          return true
        end
        -- samples / tests / inputs -> input; anything ambiguous defaults to input
        return false
      end

      -- Testcase number = the first integer found in the filename (input1 -> 1, 01 -> 1)
      local function tc_num(name)
        local stem = name:match("^(.-)%.([^.]+)$")
        if not stem then stem = name end
        return tonumber(stem:match("%d+"))
      end

      -- Scan `directory` and load any input/output files into a testcases table.
      -- Numbered files key by their number; unnumbered files get the next free index.
      local function fuzzy_load(directory)
        local tctbl = {}
        local unnumbered = {}
        local bits = luv.fs_opendir(directory)
        if bits == nil then return tctbl end
        while true do
          local entry = luv.fs_readdir(bits)
          if entry == nil then break end
          if entry[1].type == "file" then
            local name = entry[1].name
            local num = tc_num(name)
            local is_out = is_output_file(name)
            local content = u.load_file_as_string(directory .. name)
            if num then
              tctbl[num] = tctbl[num] or {}
              if is_out then
                if not tctbl[num].output then tctbl[num].output = content end
              else
                if not tctbl[num].input then tctbl[num].input = content end
              end
            else
              table.insert(unnumbered, { name = name, is_out = is_out })
            end
          end
        end
        luv.fs_closedir(bits)
        local idx = 1
        for _, f in ipairs(unnumbered) do
          while tctbl[idx] do idx = idx + 1 end
          tctbl[idx] = tctbl[idx] or {}
          local content = u.load_file_as_string(directory .. f.name)
          if f.is_out then
            tctbl[idx].output = content
          else
            tctbl[idx].input = content
          end
          idx = idx + 1
        end
        return tctbl
      end

      -- Load: ignore the default (wrong) dir; read from the per-problem dir.
      tmods.io_files.load_eval_format_string = function(_, filepath, input_format, output_format)
        return fuzzy_load(tc_dir(filepath))
      end

      -- Write: ignore the default (wrong) dir; write <n>.in / <n>.out in the per-problem dir.
      tmods.io_files.write_eval_format_string = function(_, tctbl, filepath, input_format, output_format)
        local directory = tc_dir(filepath)
        u.create_directory(directory)
        for tcnum, tc in pairs(tctbl) do
          local inpath = directory .. tcnum .. ".in"
          local outpath = directory .. tcnum .. ".out"
          if tc.input and tc.input ~= "" then
            u.write_string_on_file(inpath, tc.input)
          elseif u.does_file_exist(inpath) then
            u.delete_file(inpath)
          end
          if tc.output and tc.output ~= "" then
            u.write_string_on_file(outpath, tc.output)
          elseif u.does_file_exist(outpath) then
            u.delete_file(outpath)
          end
        end
      end
    end,
  },
}
