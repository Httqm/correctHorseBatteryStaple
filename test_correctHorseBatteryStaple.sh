#!/usr/bin/env bash

scriptName='correctHorseBatteryStaple.sh'

for language in en fr both aa; do
	for nbWords in '' 6 8 100 a; do
		"./$scriptName" "$language" "$nbWords"
		echo '============================'
	done
done
