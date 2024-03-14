# new Env('人保农场');
#by-莫老师，版本1.3
#微信小程序picc爱心农场nongchang.maxrocky.com，抓包skey，青龙创建变量rbnc，值为skey
#cron:25 * * * *
ck=($(echo $rbnc | sed 's/&/ /g'))
url=nongchang.maxrocky.com
buy(){
msg=$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"skey":"'${ck[$s]}'","type":"seeds","buyId":'$buyid',"num":1}' "https://$url/index.php?s=index%2Findex%2FbuyGoods" | jq -r '.errMsg')
if [[ $msg == *"购买成功"* ]]; then
echo "账号$s种植$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"skey":"'${ck[$s]}'","seedId":'$buyid',"lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FuserCrops" | jq -r '.errMsg')"
echo "账号$s浇水$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"wateringCrops","skey":"'${ck[$s]}'","lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
echo "账号$s施肥$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"fertilizeCrops","skey":"'${ck[$s]}'","lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
echo "账号$s除草$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"weedCrops","skey":"'${ck[$s]}'","lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
echo "账号$s除虫$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"killDebug","skey":"'${ck[$s]}'","lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
elif [[ $msg == *"等级不足"* || $msg == *"每日最多"* ]]; then
echo "购买$buyid种子失败$msg"
if [ "$buyid" = 11 ]; then
echo "失败次数过多跳过账号$s"
break
fi
let buyid--
buy
elif [[ $msg == *"太频繁了"* ]]; then
echo "稍等一会$msg"
sleep 61s
buy
fi
}
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
echo "账号$s一键收获$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"harvestFruitAll","skey":"'${ck[$s]}'","order_id":1}' "https://nongchang.maxrocky.com/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
echo "账号$s一键铲除$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"skey":"'${ck[$s]}'"}' "https://nongchang.maxrocky.com/index.php?s=index%2Findex%2FshovelFruit" | jq -r '.errMsg')"
echo "账号$s出售$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"sellType":"fruit","type":"all","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FuserSell" | jq -r '.errMsg')"
tmp=$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FgetUserSeed")
level=$(echo "$tmp" | perl -n -e 'print "$&\n" if /"level":\K\d+/')
lands=$(($level+1))
if [ $lands -gt 9 ]; then
lands=9
fi
land=($(echo "$tmp" | sed 's/,/\n/g' | grep "landId" | awk -F ":" '{print $2}'))
landed=($(echo "${land[@]}" | tr ' ' '\n' | sort | awk 'BEGIN{for(i=1;i<='$lands';i++)a[i]=0} {a[$1]=1} END{for(i=1;i<='$lands';i++)if(a[i]==0)print i}'))
buyid=$(($level+12))
if [ "$(date +%u)" -eq 1 ]; then
for i in userSell upgradeReminder returnReward helpFriends getbablance LiveStreaming
do
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"'$i'","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
done
fi
if [ "$(date +%H)" -eq 1 ]; then
for i in $(seq $lands)
do
echo "账号$s浇水$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"wateringCrops","skey":"'${ck[$s]}'","lid":"'$i'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
done
echo "账号$s购买狗💩$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"skey":"'${ck[$s]}'","type":"decate","buyId":12,"num":2}' "https://$url/index.php?s=index%2Findex%2FbuyGoods" | jq -r '.errMsg')"
for i in BrowseYouyang CourtesyPets awardShare dogfood harvestFruitShare shareTimeline sign LovePets
do
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"'$i'","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
done
for i in $(seq 3)
do
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"edproducts","skey":"'${ck[$s]}'","edproducts_name":"人保寿险美满鑫家年金保险(分红型)"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"recall","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"invition","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
done
for i in $(seq 6)
do
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"wateringByFriends","skey":"'${ck[$s]}'"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
sleep 1s
done
echo "账号$s执行任务$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"type":"questionBank","skey":"'${ck[$s]}'","type_id":9,"userAnswer":"A"}' "https://$url/index.php?s=index%2Findex%2FsetUserLog" | jq -r '.errMsg')"
fi
for i in ${landed[@]}
do
buy
done
echo "........................................"
done