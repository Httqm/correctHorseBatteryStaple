#!/usr/bin/env bash
######################################### correctHorseBatteryStaple.sh ##############################
# Password generator inspired by : https://www.xkcd.com/936/
#
# Number of 4-words combinations :
#   EN :   18,761,676,639,977,538,579,601
#   FR :   12,826,267,821,863,253,109,521
# both :  249,326,411,234,100,657,610,000
########################################## ##########################################################

nameOfthisScript="${BASH_SOURCE[0]}"
minimumNumberOfWordsInPassword=4


usage() {
	cat << EOF
usage : $nameOfthisScript <language> <number of words in passphrase>

	language :
		'en'   : use an english dictionary (default)
		'fr'   : use a  french  dictionary
		'both' : combine english and french dictionaries for even more combinations
	number of words in passphrase :
		any number in the range 1..99
		defaults to 4
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

	dictionaryFileEnglish='./words_alpha.txt'
	dictionaryFileFrench='./336531 mots de la langue française.txt'
	dictionaryFileBoth='./frenchPlusEnglish.txt'
	case "$language" in
		'en')
			dictionaryFile="$dictionaryFileEnglish"
			;;
		'fr')
			dictionaryFile="$dictionaryFileFrench"
			;;
		'both')
			cp "$dictionaryFileEnglish" "$dictionaryFileBoth"
			cat "$dictionaryFileFrench" >> "$dictionaryFileBoth"
			dictionaryFile="$dictionaryFileBoth"
			;;
		*)
			usage
			exit 1
			;;
	esac
	echo "$dictionaryFile"
	}


computeNumberOfCombinations() {
	local nbWordsInDictionary=$1
	local nbWordsInPassword=$2
	numberOfCombinations=$(echo "$nbWordsInDictionary^$nbWordsInPassword" | bc | sed -r ': repeat s/([0-9]+)([0-9]{3})(\,|$)/\1,\2/; t repeat')
	echo -e "\n(1 out of $numberOfCombinations combinations)"
	}


checkArg() {
	local argToCheck="$1"
	local value="$2"
	case "$argToCheck" in
		language)
			acceptableValues='en fr both'
			[[ "$value" =~ ^(en|fr|both)$ ]] || { echo "Wrong language : '$value'"; usage; exit 1; }
			;;
		nbWords)
			# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/13089269#13089269
			# http://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Pattern-Matching
			[[ "$value" == ?(-)+([[:digit:]]) ]] || { echo "Not a number : '$value'"; usage; exit 1; }
			[ "$value" -lt 1 -o "$value" -gt 99 ] && { echo "Wrong number of words : '$value'"; usage; exit 1; }
			;;
	esac
	}


main() {
	local language=${1:-en}
	checkArg language "$language"

	local numberOfWordsInPassword=${2:-$minimumNumberOfWordsInPassword}
	checkArg nbWords "$numberOfWordsInPassword"

	local dictionaryFile=$(getDictionaryFile "$language")

	nbAvailableWords=$(countDictionaryWords "$dictionaryFile")
	GeneratedPassword=''
	for i in $(generateRandomNumbers "$nbAvailableWords" "$numberOfWordsInPassword"); do
		GeneratedPassword+=$(sed -n "$i p" "$dictionaryFile")' '
	done
	echo -e "$GeneratedPassword"
	computeNumberOfCombinations "$nbAvailableWords" "$numberOfWordsInPassword"
	}


main "$@"
