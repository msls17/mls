#!/bin/bash
# new Env('澳门威尼斯人')
#每天三场红包雨，每场0~1元，变量名wnsr值为账号@密码
#cron:0 14,19,21 * * *
#by:莫老师
url=154.88.26.50:2939
run(){
uid=$(cat 2939 | awk -F "@" '{print $2}')
token=$(cat 2939 | awk -F "@" '{print $1}')
xshb=$(curl -sk https://$url/cn/thanksgivingRedPage?uid=$uid | sed 's/;/\n/g' | sed 's/\"//g' | grep "var activeId" | awk -F "=" '{print $2}')
money=$(curl -sk -X GET -H "Host: $url" -H "referer: https://$url/cn/thanksgivingRedPage?uid=$uid" -H "user-agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/108.0.5359.128 Mobile Safari/537.36" "https://$url/api/FrontRedWar/ReceiveRedWarAward/$xshb/$uid" | jq -r '.data.awardMoney')
balance=$(curl -sk -X POST -H "authorization: Bearer $token" -H "Content-Type: application/json" -H "Host: wac0oskk.cgshow-z66w-1.com" -d '{"plateType":"sys"}' "https://wac0oskk.cgshow-z66w-1.com/api/VipUser/RefreshBalance" | jq -r '.result')
echo "本次红包$money，当前余额$balance"
if [ "$(echo "$balance > 30" | bc -l)" -eq 1 ]; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"2939澳门威尼斯人抢到红包'$money'，当前余额'$balance'","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | jq -r '.msg'
fi
}
balance=$(curl -sk -X POST -H "authorization: Bearer $(cat 2939 | awk -F "@" '{print $1}')" -H "Content-Type: application/json" -H "Host: wac0oskk.cgshow-z66w-1.com" -d '{"plateType":"sys"}' "https://wac0oskk.cgshow-z66w-1.com/api/VipUser/RefreshBalance" | jq -r '.result')
if [ -z "$balance" ]; then
tmp=$(curl -sk -X POST -H "Content-Type: application/json" -H "Host: wac0oskk.cgshow-z66w-1.com" -d '{"userName":"'$(echo $wnsr | awk -F "@" '{print $1}')'","passWord":"'$(echo $wnsr | awk -F "@" '{print $2}')'","loginUrl":"android","geetest_challenge":"","geetest_validate":"","geetest_seccode":"","lot_number":"","captcha_output":"","pass_token":"","gen_time":"","code":"","realName":"","version":"1.9.03","vstyle":""}' "https://wac0oskk.cgshow-z66w-1.com/api/vipuser/Login")
echo "$(echo "$tmp" | jq -r '.result.token')@$(echo "$tmp" | jq -r '.result.id')" >2939
run
else
run
fi
if [ "$(date +%H)" -eq 19 ]; then
pthb=$(curl -sk https://$url/cn/NewRedWarPage?uid=$uid | sed 's/,/\n/g' | grep "\"Id\"" | awk -F ":" '{print $2}')
curl -sk -X GET -H "Host: $url" -H "referer: https://$url/cn/NewRedWarPage?uid=$uid" -H "user-agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/108.0.5359.128 Mobile Safari/537.36" "https://$url/api/FrontNewRedWar/ReceiveRedWarAward/$pthb/$uid"
fi