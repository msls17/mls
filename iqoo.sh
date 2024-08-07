# new Env('IQOO社区');
#by-莫老师，版本1.5
#微信小程序IQOO社区，抓包authorization，青龙设置变量名iqoo值为authorizatio@要兑换的商品id，抓一次30天有效
#600356，哔哩哔哩 600336，肯德基10元 600335，必胜客20 600334，Qq音乐 600332，腾讯视频
#cron:55 14 * * *
iqoos=($(echo $iqoo | sed 's/&/ /g'))
url=bbs-api.iqoo.com
key=2618194b0ebb620055e19cf9811d3c13
dh(){
t="/api/v3/exchange"
l='{"userId":'$(echo "$token" | awk -F "." '{print $2}' | awk -F "." '{print $1}' | base64 -d 2>/dev/null | jq -r '.sub')',"id":'$dhid',"imei":""}'
p
echo "$tmp"
if [ "$tmp" == *"频繁"* ]; then
echo "操作频繁重试"
dh
fi
}
d(){
echo "$tmp" | jq -r '.Meta.tips[].message'
}
p(){
a=$(date '+%s')
c=""
r=$(echo -n "POST&$t&$c&$l&appid=1002&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X POST -H "Host: $url" -H "authorization: $token" -H "sign: IQOO-HMAC-SHA256 appid=1002,timestamp=$a,signature=$r" -H "x-platform: mini" -H "content-type: application/json" -d ''$l'' "https://$url$t")
}
g(){
a=$(date '+%s')
l=""
r=$(echo -n "GET&$t&$c&$l&appid=1002&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X GET -H "Host: $url" -H "authorization: $token" -H "sign: IQOO-HMAC-SHA256 appid=1002,timestamp=$a,signature=$r" -H "x-platform: mini" -H "content-type: application/json" "https://$url$t?$c")
}
for s in $(seq 0 1 $((${#iqoos[@]}-1)));do
token=$(echo ${iqoos[$s]} | awk -F "@" '{print $1}')
echo "........开始执行iqoo账号$s........"
ckyxq=$((($(echo "$token" | awk -F "." '{print $2}' | base64 -d | jq -r '.exp')-$(date +%s))/3600))
if [ "$ckyxq" -lt "0" ]; then
echo "ck还有$ckyxq小时失效，请重新抓包"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"iqoo账号'$s'还有'$ckyxq'小时失效，请及时更新ck","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
echo "账号已失效，请重新抓包"
continue
fi
t="/api/v3/sign"
l='{"from":""}'
p
d
t="/api/v3/luck.draw"
l='{}'
p
echo "抽奖$(echo "$tmp" | jq -r '.Data.prize_name')"
tmp=$(curl -sk http://ililil.cn:66/api/yy.php)
echo "$tmp"
sleep 1
t="/api/v3/thread.create"
l='{"title":"'$(echo $tmp | awk -F "," '{print $1}')'","categoryId":27,"content":{"text":"<p>'$(echo $tmp | awk -F "," '{print $2}')'</p>"},"position":{},"price":0,"freeWords":0,"attachmentPrice":0,"draft":0,"anonymous":0,"topicId":"","source":"","videoId":""}'
p
d
sleep 1
t="/api/v3/thread.delete"
l='{"threadId":'$(echo "$tmp" | jq -r '.Data.threadId')',"message":"1"}'
p
sleep 1
t="/api/v3/thread.list"
c='filter%5Bsort%5D=4&page=1&perPage=10&scope=0'
g
sleep 1
tzid=($(echo "$tmp" | jq -r '.Data.pageData[].threadId'))
postid=($(echo "$tmp" | jq -r '.Data.pageData[].postId'))
for i in $(seq 2);do
t="/api/v3/view.count"
c='threadId='${tzid[$i]}'&type=0'
g
d
sleep 1
done
for i in $(seq 4);do
t="/api/v3/posts.update"
l='{"id":'${tzid[$i]}',"postId":'${postid[$i]}',"data":{"attributes":{"isLiked":true}}}'
p
d
sleep 1
t="/api/v3/thread.share"
l='{"threadId":"'${tzid[$i]}'"}'
p
d
sleep 1
done
t="/api/v3/user"
c='userId='$(echo "$token" | awk -F "." '{print $2}' | awk -F "." '{print $1}' | base64 -d 2>/dev/null | jq -r '.sub')''
g
echo "当前积分$(echo "$tmp" | jq -r '.Data.score')"
wait
done
if [ $(date +'%u') -eq 3 ]; then
sm=$(($(date -d 'tomorrow 15:00:00' +%s)-$(date +%s)-86400))
echo "稍等$sm秒"
sleep $sm
for s in $(seq 0 1 $((${#iqoos[@]}-1)));do
token=$(echo ${iqoos[$s]} | awk -F "@" '{print $1}')
dhid=$(echo ${iqoos[$s]} | awk -F "@" '{print $2}')
dh
d
done
fi