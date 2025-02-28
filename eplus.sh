# new Env('e生活plus');
#by-莫老师，版本1.1
#福建工行信用卡用户才可以，每周四周五抢立减金
#cron:0 10 * * 4,5
appid=wxe5688eab75967e0a
url=card.zgrongyidui.com
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
for s in $(seq 0 1 0)
do
token=$(curl -sk -X POST -H "Host: $url" -H "content-type: application/x-www-form-urlencoded;charset=UTF-8" -d "code=${code[$s]}&appId=wxe5688eab75967e0a&scope=snsapi_base&loginParams=&actId=&unionId=&elifeParam=null" "https://$url/wx/user/getTokenByParams.do" | jq -r '.body.token')
if [ "$(date +%u)" -eq 4 ]; then
for i in 2000 2001;do
echo "账号$s兑换奖品：$(curl -sk -X POST -H "Host: $url" -H "x-token: $token" -H "content-type: application/x-www-form-urlencoded;charset=UTF-8" -d "" "https://$url/activity/icbc/tuesday/v2/receiveEquity.do?type=$i&mobile=$eplus" | jq -r '.msg')"
done
elif [ "$(date +%u)" -eq 5 ]; then
for i in 2006 2007 2002;do
echo "账号$s兑换奖品：$(curl -sk -X POST -H "Host: $url" -H "x-token: $token" -H "content-type: application/x-www-form-urlencoded;charset=UTF-8" -d "" "https://$url/activity/icbc/friday/v2/receiveEquity.do?type=$i&mobile=$eplus" | jq -r '.msg')"
done
else
echo "还没到活动日哦"
fi
done
fi
}
getcode
