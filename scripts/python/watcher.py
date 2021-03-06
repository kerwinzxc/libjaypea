#!/bin/python

import subprocess, os, sys, time, atexit, signal, psutil, datetime

if len(sys.argv) < 3:
	print "Usage: watcher.py <directories and/or files to watch, comma separated> <command to terminate and repeat>"
	sys.exit(1)

watch = sys.argv[1].split(",")

print "COMMAND: " + sys.argv[2]
process = subprocess.Popen(sys.argv[2], shell=True, stdout=sys.stdout, stderr=sys.stderr)
done = False

# "&&" within the command spawns children. Must vanquish all.
def stop_process():
	if done:
		return
	temp = psutil.Process(process.pid)
	for proc in temp.children(recursive=True):
		proc.kill()
	temp.kill()
	
atexit.register(stop_process)

filetime = {}
def any_changed():
	def file_changed(file):
		mtime = os.stat(file).st_mtime
		if not file in filetime:
			filetime[file] = mtime
		else:
			if filetime[file] != mtime:
				filetime[file] = mtime
				print "CHANGE" + " (" + str(datetime.datetime.now()) + "): " + file
				return True
		return False
	def dir_changed(dir):
		for file in os.listdir(dir):
			if not os.path.isfile(dir + file):
				continue
			if not file.endswith(".swp") and file_changed(dir + file):
				return True
		return False
	for item in watch:
		if os.path.isfile(item):
			if file_changed(item):
				return True
		elif os.path.isdir(item):
			if dir_changed(item):
				return True
	return False

print "WATCHING FOR CHANGES (" + str(datetime.datetime.now()) + "): " + sys.argv[1]

while True:
	changed = False
	while not changed:
		if process and process.poll() is not None and not done:
			done = True
			print "DONE" + " (" + str(datetime.datetime.now()) + "), WATCHING FOR CHANGES: " + sys.argv[1]
		time.sleep(1)
		if any_changed():
			if process:
				stop_process()
			print "COMMAND: " + sys.argv[2]
			process = subprocess.Popen(sys.argv[2], shell=True, stdout=sys.stdout, stderr=sys.stderr)
			done = False
