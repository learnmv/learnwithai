---
name: test-api
description: Run FastAPI backend tests with pytest
---

# Test API

Runs pytest on the FastAPI backend and displays results.

## Usage

```
/test-api [path]
```

## Steps

1. Change to backend directory: `cd /home/sysadmin/learnwithai/backend`
2. Install dependencies if needed: `pip install -r requirements.txt`
3. Run tests: `pytest -v`

## Examples

```
/test-api                  # Run all tests
/test-api app/tests        # Run specific test directory
```

## Notes

- Requires Python and pytest installed
- Tests should be in `backend/app/tests/` or `backend/tests/`
