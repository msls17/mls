#!/bin/bash
# new Env('wx-rio会员中心');
#by-莫老师，版本1.0,一个月约250积分，比较鸡肋
#cron:50 0 * * *
url=club.rioalc.com
appid=wx225b10f204323da5
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
if [ -z "$code" ]; then
nc -z -w5 $serviceip 99
if [ $? -eq 0 ]; then
echo "未成功获取到code，正尝试重新获取"
getcode
else
echo "获取code失败，萝卜未启动"
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"获取code失败，请检查code服务器是否正常","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
exit
fi
else
for s in $(seq 0 1 $((${#code[@]}-1)))
do
ck[$s]=$(curl -sk -X POST -H "Host: $url" -H "content-type: application/json" -d '{"code":"'${code[$s]}'","redirect_path":"/pages/welcome/loading-page?nocheck=&type_lk=3&path=%2Fpages%2Findex%2Findex"}' "https://$url/api/miniprogram/auth" | sed 's/,/\n/g' | grep "token" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')
echo "rio账号$s"
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/miniprogram/user-sign-click" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
tmp=$(curl -sk http://ililil.cn:66/api/yy.php)
title=$(echo $tmp | awk -F "," '{print $1}')
content=$(echo $tmp | awk -F "," '{print $2}')
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"topic_id":6,"post_title":"'$title'","post_content":"'$content'","images":["https://club-oss.rioalc.com/uploads/rio/temporary/2023-10-22/L61bxgV9sXsKorDGwLB5SRsVmvB5gV1BDdhkNfyv.jpg"]}' "https://$url/api/miniprogram/post-create" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
tzid=$(curl -sk -X GET -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" "https://$url/api/miniprogram/mine-post?page=1" | sed 's/,/\n/g' | grep "\"id\"" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/miniprogram/post-likes/$tzid" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
comment=$(curl -sk http://ililil.cn:66/api/yy.php | awk -F "," '{print $2}')
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"comment":"'$comment'"}' "https://$url/api/miniprogram/post-comment/$tzid" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/miniprogram/post-skhare/$tzid" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
echo -e "$(curl -sk -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/miniprogram/post-del/$tzid" | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
echo "当前积分$(curl -sk -X GET -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" "https://$url/api/miniprogram/user-info" | sed 's/,/\n/g' | grep "points" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')"
echo "………………………………"
done
fi
}
getcode