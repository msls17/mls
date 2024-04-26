# new Env('中国人保');
#by-莫老师，版本1.7
#cron:5 1 * * *
#打开https://e.picc.com/piccapp/install/register.html?app=1&uuIdFlag=2a05f9fa-8下载app，然后用微信登陆抓包，抓thirdPartyId的值，青龙设置变量名zgrbck，值为thirdPartyId。一次抓包永久有效
url=zgrb.epicc.com.cn
url2=mp.picclife.cn
url3=piccapp.maxrocky.com
openId=($(echo $zgrbck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#openId[@]}-1)))
do
ck=$(curl -sik -X POST -H "Content-Type: application/json; charset=UTF-8" -H "Host: $url" -d '{"body":{"signInType":"0","thirdPartyId":"'${openId[$s]}'"},"head":{"accessToken":"","adCode":"350100","appInfo":{"appBuild":"243","appVersion":"6.20.6"},"deviceInfo":{"deviceId":"'$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 16 | head -n 1 | md5sum | awk '{print $1}' | sed 's/^\(.\{8\}\)\(.\{4\}\)\(.\{4\}\)\(.\{4\}\)\(.\{12\}\)$/\1-\2-\3-\4-\5/')'","deviceModel":"23049RAD8C","osType":"android","osVersion":"13","romType":"2","romVersion":"0"},"tags":{"tags":[],"tagsLogin":[]},"token":"","userId":""},"uuid":"'$uuidgen'"}' "https://$url/G-BASE/a/user/login/thirdPartyLogin/v1" | sed 's/\n//g' | sed 's/ //g' | grep "Authorization" | awk -F ":" '{print $2}' | awk -F ";" '{print $1}')
rm -rf zgrb.log
echo "中国人保账号$s"
code=$(curl -sik -X GET -H "Host: $url" -H "Cookie: w_a_t=${ck[$s]}" "https://$url/G-OPEN/oauth2/authorize/v1?client_id=EC8XhCVQNN5dha8huaRZEC1v&scope=auth_user&response_type=code&redirect_uri=https%3A%2F%2F$url2%2Fdop%2Fscoremall%2Fuser%2FappLoginCallback%3FafterLoginRedirectUrl%3Dhttps%2525253A%2525252F%2525252F$url2%2525252Fdop%2525252Fscoremall%2525252Fmall%2525252F%25252523%2525252FdailyAttendance%2525253Fapply%2525253Dapp" | sed 's/,/\n/g' | grep "code=" | awk -F "code=" '{print $2}' | awk -F "&" '{print $1}')
token=$(curl -sik -X GET -H "Host: $url2" "https://$url2/dop/scoremall/user/appLoginCallback?afterLoginRedirectUrl=https%253A%252F%252F$url2%252Fdop%252Fscoremall%252Fmall%252F%2523%252FdailyAttendance%253Fapply%253Dapp&code=$code&client_id=EC8XhCVQNN5dha8huaRZEC1v" | sed 's/,/\n/g' | grep "app-token" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
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
printf "账号$s，第$i次兑换10E卡：$km换行" >>zgrb.log
done
if [ -f "zgrb.log" ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "content-type: application/json" -d '{"appToken":"'$apptoken'","content":"'$(cat zgrb.log | sed 's/换行/\\n/g')'","summary":"中国人保账号'$s'本次兑换清单","contentType":1,"topicIds":['$topicId'],"verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
fi
echo "..........................................."
done
