# OOYE OCI image

This repo contains buildscripts and instructions to setup and run ooye inside an oci-compatible runtime like Podman or Docker.

## Setup
- Copy compose.yaml from repo
- Make sure to create the data directory (by default `./ooye-data`) and is owned by UID:GID 1000:1000
- Run `docker compose up -d` to start the container in the background
- Follow the prompts

## Repos
- Main repo: [git.shork.ch/oci-images/out-of-your-element](https://git.shork.ch/oci-images/out-of-your-element)
- Mirrors:
    - Codeberg: [melthecat/ooye-oci](https://codeberg.org/melthecat/ooye-oci)
    - Github: [melthecat/ooye-docker](https://github.com/melthecat/ooye-docker)

## Other info
- [ooye project source](https://gitdab.com/cadence/out-of-your-element)
- [ooye get-started](https://gitdab.com/cadence/out-of-your-element/src/branch/main/docs/get-started.md)
