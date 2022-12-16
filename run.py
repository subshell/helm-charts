import argparse
import os
import subprocess
import sys
from pathlib import Path

from scripts.release import release_git_prepare, release_git_perform


def test(chart_version_dir: str):
    print('running tests...')
    test_file = Path(chart_version_dir, 'test-values.yaml')
    run_result = subprocess.run(['helm', 'template', '-f', test_file, 'test', chart_version_dir])
    print('test run returned', run_result.returncode)
    print('...complete result:', run_result)
    if run_result.returncode != 0:
        print('Test of', chart_version_dir, 'failed!')
        sys.exit(run_result.returncode)


def build(chart_version_dir: str):
    print('running build...')
    run_result = subprocess.run(['helm', 'package', chart_version_dir, '--destination', 'out'])
    print('build run returned', run_result.returncode)
    print('...complete result:', run_result)
    if run_result.returncode != 0:
        print('Build of', chart_version_dir, 'failed!')
        sys.exit(run_result.returncode)


def push(chart_version_dir: str):
    print('running push only...')

    # special cases
    tools_charts = ['subshell-technology-radar', 'external-secrets', 'sprint-dashboard']

    repo = 'subshell-tools' if any(elem in str(chart_version_dir) for elem in tools_charts) else 'sophora'

    subprocess.run(['helm', 'push', chart_version_dir, repo])


def release(chart_versions_dir: str, chart_version: str, release_goal: str):
    print('running release...')
    if chart_version != 'latest' and release_goal == 'major':
        print('It is not possible to create a major release of an older version. Only "latest" is supported.')
        exit(1)

    chart_version_dir = Path(chart_versions_dir, chart_version)
    git_tag = release_git_prepare(chart_versions_dir, chart_version=chart_version, release_goal=release_goal)
    build(chart_version_dir)
    push(chart_version_dir)
    release_git_perform(chart_versions_dir, chart_version=chart_version, release_goal=release_goal, git_tag=git_tag)


def main(args: dict):
    if args['chart'] == 'all':
        charts = os.listdir(args['charts_base_dir'])
    else:
        charts = [args['chart']]

    target = args['action']
    for chart in charts:
        # chart versions
        chart_versions_dir = Path(args['charts_base_dir'], chart)
        if args['chart_sub_dir'] == 'all':
            chart_versions = os.listdir(chart_versions_dir)
        else:
            chart_versions = [args['chart_sub_dir']]

        for chart_version in chart_versions:
            chart_version_dir = Path(chart_versions_dir, chart_version)
            if not os.path.isdir(chart_version_dir):
                print('Directory {} is not a directory. Available chart sub directories are {}'.format(
                    chart_version_dir, os.listdir(chart_versions_dir)))
                exit(1)

            if target == 'build':
                build(chart_version_dir)
            elif target == 'push':
                push(chart_version_dir)
            elif target == 'test':
                test(chart_version_dir)
            elif target == 'release':
                release(chart_versions_dir, chart_version, args['release_goal'])


if __name__ == '__main__':
    def parse_arguments():
        parser = argparse.ArgumentParser(description='Runs the build steps depending on the target')
        parser.add_argument('chart', type=str, help='chart name (should match the directory). "all" for all charts')
        parser.add_argument('action', type=str, choices=['test', 'build', 'push', 'release'],
                            help='build target')
        parser.add_argument('--charts_base_dir', default='charts/', type=str)
        parser.add_argument('--chart_sub_dir', type=str, default='all',
                            help='Should match an existing sub-directory like "latest".')
        parser.add_argument('--release_goal', type=str, choices=['major', 'minor', 'patch'],
                            help='target release goal')


        return vars(parser.parse_args())

    main(parse_arguments())
