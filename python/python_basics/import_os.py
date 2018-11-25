import os
from datetime import datetime

# List of the attributes & methods in os module
# print(dir(os))

# To get the current working directory
# print(os.getcwd())
# /Users/neilflores/Desktop/DevOps/personal_projects/python/import_os

# To change directory then check the current working directory
# os.chdir('/Users/neilflores/Desktop/DevOps/personal_projects/python/')
# print(os.getcwd())
# /Users/neilflores/Desktop/DevOps/personal_projects/python

# To create directory/ies
# mkdir
# os.mkdir('test')
# mkdir -p
# os.makedirs('test01/example-01')
# os.rmdir('test') # rmdir
# os.removedirs('test01/example-01') # rm /test01/example-01 but not like rm -fr
# os.rename('test', 'rename_dir') # rename file/directory

# print information's of the files
# print(os.stat('demo.txt'))
# mod_time = os.stat('demo.txt').st_mtime # to check the last modify time
# print(datetime.fromtimestamp(mod_time))

# List the files and dir in the current working directory
# print(os.listdir())

# To traverse current, directories paths, files using os.walk
#for dirpath, dirnames, filenames in os.walk('/Users/neilflores/Desktop'):
#    print('Current Path:', dirpath)
#    print('Directories', dirnames)
#    print('Files', filenames)
#    print()

# print(os.environ.get('HOME')) # get home dir
# file_path = os.path.join(os.environ.get('HOME'), 'test.txt')
# print(file_path)
# /Users/neilflores/test.txt # will have this output but the file will not be created

# with open(file_path, 'w') as f: # needs to be review
#    f.write()                    # needs to be review

print(os.path.basename('/tmp/test.txt'))
# test.txt
print(os.path.dirname('/tmp/test.txt'))
# /tmp
print(os.path.split('/tmp/test.txt'))
# ('/tmp', 'test.txt')
print(os.path.exists('/tmp/test.txt')) # to check if it exist
# False
print(os.path.isfile('/tmp/test.txt'))
print(os.path.isdir('/tmp/test.txt'))
print(os.path.splitext('/tmp/test.txt'))
# ('/tmp/test', '.txt')

# List of the attributes & methods in os module
print(dir(os.path))