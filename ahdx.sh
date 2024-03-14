# new Env('wx-安徽电信');
#by-莫老师，版本1.1
#cron:5 0 * * *
#平均一天100金币，6000金币兑换视频会员季卡
appid=wx8ebdb28d971c6097
getcode(){
code=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
cjcode=($(curl -sk http://$serviceip:99/?wxappid=$appid | sed 's/|/ /g'))
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
ck[$s]=$(curl -sk -X POST -H "Host: wx.ah.189.cn" -H "Content-Length: 37" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "code=${code[$s]}" "https://wx.ah.189.cn/hd/ahwxboot/qdyl/login" | sed 's/,/\n/g' | grep "token" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')
done
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
echo "账号$s本月$(curl -sk -X POST -H "Host: wx.ah.189.cn" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "token=${ck[$s]}" "https://wx.ah.189.cn/hd/ahwxboot/qdyl/qd" | sed 's/,/\n/g' | grep "data" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')日签到"
done
fi
}
getcode
if [ "$(date +%d)" -eq 1 ]; then
for s in $(seq 0 1 $((${#cjcode[@]}-1)))
do
cjck[$s]=$(curl -sk -X POST -H "Host: wx.ah.189.cn" -H "Content-Length: 37" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -d "code=${cjcode[$s]}" "https://wx.ah.189.cn/hd/ahwxboot/drawnew/login" | sed 's/,/\n/g' | grep "token" | awk -F ":" '{print $3}' | sed 's/\"//g' | sed 's/}//g')
done
for s in $(seq 0 1 $((${#cjck[@]}-1)))
do
echo "账号$s本月抽奖$(curl -sk -X POST -H "Host: wx.ah.189.cn" -H "Content-Length: 518" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Origin: https://wx.ah.189.cn" -H "Referer: https://wx.ah.189.cn/wxws/zbimg/xcx/20230129/index.html?code=${cjcode[$s]}&state=123" -d "token=${cjck[$s]}" "https://wx.ah.189.cn/hd/ahwxboot/drawnew/start2" | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g')"
done
fi
