from pathlib import Path
from ruamel.yaml import YAML

yaml = YAML()


def read_chart_version(chart_dir: str, version_dir='latest'):
    return read_chart_property(chart_dir, 'version', version_dir)


def read_chart_name(chart_dir: str, version_dir='latest'):
    return read_chart_property(chart_dir, 'name', version_dir)


def read_chart_property(chart_dir: str, yaml_property: str, version_dir='latest'):
    return read_chart(chart_dir, version_dir)[yaml_property]


def read_chart(chart_dir: str, version_dir='latest'):
    chart_file = Path(chart_dir, version_dir, "Chart.yaml")

    with open(chart_file, mode='r') as file:
        return yaml.load(file)


def write_chart_version(chart_dir: str, version: str, version_dir='latest'):
    chart_file = Path(chart_dir, version_dir, "Chart.yaml")
    chart = read_chart(chart_dir, version_dir)
    chart['version'] = version

    with open(chart_file, mode='w') as file:
        yaml.dump(chart, file)
