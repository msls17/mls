# new Env('wx-卡夫亨氏');
#https://fscrm.kraftheinz.net.cn/?from=LUaDLcsUAP/NGPWj75Qfpw==
#by-莫老师，版本1.0，一天一分，200分兑换10话费
#cron:40 0 * * *
appid=wx65da983ae179e97b
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
else
for s in $(seq 0 1 $((${#code[@]}-1)))
do
token[$s]=$(curl -sk -X POST -H "Host: fscrm.kraftheinz.net.cn" -H "Content-Type: application/x-www-form-urlencoded" -d "fromId=LUaDLcsUAP%2FNGPWj75Qfpw&code=${code[$s]}" "https://fscrm.kraftheinz.net.cn/crm/public/index.php/api/v1/getUserToken" | sed 's/,/\n/g' | sed 's/\"//g' | grep "token" | awk -F ":" '{print $2}')
user[$s]=$(curl -sk -X GET -H "Host: fscrm.kraftheinz.net.cn" -H "token: ${token[$s]}" -H "Content-Type: application/x-www-form-urlencoded" "https://fscrm.kraftheinz.net.cn/crm/public/index.php/api/v1/getUserInfo" | sed 's/,/\n/g' | grep "{\"member_id" | awk -F ":" '{print $3}')
if [ -z "${user[$s]}" ]; then
echo "账号$s未注册"
else
echo "账号${user[$s]}本次签到：$(curl -sk -X POST -H "Host: fscrm.kraftheinz.net.cn" -H "token: ${token[$s]}" -H "Content-Type: application/x-www-form-urlencoded" -d "" "https://fscrm.kraftheinz.net.cn/crm/public/index.php/api/v1/dailySign" | sed 's/,/\n/g' | grep "res" | awk -F ":" '{print $3}' | sed 's/\"//g' | sed 's/}//g')分"
fi
done
for s in $(seq 0 1 $((${#user[@]}-1)))
do
for i in $(seq 0 1 $((${#token[@]}-1)))
do
curl -sk -X POST -H "Host: fscrm.kraftheinz.net.cn" -H "token: ${token[$i]}" -H "Content-Type: application/x-www-form-urlencoded" -d "cookbook_id=206&invite_id=${user[$s]}" "https://fscrm.kraftheinz.net.cn/crm/public/index.php/api/v1/recordScoreShare" | sed 's/,/\n/g' | sed 's/\"//g' | grep "msg" | awk -F ":" '{print $2}'
done
wait
done
fi
}
getcode
