#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# target_url = 'https://github.com/iina/iina/releases/download/v1.3.3/IINA.v1.3.3.dmg'
#

from cgi import print_arguments
import time, sys, os

from urllib import request, parse
from urllib.error import HTTPError

time_start = time.time()

git_original = 'https://raw.githubusercontent.com'
git_mirror   = 'https://raw.gitmirror.com'
git_domain   = git_mirror

acl4ssr      = "ACL4SSR/ACL4SSR/master"

filename = "abcd.yaml"

def _progress(block_num, block_size, total_size):
    '''回调函数
    @block_num: 已经下载的数据块
    @block_size: 数据块的大小
    @total_size: 远程文件的大小
    '''
    sys.stdout.write('\r>> Downloading %s %.2f%%' % (filename, float(block_num * block_size) / float(total_size) * 100.0))
    sys.stdout.flush()

def download(target_url, local_path: str = None):
    _save_as = local_path

    if local_path is not None and type(_save_as) is str:
        save_dir, save_filename = os.path.split(_save_as)
        if not os.path.exists(save_dir):
            os.makedirs(save_dir)
    else:
        _save_as = None

    opener = request.build_opener()
    opener.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36')]
    request.install_opener(opener)
    local_filename, headers = request.urlretrieve(target_url, filename=_save_as, reporthook=_progress)
    return local_filename

def update(local_rule_name: str, src: tuple = None):
    _local_as = os.path.normpath(local_rule_name)

    print(_local_as)

    # for tuple_item in src:
    #     aa, filename = os.path.split(tuple_item)
    #     download(f"{git_domain}/{acl4ssr}{tuple_item}", f"./.cache/{filename}")


import argparse


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='我的第一个解析器')
    parser.add_argument('-r', '--rule', '--rule-name', dest='rule', nargs='?')
    args = parser.parse_args(sys.argv)

    print(args)

    # update("google", src=(
    #     '/Clash/Ruleset/Telegram.list',
    #     '/Clash/Ruleset/Google.list',
    #     ))

    # print("\033[32m[开始]\033[0m")
    # print("\033[32m[完成]\033[0m")
    # print("\033[32m[耗时]\033[0m {:.2f}ms".format(1000 * (time.time() - time_start)))