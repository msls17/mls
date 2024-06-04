#!/bin/bash
# new Env('华为商城');
#抓包euid，变量名yylx，多账号创建多个或&分割
#by-莫老师，版本1.0
#cron:20 6 * * *
zh=($(echo $yylx | sed 's/&/ /g'))
url=openapi.vmall.com
for s in $(seq 0 1 $((${#zh[@]}-1)));do
ck=${zh[$s]}
csrf=$(curl -sik -X GET -H "Cookie: euid=$ck" -H "Host: $url" "https://$url/csrftoken.js" | grep -oP 'csrftoken\s*=\s*"\K[^"]+')
curl -sk -X POST -H "Cookie: euid=$ck" -H "CsrfToken: $csrf" -H "Content-Type: application/json; charset=utf-8" -H "Host: $url" -d '{"country":"CN","activityCode":"TA4SJFEX12E6H2N1","portal":"3","lang":"zh-CN","version":"12403301"}' "https://$url/ams/signIn/userSignIn" | jq -r '.rewardTip'
curl -sk -X POST -H "Cookie: euid=$ck" -H "CsrfToken: $csrf" -H "Content-Type: application/json; charset=utf-8" -H "Host: $url" -d '{"country":"CN","activityCode":"TA4U489XP1K3R38B25","usePoint":"1","lang":"zh-CN","portal":"3","version":"12403301"}' "https://$url/mcp/prize/commonPrize" | jq -r '.appNotPrizeTip'
tmp=$(curl -sk -X GET -H "Cookie: euid=$ck" -H "CsrfToken: $csrf" -H "Host: $url" "https://$url/sg/content/realtime/getPageDataSource?country=CN&portal=3&lang=zh_CN&filterType=2&version=1&dataSourceList=DH0002213")
activity=$(echo "$tmp" | jq -r '.pageData.DH0002213[].activityCode')
task=($(echo "$tmp" | jq -r '.pageData.DH0002213[].taskActivityTaskInfoList[].taskCode'))
for i in ${task[@]};do
curl -sk -X GET -H "Cookie: euid=$ck" -H "CsrfToken: $csrf" -H "Host: $url" "https://$url/sg/activity/attendTask?taskCode=$i&activityCode=$activity&portal=3&lang=zh_CN&country=CN&version=1" | jq -r '.success'
curl -sk -X POST -H "Cookie: euid=$ck" -H "CsrfToken: $csrf" -H "Content-Type: application/json; charset=utf-8" -H "Host: $url" -d '{"country":"CN","activityCode":"'$activity'","taskCode":"'$i'","lang":"zh-CN","portal":"3","version":"12403301"}' "https://$url/ams/task/receiveTaskReward" | jq -r '.msg'
done
