#!/bin/bash
# new Env('益禾堂');
#by莫老师，版本1.0
#益禾堂手机点单小程序，打开后授权手机号登录，抓包链接https://webapi.qmai.cn/web/seller/account/login-minp抓响应里的id和token，变量值yht填写token@id，多账号&f分割或创建多个变量
#cron:5 6 * * *
zh=($(echo $yht | sed 's/&/ /g'))
appid=wx4080846d0cec2fd5
url=webapi.qmai.cn
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
token=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
tmp=$(curl -sk -X POST -H "Host: $url" -H "qm-from: wechat" -H "qm-user-token: $token" -H "content-type: application/json" -d '{"activityId":"959131182653300737","appid":"'$appid'"}' "https://$url/web/cmk-center/sign/takePartInSign")
if [[ "$tmp" == *"登录超时"* ]]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"益禾堂账号'$s'失效","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
sleep 1
name=($(echo "$tmp" | jq -r '.data.rewardDetailList[].rewardName'))
num=($(echo "$tmp" | jq -r '.data.rewardDetailList[].sendNum'))
echo "账号$s签到获得${name[@]}"
for i in $(seq 0 1 $((${#zh[@]}-1)))
do
if [ "$i" = "$s" ]; then
continue
else
id=$(echo ${zh[$i]} | awk -F "@" '{print $2}')
echo "助力$i$(curl -sk -X POST -H "Host: $url" -H "qm-from: wechat" -H "qm-user-token: $token" -H "content-type: application/json" -d '{"helpUserId":"'$id'","activityId":"984038591192444929","appid":"'$appid'"}' "https://$url/web/cmk-center/lottery/userHelp" | jq -r '.message')"
sleep 1
fi
done
fi
wait
done
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
token=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
cs=$(curl -sk -X POST -H "Host: $url" -H "qm-from: wechat" -H "qm-user-token: $token" -H "content-type: application/json" -d '{"activityId":"984038591192444929","appid":"'$appid'"}' "https://$url/web/cmk-center/lottery/userLotteryTimes" | jq -r '.data.totalResidueTimes')
sleep 1
for a in $(seq $cs)
do
echo "账号$s第$a次抽奖：$(curl -sk -X POST -H "Host: $url" -H "qm-from: wechat" -H "qm-user-token: $token" -H "content-type: application/json" -d '{"activityId":"984038591192444929","appid":"'$appid'"}' "https://$url/web/cmk-center/lottery/takePartInLottery" | jq -r '.data.clientRewardVo.customerRewardName')"
sleep 1
done
done