#!/bin/bash
# new Env('农耙耙');
#微信小程序农耙耙
#青龙填写变量npp，值为手机号@密码，多个账号就创建多个变量
#by-莫老师，版本1.2
#cron:15 6 * * *
ua="Mozilla/5.0 (Linux; Android 13; RMX2202 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/107.0.5304.141 Mobile Safari/537.36 XWEB/5061 MMWEBSDK/20230405 MMWEBID/5817 MicroMessenger/8.0.35.2360(0x28002357) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android"
url=sc.gdzfxc.com
zh=($(echo $npp | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
ck=$(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d '{"tel":"'$(echo ${zh[$s]} | awk -F "@" '{print $1}')'","pwd":"'$(echo ${zh[$s]} | awk -F "@" '{print $2}')'","logintype":1,"pid":0}' "https://$url/?s=%2FApiIndex%2Floginsub&aid=1&platform=wx&session_id=&pid=0" | jq -r '.session_id')
echo "账号$s签到获得$(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d "" "https://$url/?s=%2FApiSign%2Fsignin&aid=1&platform=wx&session_id=$ck&pid=0" | jq -r '.scoreadd')积分"
for i in $(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d "" "https://$url/?s=%2FApiSign%2Findex&aid=1&platform=wx&session_id=$ck&pid=0" | jq -r '.video_renwu[].id')
do
echo "账号$s微信任务$i获得$(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d '{"renwu_id":'$i'}' "https://$url/?s=%2FApiSign%2FvideoRenwu&aid=1&platform=wx&session_id=$ck&pid=0" | jq -r '.scoreadd')积分"
echo "账号$s任务$i获得$(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d '{"renwu_id":'$i'}' "https://$url/?s=%2FApiSign%2FvideoRenwu&aid=1&platform=app&session_id=$ck&pid=0" | jq -r '.scoreadd')积分"
done
echo "账号$s目前积分为$(curl -sk -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d '{"st":0,"pagenum":1}' "https://$url/?s=/ApiMy/scorelog&aid=1&platform=wx&session_id=$ck&pid=0" | jq -r '.myscore')"
echo "………………………………"
done