from datetime import datetime

from pydantic import BaseModel


class EvidenceResponse(BaseModel):
    id: int
    execution_id: int
    file_url: str
    created_at: datetime

    class Config:
        from_attributes = True
