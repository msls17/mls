#!/bin/bash
# new Env('联通云盘-刮刮乐');
#by-莫老师，版本1.0
#活动地址:https://panservice.mail.wo.cn/h5/activitymobile/scratch?clientType=iOS&clientId=1001000229&activityId=mcGM6BOC2/XPOJnsZQYjNw==&appVersionCode=2.1.6&clientid=1001000035。抓包access-token，青龙变量名ltyp，值为access-token，抓一次有效7天
#cron:18 0 * * *
token=($(echo $ltyp | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#token[@]}-1)))
do
tmp=$(curl -sk -X POST -H "Host: panservice.mail.wo.cn" -H "access-token: ${token[$s]}" -H "content-type: application/json" -H "client-id: 10086" -d '{"bizKey":"newLottery","bizObject":{"lottery":{"activityId":"mcGM6BOC2/XPOJnsZQYjNw==","type":3}}}' "https://panservice.mail.wo.cn/wohome/v1/lottery")
code=$(echo "$tmp" | jq -r '.meta.code')
if [ "$code" = 0 ]; then
echo "账号$s抽奖结果$(echo "$tmp" | jq -r '.result.prizeName')"
else
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"联通云盘'$s'token失效","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
done