#!/usr/bin/env python3
"""Gate comparable AAP logical-tick profiles; never infer physical time."""
import argparse
import json


def load(path, parser):
    with open(path, encoding='utf-8') as stream:
        profile = json.load(stream)
    if (profile.get('schema') != 'pdp6-aap-tick-cost-v1' or
            profile.get('unit') != 'AAP logical pulse-delay ticks' or
            profile.get('method') != 'consecutive IT0 interval' or
            not profile.get('terminal_instruction_unmeasured') or
            not profile.get('workload_id') or not profile.get('model_id')):
        parser.error('profile lacks validated schema, workload or emulator model')
    intervals = profile.get('intervals')
    if (not isinstance(intervals, list) or not intervals or
            profile.get('complete_intervals') != len(intervals) or
            any(not isinstance(item.get('ticks'), int) or item['ticks'] <= 0
                for item in intervals) or
            sum(item['ticks'] for item in intervals) != profile.get('total_complete_ticks')):
        parser.error('incomplete or inconsistent tick profile')
    return profile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('baseline')
    parser.add_argument('candidate')
    parser.add_argument('--max-regression-pct', type=float, default=0.0)
    args = parser.parse_args()
    old, new = load(args.baseline, parser), load(args.candidate, parser)
    if (old['workload_id'] != new['workload_id'] or
            old['model_id'] != new['model_id']):
        parser.error('different workloads or AAP model configurations')
    if args.max_regression_pct < 0:
        parser.error('negative regression threshold')
    before, after = old['total_complete_ticks'], new['total_complete_ticks']
    if before <= 0:
        parser.error('baseline has no measurable ticks')
    change = (after - before) * 100.0 / before
    print('AAP logical ticks: baseline=%d candidate=%d delta=%+.4f%%' %
          (before, after, change))
    print('Both profiles exclude the terminal instruction. Matching workload '
          'and model identifiers must reflect independently verified equivalence.')
    if change > args.max_regression_pct:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
