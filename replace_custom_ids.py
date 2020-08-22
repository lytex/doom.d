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


custom_to_id = {}

for path in glob("/home/julian/org/**/*.org", recursive=True):
    root = load(path)
    custom_id = recursive_filter(lambda x: x.properties.get('custom_id') is not None, get_children(root))

    for item in custom_id:
        uuid = str(uuid4())
        custom_to_id.update({item.properties['custom_id']: uuid})
        item.properties.update({'ID': uuid})

for path in glob("/home/julian/org/**/*.org", recursive=True):
    # print(f"Opening {path}")
    with open(path, "r") as f:
        content = f.read()
        for custom, uuid in custom_to_id.items():
            # print(f"Iterating on {custom}")
            content2 = re.sub(r"\[\[#"+custom+"\]\]", f"[[id:{uuid}[{custom}]]", content)
            matches = re.findall(r"\[\[#"+custom+"\]\]", content)
            for match in matches:
                content2 = content.replace(match, f"[[id:{uuid}[{custom}]]")
                print(match, "\n", f"[[id:{uuid}[{custom}]]")


            matches = re.findall(r"\[\[#"+custom+"\[([\w\s-])+\]\]", content)
            content3 = re.sub(r"\[\[#"+custom+"\[[\w\s-]+\]\]", f"[[id:{uuid}[{custom}]]", content)
            for match in matches:
                content3 = content.replace(match, f"[[id:{uuid}[{custom}]]")
                print(match, "\n", f"[[id:{uuid}[{custom}]]")
                breakpoint()


            
