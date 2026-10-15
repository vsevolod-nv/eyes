import argparse
from pathlib import Path
from urllib.request import urlopen

from tqdm import tqdm

parser = argparse.ArgumentParser()
parser.add_argument("--url", required=True)
parser.add_argument("-o", "--output", default="sample-500.zip")
args = parser.parse_args()

destination = Path(args.output)
partial = destination.with_suffix(destination.suffix + ".part")
with urlopen(args.url) as response, partial.open("wb") as output:
    with tqdm(total=int(response.headers.get("Content-Length", 0)) or None,
              unit="B", unit_scale=True, desc=destination.name) as progress:
        while chunk := response.read(1024 * 1024):
            output.write(chunk)
            progress.update(len(chunk))
partial.replace(destination)
