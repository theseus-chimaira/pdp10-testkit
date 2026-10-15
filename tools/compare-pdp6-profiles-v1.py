#!/usr/bin/env python3
"""Compare two successful PDP-6 profiles; fail on a cost regression."""
import argparse
import json


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('baseline')
    parser.add_argument('candidate')
    parser.add_argument('--max-regression-pct', type=float, default=0.0)
    parser.add_argument('--metric', choices=('instructions', 'weighted'), default='instructions')
    args = parser.parse_args()
    old, new = [json.load(open(path, encoding='utf-8'))
                for path in (args.baseline, args.candidate)]
    if any(profile.get('schema') != 'pdp6-opcode-profile-v1' for profile in (old, new)):
        parser.error('incompatible profile schema')
    if args.metric == 'weighted':
        if (old['weight_file'] != new['weight_file'] or
                any(p['unweighted_dispatches'] for p in (old, new)) or
                not old['weight_file']):
            parser.error('weighted comparison requires identical, complete weight tables')
        key = 'partial_weighted_cost'
    else:
        key = 'instruction_count'
    before, after = old[key], new[key]
    if before <= 0 or args.max_regression_pct < 0:
        parser.error('baseline must be positive and threshold nonnegative')
    change = 100.0 * (after - before) / before
    print(f'{args.metric}: baseline={before}, candidate={after}, change={change:+.4f}%')
    if change > args.max_regression_pct:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
