#!/bin/bash
# new Env('坦克');
#坦克app，一天10分，价值0.1
#需要抓包accessToken和refreshToken，然后在脚本同目录下创建文件tank，按照accessToken@refreshToken的格式填入，一行一个号
#by-莫老师，版本1.0
#cron:20 2 * * *
appkey=7736975579
device=00000000-6875-dd02-0000-000042c75699
ck=($(cat tank))
characters="abcdefghijklmnopqrstuvwxyz0123456789"
gettime(){
nonce=$(cat /dev/urandom | tr -dc "$characters" | fold -w 16 | head -n 1)
time=$(date '+%s%3N')
}
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
gettime
token1=$(echo ${ck[$s]} | awk -F "@" '{print $1}')
token2=$(echo ${ck[$s]} | awk -F "@" '{print $2}')
tmp=$(curl -sk -X POST -H "bt-auth-nonce: $nonce" -H "bt-auth-timestamp: $time" -H "bt-auth-sign: $(echo -n 'POST%2Fapp-api%2Fapi%2Fv1.0%2FuserAuth%2FrefreshTokenbt-auth-appkey%3A'$appkey'bt-auth-nonce%3A'$nonce'bt-auth-timestamp%3A'$time'json%3D%7B%22accessToken%22%3A%22'$token1'%22%2C%22deviceId%22%3A%22'$device'%22%2C%22refreshToken%22%3A%22'$token2'%22%7D8a23355d9f6a3a41deaf37a628645c62' | sha256sum|cut -d ' ' -f1)" -H "rs: 2" -H "appVer: 1.4.400" -H "bt-auth-appkey: $appkey" -H "terminal: GW_APP_TANK" -H "enterpriseId: CC01" -H "brand: 7" -H "cVer: 1.4.400" -H "sys: Android" -H "mall-brand: 11" -H "Content-Type: application/json; charset=UTF-8" -H "Host: gw-app.beantechyun.com" -d '{"accessToken":"'$token1'","deviceId":"'$device'","refreshToken":"'$token2'"}' "https://gw-app.beantechyun.com/app-api/api/v1.0/userAuth/refreshToken")
accesstoken[$s]=$(echo "$tmp" | jq -r '.data.accessToken')
refreshtoken[$s]=$(echo "$tmp" | jq -r '.data.refreshToken')
done
rm -rf tank
for i in $(seq 0 1 $((${#accesstoken[@]}-1)))
do
echo "坦克帐号$i签到$(curl -sk -X POST -H "Host: bt-h5-gateway.beantechyun.com" -H "accessToken: ${accesstoken[$i]}" -H "terminal: GW_APP_TANK" -H "Content-Type: application/json;charset=UTF-8" -H "brand: 7" -H "rs: 2" -d '{"port":"HJ0002"}' "https://bt-h5-gateway.beantechyun.com/app-api/api/v1.0/signIn/sign" | jq -r '.description')"
echo "坦克帐号$i当前坦克币$(curl -sk -X GET -H "Host: bt-h5-gateway.beantechyun.com" -H "accessToken: ${accesstoken[$i]}" -H "terminal: GW_APP_TANK" -H "Content-Type: application/json;charset=utf-8" -H "cVer: 1.4.400" -H "brand: 7" -H "rs: 2" "https://bt-h5-gateway.beantechyun.com/app-api/api/v1.0/point/querySumPoint" | jq -r '.data.remindPoint')"
echo "${accesstoken[$i]}@${refreshtoken[$i]}" >>tank
done
