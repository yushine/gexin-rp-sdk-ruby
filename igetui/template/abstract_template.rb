# -*- encoding: utf-8 -*-
require_relative '../../protobuf/GtReq.pb'
require_relative '../../igetui/template/validate'

module GtReq
  class AbstractTemplate
    # 个推appId
    attr_writer :appId
    # 个推appKey
    attr_writer :appKey
    # 设置透传内容
    attr_accessor :transmissionContent

    def getTransparent()
      transparent = GtReq::Transparent.new
      transparent.id = ''
      transparent.messageId = ''
      transparent.taskId = ''
      transparent.action = 'pushmessage'
      transparent.actionChain = getActionChain
      transparent.pushInfo = getPushInfo
      transparent.appId = @appId
      transparent.appKey = @appKey

      return transparent
    end

    def getActionChain()
      return nil
    end

    def getPushType()
      return ""
    end

    def getPushInfo()
      if (@pushInfo==nil)
        @pushInfo = GtReq::PushInfo.new
        @pushInfo.actionKey = ''
        @pushInfo.badge = ''
        @pushInfo.message = ''
        @pushInfo.sound = ''
      end

      return @pushInfo
    end

    def setPushInfo(actionLocKey, badge, message, sound, payload, locKey, locArgs, launchImage)
      @pushInfo = GtReq::PushInfo.new
      @pushInfo.actionLocKey = actionLocKey
      @pushInfo.badge = badge
      @pushInfo.message = message
      if (sound!=nil)
        @pushInfo.sound = sound
      end
      if (payload!=nil)
        @pushInfo.payload = payload
      end
      if (locKey!=nil)
        @pushInfo.locKey = locKey
      end
      if (locArgs!=nil)
        @pushInfo.locArgs = locArgs
      end
      if (launchImage!=nil)
        @pushInfo.launchImage = launchImage
      end

      Validate.new.validate(locKey, locArgs, message, actionLocKey, launchImage, badge, sound, payload)

      return @pushInfo
    end

  end
end