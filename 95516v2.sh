#!/bin/bash
# new Env('95516v2');
#by-莫老师，版本2.0
#cron:* * * * *
openid=($(echo $yl | sed 's/&/ /g'))
url=www.wellwhales.com
rm -rf 95516v2.log
cj(){
for s in $(seq 0 1 $((${#openid[@]}-1)))
do
tmp=$(curl -sk -X POST -H "Host: $url" -d "" "https://$url/fans/activity//chouj?openid=${openid[$s]}")
msg=$(echo "$tmp" | jq -r '.msg')
if [[ "$msg" == *"noNum"* ]]; then
echo "$s无抽奖次数"
elif [ "$msg" = "3" ] || [ "$msg" = "5" ] || [ "$msg" = "7" ]; then
echo "$msg没中"
sleep 1
else
jp=$(echo "$tmp" | jq -r '.gift.giftName')
printf "${openid[$s]}，$jp换行" >>95516.log
echo "${openid[$s]}，$jp"
sleep 5
fi
done
if [ -f "95516v2.log" ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "content-type: application/json" -d '{"appToken":"'$apptoken'","content":"'$(cat 95516v2.log | sed 's/换行/\\n/g')'","summary":"95516抽奖结果","contentType":1,"topicIds":['$topicId'],"verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
}
water=$(curl -sk -X POST -H "Host: $url" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "" "https://$url/fans/activity//userReceived?openid=${openid[0]}" | jq -r '.zjlist[].createDate' | grep ''$(date +%Y-%m-%d)'' | wc -l)
if [ $water -gt $(cat 95516v2) ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"95516可能放水了,当前中奖人数'$water'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
cj
fi
if [ "$(date +%H%M)" -lt "0020" ]; then
for s in $(seq 0 1 $((${#openid[@]}-1)))
do
for i in $(seq 6)
do
curl -sk -X POST -H "Host: $url" -d "" "https://$url/fans/activity//play?openid=${openid[$s]}" >/dev/null
sleep 2s
done
done
fi
if [ "$(date +%H%M)" -eq 2200 ] || [ "$(date +%H%M)" -eq 2230 ] || [ "$(date +%H%M)" -eq 2300 ] || [ "$(date +%H%M)" -eq 2320 ] || [ "$(date +%H%M)" -eq 2340 ] || [ "$(date +%H%M)" -eq 2350 ]; then
cj
fi
echo "$water" >95516v2
