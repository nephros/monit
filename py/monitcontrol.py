#!/usr/bin/python3

# Copyright (c) 2023 Peter G. (nephros)
# SPDX-License-Identifier: Apache-2.0

import pyotherside
import os, subprocess, sys

monit = '/usr/bin/monit'
pk = '/usr/bin/pkexec'

def status():
    subprocess.run([pk, monit, 'status'])

def reload():
    subprocess.run([pk, monit, 'reload'])

def custom(cmd, parms):
    subprocess.run([pk, monit, cmd, parms])

