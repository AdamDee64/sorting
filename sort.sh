export PATH=/home/adam/Odin:$PATH
if ! test -d bin; then mkdir bin; fi
odin run . -out:./bin/sort