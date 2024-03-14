#!/bin/bash
# new Env('wx-北京汽车');
#by-莫老师，版本1.6，平均一天约5毛
#cron:35 1,22 * * *
url=beijing-gateway-customer.app-prod.bjev.com.cn
ver=138
ua="(Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.13.1 $ver release bjApp baic-app-android)"
device=ba3dc34f048899051afc4ce232c24633
url=beijing-gateway-customer.app-prod.bjev.com.cn
appkey=6164883796
key=162e31f57f928bb34df22f99f04875de
appid=wxd8add45781a1cc2a
ck=($(cat bjqc))
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，萝卜未启动"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
exit
fi
fi
}
getuuid(){
uuid1=$(uuidgen)
uuid2=$(uuidgen)
time=$(date '+%s%3N')
}
login(){
getcode
for s in $(seq 0 1 $((${#code[@]}-1)))
do
getuuid
ck[$s]=$(curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Basic MjAwMDk5OmFwcF9uZXdAMjAyMg==" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-auth-iam-customer%2Foauth%2Ftokenice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'buildversion%3D'$ver'code%3D'${code[$s]}'device_uid%3D'$device'%40'$time'grant_type%3Dwx_codeuuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/x-www-form-urlencoded" -H "Host: $url" -d "buildVersion=$ver&code=${code[$s]}&device_uid=$device%40$time&grant_type=wx_code&referralCode=" "https://$url/beijing-auth-iam-customer/oauth/token?uuid_check=$uuid1" | jq -r '.data.accessToken')
done
echo "${ck[@]}" >bjqc
}
run(){
ck=($(cat bjqc))
hour=$(date +%H)
if [ $hour -ge 0 ] && [ $hour -le 19 ]; then
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
getuuid
echo "北京账号$s签到$(curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-asset%2Fexterior%2FuserSignRecord%2FaddSignice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'uuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d "" "https://$url/beijing-zone-asset/exterior/userSignRecord/addSign?uuid_check=$uuid1" | jq -r '.msg')"
content=$(curl -sk "https://v1.hitokoto.cn/?encode=text")
getuuid
tzid=$(curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-dynamic%2Fexterior%2Fdynamic%2Faddice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'json%3D%7B%22dynamicWords%22%3A%22'$(python -c "import urllib.parse; print(urllib.parse.quote('$content', safe=''))")'%22%2C%22id%22%3A0%2C%22isEdit%22%3Afalse%2C%22isTemplateSubmit%22%3Afalse%2C%22relationTopic%22%3A%5B%5D%2C%22type%22%3A2%7Duuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d '{"dynamicWords":"'$content'","id":0,"isEdit":false,"isTemplateSubmit":false,"relationTopic":[],"type":2}' "https://$url/beijing-zone-dynamic/exterior/dynamic/add?uuid_check=$uuid1" | jq -r '.data')
if [ "$tzid" = null ]; then
echo "账号可能未绑定微信登录失败"
else
echo "帖子id是$tzid"
for d in $(seq 0 1 $((${#ck[@]}-1)))
do
getuuid
curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$d]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-dynamic%2Fexterior%2Finteract%2Flikeice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'json%3D%7B%22entityId%22%3A'$tzid'%2C%22type%22%3A2%7Duuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d '{"entityId":'$tzid',"type":2}' "https://$url/beijing-zone-dynamic/exterior/interact/like?uuid_check=$uuid1" >/dev/null
done
for i in $(seq 1 10)
do
getuuid
curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-dynamic%2Fexterior%2Finteract%2Flikeice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'json%3D%7B%22entityId%22%3A'$(($tzid-$i))'%2C%22type%22%3A2%7Duuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d '{"entityId":'$(($tzid-$i))',"type":2}' "https://$url/beijing-zone-dynamic/exterior/interact/like?uuid_check=$uuid1" >/dev/null
getuuid
curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-dynamic%2Fexterior%2Finteract%2Fdynamic%2Fshareice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'json%3D%7B%22entityId%22%3A'$(($tzid-$i))'%7Duuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d '{"entityId":'$(($tzid-$i))'}' "https://$url/beijing-zone-dynamic/exterior/interact/dynamic/share?uuid_check=$uuid1" >/dev/null
done
fi
done
elif [ $hour -ge 20 ] && [ $hour -le 23 ]; then
getuuid
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
for l in $(curl -sk -X GET -H "Content-Type: application/json;charset=UTF-8" -H "User-Agent: $ua" -H "Authorization: Bearer $ck" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'GET%2Fbeijing-zone-asset%2Fexterior%2FuserTaskProgress%2FselectTaskForMemberCenterice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'uuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Host: $url" "https://$url/beijing-zone-asset/exterior/userTaskProgress/selectTaskForMemberCenter?uuid_check=$uuid1" | jq -r '.data[].items[].taskGroupCode')
do
getuuid
curl -sk -X POST -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'POST%2Fbeijing-zone-asset%2Fexterior%2FuserTaskProgress%2FreceiveAwardice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'json%3D%7B%22taskGroupCode%22%3A%22'$l'%22%7Duuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d '{"taskGroupCode":"'$l'"}' "https://$url/beijing-zone-asset/exterior/userTaskProgress/receiveAward?uuid_check=$uuid1" | jq -r '.msg'
done
getuuid
echo "北京账号$s目前积分$(curl -sk -X GET -H "Content-Type: application/json;charset=UTF-8" -H "User-Agent: $ua" -H "Authorization: Bearer ${ck[$s]}" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'GET%2Fbeijing-zone-asset%2Fexterior%2Fuser%2Fintegral%2FmyIntegralice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'uuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Host: $url" "https://$url/beijing-zone-asset/exterior/user/integral/myIntegral?uuid_check=$uuid1" | jq -r '.data.availableIntegral')"
done
fi
}
getuuid
Integral=$(curl -sk -X GET -H "Content-Type: application/json;charset=UTF-8" -H "User-Agent: $ua" -H "Authorization: Bearer $ck" -H "ice-auth-appkey: $appkey" -H "ice-auth-timestamp: $time" -H "ice-auth-sign: $(echo -n 'GET%2Fbeijing-zone-asset%2Fexterior%2Fuser%2Fintegral%2FmyIntegralice-auth-appkey%3A'$appkey'ice-auth-timestamp%3A'$time'uuid_check%3D'$uuid1''$key'' | sha256sum|cut -d ' ' -f1)" -H "Host: $url" "https://$url/beijing-zone-asset/exterior/user/integral/myIntegral?uuid_check=$uuid1" | jq -r '.data.availableIntegral')
if [ "$Integral" = null ]; then
login
run
else
run
fi

