import os

from flytekit import task, workflow
from flytekit.types.directory import FlyteDirectory

@task
def my_task() -> int:
    return 42

@task
def create_file_task(value: int) -> FlyteDirectory:
    output_path = "output"
    os.makedirs(output_path, exist_ok=True)
    file_path = os.path.join(output_path, "test.txt")
    with open(file_path, "w") as f:
        f.write(f"Simple file with {value=}!")
    return FlyteDirectory(output_path)

@workflow
def my_workflow() -> FlyteDirectory:
    value = my_task()
    directory = create_file_task(value=value)
    return directory
