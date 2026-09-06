"""Tests for restart-safe automatic scheduling."""

from datetime import datetime, timedelta, timezone

from main import _next_interval_run, _startup_run_due


def test_recent_automatic_run_keeps_its_remaining_cooldown():
    now = datetime(2026, 9, 6, 15, 0, tzinfo=timezone.utc)
    last_run = now - timedelta(hours=2)

    assert _startup_run_due(last_run, 12, now=now) is False
    assert _next_interval_run(last_run, 12, now=now) == last_run + timedelta(hours=12)


def test_overdue_cycle_runs_at_startup_but_does_not_replay_missed_intervals():
    now = datetime(2026, 9, 6, 15, 0, tzinfo=timezone.utc)
    last_run = now - timedelta(hours=25)

    assert _startup_run_due(last_run, 12, now=now) is True
    assert _next_interval_run(last_run, 12, now=now) == now + timedelta(hours=12)


def test_first_automatic_run_starts_now_and_interval_starts_afterward():
    now = datetime(2026, 9, 6, 15, 0, tzinfo=timezone.utc)

    assert _startup_run_due(None, 12, now=now) is True
    assert _next_interval_run(None, 12, now=now) == now + timedelta(hours=12)


def test_fixed_schedule_does_not_repeat_after_a_restart():
    now = datetime(2026, 9, 6, 15, 0, tzinfo=timezone.utc)
    today_run = datetime(2026, 9, 6, 12, 1, tzinfo=timezone.utc)
    yesterday_run = datetime(2026, 9, 5, 12, 1, tzinfo=timezone.utc)

    assert _startup_run_due(today_run, 0, fixed_times=[(12, 0)], now=now) is False
    assert _startup_run_due(yesterday_run, 0, fixed_times=[(12, 0)], now=now) is True
