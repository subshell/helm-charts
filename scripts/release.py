import shutil
import subprocess
import sys
from pathlib import Path

sys.path.insert(1, 'scripts')

from helm_chart_utils import read_chart_name, read_chart_version, write_chart_version
from parse_semver import parse_semver


def prepare_major_version(chart_versions_dir: str, major_version: str):
    print('running prepare major version...')
    src = Path(chart_versions_dir, 'latest')
    dist = Path(chart_versions_dir, 'v{}'.format(major_version))
    shutil.copytree(src, dist)


def release_git_prepare(chart_versions_dir: str, chart_version: str, release_goal: str):
    current_version = read_chart_version(chart_versions_dir, version_dir=chart_version)
    next_version = parse_semver(current_version, release=release_goal)

    chart_name = read_chart_name(chart_versions_dir, version_dir=chart_version)
    release_tag = '{}-{}'.format(chart_name, next_version)

    if release_goal == 'major':
        current_major = parse_semver(current_version, release='none', output_format='major')
        prepare_major_version(chart_versions_dir, current_major)

    # set new chart version and create git tag
    print('Creating release with tag {}'.format(release_tag))
    write_chart_version(chart_versions_dir, next_version, version_dir=chart_version)

    subprocess.run(['git', 'add', '--all'])
    subprocess.run(['git', 'commit', '-m', 'release {}'.format(release_tag)])
    subprocess.run(['git', 'tag', release_tag])

    return release_tag


def release_git_perform(chart_dir: str, chart_version: str, release_goal: str, git_tag: str, git_branch='master'):
    current_version = read_chart_version(chart_dir, version_dir=chart_version)
    # increment patch version, i.e. 2.0.0 -> 2.0.1-dev
    next_dev_version = parse_semver(current_version, release='patch', suffix='-dev')
    write_chart_version(chart_dir, next_dev_version, version_dir=chart_version)

    subprocess.run(['git', 'add', '--all'])
    subprocess.run(['git', 'commit', '-m', 'prepare dev version {}'.format(next_dev_version)])
    subprocess.run(['git', 'push', '--atomic', 'origin', git_branch, git_tag])
