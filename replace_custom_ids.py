import json
import re
from glob import glob
from typing import Callable, Iterable
from uuid import uuid4
import os

from orgparse import loads
from orgparse.node import OrgBaseNode

ORG_DIRECTORY = os.environ.get("ORG_DIRECTORY")


def recursive_filter(condition: Callable[[OrgBaseNode], bool], root: Iterable[OrgBaseNode]) -> Iterable[OrgBaseNode]:
    """recursively trasvese all possible nodes from root and return only those for which
        condition returns True

    Args:
        condition: condition which evaluates to true
        nodes: nodes to be traversed

    Yields each node with matches the condition
    """
    for node in root:
        if condition(node):
            yield node
        if node.children:
            yield from recursive_filter(condition, node.children)


def get_children(parent: OrgBaseNode) -> Iterable[OrgBaseNode]:
    if parent.children:
        for node in parent.children:
            yield node
            if node.children:
                yield from get_children(node)


# This dictionary maps each custom_id to their id (either existent id or newly generated id)
custom_to_id = {}


def add_id(node):
    if node.heading == "notes narrowing by current subheading":
        breakpoint()
    if (node.properties.get("custom_id") in custom_to_id.keys()) and (
        set(node.properties.keys()).intersection(set(("id", "ID", "iD", "Id"))) == set()
    ):
        return re.sub(
            r"(:custom_id: " + node.properties["custom_id"] + r")",
            r"\1\n:ID: " + custom_to_id[node.properties["custom_id"]],
            str(node),
        )
    else:
        return str(node)


for path in glob(f"{ORG_DIRECTORY}/**/*.org", recursive=True):
    with open(path, "r") as f:
        root = loads(f.read())

    custom_id = recursive_filter(lambda x: x.properties.get("custom_id") is not None, get_children(root))

    for item in custom_id:
        uuid = item.properties.get("ID", str(uuid4()))  # Create id if not exists only
        custom_to_id.update({item.properties["custom_id"]: uuid})

    result = str(root[0]) + "\n".join([add_id(x) for x in root[1:]])

    with open(path, "w") as f:
        # Overwrite content
        f.seek(0)
        f.write(result)

for path in glob(f"{ORG_DIRECTORY}/**/*.org", recursive=True):

    with open(path, "r") as f:
        content = f.read()

    for custom, uuid in custom_to_id.items():

        # Substitute simple links [[#link]]
        content = re.sub(r"\[\[#" + custom + "\]\]", f"[[id:{uuid}][{custom}]]", content)

        # Substitute links with names [[#link][name]]
        content = re.sub(
            r"\[\[#" + custom + "\]\[([ \w\d-]+)\]\]",
            "[[id:" + uuid + r"][\1]]",
            content,
        )

    with open(path, "w") as f:
        # Overwrite content
        f.seek(0)
        f.write(content)
