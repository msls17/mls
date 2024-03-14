#!/bin/bash
# new Env('wx-三国杀移动版');
#by-莫老师，版本1.1，一个月150豆
#cron:55 0 * * *
url=mwx.sanguosha.cn
appid=wx21f2a9fbae658cd7
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，萝卜未启动"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
exit
fi
else
for s in $(seq 0 1 $((${#code[@]}-1)))
do
sgsck=$(curl -sik -X GET -H "Host: $url" "http://$url/api/wx/authorize?redirects=http%3A%2F%2F$url%2Fweb%2Fgift.html&code=${code[$s]}" | grep "laravel_session" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
echo -e "账号$s$(curl -sk -X POST -H "Host: $url" -H "Cookie: laravel_session=$sgsck" -d "" "http://$url/api/act/signin" | sed 's/,/\n/g' | grep "error" | awk -F ":"  '{print $2}')"
sleep 3s
done
fi
}
getcode