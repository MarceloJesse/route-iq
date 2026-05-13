from fastapi import FastAPI
from mangum import Mangum

from app.api.routes import router as routes_router


def create_app() -> FastAPI:
    app = FastAPI(
        title="RouteIQ API",
        version="0.1.0",
        description="Travel intelligence API for overland routes in South America.",
    )

    @app.get("/health", tags=["health"])
    def health() -> dict[str, str]:
        return {"status": "ok"}

    app.include_router(routes_router)
    return app


app = create_app()
handler = Mangum(app)
