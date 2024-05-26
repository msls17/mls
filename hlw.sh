#!/bin/bash
# new Env('wx-葫芦娃茅台');
#by-莫老师，版本1.4
#cron:5 10 * * *
host=gw.huiqunchina.com
wxappid=(wxded2e7e6d60ac09d@偲源惠购 wx61549642d715f361@贵旅优品 wx613ba8ea6a002aa8@空港乐购 wx936aa5357931e226@航旅黔购 wx624149b74233c99a@遵航出山 wx5508e31ffe9366b8@贵盐黔品 wx821fb4d8604ed4d6@乐旅商城 wxee0ce83ab4b26f9c@驿路黔寻)
today=$(date '+%Y-%m-%d')
method=POST
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，无法访问code服务器"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
exit
fi
fi
}
getsign() {
time=$(date -u +"%a, %d %b %Y %H:%M:%S GMT")
sign=$(echo "$(printf "$method\n$url\n\n$ak\n$time\n")" | openssl dgst -sha256 -hmac "$sk" -binary | openssl base64)
digest=$(echo -n "$body" | openssl dgst -sha256 -hmac "$sk" -binary | base64)
tmp=$(curl -sk -X POST -H "Host: $host" -H "X-HMAC-Date: $time" -H "dataType: json" -H "X-HMAC-DIGEST: $digest" -H "Content-Type: application/json" -H "channelid: $chanid" -H "X-HMAC-SIGNATURE: $sign" -H "X-HMAC-ALGORITHM: hmac-sha256" -H "Channel: miniapp" -H "X-HMAC-ACCESS-KEY: $ak" -H "X-access-token: $token" -d "$body" "https://$host$url")
}
for s in $(seq 0 1 $((${#wxappid[@]}-1)));do
appid=$(echo ${wxappid[$s]} | awk -F "@" '{print $1}')
name=$(echo ${wxappid[$s]} | awk -F "@" '{print $2}')
tmp=$(curl -sk -X POST -H "Host: callback.huiqunchina.com" -H "content-type: application/json" -d '{"appId":"'$appid'"}' "https://callback.huiqunchina.com/api/getInfo")
ak=$(echo "$tmp" | jq -r '.data.ak')
sk=$(echo "$tmp" | jq -r '.data.sk')
url=/front-manager/api/get/channelId
body='{"appId":"'$appid'"}'
getsign
chanid=$(echo "$tmp" | jq -r '.data')
url=/front-manager/api/customer/promotion/channelActivity
body='{}'
getsign
activity=$(echo "$tmp" | jq -r '.data.id')
edtime=$(date -d @$(echo "$tmp" | jq -r '.data.appointEndTime' | cut -c1-10) +%Y-%m-%d)
cjtime=$(date -d @$(echo "$tmp" | jq -r '.data.drawTime' | cut -c1-10) +%Y-%m-%d)
if [ "$cjtime" = "$today" ] || [ "$edtime" = "$today" ]; then
getcode
for i in $(seq 0 1 $((${#code[@]}-1)));do
url=/front-manager/api/login/wxMiniLogin
body='{"appId":"'$appid'","code":"'${code[$i]}'"}'
getsign
token=$(echo "$tmp" | jq -r '.data.token')
if [ "$cjtime" = "$today" ]; then
url=/front-manager/api/customer/promotion/queryLotteryRecord
body='{"page":{"pageNo":1,"pageSize":20}}'
getsign
zqsj=($(echo "$tmp" | jq -r '.data.list[].activityTime'))
for t in "${zqsj[@]}";do
if [ "$(date -d "@$t" '+%Y-%m-%d')" == "$today" ]; then
echo "账号$i$name$today已中签"
else
echo "账号$i$name$today未中签"
fi
done
fi
if [ "$edtime" = "$today" ]; then
url=/front-manager/api/customer/promotion/appoint
body='{"activityId":'$activity',"channelId":'$chanid'}'
getsign
if [[ "$tmp" == *"验证码"* ]]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"'$(echo "$tmp" | jq -r '.message' | sed 's/\"//g')'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
echo "账号$i$name$(echo "$tmp" | jq -r '.message')"
fi
done
else
echo "$name$today无活动"
fi
unset token
done