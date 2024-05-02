# new Env('IQOO社区');
#by-莫老师，版本1.2
#微信小程序IQOO社区，抓包authorization，青龙设置变量名iqoo值为authorization，抓一次30天有效
#cron:15 6 * * *
token=($(echo $iqoo | sed 's/&/ /g'))
url=bbs-api.iqoo.com
key=2618194b0ebb620055e19cf9811d3c13
d(){
echo "$tmp" | jq -r '.Meta.tips[].message'
}
p(){
a=$(date '+%s')
c=""
r=$(echo -n "POST&$t&$c&$l&appid=1002&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X POST -H "Host: $url" -H "authorization: ${token[$s]}" -H "sign: IQOO-HMAC-SHA256 appid=1002,timestamp=$a,signature=$r" -H "x-platform: mini" -H "content-type: application/json" -d ''$l'' "https://$url$t")
}
g(){
a=$(date '+%s')
l=""
r=$(echo -n "GET&$t&$c&$l&appid=1002&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X GET -H "Host: $url" -H "authorization: ${token[$s]}" -H "sign: IQOO-HMAC-SHA256 appid=1002,timestamp=$a,signature=$r" -H "x-platform: mini" -H "content-type: application/json" "https://$url$t?$c")
}
for s in $(seq 0 1 $((${#token[@]}-1)));do
echo "........开始执行iqoo账号$s........"
t="/api/v3/sign"
l='{"from":""}'
p
code=$(echo "$tmp" | jq -r '.Code')
if [ $code -ne "-13006" ] && [ $code -ne "0" ]; then
echo "ck可能失效，请重新抓包"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"iqoo账号'$s'可能失效，请重新抓包","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
d
t="/api/v3/luck.draw"
l='{}'
p
echo "抽奖$(echo "$tmp" | jq -r '.Data.prize_name')"
tmp=$(curl -sk http://ililil.cn:66/api/yy.php)
echo "$tmp"
t="/api/v3/thread.create"
l='{"title":"'$(echo $tmp | awk -F "," '{print $1}')'","categoryId":27,"content":{"text":"<p>'$(echo $tmp | awk -F "," '{print $2}')'</p>"},"position":{},"price":0,"freeWords":0,"attachmentPrice":0,"draft":0,"anonymous":0,"topicId":"","source":"","videoId":""}'
p
d
t="/api/v3/thread.delete"
l='{"threadId":'$(echo "$tmp" | jq -r '.Data.threadId')',"message":"1"}'
p
t="/api/v3/thread.list"
c='filter%5Bsort%5D=4&page=1&perPage=10&scope=0'
g
tzid=($(echo "$tmp" | jq -r '.Data.pageData[].threadId'))
postid=($(echo "$tmp" | jq -r '.Data.pageData[].postId'))
for i in $(seq 2);do
t="/api/v3/view.count"
c='threadId='${tzid[$i]}'&type=0'
g
d
done
for i in $(seq 4);do
t="/api/v3/posts.update"
l='{"id":'${tzid[$i]}',"postId":'${postid[$i]}',"data":{"attributes":{"isLiked":true}}}'
p
d
t="/api/v3/thread.share"
l='{"threadId":"'${tzid[$i]}'"}'
p
d
done
t="/api/v4/gift.activity"
c='source=index'
g
t="/api/v3/user"
c='userId='$(echo "$tmp" | jq -r '.Data.giftActivityUser.user_id')''
g
echo "当前积分$(echo "$tmp" | jq -r '.Data.score')"
fi
wait
done