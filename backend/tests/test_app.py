from fastapi.testclient import TestClient

from app.main import create_app


client = TestClient(create_app())


def test_health_returns_ok() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_analyze_route_accepts_initial_contract() -> None:
    response = client.post(
        "/api/routes/analyze",
        json={
            "origin": "Santiago, Chile",
            "destination": "Uyuni, Bolivia",
            "stops": ["San Pedro de Atacama"],
            "travel_date": "2026-01-15",
        },
    )

    assert response.status_code == 202
    payload = response.json()
    assert payload["route"]["origin"] == "Santiago, Chile"
    assert payload["route"]["destination"] == "Uyuni, Bolivia"
    assert payload["route"]["stops"] == ["San Pedro de Atacama"]
    assert payload["route"]["status"] == "queued"
    assert payload["alerts"] == []
    assert payload["news"] == []
    assert payload["report_url"] is None


def test_analyze_route_requires_valid_payload() -> None:
    response = client.post(
        "/api/routes/analyze",
        json={
            "origin": "",
            "destination": "Uyuni, Bolivia",
            "travel_date": "not-a-date",
        },
    )

    assert response.status_code == 422
