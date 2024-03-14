# new Env('中国人保');
#by-莫老师，版本1.5
#cron:5 1 * * *
#打开https://e.picc.com/piccapp/install/register.html?app=1&uuIdFlag=2a05f9fa-8下载app，然后用微信登陆抓包，抓thirdPartyId的值，青龙设置变量名zgrbck，值为thirdPartyId。一次抓包永久有效
url=zgrb.epicc.com.cn
url2=mp.picclife.cn
url3=piccapp.maxrocky.com
ck=($(cat zgrbapp))
zzhl(){
code2=$(curl -sik -X GET -H "Host: $url" -H "Cookie: w_a_t=${ck[$s]}" "https://$url/G-OPEN/oauth2/authorize/v1?client_id=63Tttc7Ku2r9g1DTqytXLH0Q&scope=auth_user&response_type=code&redirect_uri=https%3A%2F%2F$url3%2Fh5" | sed 's/,/\n/g' | grep "code=" | awk -F "code=" '{print $2}' | awk -F "&" '{print $1}')
ck2=$(curl -sik -X GET -H "Host: $url3" "https://$url3/h5/$activity/getCode?code=$code2&client_id=63Tttc7Ku2r9g1DTqytXLH0Q" | sed 's/,/\n/g' | grep "token=" | awk -F "token=" '{print $2}' | awk -F ";" '{print $1}')
}
apprun(){
ck=($(cat zgrbapp))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
echo "中国人保账号$s"
code=$(curl -sik -X GET -H "Host: $url" -H "Cookie: w_a_t=${ck[$s]}" "https://$url/G-OPEN/oauth2/authorize/v1?client_id=EC8XhCVQNN5dha8huaRZEC1v&scope=auth_user&response_type=code&redirect_uri=https%3A%2F%2F$url2%2Fdop%2Fscoremall%2Fuser%2FappLoginCallback%3FafterLoginRedirectUrl%3Dhttps%2525253A%2525252F%2525252F$url2%2525252Fdop%2525252Fscoremall%2525252Fmall%2525252F%25252523%2525252FdailyAttendance%2525253Fapply%2525253Dapp" | sed 's/,/\n/g' | grep "code=" | awk -F "code=" '{print $2}' | awk -F "&" '{print $1}')
token=$(curl -sik -X GET -H "Host: $url2" "https://$url2/dop/scoremall/user/appLoginCallback?afterLoginRedirectUrl=https%253A%252F%252F$url2%252Fdop%252Fscoremall%252Fmall%252F%2523%252FdailyAttendance%253Fapply%253Dapp&code=$code&client_id=EC8XhCVQNN5dha8huaRZEC1v" | sed 's/,/\n/g' | grep "app-token" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
if [ -z "$token" ]; then
echo "账号$s登录签到有礼失败，可能是没有人脸认证，请打开app进行实名认证"
else
curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/coupon/ut/signIn" | jq -r '.resultMessage'
for i in $(seq 9)
do
curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-auth-token: $token" -d '{"businessId":"'$(date +"%Y-%m-%dT%H:%M:%S.%3NZ")'","taskId":"'$i'"}' "https://$url2/dop/scoremall/coupon/ut/task/complete" | jq -r '.resultMessage'
done
jg=$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/coupon/blindBox/draw" | jq -r '.result.blindBoxGoodsVO.productName')
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"中国人保帐号'$s'盲盒抽奖结果'$jg'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
if [ "$(date +%u)" -eq 1 ]; then
activity=rbxyr
zzhl
curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -d "{}" "https://$url3/h5/rbxyr/activity/completeTask" | jq -r '.msg'
activity=rbzy
zzhl
for i in $(seq 3)
do
echo "账号$s第$i次周一抽奖结果:$(curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -H "Content-type: application/json; charset=UTF-8" -d "{}" "https://$url3/h5/rbzy/activity/luckDraw" | jq -r '.data.prizeName')"
done
elif [ "$(date +%u)" -eq 3 ]; then
activity=rbxyr
zzhl
for i in $(seq 2)
do
echo "账号$s第$i次周三抽奖结果:$(curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -H "Content-type: application/json; charset=UTF-8" -d "{}" "https://$url3/h5/rbxyr/activity/luckDraw" | jq -r '.data.prizeName')"
done
elif [ "$(date +%u)" -eq 5 ]; then
activity=rbxyr
zzhl
curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -d "{}" "https://$url3/h5/rbxyr/activity/completeTask" | jq -r '.msg'
activity=rbczr
zzhl
for i in $(seq 20)
do
curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -H "Content-type: application/json; charset=UTF-8" -d '{"taskType":'$i'}' "https://piccapp.maxrocky.com/h5/rbczr/activity/completeTask" | jq -r '.msg'
echo "账号$s第$i次周五抽奖结果:$(curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -H "Content-type: application/json; charset=UTF-8" -d "{}" "https://piccapp.maxrocky.com/h5/rbczr/activity/luckDraw" | jq -r '.data.prizeName')"
done
elif [ "$(date +%u)" -eq 7 ]; then
activity=rbxyr
zzhl
curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -d "{}" "https://$url3/h5/rbxyr/activity/completeTask" | jq -r '.msg'
activity=rbzr
zzhl
for i in $(seq 3)
do
echo "账号$s第$i次周日抽奖结果:$(curl -sk -X POST -H "Host: $url3" -H "Authorization: $ck2" -H "Content-type: application/json; charset=UTF-8" -d "{}" "https://$url3/h5/rbzr/activity/luckDraw" | jq -r '.data.prizeName')"
done
fi
echo "账号$s当前积分$(curl -sk -X POST -H "Host: $url2" -H "x-app-auth-type: APP" -H "x-app-score-platform: picc-app" -H "Content-Type: application/json;charset=UTF-8" -H "x-app-score-channel: picc-app001" -H "x-app-auth-token: $token" -d "{}" "https://$url2/dop/scoremall/score/internal/scoreAccount/queryMyScoreAccount" | jq -r '.result.totalScore')"
echo "..........................................."
done
}
ztm=$(curl -sk -X POST -H "Host: $url" -H "authorization: $ck" -H "Content-Type: application/json" -d "{}" "https://$url/G-HAPP/h/AppSigninNewController/pageInitialization" | jq -r '.code')
if [ "$ztm" = 00006 ]; then
openId=($(echo $zgrbck | sed 's/&/ /g'))
rm -rf zgrbapp
echo "登录失效正在重新登录"
for s in $(seq 0 1 $((${#openId[@]}-1)))
do
ck=$(curl -sik -X POST -H "Content-Type: application/json; charset=UTF-8" -H "Host: $url" -d '{"body":{"signInType":"0","thirdPartyId":"'${openId[$s]}'"},"head":{"accessToken":"","adCode":"350100","appInfo":{"appBuild":"243","appVersion":"6.20.6"},"deviceInfo":{"deviceId":"'$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 16 | head -n 1 | md5sum | awk '{print $1}' | sed 's/^\(.\{8\}\)\(.\{4\}\)\(.\{4\}\)\(.\{4\}\)\(.\{12\}\)$/\1-\2-\3-\4-\5/')'","deviceModel":"23049RAD8C","osType":"android","osVersion":"13","romType":"2","romVersion":"0"},"tags":{"tags":[],"tagsLogin":[]},"token":"","userId":""},"uuid":"'$uuidgen'"}' "https://$url/G-BASE/a/user/login/thirdPartyLogin/v1" | sed 's/\n//g' | sed 's/ //g' | grep "Authorization" | awk -F ":" '{print $2}' | awk -F ";" '{print $1}')
echo "$ck" >>zgrbapp
done
apprun
else
apprun
fi
