// Path Restrictions Extension for Pi
// Restricts file access and cd commands to specific directories

import * as path from "node:path";
import * as fs from "node:fs";
import os from "node:os";

interface PathConfig {
  allowedDirs: string[];
  requirePermissionOutside: boolean;
}

const CONFIG_PATH = path.join(os.homedir(), ".pi", "agent", "path-restrictions.json");

function loadConfig(): PathConfig {
  const defaults: PathConfig = {
    allowedDirs: [process.cwd(), path.join(os.homedir(), "repos")],
    requirePermissionOutside: true,
  };

  try {
    if (fs.existsSync(CONFIG_PATH)) {
      const raw = fs.readFileSync(CONFIG_PATH, "utf-8");
      const config = JSON.parse(raw);
      return { ...defaults, ...config };
    }
  } catch {
    // Use defaults on error
  }
  return defaults;
}

function resolveAllowedDirs(dirs: string[]): string[] {
  return dirs.map((dir) => {
    // Expand ~ to home directory
    if (dir.startsWith("~")) {
      dir = path.join(os.homedir(), dir.slice(1));
    }
    // Resolve . to cwd
    if (dir === ".") {
      dir = process.cwd();
    }
    return path.resolve(dir);
  });
}

function isPathAllowed(filePath: string, allowedDirs: string[]): boolean {
  let resolved: string;
  try {
    // Expand ~ to home directory first
    if (filePath.startsWith("~")) {
      filePath = path.join(os.homedir(), filePath.slice(1));
    }
    resolved = path.resolve(filePath);
    // Try to resolve symlinks
    try {
      resolved = fs.realpathSync(resolved);
    } catch {
      // File may not exist yet, use resolved path
    }
  } catch {
    return false;
  }

  for (const dir of allowedDirs) {
    if (resolved === dir || resolved.startsWith(dir + path.sep)) {
      return true;
    }
  }
  return false;
}

function extractCdPath(command: string): string | null {
  // Match cd commands: cd path, cd "path", cd 'path'
  const cdMatch = command.match(/\bcd\s+(?:["']([^"']+)["']|(\S+))/);
  if (cdMatch) {
    return cdMatch[1] || cdMatch[2];
  }
  return null;
}

function extractFilePaths(input: Record<string, unknown>): string[] {
  const paths: string[] = [];
  const pathKeys = ["path", "file_path", "filePath", "inputPath", "output_path", "cwd"];
  
  for (const key of pathKeys) {
    const value = input[key];
    if (typeof value === "string" && value.length > 0) {
      paths.push(value);
    }
  }
  return paths;
}

export default function pathRestrictions(pi: any) {
  const config = loadConfig();
  const allowedDirs = resolveAllowedDirs(config.allowedDirs);

  // Log loaded config
  console.error(`[path-restrictions] Loaded config: allowedDirs=${JSON.stringify(allowedDirs)}`);

  pi.on("tool_call", (event: any) => {
    const toolName = event.toolName;
    const input = event.input ?? {};

    // Check bash/shell commands for cd
    if (toolName === "bash" || toolName === "shell" || toolName === "run_command") {
      const command = input.command ?? input.cmd ?? "";
      const cdPath = extractCdPath(command);
      
      if (cdPath) {
        // Resolve cd path relative to current working directory
        const resolvedCdPath = path.resolve(process.cwd(), cdPath);
        
        if (!isPathAllowed(resolvedCdPath, allowedDirs)) {
          return {
            block: true,
            reason: `[PATH RESTRICTION] cd to '${cdPath}' is outside allowed directories. Allowed: ${config.allowedDirs.join(", ")}`,
            requiresPermission: config.requirePermissionOutside,
          };
        }
      }
    }

    // Check file operations
    if (["read", "read_file", "write", "write_file", "edit", "edit_file", "list_directory", "list_dir"].includes(toolName)) {
      const filePaths = extractFilePaths(input);
      
      for (const filePath of filePaths) {
        if (!isPathAllowed(filePath, allowedDirs)) {
          return {
            block: true,
            reason: `[PATH RESTRICTION] Access to '${filePath}' is outside allowed directories. Allowed: ${config.allowedDirs.join(", ")}`,
            requiresPermission: config.requirePermissionOutside,
          };
        }
      }
    }

    // Check herdr_layout for cwd
    if (toolName === "herdr_layout" || toolName === "herdr_pane") {
      const cwd = input.cwd;
      if (typeof cwd === "string" && cwd.length > 0) {
        if (!isPathAllowed(cwd, allowedDirs)) {
          return {
            block: true,
            reason: `[PATH RESTRICTION] Working directory '${cwd}' is outside allowed directories. Allowed: ${config.allowedDirs.join(", ")}`,
            requiresPermission: config.requirePermissionOutside,
          };
        }
      }
    }

    return undefined; // Allow the operation
  });

  // Register command to view/update path restrictions
  pi.registerCommand("path-restrictions", {
    description: "View or update path restriction settings",
    handler: async (args: string, ctx: any) => {
      const parts = args.trim().split(/\s+/);
      const sub = parts[0]?.toLowerCase() || "";

      if (sub === "add" && parts[1]) {
        const newPath = parts.slice(1).join(" ");
        const currentConfig = loadConfig();
        if (!currentConfig.allowedDirs.includes(newPath)) {
          currentConfig.allowedDirs.push(newPath);
          fs.writeFileSync(CONFIG_PATH, JSON.stringify(currentConfig, null, 2) + "\n");
          ctx.ui.notify(`Added '${newPath}' to allowed directories. Restart Pi to apply.`, "success");
        } else {
          ctx.ui.notify(`'${newPath}' is already in allowed directories.`, "info");
        }
        return;
      }

      if (sub === "remove" && parts[1]) {
        const removePath = parts.slice(1).join(" ");
        const currentConfig = loadConfig();
        const index = currentConfig.allowedDirs.indexOf(removePath);
        if (index > -1) {
          currentConfig.allowedDirs.splice(index, 1);
          fs.writeFileSync(CONFIG_PATH, JSON.stringify(currentConfig, null, 2) + "\n");
          ctx.ui.notify(`Removed '${removePath}' from allowed directories. Restart Pi to apply.`, "success");
        } else {
          ctx.ui.notify(`'${removePath}' is not in allowed directories.`, "info");
        }
        return;
      }

      // Show current config
      const lines = [
        "── PATH RESTRICTIONS ──────────────────────────────────────",
        `  Config file: ${CONFIG_PATH}`,
        "",
        "  Allowed directories:",
        ...config.allowedDirs.map((d) => `    • ${d}`),
        "",
        "  Resolved paths:",
        ...allowedDirs.map((d) => `    • ${d}`),
        "",
        `  Require permission outside: ${config.requirePermissionOutside}`,
        "",
        "  Commands:",
        "    /path-restrictions add <path>    - Add allowed directory",
        "    /path-restrictions remove <path> - Remove allowed directory",
        "───────────────────────────────────────────────────────────",
      ];

      pi.sendMessage({
        customType: "path-restrictions-info",
        content: lines.join("\n"),
        display: { type: "content", content: lines.join("\n") },
      });
    },
  });
}
