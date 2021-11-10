#!/bin/sh

release_ctl eval --mfa "Content.ReleaseTasks.migrate/1" --argv -- "$@"
