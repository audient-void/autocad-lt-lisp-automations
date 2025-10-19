# autocad-lt-lisp-automations
A collection of quick tools to shore up AutoCAD LT limitations.

## Tools

### SeqText
Prefixes selected text objects with sequential numbers while preserving the original text content.

**Usage:**
1. Type `SeqText` at the AutoCAD command prompt
2. Select TEXT or MTEXT objects
3. Enter the starting number when prompted
4. Selected text will be prefixed with bold sequential numbers: `{\\B1\\B} Original Text`, `{\\B2\\B} Original Text`, etc.

### SeqTextReplace
Replaces selected text objects completely with sequential numbers.

**Usage:**
1. Type `SeqTextReplace` at the AutoCAD command prompt
2. Select TEXT or MTEXT objects
3. Enter the starting number when prompted
4. Selected text will be replaced with sequential numbers: `1`, `2`, `3`, etc.

## Installation

1. Download the desired .lsp file(s)
2. In AutoCAD LT, type `APPLOAD` at the command prompt
3. Browse to and select the .lsp file
4. Click Load
5. The command is now available for the current session

To load automatically on startup, add the script to your ACAD.LSP file or use the Startup Suite in APPLOAD.
