# RouteIQ backend

FastAPI application packaged for AWS Lambda through Mangum.

## Local checks

```bash
cd backend
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
PYTHONPATH=. pytest
uvicorn app.main:app --reload
```
