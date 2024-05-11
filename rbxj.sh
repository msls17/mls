# new Env('人保小鸡');
#by-莫老师，版本1.5，一天20币
#中国人保app内的小鸡爱运动，抓包https://m.picclife.cn/chicken/?user_id，创建变量rbxj，值为user_id
#cron:0/20 * * * *
time=$(date +"%Y-%m-%d")
user=($(echo $rbxj | sed 's/&/ /g'))
url=m.picclife.cn
rm -rf rbxj.log
for s in $(seq 0 1 $((${#user[@]}-1)))
do
token[$s]=$(curl -sk -X GET -H "Host: $url" "https://$url/chicken-api/h5login?userId=${user[$s]}" | jq -r '.access_token')
done
for s in $(seq 0 1 $((${#token[@]}-1)))
do
tmp=$(curl -sk -X GET -H "Host: $url" -H "Authorization: bearer${token[$s]}" "https://$url/chicken-api/p/chicken/userinfo")
per=$(echo "$tmp"  | jq -r '.result.eggPer')
quantity=$(echo "$tmp"  | jq -r '.result.feedfoodQuantity')
coin=$(echo "$tmp"  | jq -r '.result.coinCount')
egg=$(echo "$tmp"  | jq -r '.result.eggCount')
if [ "$(date +%H)" -eq 1 ]; then
echo "签到$(curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/tashdailyfinish?clockNumber=1&foodQuantity=0"  | jq -r '.message')"
fi
if [ "$egg" -ge 9 ]; then
curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/v2UseCarNo?awardType=3" | jq -r '.message'
echo "卖蛋$(curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/eggsellall" | jq -r '.message')"
fi
if [ "$per" -eq 100 ]; then
echo "收蛋$(curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/collectegg" | jq -r '.result')"
fi
if [ "$quantity" -eq 0 ]; then
curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/tashfinish?tashId=1" | jq -r '.message'
curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/tashcollectall" | jq -r '.message'
echo "喂养$(curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/addfeedfood_v3?foodQuantity=1800" | jq -r '.message')"
curl -sk -X POST -H "Host: $url" -H "Authorization: bearer${token[$s]}" -d "" "https://$url/chicken-api/p/chicken/v2UseCarNo?awardType=2" | jq -r '.message'
fi
echo "账号$s，剩余$quantity饲料，鸡蛋进度$per，金币$coin"
done