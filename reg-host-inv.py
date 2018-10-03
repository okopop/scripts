#!/bin/python
import argparse
import os.path
import socket

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--fqdn", required=True, help="Host FQDN")
parser.add_argument("-o", "--os", required=True, help="SLES or RHEL")
parser.add_argument("-v", "--vlan", required=True, help="VLAN-ID")
parser.add_argument("-s", "--system", required=True, help="System name")
args = vars(parser.parse_args())

# set
server = args["fqdn"]
os = args["os"]
vlan =  args["vlan"]
system = args["system"]
inv_id = server[2:8]

def print_variables():
  print("--------------------")
  print("Inv-id: {}".format(inv_id))
  print("FQDN: {}".format(server))
  print("OS: {}".format(os_value))
  print("VLAN: {}".format(vlan))
  print("System: {}".format(system))
  print("--------------------")
  print(socket.gethostname())
 
def os_check():
  global os_value
  if os == "sles":
    os_value = "SUSE Linux Enterprise Server"
  elif os == "rhel":
    os_value = "Red Hat Enterprise Linux"
  else:
    print("Abort script: Operating System not supported")
    exit()
 
# functions
def yes_or_no(question):
  while "the answer is invalid":
    reply = str(raw_input(question+' (y/n): ')).lower().strip()
    if reply[:1] == 'y':
      return True
    if reply[:1] == 'n':
      print("Abort script...")
      exit()     

def login_cred():
  #if os.path.isfile('./passfile'):
  #  print "File exists and is readable"
  #else:
  #  print "Passfile is missing"
  login_user = "xxx"
  login_pw = open("passfile","r")
  print login_pw.read()

# run it
os_check()
login_cred()
print_variables()
yes_or_no("Register host. Is above correct?")

print("Continue script...")
