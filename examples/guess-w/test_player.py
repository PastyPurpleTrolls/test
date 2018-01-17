#! /usr/bin/env python3.4

# test_player.py
# Douglas Brown
# 1/15/2014
#

# Guess W! player written in python. Can interact properly with test_referee.rb

# imports
from optparse import OptionParser
import socket
from random import choice
import datetime

# Parsing command line arguments
# Usage: client.py --name [name] -p [port]"
parser = OptionParser()
parser.add_option("-p", "--port", action="store", type="int", dest="port")
parser.add_option("-n", "--name", action="store", type="string", dest="name")
(options, args) = parser.parse_args()

HOST = 'localhost'
PORT = options.port
NAME = options.name


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
ip = socket.gethostbyname(HOST)
s.connect((ip, PORT))  # Connect to server

message = str(NAME + "\n")
s.send(message.encode())

# Now receive data
while True:
    reply = s.recv(4096).decode()
    if "move" in reply:
        # currentTime = datetime.datetime.now()
        guesses = ['a', 'b', 'c', 'w']
        playerMove = choice(guesses) + "\n"
        s.send(playerMove.encode())
        # print("{:%H:%M} - Guess:{}".format(currentTime, playerMove))
    elif "wins" in reply:
        print(NAME + ': 1' + reply.strip())
        break

s.close()
