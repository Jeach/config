#!/bin/bash
#-----------------------------------------------------------------------------
# Git configuration tutorial.
#-----------------------------------------------------------------------------
# Copyright (C) 2013 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
#


USER_NAME="Christian Jean"
EMAIL_ADDR="christian.jean@gmail.com"


#-----------------------------------------------------------------------------
# First you need to tell git your name, so that it can properly label the 
# commits you make.
#-----------------------------------------------------------------------------
git config --global user.name "$USER_NAME"


#-----------------------------------------------------------------------------
# Git saves your email address into the commits you make.  We use the email 
# address to associate your commits with your GitHub account.
#-----------------------------------------------------------------------------
git config --global user.email "$EMAIL_ADDR"


#-----------------------------------------------------------------------------
# Set our default editor.
#-----------------------------------------------------------------------------
git config core.editor "vi"


#-----------------------------------------------------------------------------
# Defines the action git push should take if no refspec is explicitly given.
# Different values are well-suited for specific workflows; for instance, in a
# purely central workflow (i.e. the fetch source is equal to the push 
# destination), upstream is probably what you want.
#
# Possible values are:
#
# nothing - do not push anything (error out) unless a refspec is explicitly 
# given. This is primarily meant for people who want to avoid mistakes by 
# always being explicit.
#
# current - push the current branch to update a branch with the same name on 
# the receiving end. Works in both central and non-central workflows.
#
# upstream - push the current branch back to the branch whose changes are 
# usually integrated into the current branch (which is called @{upstream}). 
# This mode only makes sense if you are pushing to the same repository you 
# would normally pull from (i.e. central workflow).
#
# simple - in centralized workflow, work like upstream with an added safety 
# to refuse to push if the upstream branch’s name is different from the local
# one.
#
# When pushing to a remote that is different from the remote you normally pull
# from, work as current. This is the safest option and is suited for beginners.
#
# matching - push all branches having the same name on both ends. This makes
# the repository you are pushing to remember the set of branches that will be
# pushed out (e.g. if you always push maint and master there and no other 
# branches, the repository you push to will have these two branches, and 
# your local maint and master will be pushed there).
#-----------------------------------------------------------------------------
git config --global push.default simple


#-----------------------------------------------------------------------------
# Push all the refs that would be pushed without this option, and also push
# annotated tags in refs/tags that are missing from the remote but are 
# pointing at commit-ish that are reachable from the refs being pushed. 
#
# In other words, since git 1.8.3 (April 22d, 2013), you no longer have to
# do 2 commands to push branches, and then to push tags.
#-----------------------------------------------------------------------------
git config --global push.followTags true


#-----------------------------------------------------------------------------
# Helper to temporarily store credentials in memory.
# The '--timeout <seconds>' can be used to change the default timeout value.
# Default timeout is 900 seconds (or 15 minutes).
#-----------------------------------------------------------------------------
git config --global credential.helper cache
#git config --global credential.helper "cache --timeout=3600"

