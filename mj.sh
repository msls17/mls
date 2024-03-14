# new Env('MGlike');
#app:MGlike，域名social.saicmg.com
#抓token和watch-man-token
#变量名mjck值为token@watch-man-token
#抓一次有效20天，如果被安全锁定，请重新抓
#by-莫老师，版本1.3
#cron:5 7 * * *
zh=($(echo $mjck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
tmp=$(curl -sk -X POST -H "Host: social.saicmg.com" -H "token: $(echo ${zh[$s]} | awk -F "@" '{print $1}')" -H "watch-man-token: $(echo ${zh[$s]} | awk -F "@" '{print $2}')" -H "content-type: application/json; charset=UTF-8" -d '{"token":"'$ck'","brandCode":"2","timestamp":"'$(date '+%s%3N')'"}' "https://social.saicmg.com/api/energy/task/app/dailySignInV2?brandCode=2")
result=$(echo "$tmp" | sed 's/,/\n/g' | grep "resultCode" | awk -F ":" '{print $2}')
if [ "$result" = 200 ]; then
jf=$(echo "$tmp" | sed 's/,/\n/g' | grep "point" | awk -F ":" '{print $2}')
cj=$(echo "$tmp" | sed 's/,/\n/g' | grep "luckyDrawNum" | awk -F ":" '{print $2}')
echo "MGlike账号$s签到成功本次积分$jf，抽奖$cj"
elif [ "$result" = 21103 ]; then
echo "MGlike账号$s已被安全锁定，请更新ck"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"MGlike账号'$s'已被安全锁定请更新ck","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
echo "MGlike账号$s的ck失效请重新抓"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"MGlike账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
done