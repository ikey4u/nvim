#! /usr/bin/env python3
#! -*- coding:utf-8 -*-

from datetime import datetime

def date(fmt):
    return datetime.today().strftime(fmt)
