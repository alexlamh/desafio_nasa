#!/bin/bash

export DAYS=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31")

mkdir -p tmp_folder

TMP=$(pwd)/tmp_folder
file=$(pwd)/data/access_log_Aug95
#file=$(pwd)/data/access_log_Jul95

echo "=== Quantidade de hosts unicos === "
cat $file | awk '{print $1}' | sort | uniq | wc -l

echo
echo "=== Quantos erros 404 são encontrados nos logs === "
cat $file | grep " 404 " > $TMP/errorhosts.tmp
cat $TMP/errorhosts.tmp | wc -l

echo
echo "=== Erros 404 por dia === "
for i in "${DAYS[@]}"
do
	echo "Dia $i -" $(cat $TMP/errorhosts.tmp | grep "\[$i" | wc -l)
done

echo
echo "=== Qtds bytes retornados === "
SIZE=$(cat $file | grep -v " 404 " | awk '{s+=$NF} END {print s / 1024 / 1024 /1024 " MB"}')
echo $SIZE

echo
echo "=== Top 5 dominios de erros 404 === "
cat $TMP/errorhosts.tmp | awk '{print $1}' | sort | uniq -c | sort -rn | head -5

rm -f -r $TMP

