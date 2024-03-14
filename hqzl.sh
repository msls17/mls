#!/bin/bash
# new Env('wx-红旗空间');
#by-莫老师，版本3.2，一天两分，20分=1元
#cron:35 0 * * *
url=hqpp-gw.faw.cn
appid=wxf076d8670405c937
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
ck=$(curl -sik -X GET -H "Host: $url" "https://$url/gimc-hongqi-webapp/f/login?_timestamp=$(date '+%s%3N')&code=${code[$s]}" | grep "JSESSIONID" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
curl -sk -X POST -H "Host: $url" -H "cookie: JSESSIONID=$ck" -d "" "https://$url/gimc-hongqi-webapp/f/checkin/user-checkin/?_timestamp=$(date '+%s%3N')" | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
tmp=$(curl -sk -X GET -H "Host: $url" -H "cookie: JSESSIONID=$ck" "https://$url/gimc-hongqi-webapp/f/credits/userCredits/?_timestamp=$(date '+%s%3N')")
echo "红旗账号$(echo "$tmp" | jq -r '.data.phone')目前积分$(echo "$tmp" | jq -r '.data.amount')"
done
fi
}
getcode