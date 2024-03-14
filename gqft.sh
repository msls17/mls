#!/bin/bash
# new Env('wx-广汽丰田');
#广汽丰田小程序，一天50分，价值0.5
#by-莫老师，版本1.0
#cron:30 0 * * *
url=xcx.nevapp.gtmc.com.cn
appid=wxd8a42d1c0c59c15d
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
ck[$s]=$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"code":"'${code[$s]}'","clickUrl":"/pages/index/index","clickId":""}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/auth/login?code=${code[$s]}&clickUrl=%2Fpages%2Findex%2Findex&clickId=" | jq -r '.body.token')
tmp=$(curl -sk -X GET -H "Hosts $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" "https://$url/wxapp/nev-prod/bff-nev-wxapp/user/current")
uid[$s]=$(echo "$tmp" | jq -r '.body.gtmcUid')
userid[$s]=$(echo "$tmp" | jq -r '.body.id')
tzid=($(curl -sk -X POST -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -d '{"pageNum":1,"pageSize":10,"orderByField":" is_top=1 desc, sort=0, sort, top_time desc, create_time desc"}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/post/page" | jq -r '.body.data[].id'))
echo "广汽丰田账号$s"
echo "签到获得$(curl -sk -X POST -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -d '{"ruleCode":"SIGN_IN","bsId":"SIGN_IN:'${uid[$s]}'"}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/point/grantPoints" | jq -r '.body.grantPoints')分"
for i in $(seq 10)
do
echo "点赞获得$(curl -sk -X POST -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -d '{"subjectId":"'${tzid[$i]}'","subjectType":"POST","userId":"'${userid[$s]}'"}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/user/like" | jq -r '.body.grantPoints')分"
echo "浏览获得$(curl -sk -X POST -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -d '{"ruleCode":"BROWSE_CONTENT","businessType":"POST","bsId":"BROWSE_CONTENT:'${uid[$s]}':'${tzid[$i]}'"}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/point/grantPoints" | jq -r '.body.grantPoints')分"
echo "转发获得$(curl -sk -X POST -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -d '{"ruleCode":"FORWARD_CONTENT","businessType":"POST","bsId":"FORWARD_CONTENT:'${uid[$s]}':'${tzid[$i]}'"}' "https://$url/wxapp/nev-prod/bff-nev-wxapp/point/grantPoints" | jq -r '.body.grantPoints')分"
done
echo "当前积分$(curl -sk -X GET -H "Host: $url" -H "authorization: ${ck[$s]}" -H "content-types application/json" "https://$url/wxapp/nev-prod/bff-nev-wxapp/point/queryAccountinfo" | jq -r '.body')"
echo "………………………………"
done
fi
}
getcode