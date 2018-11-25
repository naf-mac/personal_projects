# File Objects

f = open('demo.txt', 'r')

# print(f.name) # to get the filename
# demo.txt
# print(f.mode) # to check the mode the file currently open with
# r

f.close()

# How to open the file using context manager doesn't need the close()
#with open('demo.txt', 'r') as f:
    # f_contents = f.read() # will print all lines of the file
    # f_contents = f.readlines() # will print in one single line

    #for line in f:
    #    print(line, end='')

    # f_contents = f.readline() # will print first line of the file
    # print(f_contents, end='') # this will remove the space print after the line

    # f_contents = f.readline()  # will print the second line of the file
    # print(f_contents, end='')

    # f_contents = f.read(100)  # will print the 1st 100 characters, you can repeat this like above
    # print(f_contents, end='')

    # size_to_read = 100

    # f_contents = f.read(size_to_read)

    # while len(f_contents) > 0:
    #    print(f_contents, end='')
    #    f_contents = f.read(size_to_read)

    # size_to_read = 10

    #f_contents = f.read(size_to_read)
    #print(f_contents, end='')

    # print(f.tell()) # tells which character counts are you
    #f.seek(0) # will seek or start again on the same position pass in

    #f_contents = f.read(size_to_read)
    #print(f_contents, end='')

    # while len(f_contents) > 0:
    #    print(f_contents, end='*')
    #    f_contents = f.read(size_to_read)

    #f.write('Test') # will error because the operation is not writable

# print(f.closed)
# print(f.read)

# with open('demo2.txt', 'w') as f: # this will create demo2.txt
    #pass # do nothing
    #f.write('Write in demo2.txt') # will write inside the demo2.txt
    #f.seek(0)
    #f.write('R') # will only replace 'W' of write to R
    # NOTE: re-running it will continue where it last wtite


# Copying the contents of the file
#with open('demo.txt', 'r') as rf:
#    with open('demo_copy.txt', 'w') as wf:
#        for line in rf:
#            wf.write(line)

# copying images instead of strings, we need to use bytes
#with open('aws_pofile.jpg', 'rb') as rf:
#    with open('aws_pofile_copy.jpg', 'wb') as wf:
#        for line in rf:
#            wf.write(line)

# Copy image by chunk
with open('aws_pofile.jpg', 'rb') as rf:
    with open('aws_pofile_copy.jpg', 'wb') as wf:
        chunk_size = 4096
        rf_chunk = rf.read(chunk_size)
        while len(rf_chunk) > 0:
            wf.write(rf_chunk)
            rf_chunk = rf.read(chunk_size)
