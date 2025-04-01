#!/usr/bin/env python3
"""
Script pour la construction et la publication d'images Docker vers GitLab Container Registry.
"""
from os import getcwd
from docker import from_env

from typer import Exit, Typer


app = Typer()

@app.command()
def publish(image, username = None, password = None):
    """
    Publish image with specific docker credentials

    Args:
        username (str): username of the registry
        password (str): password of the registry

    Example:
        To publish the project:
        ```
        python3 docker-ci.py publish --username token_username --password token_value
        ```
    """
    
    client = from_env()
    generator = client.api.push(
        repository = image,
        # tag = tag or f'{APPLICATION_TAG}/{version}', 
        auth_config = {
            "username": username, 
            "password": password, 
        },
        stream = True,
        decode = True)

    for line in generator:
        print(line)


if __name__ == '__main__':
    app()