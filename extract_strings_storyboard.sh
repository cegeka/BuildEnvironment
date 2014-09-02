#!/usr/bin/env python

from subprocess import check_output
import io
import re
import os
import sys
import glob
from shutil import copyfile


def exportStrings(storyboard, outputFilename):
    newFilename = outputFilename + "-new"
    oldFilename = outputFilename + "-old"
    copyfile(outputFilename, oldFilename)

    check_output(["ibtool", "--export-strings-file", newFilename, storyboard])

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

    os.remove(newFilename)
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
    print "Looking for {0}/Base.lproj/*.storyboard".format(sys.argv[1])
    storyboards = glob.glob("{0}/Base.lproj/*.storyboard".format(sys.argv[1]))
    languages = glob.glob("{0}/*.lproj".format(sys.argv[1]))
    languages.remove("{0}/Base.lproj".format(sys.argv[1]))
    for storyboard in storyboards:
        for language in languages:
            destination = "{0}/{1}.strings".format(language, os.path.splitext(os.path.basename(storyboard))[0])
            print "Exporting {0} to {1}".format(storyboard, destination)
            exportStrings(storyboard, destination)