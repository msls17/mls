# new Env('街猫app');
#by-莫老师，版本1.2
#抓包域名miaowa.hellobike.com青龙创建变量jmapp，值为ticket@token
#cron:10 8 * * *
#下载链接https://m.hellobike.com/AppPetH5/latest/index.html?shareUserId=7310951801574074532&shareForm=miaowa_pet_android_2&shareType=[2]&fromPageId=pages-interaction-invited-record-list-invited-record-list

zh=($(echo $jmapp | sed 's/&/ /g'))
key=0199bec97dfa5e0d
hexkey=30313939626563393764666135653064
url=miaowa.hellobike.com
p(){
tmp=$(echo "$(curl -sk -X POST -H "Host: $url" -H "user-agent: Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36" -H "chaos: true" -H "content-type: application/json; charset=UTF-8" -d "$(echo -n ''$body'' | openssl enc -aes-128-cbc -K $hexkey -iv $hexkey -base64 -A)" "https://$url/api")" | openssl enc -d -aes-128-cbc -K $hexkey -iv $hexkey -base64 -A)
}
zy(){
userid=$(curl -sk -X POST  -H "content-type: application/json" -H "Host: $url" -d '{"action":"pet.user.app.granary.getDetailV2","version":"5.21.3","appName":"AppPetStray","from":"pet","appScene":2000,"appTraceId":"","systemCode":"Mi4","supportFunctions":[],"latitude":0,"longitude":0,"mobileVersion":"2.0.5","mobileModel":"OnePlus PJE110","mobileSystem":"14","systemPlatform":"Android","ticket":"'$ticket'","token":"'$token'"}' "https://$url/api/pet.user.app.granary.getDetailV2" | jq -r '.data.userinfo.id')
for i in $(seq 20); do
if [ "$zynum" -gt "200" ]; then
echo "今日收取🐾已达上限"
break
fi
body='{"action":"pet.user.facade.search.result","clientId":"","systemCode":"Mi2","ticket":"'$ticket'","token":"'$token'","version":"2.0.5","curPage":'$i',"latitude":"0","longitude":"0","pageSize":10,"searchParam":"","searchSource":1,"showType":"1","userId":"'$userid'","riskControlData":{"deviceLat":0,"deviceLon":0,"systemCode":"Mi2","network":"Wifi","mobileNoInfo":"中国电信","ssidName":"","capability":"","roam":"86","batteryLevel":"100"}}'
p
roomids=$(echo ''$tmp'' | jq -r '.data.resultList[].dslData.id')
for r in ${roomids[@]}; do
body='{"action":"pet.user.claw.mark.query.liveRoom","clientId":"","systemCode":"Mi2","ticket":"'$ticket'","token":"'$token'","version":"2.0.5","supportFunctions":["mock","freeze"],"curPage":1,"siteId":"'$r'","riskControlData":{"deviceLat":0,"deviceLon":0,"systemCode":"Mi2","network":"Wifi","mobileNoInfo":"中国电信","ssidName":"","capability":"","roam":"86","batteryLevel":"100"}}'
p
if [ "$tmp" = '{"code":0,"msg":"ok"}' ]; then
echo "无爪印🐾"
else
ids=$(echo ''$tmp'' | jq -r '.data.clawMarkList[].id')
for c in ${ids[@]}; do
body='{"action":"pet.user.facade.clawmark.collectSingle","clientId":"","systemCode":"Mi2","ticket":"'$ticket'","token":"'$token'","version":"2.0.5","supportFunctions":["mock","freeze"],"clawMarkId":"'$c'","collectChannel":2,"riskControlData":{"deviceLat":0,"deviceLon":0,"systemCode":"Mi2","network":"Wifi","mobileNoInfo":"中国电信","ssidName":"","capability":"","roam":"86","batteryLevel":"100"}}'
p
num=$(echo ''$tmp'' | jq -r '.data.collectQuantity' | sed 's/.00//g')
zynum=$(($num+$zynum))
echo "收取$num🐾/今日累积获得$zynum🐾"
done
fi
sleep $((RANDOM % 10))
done
done
}
for s in "${!zh[@]}"; do
zynum=0
IFS='@' read -r ticket token <<< "${zh[$s]}"
coin=$(curl -sk -X POST -H "content-type: application/json" -H "Host: $url" -d '{"action":"pet.user.app.my.signIn","version":"5.21.3","appName":"AppPetStray","from":"pet","appScene":2000,"appTraceId":"","systemCode":"Mi4","supportFunctions":[],"latitude":0,"longitude":0,"mobileVersion":"2.0.5","mobileModel":"OnePlus PJE110","mobileSystem":"14","systemPlatform":"Android","ticket":"'$ticket'","token":"'$token'","type":4}' "https://$url/api/pet.user.app.my.signIn" | jq -r '.data.coinNum')
if [ ''$coin'' = "null" ]; then
echo "街猫账号$s已失效，请重新登陆"
bash push.sh 街猫账号$s已失效 街猫
else
echo "签到获得金币$coin"
gametoken=$(curl -sk -X POST -H "Host: api.hellobike.com" -H "content-type: application/json" -d '{"notNeedToken":true,"token":"'$token'","action":"g.user.loginByHello","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://api.hellobike.com/api/?action=g.user.loginByHello&deliveryChannel=JM" | jq -r '.data.token')
echo "游戏签到获得金币$(curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type:application/json" -d '{"action":"gaia.daily.sign","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.daily.sign&deliveryChannel=JM" | jq -r '.data.goldNum')"
gameid=$(curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type:application/json" -d '{"action":"gaia.profit.task","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.profit.task&deliveryChannel=JM" | jq -r '.data.profitTasks[3].gameId')
sessionId=$(curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type: application/json" -d '{"gameId":"'$gameid'","extInfoDTO":{"pageId":"base_task","pageName":"任务中心","moduleId":"single_game_task_id","moduleName":"游戏任务模块","device":"62","systemInfo":{"model":"","brand":"Google Inc.","version":"h5","system":"Android"}},"action":"gaia.game.platform.gameinfo.startSmallGame","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.game.platform.gameinfo.startSmallGame&deliveryChannel=JM" | jq -r '.data.sessionId')
curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type: application/json" -d '{"action":"gaia.game.platform.usertask.addPalyGameRecord","gameGuid":"'$gameid'","sessionId":"'$sessionId'","duration":3600,"gameName":"喵喵喵","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.game.platform.usertask.addPalyGameRecord&deliveryChannel=JM" | jq -r '.msg'
sleep $((RANDOM % 60))
curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type: application/json" -d '{"profitTaskGuid":"play_random_game_100","action":"gaia.game.platform.usertask.dailyReceiveAward","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.game.platform.usertask.dailyReceiveAward&deliveryChannel=JM" | jq -r '.data'
curl -sk -X POST -H "Host: entertainment.hellobike.com" -H "content-type: application/json" -d '{"action":"gaia.game.home.task.reward.all","token":"'$gametoken'","deliveryChannel":"JM","jhyPlatform":5,"identifying":"h5","source":"jm_icom","version":"2.0.5","fingerHash":"","__sysTag":"pro","riskControlData":{"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 14; PJE110 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/117.0.0.0 Mobile Safari/537.36; app=hellopet; version=2.0.5"}}' "https://entertainment.hellobike.com/api/?action=gaia.game.home.task.reward.all&deliveryChannel=JM" | jq -r '.data.goldNum'
zy
curl -sk -X POST -H "content-type: application/json" -H "Host: $url" -d '{"action":"pet.user.facade.clawMark.exchResources","version":"5.21.5","appName":"AppPetStray","from":"pet","appScene":2000,"appTraceId":"","systemCode":"Mi4","supportFunctions":[],"latitude":0,"longitude":0,"mobileVersion":"2.0.5","mobileModel":"OnePlus PJE110","mobileSystem":"14","systemPlatform":"Android","ticket":"'$ticket'","token":"'$token'"}' "https://$url/api/pet.user.facade.clawMark.exchResources" | jq -r '.data as $data | $data.expiringSoonContent | split("$text:expiringSoonValue$") | "当前爪印" + $data.balance + "，" + .[0] + $data.expiringSoonValue + .[1]'
fi
done
