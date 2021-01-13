#!/bin/bash

sed -E 's:/home/alunos/:/srv/students/:' /etc/passwd > passwd.new
