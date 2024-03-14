#!/bin/bash
# new Env('招商信诺');
#招商信诺app微信登陆绑定手机，然后抓微信小程序招商信诺服务中心的包https://member.cignacmb.com/mini/member/interface/login
#青龙填写变量zsxn，值为unionid@miniopenid@mobile，多个账号就创建多个变量
#by-莫老师，版本1.1
#cron:30 */3 * * *
ck=($(echo $zsxn | sed 's/&/ /g'))
url=hms.cignacmb.com
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
token=$(curl -sik -X POST -H "Host: member.cignacmb.com" -H "content-type: application/x-www-form-urlencoded" -d "param=%7B%22unionid%22%3A%22$(echo ${ck[$s]} | awk -F "@" '{print $1}')%22%2C%22miniOpenId%22%3A%22$(echo ${ck[$s]} | awk -F "@" '{print $2}')%22%2C%22mobile%22%3A%22$(echo ${ck[$s]} | awk -F "@" '{print $3}')%22%2C%22miniOpenid%22%3A%22$(echo ${ck[$s]} | awk -F "@" '{print $2}')%22%2C%22sensorDeviceId%22%3A%22$(echo ${ck[$s]} | awk -F "@" '{print $2}')%22%7D" "https://member.cignacmb.com/mini/member/interface/login" | sed 's/,/\n/g' | grep "token" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/ //g')
hour=$(date +%H)
if [ $hour -ge 6 ] && [ $hour -le 8 ]; then
echo "账号$s$(curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "" "http://$url/activity/appCheck/appCheckIn" | jq -r '.msg')"
echo "账号$s早起$(curl -sk -X GET -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" "http://$url/activity/checkin/dailyCheckin?operateType=0" | jq -r '.msg')"
tmp=$(curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "lastTaskId=" "http://$url/health/nuo/queryHealthTaskList")
ids=($(echo "$tmp" | jq -r '.data[].id'))
codes=($(echo "$tmp" | jq -r '.data[].taskCode'))
for i in $(seq 0 1 $((${#ids[@]}-1)))
do
curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "taskId=${ids[$i]}&taskType=2&receiveAward=500&taskCode=${codes[$i]}" "http://$url/health/nuo/toComplete" >/dev/null
curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "id=${ids[$i]}&taskType=${codes[$i]}" "http://$url/health/nuo/claimYourReward" >/dev/null
done
rwcode=($(curl -sk -X GET -H "Host: $url" -H "Authorization: Bearer_$token" "http://$url/activity/cignaInvestment/getUserTaskList" | sed 's/,/\n/g' | grep "taskCode" | awk -F ":" '{print $2}' | sed 's/\"//g'))
for i in $(seq 0 1 $((${#rwcode[@]}-1)))
do
curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "taskCode=${rwcode[$i]}" "http://$url/activity/cignaInvestmentTask/updateTaskStatus" >/dev/null
done
recordId=($(curl -sk -X GET -H "Host: $url" -H "Authorization: Bearer_$token" "http://$url/activity/cignaInvestment/getUserTaskList" | sed 's/{/\n/g' | sed 's/,/\n/g' | grep "recordId" | awk -F ":" '{print $2}' | sed 's/\"//g'))
for i in $(seq 0 1 $((${#recordId[@]}-1)))
do
curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "recordId=${recordId[$i]}" "http://$url/activity/cignaInvestment/receiveCandy" >/dev/null
done
fi
echo "账号$s当前诺米$(curl -sk -X GET -H "Host: $url" -H "Authorization: Bearer_$token" -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" "http://$url/activity/appCheck/getTheMonthCheckInRecord" | jq -r '.data.totalScore')"
echo "账号$s喂糖果$(curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -d "" "http://$url/activity/cignaInvestment/investCandy" | jq -r '.msg')"
curl -sk -X POST -H "Host: $url" -H "Authorization: Bearer_$token" -d "" "http://$url/activity/cignaInvestment/receiveNaomi" | jq -r '.msg'
done