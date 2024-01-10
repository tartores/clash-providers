#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from urllib import request, parse
from urllib.error import URLError, HTTPError

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36'

def download():
    try:
        print('try:')
        pass
    except HTTPError as e:
        print('except:')
        pass
    finally:
        print('finally:')
        pass