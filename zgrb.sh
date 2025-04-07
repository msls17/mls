# new Env('中国人保');
#by-莫老师，版本2.2
#cron:5 1 * * *
#打开https://e.picc.com/piccapp/install/register.html?app=1&uuIdFlag=2a05f9fa-8下载app，然后用微信登陆抓包，抓thirdPartyId和deviceid的值，青龙设置变量名zgrbck，值为thirdPartyId@deviceid。一次抓包永久有效
url=zgrb.epicc.com.cn
url2=dop.picc.com.cn
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
ck=$(curl -sik -X POST -H "Content-Type: application/json; charset=UTF-8" -H "Host: $url" -d '{"body":{"signInType":"0","thirdPartyId":"'$openid'"},"head":{"accessToken":"","adCode":"350100","appInfo":{"appBuild":"285","appVersion":"6.23.12"},"deviceInfo":{"deviceId":"'$device'","deviceModel":"23049RAD8C","osType":"android","osVersion":"13","romType":"2","romVersion":"0"},"tags":{"tags":[],"tagsLogin":[]},"token":"","userId":""},"uuid":"'$uuidgen'"}' "https://$url/G-BASE/a/user/login/thirdPartyLogin/v1" | sed 's/\n//g' | sed 's/ //g' | grep "Authorization" | awk -F ":" '{print $2}' | awk -F ";" '{print $1}')
rm -rf zgrb.log
echo "........中国人保账号$s........"
state=$(curl -sk -X POST -H "Host: mp.picclife.cn" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "x-app-score-channel: picc-app001" -H "Content-Type: application/json;charset=UTF-8" -d "{}" "https://mp.picclife.cn/dop/scoremall/score/internal/scoreAccount/queryMyScoreAccount" | jq -r '.result' | grep -oP 'state=\K[^&]+')
tmp=$(curl -sik -X GET -H "Host: piccapp.picc.com.cn" -H "Cookie: w_a_t=$ck" "https://piccapp.picc.com.cn/G-OPEN/oauth2/authorize/v1?client_id=7nbv5z4zS86jhGDCt5XuwfWI&scope=auth_user&response_type=code&state=$state&redirect_uri=https%3A%2F%2Fdop.picc.com.cn%2Fdop%2Fscoremall%2Fuser%2FappLoginCallback%3FafterLoginRedirectUrl%3Dhttps%2525253A%2525252F%2525252Fmp.picclife.cn%2525252Fdop%2525252Fscoremall%2525252Fmall%2525252F%25252523%2525252Fhome%2525253Fapply%2525253Dapp")
lj=$(echo "$tmp" | grep "Location" | awk -F " " '{print $2}')
if [ -z "$lj" ]; then
uuid=$(echo "$tmp" | grep -oP 'id="uuid" name="uuid" value="\K[^"]+')
res=$(echo "$tmp" | grep -oP 'id="redirectUri" name="scope" value="\K[^"]+' | sed 's/amp;//g')
curl -sk -X POST -H "Host: piccapp.picc.com.cn" -H "Authorization: $ck" -H "content-type: application/json" -d '{"head":{"clientId":"7nbv5z4zS86jhGDCt5XuwfWI","uuid":"'$uuid'","redirectUri":"'$res'"},"body":{}}' "https://piccapp.picc.com.cn/G-OPEN/oauth2/getAgree" | jq -r '.message'
lj=$(curl -sik -X GET -H "Host: piccapp.picc.com.cn" -H "Cookie: w_a_t=$ck" "https://piccapp.picc.com.cn/G-OPEN/oauth2/agree/v1?client_id=7nbv5z4zS86jhGDCt5XuwfWI&redirectUri=$res&scope=auth_user&uuid=$uuid" | grep "Location" | awk -F " " '{print $2}')
else
token=$(curl -sik -X GET -H "Host: $url2" "$lj" | grep "app-token" | awk -F "app-token=" '{print $2}' | awk -F ";" '{print $1}')
fi
if [ -z "$token" ]; then
echo "账号$s登录签到有礼失败，可能是没有人脸认证，请打开app进行实名认证"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"中国人保帐号'$s'登录失败，请检查","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
else
curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/coupon/ut/signIn" | jq -r '.resultMessage'
task=($(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d '{"type":2,"ver":"gNMJgr8lU5d8FeDKCaOiUoLFMJPYHw71bPvzr3MQOqncg+B546XRn2jpAgh0oj7RLYNl6Q1q+khuQxYsPDnUEMOHVkWH+z4xv/eVeW0+4Ar1UIGSNBvIT6nAx9TQ5MKeaIlcAx0vasj7xUgXijNoR2/laSI2sPN1W24oL7Oz6WezdfsdmU+dYF39X1bxUCKlYcUKTD7gdAfG7T6hq+3P2eFKQxE/fjalfAtYO9Iw6wpWIexamCu6yagIvsMx90Rn7nShEa+BE6ulNWlYj4YrjyHh1DS6KKm9rJ0VGRmtadHLW5WZdTJKmU3WEvjm0/h+3NCFAxf0u4hFRQQcTQs2+A==","localizedModel":"","platform":""}' "https://$url2/dop/scoremall/coupon/ut/task/list" | jq -r '.result.taskList[].id'))
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
fi
done
