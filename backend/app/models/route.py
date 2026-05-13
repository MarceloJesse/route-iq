from datetime import date

from pydantic import BaseModel, ConfigDict, Field


class AnalyzeRouteRequest(BaseModel):
    origin: str = Field(min_length=2, examples=["Santiago, Chile"])
    destination: str = Field(min_length=2, examples=["Uyuni, Bolivia"])
    stops: list[str] = Field(default_factory=list, examples=[["San Pedro de Atacama"]])
    travel_date: date


class RouteMetadata(BaseModel):
    origin: str
    destination: str
    stops: list[str]
    travel_date: date
    status: str


class Alert(BaseModel):
    title: str
    severity: str
    description: str
    source: str | None = None


class NewsItem(BaseModel):
    title: str
    source: str
    published_at: date | None = None
    url: str | None = None
    summary: str | None = None


class AnalyzeRouteResponse(BaseModel):
    model_config = ConfigDict(json_schema_extra={
        "example": {
            "route": {
                "origin": "Santiago, Chile",
                "destination": "Uyuni, Bolivia",
                "stops": ["San Pedro de Atacama"],
                "travel_date": "2026-01-15",
                "status": "queued",
            },
            "summary": {
                "message": "Route analysis contract accepted. Provider integrations are pending."
            },
            "alerts": [],
            "news": [],
            "report_url": None,
        }
    })

    route: RouteMetadata
    summary: dict[str, str]
    alerts: list[Alert]
    news: list[NewsItem]
    report_url: str | None
