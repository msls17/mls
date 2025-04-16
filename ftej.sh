# new Env('福田e家');
#by-莫老师，版本1.3
#青龙创建变量ftej，值为账号@密码，100积分等于1元，平均一天约100分
#cron:10 1 * * *
zh=($(echo $ftej | sed 's/&/ /g'))
appkey=7918d2d1a92a02cbc577adb8d570601e72d3b640
token=ebf76685e48d4e14a9de6fccc76483e3
ftapptoken=58891364f56afa1b6b7dae3e4bbbdfbfde9ef489
url=czyl.foton.com.cn
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
phone=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
pass=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
tmp=$(curl -sk -X POST -H "Content-Type: application/json;charset=utf-8" -H "Host: $url" -H "app-key: $appkey" -d '{"password":"'$pass'","version_name":"7.3.23","version_auth":"IUHlVJDl3C5eUpe4T5pJfw\u003d\u003d","device_id":"isAppMarket","device_model":"Redmi23049RAD8C","ip":"","name":"'$phone'","version_code":"316","deviceSystemVersion":"13","device_type":"0"}' "https://$url/ehomes-new/homeManager/getLoginMember")
code=$(echo $tmp | jq -r '.data.memberComplexCode')
uid=$(echo $tmp | jq -r '.data.uid')
memberid=$(echo $tmp | jq -r '.data.memberID')
content=$(curl -sk http://ililil.cn:66/api/yy.php | awk -F "," '{print $2}')
if [ $(expr length "$content") -lt 10 ]; then
content=福田汽车veryveryverygood
fi
tzid=$(curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1,"content":"'$content'","postType":1,"topicIdList":[290],"uploadFlag":3,"title":"","urlList":[]}' "https://$url/ehomes-new/ehomesCommunity/api/post/addJson2nd" | jq -r '.data.postId')
sleep $((RANDOM % 60))
curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1}' "https://$url/ehomes-new/homeManager/api/bonus/signActivity2nd" >/dev/null
sleep $((RANDOM % 60))
curl -sk -X POST -H "Content-Type: application/json;charset=utf-8" -H "Host: $url" -H "app-key: $appkey" -d '{"safeEnc":'$(($(date '+%s%3N')-20220202))',"activity":"","tel":"'$phone'","id":"33","source":"APP","memberId":"'$code'"}' "https://$url/ehomes-new/homeManager/api/bonus/addIntegralForShare" >/dev/null
sleep $((RANDOM % 60))
gzid=$((RANDOM + 8010000))
curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1,"behavior":"1","memberIdeds":"'$gzid'","navyId":"null"}' "https://$url/ehomes-new/ehomesCommunity/api/post/follow2nd" >/dev/null
sleep $((RANDOM % 60))
curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1,"behavior":"2","memberIdeds":"'$gzid'","navyId":"null"}' "https://$url/ehomes-new/ehomesCommunity/api/post/follow2nd" >/dev/null
sleep $((RANDOM % 60))
curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$memberid'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1,"postId":'$tzid'}' "https://$url/ehomes-new/ehomesCommunity/api/mine/delete" >/dev/null
sleep $((RANDOM % 60))
#临时活动
curl -sk -X POST -H "Host: $url" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "encryptMemberId=$code" "https://czyl.foton.com.cn/shareCars/c250401/getShare.action" | jq -r '.msg'
num=$(curl -sk -X POST -H "Host: $url" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "encryptMemberId=$code" "https://czyl.foton.com.cn/shareCars/c250401/getDrawNum.action" | jq -r '.data.remainNum')
for l in $(seq $num);do
award=$(curl -sk -X POST -H "Host: $url" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "encryptMemberId=$code&activityNum=250401" "https://czyl.foton.com.cn/shareCars/c250401/luckyDraw.action" | jq -r '.msg')
echo "$phone第$l次抽奖$award"
if [ "$award" = "很遗憾，未中奖！" ]; then
sleep 5
else
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"福田e家'$phone'中奖了'$award'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
sleep 5
done
#临时活动
echo "$phone任务运行成功，稍等一会儿积分到账"
echo "福田e家帐号$phone目前积分$(curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$memberid'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-20220202))',"businessId":1}' "https://$url/ehomes-new/homeManager/api/Member/findMemberPointsInfo" | jq -r '.data.pointValue')"
echo "############"
done