# new Env('wx-ems');
#by-莫老师，版本1.1
#没啥用，一天两金币，200金币兑换12-5寄件优惠券
#cron:20 0 * * *
appid=wx2aac4592a3c19bb1
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
wz=$(curl -sik -X GET -H "Host: ump.ems.com.cn" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/111.0.5563.116 Mobile Safari/537.36 XWEB/5279 MMWEBSDK/20230805 MMWEBID/5873 MicroMessenger/8.0.41.2441(0x28002951) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64" "https://ump.ems.com.cn/ndwz/r/quae2q" | sed 's/,/\n/g' | grep "Location" | awk -F "/" '{print $13}' | awk -F "&" '{print $1}')
tmp=$(curl -sik -X GET -H "Host: ump.ems.com.cn" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/111.0.5563.116 Mobile Safari/537.36 XWEB/5279 MMWEBSDK/20230805 MMWEBID/5873 MicroMessenger/8.0.41.2441(0x28002951) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64" "https://ump.ems.com.cn/ndwz/p/quae2q/oauth/$wz?code=${code[$s]}&state=")
ck[$s]=$(echo "$tmp" | sed 's/,/\n/g' | grep "CGSS" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
user[$s]=$(echo "$tmp" | sed 's/,/\n/g' | grep "userId" | awk -F "=" '{print $2}' | awk -F "&" '{print $1}')
openid[$s]=$(curl -sik -X GET -H "Host: ump.ems.com.cn" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/111.0.5563.116 Mobile Safari/537.36 XWEB/5279 MMWEBSDK/20230805 MMWEBID/5873 MicroMessenger/8.0.41.2441(0x28002951) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64" -H "Cookie: CGSS=${ck[$s]}" "https://ump.ems.com.cn/ndwz/r/VJ3Y3a?activId=c27d62bccffd4b18861b69cfa2b7ce72" | sed 's/,/\n/g' | grep "openId" | awk -F "=" '{print $3}' | awk -F "&" '{print $1}')
done
for s in $(seq 0 1 $((${#openid[@]}-1)))
do
echo "账号$s签到奖品：$(curl -sk -X POST -H "Host: ump.ems.com.cn" -H "Content-Type: application/json" -H "Cookie: CGSS=${ck[$s]}" -d '{"userId":"'${user[$s]}'","appId":"wx2aac4592a3c19bb1","openId":"'${openid[$s]}'","activId":"c27d62bccffd4b18861b69cfa2b7ce72"}' "https://ump.ems.com.cn/activCenterApi/signActivInfo/sign" | sed 's/,/\n/g' | grep "prizeSize" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')积分"
done
fi
}
getcode
