# new Env('福建人保财险');
#by-莫老师，版本1.1
#微信公众号福建人保财险，菜单栏超级1+6抓包openid，青龙创建变量rbcx值为openid
#cron:40 1 * * *
openid=($(echo $rbcx | sed 's/&/ /g'))
cj(){
for s in $(seq 0 1 $((${#openid[@]}-1)))
do
tmp=$(curl -sk -X POST -H "Host: smsp.epicc.com.cn" -H "Content-Type: application/json" -d '{"requestbody":{"comCode":"","userName":"","comId":"","agentCode":"0","userId":"picc-fuj","unionId":"","openId":"'${openid[$s]}'"}}' "https://smsp.epicc.com.cn/WAS/userLoginApi/autoLogin")
unionid=$(echo "$tmp" | jq -r '.data.unionid')
name=$(echo "$tmp" | jq -r '.data.encryName')
tmp=$(curl -sk -X POST -H "Host: smsp.epicc.com.cn" -H "Content-Type: application/json" -d '{"header":{"openid":"'${openid[$s]}'","comCode":"35000000","comId":"35000000","userName":"'$name'","agentCode":"0","token":"","userId":"picc-fuj","unionId":"'$unionid'"},"body":{"cmd":"queryactivitydetail","activityNo":"'$id'","memId":"","activityType":"1","transactionNo":"","isDifferWinningRate":""}}' "http://smsp.epicc.com.cn/WAS/recentActivtyApi/themeActivityNew")
msg=$(echo "$tmp" | jq -r '.message')
name=$(echo "$tmp" | jq -r '.data.activityName')
jp=$(echo "$tmp" | jq -r '.data.giftName')
if [[ "$jp" == *"很遗憾"* ]] || [[ "$jp" == *"null"* ]]; then
echo "$s没中"
else
echo "$s $msg $name $jp"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "content-type: application/json" -d '{"appToken":"'$apptoken'","content":"福建人保财险账号'$s'中了'$jp'","contentType":1,"topicIds":['$topicId'],"verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
done
}
if [ "$(date +%u)" -eq 1 ]; then
id=300008404
cj
elif [ "$(date +%u)" -eq 6 ]; then
id=300008402
cj
fi
day=$(date +"%d")
if [ "${day: -1}" -eq 1 ]; then
id=300008458
cj
elif [ "${day: -1}" -eq 6 ]; then
id=300008348
cj
else
echo "今日非活动日期"
fi