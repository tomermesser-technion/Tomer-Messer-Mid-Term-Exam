# Status Dashboard

A Flask-based internal status service, containerized with Docker and served via nginx.

## Installation

```bash
sudo API_KEY=<your-secret-key> ./install.sh
```

The script builds the Docker image, starts the container, configures nginx, and prints the service URL.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `API_KEY` | required | Secret key for the `/api/v1/secret` route |
| `VERSION` | `1.0.0` | App version returned in the status response |
| `PORT` | `5000` | Port the Flask app listens on |

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | HTML status page |
| GET | `/api/status` | Returns `{"status", "hostname", "version"}` |
| GET | `/api/secret` | Requires `X-API-Key` header, returns `401` if missing or wrong |

## Verify

```bash
curl -sL http://localhost/api/status | jq .
curl -s -o /dev/null -w "%{http_code}\n" http://localhost/api/secret
curl -sL -H "X-API-Key: <your-secret-key>" http://localhost/api/secret | jq .
```

