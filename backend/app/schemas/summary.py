from pydantic import BaseModel


class SummaryResponse(BaseModel):
    executed_today: int
    pending_today: int
