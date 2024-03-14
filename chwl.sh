# new Env('wx-福清吃喝玩乐');
#by-莫老师，版本1.3
#800积分等于10元，一天5分
#cron:10 0 * * *
appid=wx0f83e319dd823721
getcode(){
code=($(curl -s http://$serviceip:99/?wxappid=$appid -k | sed 's/|/ /g'))
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
ck=$(curl -sk -X POST -H "Hosts csxcx.biaodianyun.cn" -H "content-type: application/x-www-form-urlencoded" -H "Referer: https://servicewechat.com/wx0f83e319dd823721/107/page-frame.html" -d "code=${code[$s]}" "https://csxcx.biaodianyun.cn/wxapp/v1.user/user_login_code" | jq -r '.data.session_key')
if [ -n "$ck" ]; then
echo "账号$s签到积分$(curl -sk -X POST -H "Host: csxcx.biaodianyun.cn" -H "cookie: session_key=$ck" -H "content-type: application/x-www-form-urlencoded" -H "Referer: https://servicewechat.com/wx0f83e319dd823721/107/page-frame.html" -d "accept_uid=null&channel=null&scene=null" "https://csxcx.biaodianyun.cn/wxapp/v1.signIn/sign_in" | jq -r '.data.points')"
else
echo "账号$s未注册，请打开小程序注册"
fi
done
fi
}
getcode