require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'
require_relative '../igetui/template/transmission_template'
require_relative '../igetui/template/notification_template'
require_relative '../igetui/igt_message'
require_relative '../igetui/igt_push'
require 'base64'

$APPID = "xxxxxxxxxxxxxxxxxxxxxxxx"
$APPKEY = "xxxxxxxxxxxxxxxxxxxxxxxx"
$MASTERSECRET = "xxxxxxxxxxxxxxxxxxxxxxxx"
$CID = 'xxxxxxxxxxxxxxxxxxxxxxxx'
$CID1 = "xxxxxxxxxxxxxxxxxxxxxxxx"
$URL = "http://sdk.open.api.igexin.com/apiex.htm"


def toSingleTest()
  iGtPush = GtReq::IGtPush.new($URL, $APPKEY, $MASTERSECRET)
  transmissionTemplate = GtReq::TransmissionTemplate.new
  transmissionTemplate.appId= $APPID
  transmissionTemplate.appKey=$APPKEY
  transmissionTemplate.transmissionType=2
  transmissionTemplate.transmissionContent="How about toSingle 中文呢？"
  singleMessage = GtReq::SingleMessage.new
  singleMessage.data = transmissionTemplate
  singleMessage.isOffline = true
  singleMessage.offlineExpireTime=1000
  target = GtReq::Target.new
  target.appId = $APPID
  target.clientId = $CID
  ret = iGtPush.pushMessageToSingle(singleMessage, target)
  p ret
end

def toSingleTest2()
  iGtPush = GtReq::IGtPush.new($URL, $APPKEY, $MASTERSECRET)
  notificationTemplate = GtReq::NotificationTemplate.new
  notificationTemplate.appId= $APPID
  notificationTemplate.appKey = $APPKEY
  notificationTemplate.logo = 'push.png'
  notificationTemplate.logoURL = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
  notificationTemplate.title = '测试标题'
  notificationTemplate.text = '测试文本'
  notificationTemplate.isClearable = false
  notificationTemplate.isRing = true
  notificationTemplate.isVibrate = true
  notificationTemplate.transmissionType = 1
  notificationTemplate.transmissionContent = "what's this? an offline msg!"

  singleMessage = GtReq::SingleMessage.new
  singleMessage.data = notificationTemplate
  singleMessage.isOffline = true
  singleMessage.offlineExpireTime=6 * 1000 #ms
  target = GtReq::Target.new
  target.appId = $APPID
  target.clientId = $CID
  ret = iGtPush.pushMessageToSingle(singleMessage, target)
  p ret

end

def toListTest()
  iGtPush = GtReq::IGtPush.new($URL, $APPKEY, $MASTERSECRET)
  transmissionTemplate = GtReq::TransmissionTemplate.new
  transmissionTemplate.appId = $APPID
  transmissionTemplate.appKey = $APPKEY
  transmissionTemplate.transmissionType=2
  transmissionTemplate.transmissionContent="How about toList 中文呢？"
  listMessage = GtReq::ListMessage.new
  listMessage.data = transmissionTemplate
  listMessage.isOffline = true
  listMessage.offlineExpireTime=1000
  target1 = GtReq::Target.new
  target1.appId = $APPID
  target1.clientId = $CID
  target2 = GtReq::Target.new
  target2.appId = $APPID
  target2.clientId = $CID2
  targetList = [target1, target2]

  contentId = iGtPush.getContentId(listMessage)

  ret = iGtPush.pushMessageToList(contentId, targetList)
  p ret
end

def toAppTest()
  iGtPush = GtReq::IGtPush.new($URL, $APPKEY, $MASTERSECRET)
  transmissionTemplate = GtReq::TransmissionTemplate.new
  transmissionTemplate.appId = $APPID
  transmissionTemplate.appKey = $APPKEY
  transmissionTemplate.transmissionType=2
  transmissionTemplate.transmissionContent="How about toApp 中文呢？"

  appMessage = GtReq::AppMessage.new
  appMessage.data = transmissionTemplate
  appMessage.isOffline = false
  appMessage.offlineExpireTime = 0
  appMessage.appIdList = [$APPID]
  appMessage.provinceList = ['浙江', '上海']
  #appMessage.tagList = ['开心']

  ret = iGtPush.pushMessageToApp(appMessage)
  p ret
end

def statusTest()
  iGtPush = GtReq::IGtPush.new($URL, $APPKEY, $MASTERSECRET)
  p iGtPush.getClientIdStatus($APPID, $CID)
end


statusTest()

toSingleTest2()
toListTest()
toAppTest()

