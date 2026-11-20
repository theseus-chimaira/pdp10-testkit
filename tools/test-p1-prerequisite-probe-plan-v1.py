#!/usr/bin/env python3
"""Host-only positive and negative controls for bounded P1 probe planning."""

import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    'p1_probe_plan_v1', ROOT / 'tools/plan-p1-prerequisite-probes-v1.py')
plan = importlib.util.module_from_spec(spec)
spec.loader.exec_module(plan)


def rejected(rows, policy, limit):
    try:
        plan.select(rows, policy, limit)
    except ValueError:
        return
    raise AssertionError('invalid probe plan accepted')


def main():
    with plan.MANIFEST.open(newline='') as stream:
        rows = list(csv.DictReader(stream, delimiter='\t'))
    counts = {}
    for policy in plan.POLICIES:
        chosen = plan.select(rows, policy, 10)
        assert chosen and len(chosen) <= 10
        assert all(row['prerequisite_policy'] == policy for row in chosen)
        counts[policy] = sum(row['prerequisite_policy'] == policy for row in rows)
    assert sorted(counts.values()) == [1, 6, 13, 15, 18]
    rejected(rows, plan.POLICIES[0], 0)
    rejected(rows, plan.POLICIES[0], 11)
    rejected(rows, 'unknown', 1)
    changed = [dict(row) for row in rows]
    changed[0]['current_sha256'] = '0' * 64
    rejected(changed, plan.POLICIES[0], 1)
    changed = [dict(row) for row in rows]
    changed[1]['current_path'] = changed[0]['current_path']
    changed[1]['current_sha256'] = changed[0]['current_sha256']
    changed[1]['prerequisite_policy'] = (
        'variadic-abi-review' if changed[0]['prerequisite_policy'] !=
        'variadic-abi-review' else 'hosted-service-required')
    rejected(changed, plan.POLICIES[0], 1)
    changed = [dict(row) for row in rows]
    changed[0]['current_path'] = '../outside.c'
    rejected(changed, plan.POLICIES[0], 1)
    print('PASS: bounded P1 probe planning (53 sources, 5 policies, 6 negative controls)')


if __name__ == '__main__':
    main()
