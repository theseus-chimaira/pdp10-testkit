"""Synchronous AAP guest-completion protocol using simulator-thread status.

Requires PDP-6 AAP `cpustatus` / APR_STATUS_V1. The simulator processes
status commands in its own simulation thread; the test waits for a HALTED
acknowledgement rather than guessing a host sleep duration.
"""
import os
from pathlib import Path
import re
import select
import subprocess
import tempfile
import time

STATUS = re.compile(rb'APR_STATUS_V1 (START_PENDING|RUNNING|HALTED)\r?\n')


def run_guest(emulator, work, words, readbacks, trace_enabled=True, timeout=8,
              extra_commands="", start_address=0o1000):
    commands = ['power on']
    commands.extend('deposit %o %012o' % (a, w) for a, w in sorted(words.items()))
    commands.append('start %o' % start_address)
    env = dict(os.environ)
    env['PDP6_AAP_TIMING_TRACE_V1'] = '1' if trace_enabled else '0'
    deadline = time.monotonic() + timeout
    with tempfile.TemporaryFile() as error_output:
        proc = subprocess.Popen([str(emulator)], cwd=Path(work),
                                stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                stderr=error_output, env=env, bufsize=0)
        try:
            proc.stdin.write(('\n'.join(commands) + '\n').encode('ascii'))
            proc.stdin.flush()
            transcript = b''
            pending = b''
            states = []
            while True:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise TimeoutError('AAP guest did not acknowledge HALT')
                proc.stdin.write(b'cpustatus\n')
                proc.stdin.flush()
                while True:
                    match = STATUS.search(pending)
                    if match:
                        state = match.group(1).decode('ascii')
                        pending = pending[match.end():]
                        states.append(state)
                        break
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        raise TimeoutError('AAP cpustatus response timed out')
                    ready, _, _ = select.select([proc.stdout], [], [], remaining)
                    if not ready:
                        raise TimeoutError('AAP cpustatus response missing')
                    data = os.read(proc.stdout.fileno(), 4096)
                    if not data:
                        raise RuntimeError('AAP console ended before HALT')
                    transcript += data
                    pending += data
                if state == 'HALTED':
                    break
                # Yield to the machine pulse scheduler between status requests.
                time.sleep(0.005)
            requests = ''.join('examine %o\n' % address for address in readbacks)
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise TimeoutError('AAP HALT reached after total deadline')
            stdout_tail, _ = proc.communicate((requests + extra_commands + 'quit\n').encode('ascii'),
                                               timeout=remaining)
            transcript += stdout_tail
            if proc.returncode != 0:
                raise RuntimeError('AAP process exit %d' % proc.returncode)
            error_output.seek(0)
            return transcript.decode('ascii', errors='replace'), error_output.read().decode(
                'ascii', errors='replace'), states
        except BaseException:
            proc.kill()
            proc.communicate()
            raise
