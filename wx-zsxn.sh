# new Env('wx-招商信诺');
#by-莫老师，版本1.3
#招商信诺小程序
#cron:30 1 * * *
appid=wx9e80e31a38b1ccde
url=iuss.cignacmb.com
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，萝卜未启动"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
exit
fi
else
for s in $(seq 0 1 $((${#code[@]}-1)))
do
tmp=$(curl -sik -X POST -H "Host: $url" -H "content-type: application/json" -d '{"code":"'${code[$s]}'"}' "https://$url/iuss-edge-mini/mini/interface/miniLogin")
token=$(echo "$tmp" | sed 's/,/\n/g' | grep "jwtToken" | awk -F ":" '{print $2}' | sed 's/ //g')
if [[ "$(date +%d)" -eq 13 || "$(date +%d)" -eq 28 ]]; then
unionId=$(echo "$tmp" | sed 's/,/\n/g' | grep "unionId" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')
sleep $[$RANDOM%10]s
curl -sk -X GET -H "Host: ililil.cn" "http://ililil.cn:66/zsxn/api.php?unionId=$unionId"
unionIds=($(curl -sk -X GET -H "Host: ililil.cn" "http://ililil.cn:66/zsxn/unionIds" | sed 's/\n/ /g'))
for i in ${unionIds[@]}
do
curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d '{"inviteUnionId":"'$i'"}' "https://$url/iuss-edge-mini/mini/mmd/help" | jq -r '.message'
done
for i in $(seq 4)
do
curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d "" "https://$url/iuss-edge-mini/mini/mmd/draw" | jq -r '.message'
done
fi
ids=($(curl -sk -X GET -H "Host:$url" -H "jwttoken: $token" -H "content-type: application/json" "https://$url/iuss-edge-mini/mini/activity/getBubbleList" | jq -r '.data[].id'))
curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d '{"ids":['$(echo "${ids[@]}" | sed 's/ /,/g')']}' "https://$url/iuss-edge-mini/mini/activity/revMilkyTea" | jq -r '.message'
for i in $(seq 2)
do
curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d '{"taskCode":"browse_video","bizCode":"CARE0713101628000'$i'"}' "https://$url/iuss-edge-mini/mini/task/complete" | jq -r '.message'
curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d '{"taskCode":"browse_video"}' "https://$url/iuss-edge-mini/mini/task/reward" | jq -r '.message'
done
tmp=$(curl -sk -X GET -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" "https://$url/iuss-edge-mini/mini/question/get?activityNo=milkyTea")
topic=$(echo "$tmp" | jq -r '.data.content')
if [ "$topic" = 已完成本期问答 ]; then
echo "账号$s已经答过了"
else
activity=$(echo "$tmp" | jq -r '.data.activityId')
answer=$(curl -sk -X GET -H "Host: ililil.cn" "http://ililil.cn:66/zsxn/answer")
dt=$(curl -sk -X POST -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" -d '{"content":"'$answer'","activityId":'$activity'}' "https://$url/iuss-edge-mini/mini/question/reply" | jq -r '.data')
if [ "$dt" = true ]; then
curl -sk -X GET -H "Host: $url" -H "jwttoken: $token" -H "content-type: application/json" "https://$url/iuss-edge-mini/mini/activity/questionAward" | jq -r '.message'
else
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"招商信诺奶茶活动答题错误，请手动答题或等待答案更新","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
fi
done
fi
}
getcode
