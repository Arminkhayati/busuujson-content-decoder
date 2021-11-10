#!/bin/sh

release_ctl eval --mfa "Content.ReleaseTasks.seed/1" --argv -- "$@"
