/**
 * FZF File Picker Extension
 *
 * Replaces the @ file autocomplete with fzf.
 * Press @ to immediately open fzf file picker.
 * - Select a file: inserts @path/to/file
 * - Cancel (Esc): inserts just @ so you can type normally
 *
 * Requirements:
 * - fzf must be installed and in PATH
 * - fd is optional but recommended for better file listing
 */

import { spawnSync } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function commandExists(cmd: string): boolean {
  const result = spawnSync("which", [cmd], { encoding: "utf-8" });
  return result.status === 0;
}

function runFzf(cwd: string): string | null {
  let listCmd: string;
  if (commandExists("fd")) {
    listCmd = "fd --type f --hidden --exclude .git";
  } else {
    listCmd = "find . -type f -not -path '*/.git/*' 2>/dev/null";
  }

  const shell = process.env.SHELL || "/bin/sh";
  const fzfCmd = `${listCmd} | fzf --preview 'head -100 {}' --preview-window=right:50%:wrap`;
  
  const result = spawnSync(shell, ["-c", fzfCmd], {
    stdio: ["inherit", "pipe", "inherit"],
    encoding: "utf-8",
    cwd,
    env: {
      ...process.env,
      FZF_DEFAULT_OPTS: process.env.FZF_DEFAULT_OPTS || "",
    },
  });

  const selected = result.stdout?.trim();
  if (result.status === 0 && selected) {
    return selected.startsWith("./") ? selected.slice(2) : selected;
  }
  return null;
}

export default function (pi: ExtensionAPI) {
  pi.registerShortcut("@", {
    description: "Open fzf file picker for @ file reference",
    handler: async (ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.pasteToEditor("@");
        return;
      }

      if (!commandExists("fzf")) {
        ctx.ui.notify("fzf not found - install with: brew install fzf", "error");
        ctx.ui.pasteToEditor("@");
        return;
      }

      let selectedFile: string | null = null;

      await ctx.ui.custom<void>((tui, _theme, _kb, done) => {
        tui.stop();
        process.stdout.write("\x1b[2J\x1b[H");
        
        selectedFile = runFzf(ctx.cwd);
        
        tui.start();
        tui.requestRender(true);
        done();

        return { render: () => [], invalidate: () => {} };
      });

      // Insert after custom UI closes (add trailing space after filename)
      const insertion = selectedFile ? `@${selectedFile} ` : "@";
      ctx.ui.pasteToEditor(insertion);
      
      // Force render by toggling status
      ctx.ui.setStatus("fzf-refresh", " ");
      ctx.ui.setStatus("fzf-refresh", undefined);
    },
  });

  pi.registerShortcut("ctrl+@", {
    description: "Open fzf file picker (alternative)",
    handler: async (ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("fzf file picker requires TUI mode", "error");
        return;
      }

      if (!commandExists("fzf")) {
        ctx.ui.notify("fzf not found - install with: brew install fzf", "error");
        return;
      }

      let selectedFile: string | null = null;

      await ctx.ui.custom<void>((tui, _theme, _kb, done) => {
        tui.stop();
        process.stdout.write("\x1b[2J\x1b[H");
        
        selectedFile = runFzf(ctx.cwd);
        
        tui.start();
        tui.requestRender(true);
        done();

        return { render: () => [], invalidate: () => {} };
      });

      if (selectedFile) {
        const currentText = ctx.ui.getEditorText();
        const insertion = `@${selectedFile}`;
        
        if (currentText && !currentText.endsWith(" ") && !currentText.endsWith("\n")) {
          ctx.ui.pasteToEditor(` ${insertion} `);
        } else {
          ctx.ui.pasteToEditor(`${insertion} `);
        }
        
        ctx.ui.setStatus("fzf-refresh", " ");
        ctx.ui.setStatus("fzf-refresh", undefined);
      }
    },
  });
}
