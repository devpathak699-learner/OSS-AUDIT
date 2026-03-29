# Open Source Audit Project — Git

## Student Details

**Name:** Dev Pathak
**Registration Number:** 24BCE10361

---

## Project Overview

This project is part of the Open Source Software course. The goal is to study an open-source tool (**Git**) and understand both its technical and philosophical aspects.

Five enhanced Bash shell scripts demonstrate practical Linux skills: system inspection, cross-distro package management, disk auditing, log analysis, and automation — all with color-coded terminal output and robust error handling.

---

## Chosen Software

**Git — Distributed Version Control System**

Git tracks changes in source code and enables large-scale developer collaboration without relying on a central server. It is one of the most widely adopted open-source tools in the world, licensed under **GPL v2**.

---

## System Requirements

| Requirement | Details |
|---|---|
| OS | Linux (Ubuntu / Fedora / CentOS) |
| Shell | Bash 4.0+ |
| Git | Any version (auto-installed if missing) |
| Permissions | `sudo` access for log files and package install |

---

## Environment Setup

### Step 1 — Update System Packages

```bash
sudo apt update
```

### Step 2 — Install Git (auto-handled by `run_all.sh`)

```bash
sudo apt install git -y
git --version
```

### Step 3 — Clone the Repository

```bash
git clone https://github.com/your-username/oss-audit-24BAI10489.git
cd oss-audit-24BAI10489
```

### Step 4 — Grant Execute Permissions

```bash
chmod +x *.sh
```

---

## Running the Project

### Option A — Run Everything at Once (Recommended)

```bash
chmod +x run_all.sh
./run_all.sh
```

This will:
- ✔ Check and auto-install Git if required (supports `apt` and `dnf`)
- ✔ Grant execute permissions to all scripts
- ✔ Run all five scripts sequentially with per-script timing
- ✔ Save a full audit log to `reports/audit_<timestamp>.log`
- ✔ Print a summary with pass/fail status

### Option B — Run Scripts Individually

```bash
./script1_system_identity.sh
./script2_package_inspector.sh
./script3_disk_auditor.sh
./script4_log_analyzer.sh /var/log/syslog [keyword]
./script5_manifesto.sh
```

---

## Script Details

### 1. System Identity Report (`script1_system_identity.sh`)

Displays a complete system profile including kernel, architecture, CPU model, RAM, uptime, and Git configuration.

**Enhancements:**
- Added CPU model, RAM total, and architecture info
- Fixed `cat /etc/os-release | grep` → `grep /etc/os-release` (UUOC fix)
- ANSI color output with formatted table

```bash
./script1_system_identity.sh
```

---

### 2. FOSS Package Inspector (`script2_package_inspector.sh`)

Inspects any installed package — defaults to `git`. Supports Debian/Ubuntu (`apt`) and Fedora/CentOS (`dnf`/`rpm`) automatically.

**Enhancements:**
- Package name is now a CLI argument (default: `git`)
- Auto-detects package manager: `apt`, `dnf`, or `rpm`
- Shows live Git config and last 5 repo commits (if inside a git repo)

```bash
./script2_package_inspector.sh          # inspect git
./script2_package_inspector.sh firefox  # inspect any package
```

---

### 3. Disk and Permission Auditor (`script3_disk_auditor.sh`)

Audits key system directories for size, ownership, and permissions. Scans home directory for git repositories.

**Enhancements:**
- Fixed unquoted `$DIR` variable (was causing word-splitting bugs)
- Added aligned `printf` table output
- World-writable directory security check
- Git repository scanner (finds all `.git` repos under `$HOME`)

```bash
./script3_disk_auditor.sh
```

---

### 4. Log File Analyzer (`script4_log_analyzer.sh`) ⚡ Performance Fix

Efficiently counts and analyzes keyword occurrences in log files.

**Enhancements:**
- **Critical fix**: replaced slow Bash `while read` loop with `grep -c` — up to 10x faster on large logs
- Added usage message and file permission check
- Severity breakdown (error / warning / critical / info / debug counts)
- Shows first 5 and last 5 matching lines

```bash
./script4_log_analyzer.sh /var/log/syslog          # searches 'error'
./script4_log_analyzer.sh /var/log/syslog warning  # searches 'warning'
```

---

### 5. Open Source Manifesto Generator (`script5_manifesto.sh`)

Generates a personalized open-source manifesto as a `.txt` file.

**Enhancements:**
- Input validation — re-prompts if any field is left empty
- Overwrite guard — warns if a manifesto already exists
- Formatted, signed manifesto saved to `manifesto_<username>.txt`

```bash
./script5_manifesto.sh
```

---

## Output

### Terminal Output
All scripts produce color-coded, aligned terminal output with:
- 🟢 Green — success / installed
- 🟡 Yellow — warnings / not configured
- 🔴 Red — errors / not found

### Report Files
`run_all.sh` saves timestamped logs to:
```
reports/audit_YYYY-MM-DD_HH-MM-SS.log
```

---

## Dependencies

All dependencies are pre-installed on most Linux systems:

| Tool | Used In |
|---|---|
| `bash` 4.0+ | All scripts |
| `grep`, `awk`, `sed` | All scripts |
| `du`, `ls`, `stat` | Script 3 |
| `find` | Script 3 |
| `wc` | Script 4 |
| `git` | Scripts 1, 2, 3 (auto-installed) |
| `/proc/cpuinfo`, `/proc/meminfo` | Script 1 |

---

## Notes

- All scripts tested on **Ubuntu Linux** (Bash 5.x)
- No external libraries required
- Scripts use `set -euo pipefail` in `run_all.sh` for safe execution
- Script 4 uses `sudo` if reading protected log files

---

## Conclusion

This project demonstrates practical Linux scripting skills and a philosophical understanding of open-source software. The enhanced scripts reflect real-world Bash best practices: proper quoting, efficient tool usage, cross-distro compatibility, color-coded UX, and safe error handling.

---

*"Open source is not just code — it is a philosophy of trust, community, and freedom."*
