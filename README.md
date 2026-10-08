# COBOL Employee Record Management

A command-line COBOL program for entering employee records, storing them in a line-sequential file, and reporting employees with fewer than five years of service. Based on a coursework project, with file handling, input validation, and reporting corrections.

## Features
- Employee ID, department code, first and last name, age, and service years
- Validates numeric input, allowed ranges, nonempty names, and 20-character name limits
- Appends records instead of overwriting an existing file
- Reports employees with fewer than five years of service
- Checks file status for open, read, and write operations

## Requirements
Install **GnuCOBOL** (`cobc`). The source uses free-format COBOL.

## Compile and run
Run commands in the repository root:

```bash
cobc -x -free -o employee-manager src/employee-data-management.cob
./employee-manager
```

On Windows, use `-o employee-manager.exe` and run `employee-manager.exe` instead. Run the executable from the directory where you want `EMPLOYEERECORD.DAT` stored. The file is created when the first employee is entered.

### Try sample records
Copy `sample-data/EMPLOYEERECORD.DAT` into the working directory before running the program. Choose `N` at the first prompt to display the report. This sample contains fictional records only. **Do not overwrite your own data file with the sample.**

## Data layout
Each line stores fixed-width text fields: employee ID (6), department (3), last name (20), first name (20), age (3), years of service (2). Short numeric IDs are zero-padded. File contents are plaintext and should not be used for real employee personal data.

## Documentation
The `docs/` folder contains the original coursework flowchart and program hierarchy. They represent the original write/read/report workflow; the revised source adds validation and appending.

## Notes
- Replaces the original reporting-flag logic with a report that runs after entry (including when no new records are entered).
- The original sample employee data was excluded to avoid exposing personal information. Fictional records are provided.
- GnuCOBOL compilation and execution have **not been verified** in this environment. Test locally before publicizing as fully working.
- Confirm that public sharing complies with your institution's coursework policy.
