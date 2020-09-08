import json
import re
from glob import glob
from typing import Callable, Iterable
from uuid import uuid4
import os
from os.path import isdir

from orgparse import loads
from orgparse.node import OrgBaseNode

ORG_DIRECTORY = os.environ.get("ORG_DIRECTORY")

def ls(path: str):
    files_and_dirs = os.listdir(path)
    yield path, filter(isdir, files_and_dirs), filter(lambda x: not isdir(x), files_and_dirs)


def func(path: str, level: int) -> Iterable[str]:
    # print((path, level))
    # breakpoint()
    path = ls(path)
    for root, directories, files in path:
        directories, files = sorted(directories, key=lambda x: x.lower()), sorted(files, key=lambda x: x.lower())
        # print(root, directories, files)
        # breakpoint()
        for directory in directories:
            # print("*"*(level+1) + f" [[file:{root}/{directory}][{directory}]]")
            # breakpoint()
            yield "*"*(level+1) + f" {directory}"
            yield from sorted(func(root+"/"+directory, level+1))
        for file in files:
            if file.endswith(".org"):
                print("\t", file)
                # print("*"*(level+1) + f" [[file:{root}/{file}][{file}]]")
                # breakpoint()
                yield "*"*(level+1) + f" [[file:{file}][{file}]]"

with open("/home/julian/org/0.org", "w") as f: 
    print("\n".join(func(ORG_DIRECTORY, 0)), file=f) 