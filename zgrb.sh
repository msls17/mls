# new Env('中国人保');
#by-莫老师，版本2.0
#cron:5 1 * * *
#打开https://e.picc.com/piccapp/install/register.html?app=1&uuIdFlag=2a05f9fa-8下载app，然后用微信登陆抓包，抓thirdPartyId和deviceid的值，青龙设置变量名zgrbck，值为thirdPartyId@deviceid。一次抓包永久有效
url=zgrb.epicc.com.cn
url2=mp.picclife.cn
url3=piccapp-2024khj.maxrocky.com
zh=($(echo $zgrbck | sed 's/&/ /g'))
getsign(){
time=$(date '+%s%3N')
sign=$(echo -n ''$game''$i''$cj''$time'##$#gsgs123232' | md5sum | awk '{print $1}')
}
hqsign(){
time=$(date '+%s%3N')
sign=$(echo -n ''$time'##$#gsgs123232' | md5sum | awk '{print $1}')
}
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
openid=$(echo "${zh[$s]}" | awk -F "@" '{print $1}')
device=$(echo "${zh[$s]}" | awk -F "@" '{print $2}')
ck=$(curl -sik -X POST -H "Content-Type: application/json; charset=UTF-8" -H "Host: $url" -d '{"body":{"signInType":"0","thirdPartyId":"'$openid'"},"head":{"accessToken":"","adCode":"350100","appInfo":{"appBuild":"261","appVersion":"6.22.2"},"deviceInfo":{"deviceId":"'$device'","deviceModel":"23049RAD8C","osType":"android","osVersion":"13","romType":"2","romVersion":"0"},"tags":{"tags":[],"tagsLogin":[]},"token":"","userId":""},"uuid":"'$uuidgen'"}' "https://$url/G-BASE/a/user/login/thirdPartyLogin/v1" | sed 's/\n//g' | sed 's/ //g' | grep "Authorization" | awk -F ":" '{print $2}' | awk -F ";" '{print $1}')
rm -rf zgrb.log
echo "........中国人保账号$s........"
#
lj=$(curl -sik -X GET -H "Host: $url" -H "Cookie: w_a_t=$ck" "https://$url/G-OPEN/oauth2/authorize/v1?client_id=5TuIXelNdOotDUWXRhPid1NZ&scope=auth_user&response_type=code&state=eyJzb3VyY2VfZW50cnkiOiIiLCJhY3Rpdml0eV9zb3VyY2UiOiIiLCJhY3Rpdml0eV9jb2RlIjoiQXBwQ3VzdG9tZXIyNCIsInBsYXRmb3JtIjoiNyJ9&redirect_uri=https://m.picclife.cn/cust/api/activity-access-code/get-token" | grep "Location" | awk -F " " '{print $2}')
lj2=$(curl -sik "$lj" | grep "location" | awk -F " " '{print $2}')
token="$(curl -sik "$lj2" | grep "CUSTOMER2024" | awk -F "CUSTOMER2024=" '{print $2}' | awk -F ";" '{print $1}')"
for i in 1 2;do
getsign
curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time',"id":'$i'}' "https://$url3/api/task/complete" | jq -r '.msg'
sleep 1
getsign
curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time',"taskId":'$i'}' "https://$url3/api/task/claimReward" | jq -r '.msg'
sleep 1
done
for i in 6 6 6;do
hqsign
tmp=$(curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time'}' "https://$url3/api/task/view-$i")
key=$(echo -e "$tmp" | grep -oP '(?<=key=)[^&"]+')
sleep 15
curl -sk -X GET -H "Host: piccapp-api.picclife.cn" -H "combCode: GAESCQYLBX" -H "utmSource: 218" -H "platform: 7" "https://piccapp-api.picclife.cn/gateway-api/ebs-api/api/maxrocky/callBackMaxrocky?key=$key" | jq -r '.msg'
sleep 1
getsign
curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time',"taskId":'$i'}' "https://$url3/api/task/claimReward" | jq -r '.msg'
done
hqsign
tmp=$(curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time'}' "https://$url3/api/config")
yxcs=$(echo "$tmp" | jq -r '.data.user.playGameNum')
cjcs=$(echo "$tmp" | jq -r '.data.user.lotteryNum.a')
sleep 1
for i in $(seq $yxcs );do
cj=99
hqsign
tmp=$(curl -sik -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time'}' "https://$url3/api/game/config")
game=$(echo "$tmp" | grep -oP '"gameId"\s*:\s*"\K[^"]+')
app=$(echo "$tmp" | grep -oP 'X-App-Game:\s*\K[^[:space:]]+')
sleep 60
getsign
curl -sk -X POST -H "Host: $url3" -H "X-App-Game: $app" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time',"gameId":'$game',"score": '$cj'}' "https://$url3/api/game/end"
sleep 1
done
for i in $(seq $cjcs );do
hqsign
curl -sk -X POST -H "Host: $url3" -H "Content-Type: application/json" -H "sign: $sign" -H "Cookie: PICC_APP_CUSTOMER2024=$token" -d '{"timestamp":'$time'}' "https://$url3/api/lottery/draw.a" | jq -r '.msg'
sleep 1
done
#
lj=$(curl -sik -X GET -H "Host: $url" -H "Cookie: w_a_t=$ck" "https://$url/G-OPEN/oauth2/authorize/v1?client_id=EC8XhCVQNN5dha8huaRZEC1v&scope=auth_user&response_type=code&redirect_uri=https%3A%2F%2F$url2%2Fdop%2Fscoremall%2Fuser%2FappLoginCallback%3FafterLoginRedirectUrl%3Dhttps%2525253A%2525252F%2525252F$url2%2525252Fdop%2525252Fscoremall%2525252Fmall%2525252F%25252523%2525252FdailyAttendance%2525253Fapply%2525253Dapp" | grep "Location" | awk -F " " '{print $2}')
token=$(curl -sik -X GET -H "Host: $url2" "$lj" | grep "app-token" | awk -F "app-token=" '{print $2}' | awk -F ";" '{print $1}')
if [ -z "$token" ]; then
echo "账号$s登录签到有礼失败，可能是没有人脸认证，请打开app进行实名认证"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"中国人保帐号'$s'登录失败，请检查","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/coupon/ut/signIn" | jq -r '.resultMessage'
task=($(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d '{"type":2}' "https://$url2/dop/scoremall/coupon/ut/task/list" | jq -r '.result.taskList[].id'))
for i in ${task[@]}
do
curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-auth-token: $token" -d '{"businessId":"'$(date +"%Y-%m-%dT%H:%M:%S.%3NZ")'","taskId":"'$i'"}' "https://$url2/dop/scoremall/coupon/ut/task/complete" | jq -r '.resultMessage'
done
jg=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/coupon/blindBox/draw" | jq -r '.result.blindBoxGoodsVO.productName')
if [ -z "$jg" ] || [ "$jg" = "null" ]; then
echo "盲盒未中奖或无次数"
else
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"中国人保帐号'$s'盲盒抽奖结果'$jg'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
jf=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/score/internal/scoreAccount/queryMyScoreAccount" | jq -r '.result.totalScore')
echo "账号$s当前积分$jf"
for i in $(seq $(($jf/2500)))
do
dh=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d '{"goodsList":[{"count":1,"goodsId":"946008294354575362"}],"requestId":'$(date '+%s%3N')'}' "https://$url2/dop/scoremall/order/ut/order/createTempOrder" | jq -r '.result.id')
ddh=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d '{"id":"'$dh'"}' "https://$url2/dop/scoremall/order/ut/order/submitOrder" | jq -r '.result.orderId')
km=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d '{"id":"'$ddh'"}' "https://$url2/dop/scoremall/order/orderInfo/queryClientOrderDetails" | jq -r '.result.virtualOrderCardInfoDTO.cardPsss')
echo "账号$s，第$i次兑换10E卡：$km"
if [ "$km" = "null" ]; then
echo "兑换失败可能库存不足或未实名"
else
printf "账号$s，第$i次兑换10E卡：$km换行" >>zgrb.log
fi
done
if [ -f "zgrb.log" ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "content-type: application/json" -d '{"appToken":"'$apptoken'","content":"'$(cat zgrb.log | sed 's/换行/\\n/g')'","summary":"中国人保账号'$s'本次兑换清单","contentType":1,"topicIds":['$topicId'],"verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
fi
done
