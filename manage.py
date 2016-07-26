#-*- coding: utf-8 -*-

import zipfile, os, sys

import requests
import wget
from bs4 import BeautifulSoup

WOW_DIR = "/data/World of Warcraft"
ADDONS_DIR = ""

CONF_FILE = "conf"
CONF_FILE_OLD = CONF_FILE + "_old"

URL_ROOT = "http://mods.curse.com"
URL_HOME = URL_ROOT + "/addons/wow/{}"


def print_lv2(param):
    print ("  ->", param)

def handle():
    map = read_file()
    for name, old_version in map.items():
        print ("{}({})".format(name, old_version))

        # 1.
        print_lv2("check version...")
        r = requests.get(URL_HOME.format(name))
        bs = BeautifulSoup(r.content, 'html.parser')
        data = bs.find('tr', 'even').find('a', href=True)
        url_down =  data['href']
        new_version = data.getText()

        print_lv2("new: {}".format(new_version))
        if new_version == old_version:
            print_lv2("PASS")
            continue;

        # 2.
        print_lv2("download...")
        r = requests.get(URL_ROOT + url_down)
        bs = BeautifulSoup(r.content, 'html.parser')
        url = bs.find('div', "countdown").find('a')['data-href']
        file_name = wget.download(url, bar="")

        # 3.
        print_lv2("extract...")
        zf = zipfile.ZipFile(file_name)
        zf.extractall(ADDONS_DIR)
        zf.close()
        os.remove(file_name)

        print_lv2("DONE")
        map[name] = new_version
    write_file(map)

def read_file():
    map = {}
    for line in open(CONF_FILE):
        arr = line.split()
        if len(arr) == 0:
            continue;
        map[arr[0]] = "" if len(arr) == 1 else arr[-1]
    return map

def write_file(map):
    os.rename(CONF_FILE, CONF_FILE_OLD)
    with open(CONF_FILE, "w") as f:
        for k,v in map.items():
            f.write("{} {}\n".format(k, v))

def check():
    global ADDONS_DIR

    if not os.path.exists(WOW_DIR):
        print ("WOW directory error, plz check! -> [{}].".format(WOW_DIR))
        sys.exit(1)

    ADDONS_DIR = WOW_DIR + "/Interface/AddOns"
    if not os.path.exists(ADDONS_DIR):
        print ("WOW AddOns directory error, plz check! -> [{}].".format(ADDONS_DIR))
        sys.exit(1)

    if not os.path.isfile(CONF_FILE):
        print ("local config file error, plz check! -> [].".format(CONF_FILE))
        sys.exit(1)

if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.realpath(os.path.abspath(sys.argv[0]))))
    if len(sys.argv) > 1:
        WOW_DIR = sys.argv[1]
    check()
    handle()
