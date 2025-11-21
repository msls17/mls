#推送脚本，变量名push，值为推送渠道（可选wxpusher和pushplus）@消息token@群组id
#例pushplus@2f45148b032b433db9481c721su69dn8@topic
#by-莫老师，版本1.0
IFS='@' read -r channel pushtoken topic <<< "$push"
if [ "$channel" = "pushplus" ]; then
curl -sk -X POST -H "Content-Type: application/json" -H "Host: www.pushplus.plus" -d '{"token":"'$pushtoken'","title":"'$2'","content":"'$1'","topic":"'$topic'", "template":"html"}' "https://www.pushplus.plus/send" | jq -r '.msg'
elif [ "$channel" = "wxpusher" ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$pushtoken'","content":"'$1'","summary":"'$2'","contentType":1,"topicIds":['$topic'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi