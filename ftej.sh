# new Env('福田e家');
#by-莫老师，版本1.4
#青龙创建变量ftej，值为账号@密码，100积分等于1元，平均一天约100分
#cron:10 1 * * *
zh=($(echo $ftej | sed 's/&/ /g'))
appkey=7918d2d1a92a02cbc577adb8d570601e72d3b640
token=ebf76685e48d4e14a9de6fccc76483e3
ftapptoken=58891364f56afa1b6b7dae3e4bbbdfbfde9ef489
pkt=7fe186bb15ff4426ae84f300f05d9c8d
url=czyl.foton.com.cn
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
phone=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
pass=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
tmp=$(curl -sk -X POST -H "content-type: application/json; charset=utf-8" -H "channel: 1" -H "host: $url" -d '{"memberId":"","memberID":"","mobile":"","token":"'$pkt'","vin":"","safeEnc":'$(($(date '+%s%3N')-1011010100))',"name":"'$phone'","password":"'$pass'","position":"","deviceId":"","deviceBrand":"","brandName":"","deviceType":"0","versionCode":"21","versionName":"V1.1.16"}' "https://czyl.foton.com.cn/ehomes-new/pkHome/api/user/getLoginMember2nd")
pkcode=$(echo $tmp | jq -r '.data.memberComplexCode')
pkmemberid=$(echo $tmp | jq -r '.data.user.memberNo')
pktoken=$(echo $tmp | jq -r '.data.token')
#皮卡生活
curl -sk -X POST -H "Host: $url" -H "content-type: application/json; charset=utf-8" -H "token: $pktoken" -d '{"memberId":"'$pkcode'","memberID":"'$pkmemberid'","mobile":"'$phone'","token":"'$pkt'","vin":"","safeEnc":'$(($(date '+%s%3N')-1011010100))'}' "https://$url/ehomes-new/pkHome/api/bonus/signActivity2nd" | jq -r '.data.integral'
tmp=$(curl -sk -X POST -H "Content-Type: application/json;charset=utf-8" -H "Host: $url" -H "app-key: $appkey" -d '{"password":"'$pass'","version_name":"7.4.9","version_auth":"l8szUT88Wl9U90WxUw/exQ==","device_id":"isAppMarket","device_model":"OnePlusPJE110","ip":"","name":"'$phone'","version_code":"342","deviceSystemVersion":"14","device_type":"0"}' "https://$url/ehomes-new/homeManager/getLoginMember")
code=$(echo $tmp | jq -r '.data.memberComplexCode')
uid=$(echo $tmp | jq -r '.data.uid')
memberid=$(echo $tmp | jq -r '.data.memberID')
content=$(curl -sk http://ililil.cn:88/api/yy.php | awk -F "," '{print $2}')
if [ $(expr length "$content") -lt 10 ]; then
content=福田汽车veryveryverygood
fi
tzid=$(curl -sk -X POST -H "user-agent: web" -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1,"content":"'$content'","postType":1,"topicIdList":[290],"uploadFlag":3,"title":"","urlList":[]}' "https://$url/ehomes-new/ehomesCommunity/api/post/addJson2nd" | jq -r '.data.postId')
sleep $((RANDOM % 60))

curl -sk -X POST  -H "user-agent: web" -H "accept-encoding: gzip" -H "host: czyl.foton.com.cn" -H "app-key: 7918d2d1a92a02cbc577adb8d570601e72d3b640" -H "content-type: application/json; charset=utf-8" -H "token:" -H "app-token: 58891364f56afa1b6b7dae3e4bbbdfbfde9ef489" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1}' "https://$url/ehomes-new/homeManager/api/bonus/signActivity2nd" | jq -r '.data.integral'
sleep $((RANDOM % 60))
curl -sk -X POST -H "Content-Type: application/json;charset=utf-8" -H "Host: $url" -H "app-key: $appkey" -d '{"safeEnc":'$(($(date '+%s%3N')-2022020200))',"activity":"","tel":"'$phone'","id":"33","source":"APP","memberId":"'$code'"}' "https://$url/ehomes-new/homeManager/api/bonus/addIntegralForShare" | jq -r '.data.integral'
sleep $((RANDOM % 60))

gzid=$((RANDOM + 8010000))
curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1,"behavior":"1","memberIdeds":"'$gzid'","navyId":"null"}' "https://$url/ehomes-new/ehomesCommunity/api/post/follow2nd" | jq -r '.data.integral'
sleep $((RANDOM % 60))

curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$code'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1,"behavior":"2","memberIdeds":"'$gzid'","navyId":"null"}' "https://$url/ehomes-new/ehomesCommunity/api/post/follow2nd" >/dev/null
sleep $((RANDOM % 60))

curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$memberid'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1,"postId":'$tzid'}' "https://$url/ehomes-new/ehomesCommunity/api/mine/delete" >/dev/null
sleep $((RANDOM % 60))

echo "帐号$phone福田e家目前积分$(curl -sk -X POST -H "Host: $url" -H "app-key: $appkey" -H "content-type: application/json; charset=utf-8" -H "app-token: $ftapptoken" -d '{"memberId":"'$memberid'","userId":"'$uid'","userType":"61","uid":"'$uid'","mobile":"'$phone'","tel":"'$phone'","phone":"'$phone'","brandName":"","seriesName":"","token":"'$token'","safeEnc":'$(($(date '+%s%3N')-2022020200))',"businessId":1}' "https://$url/ehomes-new/homeManager/api/Member/findMemberPointsInfo" | jq -r '.data.pointValue')"
echo "############"
done