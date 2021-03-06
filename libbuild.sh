#!/bin/sh
rm NAR_first_stage *.o
rm src/RuleTable.c
mv src/main_ src/main.c
sudo rm -rf /usr/local/include/ona
sudo rm /usr/local/lib/libONA.a
sudo rm /usr/local/lib/libONA.so
Str=`ls src/*.c src/NetworkNAR/*.c | xargs`
echo $Str
echo "Compilation started:"
BaseFlags="-pthread -lpthread -D_POSIX_C_SOURCE=199506L -pedantic -std=c99 $Str -lm"
gcc -DSTAGE=1 -Wall -Wextra -Wformat-security $BaseFlags -oNAR_first_stage
echo "First stage done, generating RuleTable.c now, and finishing compilation."
mv src/main.c src/main_
Str=`ls src/*.c src/NetworkNAR/*.c | xargs`
BaseFlags="-pthread -lpthread -D_POSIX_C_SOURCE=199506L -pedantic -std=c99 $Str -lm"
./NAR_first_stage NAL_GenerateRuleTable > ./src/RuleTable.c
gcc -c -DSTAGE=2 $BaseFlags src/RuleTable.c
ar rcs libONA.a *.o
rm -rf *.o NAR_first_stage
gcc -c -fPIC -DSTAGE=2 $BaseFlags src/RuleTable.c
gcc -shared -o libONA.so *.o
rm -rf *.o
sudo mkdir /usr/local/include/ona/
sudo cp src/*.h /usr/local/include/ona/
sudo mkdir /usr/local/include/ona/NetworkNAR/
sudo cp src/NetworkNAR/*.h /usr/local/include/ona/NetworkNAR/
sudo cp *.a /usr/local/lib/
sudo cp *.so /usr/local/lib/
mv src/main_ src/main.c
echo "Done."
