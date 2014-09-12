#!/usr/bin/env python

import os
import sys
import glob
from subprocess import check_output,STDOUT
from shutil import copyfile
import re
import io


def get_source_files(rootPath):
    print "Extracting translations from {0}".format(rootPath)
    source_files = []
    for root, dirs, files in os.walk(rootPath):
        source_files += [os.path.join(root, f) for f in files if f.endswith('.m') or f.endswith('.swift')]
    return set(source_files)

def translate(rootPath, files):
    error_regex = re.compile('^Bad entry in file (.*) \(line = ([0-9]+)\): (.*)$')

    output = check_output(["genstrings", "-o", os.path.join(rootPath,"Supporting Files")] + list(files), stderr=STDOUT)
    for line in output.split("\n"):
        match = error_regex.match(line)
        if match:
            print '{0}:{1}: error: {2}'.format(match.group(1),match.group(2),match.group(3))
    return os.path.join(rootPath,"Supporting Files","Localizable.strings")

def exportStrings(generatedFile, outputFilename):
    newFilename = generatedFile
    oldFilename = outputFilename + "-old"
    copyfile(outputFilename, oldFilename)
    translationRegex = re.compile('^\"(.*)\" \= \"(.*)"\;$')
    oldStrings = {}

    with utfOpen(oldFilename) as oldFile, utfOpen(newFilename) as newFile, io.open(outputFilename, 'w', encoding='utf-16') as outputFile:

        for line in oldFile:
            match = translationRegex.match(line)
            if match:
                oldStrings[match.group(1)] = match.group(2)

        for line in newFile:
            match = translationRegex.match(line)
            if match and match.group(1) in oldStrings:
                outputFile.write(u'"{0}" = "{1}";\n'.format(match.group(1), oldStrings[match.group(1)]))
            else:
                outputFile.write(line)

    os.remove(oldFilename)

def utfOpen(filename):
    file = io.open(filename,'r',encoding='utf-16')
    try:
        file.read(20)
        file.seek(0)
        return file
    except UnicodeError:
        return io.open(filename,'r',encoding='utf-8')

if __name__ == "__main__":
    rootPath = sys.argv[1]
    source_files = get_source_files(rootPath)
    generated_file = translate(rootPath, source_files)
    existing_files = glob.glob(os.path.join(rootPath,"Supporting Files","*","Localizable.strings"))
    for existing_file in existing_files:
        exportStrings(generated_file, existing_file)
    os.remove(generated_file)
