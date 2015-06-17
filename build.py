import json
import sys
import os
import glob
import tempfile
import shutil
import distutils.dir_util
from subprocess import Popen, PIPE

def build(config):
    # make build dir if it doesn't exist
    os.makedirs(config["output"], exist_ok=True)
    # assemble list of source files
    source_files = []
    for src_str in config["sources"]:
        source_files += glob.glob(src_str)
    # make temporary dir to hold all source files
    with tempfile.TemporaryDirectory() as tempDir:
        # copy source files
        for source_file in source_files:
            if os.path.isdir(source_file):
                distutils.dir_util.copy_tree(source_file, tempDir)
            else:
                print(source_file)
                shutil.copy(source_file, tempDir)
        # make zip of temp dir
        zip = shutil.make_archive(
            os.path.join(config["output"], "{} v{}".format(config["title"], config["version"])),
            "zip",
            tempDir
        )
        # rename to .love
        love = shutil.move(zip, os.path.splitext(zip)[0]+".love")
        print("Created {}".format(love))

def run(config):
    love_path = config["love_path"] or shutil.which("love")
    love_file = glob.glob(os.path.join(config["output"], "*.love"))[0]
    proc = Popen([love_path, love_file, "--console"], stdout=PIPE)

def config(filename="project.json"):
    with open(filename, encoding="utf-8") as raw_json:
        return json.loads(raw_json.read())

if __name__ == "__main__":
    build(config())
    if "--run" in sys.argv:
        run(config())