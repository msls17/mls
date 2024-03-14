#!/bin/bash
# new Env('比亚迪汽车');
#抓包比亚迪app，打开签到页面，抓这个链接dilinkappserver.byd.com/club/?service=ForInterfaceApp.forward&serviceDir=Sign.sign_day
#青龙创建环境变量，变量名bydck，值为刚才抓的链接请求中的request的参数，多个账号就创建多个变量。
#7.0以上的比亚迪APP可能抓不到包，建议下载旧版本抓，平均一天三分价值≈0.15
#by莫老师，版本1.6
#cron:5 6 * * *
ck=($(echo $bydck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
status=$(curl -sk -X POST -H "Content-Type:application/json; charset=UTF-8" -H "Host:dilinkappserver.byd.com" -H "Connection:Keep-Alive" -H "Accept-Encoding:gzip" -H "User-Agent:okhttp/4.9.1" -d '{"request":"'${ck[$s]}'"}' "https://dilinkappserver.byd.com/club/?service=ForInterfaceApp.forward&serviceDir=Sign.sign_day" | jq -r '.status')
if [ "$status" = 200 ]; then
echo "比亚迪账号$s的ck已失效"
curl -sk -X POST -H "Host:wxpusher.zjiecode.com" -H "Content-Type:application/json" -d '{"appToken":"'$apptoken'","content":"比亚迪账号'$s'的ck已失效","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
echo "比亚迪账号$s签到成功"
fi
done
