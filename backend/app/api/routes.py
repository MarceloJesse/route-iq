from fastapi import APIRouter, status

from app.models.route import AnalyzeRouteRequest, AnalyzeRouteResponse, RouteMetadata

router = APIRouter(prefix="/api/routes", tags=["routes"])


@router.post(
    "/analyze",
    response_model=AnalyzeRouteResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def analyze_route(request: AnalyzeRouteRequest) -> AnalyzeRouteResponse:
    return AnalyzeRouteResponse(
        route=RouteMetadata(
            origin=request.origin,
            destination=request.destination,
            stops=request.stops,
            travel_date=request.travel_date,
            status="queued",
        ),
        summary={
            "message": "Route analysis contract accepted. Provider integrations are pending."
        },
        alerts=[],
        news=[],
        report_url=None,
    )
