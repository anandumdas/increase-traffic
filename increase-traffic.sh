#!/bin/bash

#Printing Usage instruction string
USAGE="Usage: $0 -u [url] 

    -u    --url         Url
    -h    --help        Display this message and exit
"

if [[ $# -eq 0 || $1 == "-h" ]]; then
	echo "$USAGE"
	exit 1
fi




##reading the parameters and storing to respective variables
while [ $# -gt 0 ]
do
key="$1"
case $key in
    -u|--url)
    URL="$2"
    shift # past argument
    ;;
    -i|--interval)
    INTERVAL="$2"
    shift # past argument
    ;;
    -t|--time)
    TIME="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

isTorActive=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs)


if [[ "$isTorActive" == "Congratulations. This browser is configured to use Tor." ]]; then
	echo "Tor is properly used.."
else
	echo "Unable to use Tor. Please check your Tor installation"
fi

count=1
end=$((SECONDS+$TIME))
(while [ $SECONDS -lt $end ]; do
	echo "Requesting new identity and running for $count th time"
	printf "AUTHENTICATE \"password\"\r\nSIGNAL NEWNYM\r\n" | nc 127.0.0.1 9051 > /dev/null
    ((count++))
    curl -s --socks5-hostname localhost:9050 $URL > /dev/null
    sleep $INTERVAL
    :
done
echo "hit $URL for $count times.") & 
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done

echo "Task completed. Quitting..."