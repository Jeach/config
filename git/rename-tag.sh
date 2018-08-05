#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2014 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Script to easily rename a Git tag.
#-----------------------------------------------------------------------------
#

[ $# -lt 2 ] && echo "USAGE: $0 <old-tag> <new-tag>" && exit 0

OLD=$1
NEW=$2

echo "About to rename git tag '$OLD' with '$NEW', continue?"

read answer

[ "$answer" != "y" -a "$answer" != "Y" ] && echo "Aborting!" && exit 1

echo "Renaming..."

git tag $NEW $OLD
git tag -d $OLD
git push origin :refs/tags/$OLD
git push --tags
