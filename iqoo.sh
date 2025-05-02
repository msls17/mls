# new Env('IQOO社区');
#by-莫老师，版本1.9
#IQOO社区app，抓包登录链接https://usrsys.vivo.com.cn/usrlg/v5/login/manual，变量名iqoo，值为请求体中全部内容，多账号@分隔
#600356，哔哩哔哩 600336，肯德基10元 600335，必胜客20 600334，Qq音乐 600332，腾讯视频，以上数字是秒速星期三对应商品的id，设置变量名为iqoodhid，值为以上数字中的一个，如不需要兑换就不要填写
#cron:55 14 * * *
url=bbs-api.iqoo.com
#wxkey=2618194b0ebb620055e19cf9811d3c13
key=1aa0fe59f218c000e3bd533c33e8f27a
zh=($(echo $iqoo | sed 's/@/ /g'))
dh(){
t="/api/v3/exchange"
l='{"userId":'$(echo "$token" | awk -F "." '{print $2}' | awk -F "." '{print $1}' | base64 -d 2>/dev/null | jq -r '.sub')',"id":'$iqoodhid',"imei":""}'
p
echo "$tmp"
if [ ''$tmp'' == *"频繁"* ]; then
echo "操作频繁重试"
sleep 1
dh
fi
}
d(){
echo "$tmp" | jq -r '.Meta.tips[].message'
}
p(){
a=$(date '+%s')
c=""
r=$(echo -n "POST&$t&$c&$l&appid=1001&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer $token" -H "sign: IQOO-HMAC-SHA256 appid=1001,timestamp=$a,signature=$r" -H "content-nonce: v9a8+5QzSygkuL99Pn8P0oFHR36oxLgCqQzr7bHw5+T18HqRwiwjCcHzWk2lTOFwoTd/YaCdltI/HddfkSbE8Hs0X6cQgDvUuEh34c6HdTHS798fDnA5vo69c3jkX1PtazLhMzSvaWY6XgE0OspI6ZfGGW7RsnDgH0VFeY0DB90=" -H "x-platform: mini" -H "content-type: application/json" -d ''$l'' "https://$url$t")
}
g(){
a=$(date '+%s')
l=""
r=$(echo -n "GET&$t&$c&$l&appid=1001&timestamp=$a" | openssl dgst -sha256 -hmac "$key" -binary | openssl base64)
tmp=$(curl -sk -X GET -H "Host: $url" -H "authorization: Bearer $token" -H "sign: IQOO-HMAC-SHA256 appid=1002,timestamp=$a,signature=$r" -H "x-platform: mini" -H "content-type: application/json" "https://$url$t?$c")
}
start(){
iqoos=($(cat iqoo | sed 's/\n/ /g'))
for s in "${!iqoos[@]}";do
token=$(echo ${iqoos[$s]} | awk -F "@" '{print $1}')
echo "........开始执行iqoo账号$s........"
t="/api/v3/sign"
l='{"from":""}'
p
d
t="/api/v3/luck.draw"
l='{}'
p
echo "抽奖$(echo "$tmp" | jq -r '.Data.prize_name')"
tmp=$(curl -sk http://ililil.cn:88/api/yy.php)
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
}
getlogin(){
rm -rf iqoo
for s in "${!zh[@]}";do
tmp=$(curl -sk -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -H "Host: usrsys.vivo.com.cn" -d "${zh[$s]}" "https://usrsys.vivo.com.cn/usrlg/v5/login/manual")
openid=$(echo "$tmp" | jq -r '.data.openid')
vivotoken=$(echo "$tmp" | jq -r '.data.vivotoken')
u=$(echo "$tmp" | jq -r '.data.phonenum')
echo "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDlxzUDWEe8wfk9ionjtodSmyl7
V0UOeQio94+zsI4DQaZmV0dnJ3EAk+1Gf5h0otMtkS/7XNVSUIG+Q6Xk34RZblaz
sDL+UbpR/dAMWr3tTXYsdZj+EiJfQKn72rdLvTPlDi//ieDh6GwnG3MrYQbA2y9X
CQsHfW1D2/ggIPgTIwIDAQAB
-----END PUBLIC KEY-----" > vivo.pem
echo -n '{"requestTime":'$(date +%s)',"openid":"'$openid'","nickname":"'$u'","mobile":"'$u'","vivotoken":"'$vivotoken'","versionCode":70300}' > plaintext.dat
TMP_DIR=$(mktemp -d)
split -b 117 plaintext.dat "$TMP_DIR/block_"
for block in "$TMP_DIR"/block_*; do
openssl pkeyutl -encrypt -pubin -inkey vivo.pem -pkeyopt rsa_padding_mode:pkcs1 -in "$block" -out "$block.enc" || exit 1
done
data=$(cat "$TMP_DIR"/*.enc | base64 -w 0 | sed 's/=/\\u003d/g')
rm -rf "$TMP_DIR" plaintext.dat
t="/api/v3/users/vivo/app"
l='{"data":"'$data'","channel":1}'
p
token=$(echo "$tmp" | jq -r '.Data.accessToken')
if [ -z "$token" ]; then
echo "$u登录失败"
else
echo "$u登陆成功"
echo "$token" >>iqoo
fi
done
}
if [ ! -f "iqoo" ]; then
getlogin
fi
token=$(head -n 1 iqoo)
t="/api/v3/user?userId=1510446"
c='userId=1510446'
g
if [ "$tmp" == *"接口调用成功"* ]; then
start
else
getlogin
start
fi
if [ $(date +'%u') -eq 3 ]; then
sm=$(($(date -d 'tomorrow 15:00:00' +%s)-$(date +%s)-86400))
echo "稍等$sm秒"
sleep $sm
for s in "${!iqoos[@]}";do
token=$(echo ${iqoos[$s]} | awk -F "@" '{print $1}')
dh
d
done
fi