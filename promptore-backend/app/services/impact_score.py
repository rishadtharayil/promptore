from datetime import datetime, timezone


def compute_impact_score(
    echo_count: int,
    archive_count: int,
    remix_count: int,
    annotation_count: int,
    created_at: datetime,
) -> float:
    raw = (
        echo_count * 0.40
        + archive_count * 0.30
        + remix_count * 0.20
        + annotation_count * 0.10
    )
    now = datetime.now(timezone.utc)
    if created_at.tzinfo is None:
        created_at = created_at.replace(tzinfo=timezone.utc)
    age_hours = max(1.0, (now - created_at).total_seconds() / 3600)
    return raw / (age_hours**1.5)
