#!/bin/bash
#注册链接https://oneapph5.dongfeng-nissan.com.cn/oneapp/inviteBindCar?urlData=2HuCYYTn5BB%2FrBQI%2FpKH%2FZX0VYSPsqBWb6opaO9uaizK9x%2BTGaECIC%2FHeRf19vcwyYNVb%2B%2BLgUaXXPPze5JfAg%3D%3D
# new Env('wx-东风日产');
#by-莫老师，更新日期2023-10-14，版本3.8
#cron:15 0 * * *
################################
url=community.dongfeng-nissan.com.cn
if [ ! -f "testtzid" ]; then
echo $[$RANDOM%200000+1000000] >testtzid
fi
login(){
apicode=($(curl -s http://$serviceip:99/?wxappid=wxe3fd49854884240e -k | sed 's/|/ /g'))
code=($(curl -s http://$serviceip:99/?wxappid=wxe3fd49854884240e -k | sed 's/|/ /g'))
if [ -z "$code" ]; then
echo "获取code失败"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
exit
fi
for s in $(seq 0 1 $((${#code[@]}-1)))
do
tmp=$(curl -s -X GET -H "Host: ariya-api.dongfeng-nissan.com.cn" "https://ariya-api.dongfeng-nissan.com.cn/toc-login-service/nissan/v2/user/login/${apicode[$s]}" -k)
msg=$(echo "$tmp" | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if echo "$msg" | grep -q "成功"; then
phone[$s]=$(echo "$tmp" | sed 's/,/\n/g' | grep "phone" | awk -F ":" '{print $2}' | sed 's/\"//g')
id=$(uuidgen)
a=$(echo $id | cut -c25-36)
b=$(echo $id | cut -c9-19)
c=$(echo $id | cut -c1-8)
echo -e "$s日产账号$(curl -s -X POST -H "Host: wxapi.dongfeng-nissan.com.cn" -H "authorization: Bearer $(echo "$tmp" | sed 's/,/\n/g' | grep "api_token" | awk -F ":" '{print $3}' | sed 's/\"//g')" -H "content-type: application/json" -d '{"wxUuid":"'$a$b$c'"}' "https://wxapi.dongfeng-nissan.com.cn/api/small/v4/sign_in" -k | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}')"
ck[$s]=$(curl -s -X POST -H "Host: $url" -H "content-type: application/json" -d '{"phone":"'${phone[$s]}'","code":"'${code[$s]}'"}' "https://$url/api/v2/user_manage/wxlogin" -k | sed 's/,/\n/g' | grep "\"token\"" | awk -F ":" '{print $3}' | sed 's/\"//g')
else
echo "$s日产账号可能登陆失败，请检查微信是否在线"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号'$s'登录失败，请检查微信是否在线","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
phone[$s]=null
ck[$s]=null
fi
done
}
getid(){
testtzid=$(cat testtzid)
msg=$(echo -e $(curl -s -X GET -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" "https://$url./api/v2/feeds/$testtzid" -k) | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if echo "$msg" | grep -q "成功"; then
tzid=$testtzid
let testtzid++
echo $testtzid >testtzid
else
let testtzid++
echo $testtzid >testtzid
getid
fi
}
if [ "$(date +%d)" -eq 16 ]; then
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号抽奖次数今日将会清零，请尽快登录小程序，使用抽奖次数","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
login
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
getid
msg=$(echo -e "$(curl --max-time 9 -s -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/v2/feeds/$tzid/like" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')")
if [ "$msg" = 账号暂停使用，敬请联系客服 ]; then
echo "$s$msg"
else
echo "$s$msg"
echo "$s账号$(echo -e "$(curl --max-time 9 -s -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"commentable_type":"feeds","commentable_id":'$tzid',"body":"'$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)'","from_type":3}' "https://$url/api/v2/comments" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")"
echo "$s账号$(echo -e $(curl -s -X PUT -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"isToast":true}' "https://$url/api/v2/user/followings/$[$RANDOM%200000+1000]" -k) | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')"
tmp=$(curl -s http://ililil.cn:66/api/yy.php)
echo "$s账号$ztm$(echo -e "$(curl --max-time 9 -s -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"feed_title":"'$(echo $tmp | awk -F "," '{print $1}')'","feed_content":"<p>'$(echo $tmp | awk -F "," '{print $2}')'</p>","feed_from":3,"themes":[],"feed_mark":'$(date +%s)'850,"feeds_type":2,"location":null}' "https://$url/api/v2/feeds" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")"
fi
done