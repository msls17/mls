#!/bin/bash
# new Env('wx-联通微厅');
#by-莫老师，版本1.0，一个月约100分，一块钱
#cron:45 0 * * *
url=weixin.10010.com
appid=wx24603f132a6753ea
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
ck=$(curl -sik -X GET -H "Host: $url" "http://$url/wxagent/oauth2?code=${code[$s]}&state=weitingsign_page" | sed 's/,/\n/g' | grep "TOKEN" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
echo "账号$s签到获得$(curl -sk -X GET -H "Host: $url" -H "Cookie: TOKEN=$ck" "http://$url/wxActivity/wtsign/signPage" | sed 's/,/\n/g' | grep "jiaJf\">+" | awk -F ">" '{print $3}' | awk -F "<" '{print $1}')分"
curl -sk -X GET -H "Host: $url" -H "Cookie: TOKEN=$ck" "http://$url/wxActivity/wtsign/goto?type=fgzq"
curl -sk -X GET -H "Host: $url" -H "Cookie: TOKEN=$ck" "http://$url/wxActivity/wtsign/goto?type=ltkb"
echo "………………………………"
done
fi
}
getcode
