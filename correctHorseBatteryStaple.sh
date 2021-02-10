#!/usr/bin/env bash
######################################### correctHorseBatteryStaple.sh ##############################
# Password generator inspired by : https://www.xkcd.com/936/
########################################## ##########################################################

nameOfthisScript="${BASH_SOURCE[0]}"
numberOfWordsInPassword=4


usage() {
	cat << EOF
usage : $nameOfthisScript <language>

	language :
		'en' : use an english dictionary (default)
		'fr' : use a  french  dictionary
EOF
	}


countDictionaryWords() {
	local dictionaryFile=$1
	wc -l "$dictionaryFile" | cut -d' ' -f1
	}


generateRandomNumbers() {
	local maxNumber=$1
	local numberOfRandomNumbers=$2
	shuf -i 1-"$maxNumber" -n "$numberOfRandomNumbers"
	}


getDictionaryFile() {
	local language=$1
	local dictionaryFile
	case "$language" in
		'en')
			dictionaryFile='./words_alpha.txt'
			;;
		'fr')
			dictionaryFile='./336531 mots de la langue française.txt'
			;;
		*)
			usage
			exit 1
			;;
	esac
	echo "$dictionaryFile"
	}

main() {
	local language=${1:-en}
	local dictionaryFile=$(getDictionaryFile "$language")

	nbAvailableWords=$(countDictionaryWords "$dictionaryFile")
	GeneratedPassword=''
	for i in $(generateRandomNumbers "$nbAvailableWords" "$numberOfWordsInPassword"); do
		GeneratedPassword+=$(sed -n "$i p" "$dictionaryFile")' '
	done
	echo -e "$GeneratedPassword"
	}


main "$@"
