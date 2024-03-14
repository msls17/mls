# new Env('wx-丰享汇');
#by-莫老师，版本1.6
#cron:25 0 * * *
#1分价值0.1元
appid=wxdc0171c19d8ff575
ck=($(cat fxh | awk -F "@" '{print $1}'))
id=($(cat fxh | awk -F "@" '{print $2}'))
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，萝卜未启动"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message".| jq -r '.msg'
exit
fi
else
rm -rf fxh
for s in $(seq 0 1 $((${#code[@]}-1)))
do
tmp=$(curl -sk -X POST -H "Host: wx.member.ftms.com.cn" -H "content-type: application/json" -d '{"nickName":"","gender":0,"language":"","city":"","province":"","country":"","avatarUrl":"","form":"app","iv":"","signature":"","jsCode":"'${code[$s]}'","headImg":""}' "https://wx.member.ftms.com.cn/yqftapi/weixin/scx/login")
echo "$(echo "$tmp" | jq -r '.returnDataList.token')@$(echo "$tmp" | jq -r '.returnDataList.customerId')" >>fxh
done
fi
}
run(){
ck=($(cat fxh | awk -F "@" '{print $1}'))
id=($(cat fxh | awk -F "@" '{print $2}'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
curl -sk -X POST -H "Host: wx.member.ftms.com.cn" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -H "ts: $(date +%Y%m%d%H%M%S%3N)" -d '{"customerid":"'${id[$s]}'"}' "https://wx.member.ftms.com.cn/yqftapi/weixin/customer/signpoints/today" | jq -r '.returnMsg'
tmp=$(curl -sk -X POST -H "Host: wx.member.ftms.com.cn" -H "Content-Length: 49" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -H "ts: $(date +%Y%m%d%H%M%S%3N)" -d '{"customerid":"'${id[$s]}'"}' "https://wx.member.ftms.com.cn/yqftapi/weixin/integralShop/basicInfo")
echo "丰享汇账号$(echo "$tmp" | jq -r '.returnDataList.mobile')目前积分$(echo "$tmp" | jq -r '.returnDataList.integralfirms2')"
done
}
code=$(curl -sk -X POST -H "Host: wx.member.ftms.com.cn" -H "Content-Length: 49" -H "authorization: $ck" -H "content-type: application/json" -H "ts: $(date +%Y%m%d%H%M%S%3N)" -d '{"customerid":"'$id'"}' "https://wx.member.ftms.com.cn/yqftapi/weixin/integralShop/basicInfo" | jq -r '.returnCode')
if [ "$code" = 1 ]; then
run
else
getcode
run
fi