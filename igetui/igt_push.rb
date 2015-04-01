# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'

module GtReq
  class IGtPush
    def initialize(host, appKey, masterSecret)
      @host = host
      @appKey = appKey
      @masterSecret = masterSecret
    end

    def connect()
      timeStamp = Time.now.to_i
      sign = md5(@appKey + timeStamp.to_s + @masterSecret)

      data = {
          'action' => 'connect',
          'appkey' => @appKey,
          'timeStamp' => timeStamp,
          'sign' => sign,
      }

      ret = httpPost(data)

      if 'success'==(ret['result'])
        true
      end
      puts ret

      false
    end

    def pushMessageToSingle(message, target)
      template = message.data
      base64Str = Base64.strict_encode64(template.getTransparent().serialize_to_string)
      data = {
          'action' => 'pushMessageToSingleAction',
          'appkey' => @appKey,
          'clientData' => base64Str,
          'transmissionContent' => template.transmissionContent,
          'isOffline' => message.isOffline,
          'offlineExpireTime' => message.offlineExpireTime,
          'appId' => target.appId,
          'clientId' => target.clientId,
          'type' => 2, #default is message
          'pushType' => template.getPushType()
      }

      httpPostJson(data)
    end

    def pushMessageToList(contentId, targets)

      targetList = []
      targets.each{
        |target| targetList.push({'appId' => target.appId, 'clientId' => target.clientId})
      }

      data = {
          'action' => 'pushMessageToListAction',
          'appkey' => @appKey,
          'contentId' => contentId,
          'needDetails' => true,
          'targetList' => targetList,
          'type' => 2
      }

      httpPostJson(data)
    end

    def pushMessageToApp(message)
      template = message.data
      base64Str = Base64.strict_encode64(template.getTransparent().serialize_to_string)
      data = {
          'action' => 'pushMessageToAppAction',
          'appkey' => @appKey,
          'clientData' => base64Str,
          'transmissionContent' => template.transmissionContent,
          'isOffline' => message.isOffline,
          'offlineExpireTime' => message.offlineExpireTime,
          'appIdList' => message.appIdList,
          'phoneTypeList' => message.phoneTypeList,
          'provinceList' => message.provinceList,
          'tagList' => message.tagList,
          'type' => 2,
          'pushType' => template.getPushType()
      }
      httpPostJson(data)

    end

    def stop(contentId)
      data = {
          'action' => 'stopTaskAction',
          'appkey' => @appKey,
          'contentId' => contentId
      }

      ret = httpPostJson(data)
      if ret['result']=='ok'
        true
      end
      false
    end

    def getClientIdStatus(appId, clientId)
      data = {
          'action' => 'getClientIdStatusAction',
          'appkey' => @appKey,
          'appId' => appId,
          'clientId' => clientId
      }
      httpPostJson(data)
    end


    def getContentId(message)
      template = message.data
      base64Str = Base64.strict_encode64(template.getTransparent().serialize_to_string)
      data = {
          'action' => 'getContentIdAction',
          'appkey' => @appKey,
          'clientData' => base64Str,
          'transmissionContent' => template.transmissionContent,
          'isOffline' => message.isOffline,
          'offlineExpireTime' => message.offlineExpireTime,
          'pushType' => template.getPushType()
      }
      ret = httpPostJson(data)

      if 'ok'==(ret['result'])
        ret['contentId']
      else
        ''
      end
    end

    def cancelContentId(contentId)
      data = {
          'action' => 'cancleContentIdAction',
          'contentId' => contentId,
      }
      ret = httpPostJson(data)
      if 'ok'==ret['result']
        true
      end
      false
    end

    def md5(text)
      Digest::MD5.hexdigest(text)
    end

    def httpPost(params)
      params['version'] = '3.0.0.0'
      data = params.to_json

      url = URI.parse(@host)
      req = Net::HTTP::Post.new(url.path, initheader = {'Content-Type' => 'application/json'})
      req.body = data

      is_fail = true
      retry_time_limit = 3
      try_time = 0
      while is_fail and try_time < retry_time_limit
        begin
          res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
          is_fail = false
        rescue
          is_fail = true
          try_time += 1
          puts ('try ' + try_time.to_s + ' time failed, time out.')
        end
      end
      JSON.parse res.body
    end

    def httpPostJson(params)
      params['version'] = '3.0.0.0'
      ret = httpPost(params)
      if ret!=nil and 'sign_error'==(ret['result'])
        connect()
        ret = httpPost(params)
      end
      ret
    end
  end
end