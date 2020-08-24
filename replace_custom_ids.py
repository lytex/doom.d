import json
import re
from glob import glob
from typing import Callable, Iterable
from uuid import uuid4

from orgparse import load
from orgparse.node import OrgRootNode


def recursive_filter(condition: Callable[[OrgRootNode], bool], root: Iterable[OrgRootNode]) -> Iterable[OrgRootNode]:
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

def get_children(parent):
    if parent.children:
        for node in parent.children:
            yield node
            if node.children:
                yield from get_children(node)


# r = "\n".join([str(x) for x in root])
# with open("test.org", "w") as f:
#     f.write(r)

# This dictionary maps each custom_id to their id (either existent id or newly generated id)
custom_to_id = {} 

for path in glob("/home/julian/org/**/*.org", recursive=True):
    root = load(path)
    custom_id = recursive_filter(lambda x: x.properties.get('custom_id') is not None, get_children(root))

    for item in custom_id:
        uuid = item.properties.get('ID', str(uuid4())) # Create id if not exists only
        custom_to_id.update({item.properties['custom_id']: uuid})
        item.properties.update({'ID': uuid})

for path in glob("/home/julian/org/**/*.org", recursive=True):
    with open(path, "w") as f:
        content = f.read()

        for custom, uuid in custom_to_id.items():
            # Match simple links [[#link]]
            matches = re.findall(r"\[\[#"+custom+"\]\]", content)
            for match in matches:
                content = content.replace(match, f"[[id:{uuid}[{custom}]]")

            # Match links with names [[#link][name]]
            matches = re.findall(r"\[\[#"+custom+"\]\[[ \w\d-]+\]\]", content)
            for match in matches:
                content = content.replace(match, f"[[id:{uuid}[{custom}]]")

        f.write(content)

        



            
