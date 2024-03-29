#!/bin/bash
# new Env('埃安汽车');
#by-莫老师，版本1.4
#抓www.gacne.com.cn/store/oauth/snslogin
#一天不到一分钱，有点鸡肋，变量名aack值为uid的值
#cron:0 7 * * *
uid=($(echo $aack | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#uid[@]}-1)))
do
ck=$(curl -sik -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Host: www.gacne.com.cn" -d "uid=${uid[$s]}&type=3&version=3.5.0" "https://www.gacne.com.cn/store/oauth/snslogin" | sed 's/,/\n/g' | grep "PHPSESSID" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
msg=$(curl -sk -X POST -H "Host: www.gacne.com.cn" -H "Content-Type: application/json" -H "Cookie: PHPSESSID=$ck" -d '{"taskTypeCode":"TASK-INTEGRAL-SIGN-IN"}' "https://www.gacne.com.cn/newv1/lifemain/task-mapi/sign-in" | jq -r '.msg')
for i in $(seq 2 1 11)
do
curl -sk -X POST -H "Host: www.gacne.com.cn" -H "Content-Type: application/json" -H "Cookie: PHPSESSID=$ck" -d '{"boxId":'$i',"type":0}' "https://www.gacne.com.cn/newv1/lifemain/frontend/box/draw" | jq -r '.msg'
done
if [ -z "$msg" ]; then
echo "埃安账号$s签到成功"
else
echo "$msg"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"埃安账号'$s'，'$msg'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
done