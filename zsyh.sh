# new Env('wx-招商银行');
#by-莫老师，版本1.0，抽奖
#cron:0 1 * * *
appid=wx619991cc795028f5
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
ck[$s]=$(curl -sik -X GET -H "Host: xyk.cmbchina.com" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/111.0.5563.116 Mobile Safari/537.36 XWEB/5279 MMWEBSDK/20230805 MMWEBID/5873 MicroMessenger/8.0.41.2441(0x28002951) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64" "https://xyk.cmbchina.com/OauthPortal/v2/wechat/callback?oauth_id=837f45c0&callback_uri=https%3A%2F%2Fweclub.xyk.cmbchina.com%2FSCRMCustomActivityFront%2Fcheckin-plus%2Fhome%3FactivityCode%3DcheckinPlus%26version%3D3&code=${code[$s]}&state=state" | sed 's/,/\n/g' | grep "SCRM_SSID" | awk -F "=" '{print $2}' | awk -F ";" '{print $1}')
done
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
echo "账号$s签到奖品：$(curl -sk -X POST -H "Hosts weclub.xyk.cmbchina.com" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; 23049RAD8C Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/111.0.5563.116 Mobile Safari/537.36 XWEB/5279 MMWEBSDK/20230805 MMWEBID/5873 MicroMessenger/8.0.41.2441(0x28002951) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64" -H "Content-Type: application/json;charset=UTF-8" -H "Cookie: SCRM_SSID=${ck[$s]}" -d '{"activityCode":"checkinPlus","version":3}' "https://weclub.xyk.cmbchina.com/SCRMCustomActivityFront/checkin-plus/request/checkin.json" | sed 's/,/\n/g' | grep "awardName" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')"
done
fi
}
getcode
