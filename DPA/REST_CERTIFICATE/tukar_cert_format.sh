#!/bin/bash

pwd1=`pwd`

# openssl x509 -outform der -in server.pem -out server.cer
# openssl x509 -inform der -in server.cer -out server.pem

echo
echo "DARI MANA NAK KE MANA?"
echo "1) .PEM -> .CER"
echo "2) .CER -> .PEM"
echo
echo -n "Choose [ 1 / 2 ] : "
read -e pilihan

if [ $pilihan == 1 ]
then
echo
echo -n "FILE INPUT .PEM (must exist in this directory $pwd1) : "
read -e input1
echo 
echo -n "FILE OUTPUT .CER (suggest to put .cer at the end of filename) : "
read -e output1
echo
openssl x509 -outform der -in "$pwd1"/"$input1" -out "$pwd1"/"$output1"

elif [ $pilihan == 2 ]
then
echo
echo -n "FILE INPUT .CER (must exist in this directory $pwd1) : "
read -e input1
echo
echo -n "FILE OUTPUT .PEM (suggest to put .pem at the end of filename) : "
read -e output1
echo
openssl x509 -inform der -in "$pwd1"/"$input1" -out "$pwd1"/"$output1"

else
echo
echo "WRONG CHOICE - $pilihan out of range"
echo
fi
