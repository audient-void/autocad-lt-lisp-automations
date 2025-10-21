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

### CopyBlockAcrossSheets
Copies a selected block from one sheet to all other sheets in the drawing while maintaining its X,Y position and properties (scale, rotation).

**Usage:**
1. Type `CopyBlockAcrossSheets` at the AutoCAD command prompt
2. Select a block reference when prompted
3. The block will be automatically copied to all other layout sheets (excluding Model space and the current sheet)
4. Each copy maintains the exact X,Y coordinates, scale factors, and rotation angle of the original block
5. The command will report how many copies were created

**Notes:**
- The original block remains on its current sheet
- Model space is always excluded from the copy operation
- The current sheet (where the block is selected) is not duplicated to itself
- Returns to the original sheet after completing all copies

## Installation

1. Download the desired .lsp file(s)
2. In AutoCAD LT, type `APPLOAD` at the command prompt
3. Browse to and select the .lsp file
4. Click Load
5. The command is now available for the current session

To load automatically on startup, add the script to your ACAD.LSP file or use the Startup Suite in APPLOAD.
