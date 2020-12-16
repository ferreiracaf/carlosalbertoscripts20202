#!/bin/bash

grep -v "sshd" /home/compartilhado/auth.log.1

grep "(sshd:session): session opened" /home/compartilhado/auth.log.1

grep -E "sshd([[:alnum:]]|[[:punct:]]|[[:space:]])*root" /home/compartilhado/auth.log.1

grep -E "Dec[[:space:]]*4[[:space:]]*((18:[0-9]{2}:[0-9]{2})|(19:00:00))([[:alnum:]]|[[:punct:]]|[[:space:]])*sshd:session): session opened" /home/compartilhado/auth.log.1
