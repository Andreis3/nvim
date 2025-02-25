return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = {
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch JS file",
              program = "${file}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal"
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch NestJS with npm run start:debug",
              cwd = "${workspaceFolder}",
              runtimeExecutable = "npm",
              runtimeArgs = {
                "run",
                "start:debug"
              },
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = {
                "<node_internals>/**",
                "node_modules/**"
              },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
              }
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch TypeScript File with ts-node",
              cwd = "${workspaceFolder}",
              runtimeExecutable = "npx",
              runtimeArgs = {
                "ts-node",
                "--esm"
              },
              args = {
                "${file}"
              },
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = {
                "<node_internals>/**",
                "node_modules/**"
              },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
              }
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  }
}
