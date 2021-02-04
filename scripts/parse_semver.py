import re
import argparse
from sys import stderr


def validate_version(version: str):
    if not re.match(r'^\d+\.\d+\.\d+.*$', version):
        print('Error: version {} does not follow semantic versioning standards'.format(version), file=stderr)
        exit(1)


def get_suffix(version: str):
    return re.sub(r'^\d+\.\d+\.\d+', '', version)


def get_version(version: str):
    suffix = get_suffix(version)
    version_without_suffix = re.sub(suffix + '$', '', version)
    [major, minor, patch] = [int(x) for x in version_without_suffix.split('.')]

    return [major, minor, patch, suffix]


def get_next_version(version: str, release_type: str):
    [major, minor, patch, suffix] = get_version(version)

    if release_type == 'major':
        return [major + 1, 0, 0, '']
    
    if release_type == 'minor':
        return [major, minor + 1, 0, '']
    
    if suffix == '':
        return [major, minor, patch + 1, '']

    return [major, minor, patch, '']


def parse_version(version: str, release_type: str): 
    if release_type == 'none': 
        return get_version(version)

    return get_next_version(version, release_type)


def format_output(version, new_suffix: str, format_str: str):
    if new_suffix is not None:
        version = [*version[:3], new_suffix]

    if format_str == 'version':
        return '{}.{}.{}{}'.format(*version)
    
    if format_str == 'major':
        return version[0]
        
    if format_str == 'minor':
        return version[1]

    if format_str == 'patch':
        return version[2]
    
    if format == 'suffix':
        return version[3]


def parse_semver(version: str, release: str, suffix=None, output_format='version'):
    validate_version(version)
    parsed_version = parse_version(version, release)

    return format_output(parsed_version, suffix, output_format)


def main(args: dict):
    return parse_semver(args['version'], args['release'], args['suffix'], args['format'])


if __name__ == '__main__':
    def parse_arguments():
        parser = argparse.ArgumentParser(description='Calculates the release version for major, minor, '
                                                     'and patch releases and prints the version to std out.')
        parser.add_argument('version', type=str, help='version to analyse')
        parser.add_argument('--release', type=str, choices=['major', 'minor', 'patch', 'none'], default='none',
                            help='realease type which is used to manipulate the version')
        parser.add_argument('--format', type=str, choices=['major', 'minor', 'patch', 'version', 'suffix'],
                            default='version', help='output format')
        parser.add_argument('--suffix', type=str, help='suffix to be added to the version')
        return vars(parser.parse_args())

    print(main(parse_arguments()))
