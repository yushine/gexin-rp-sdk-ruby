# -*- encoding: utf-8 -*-
require 'json'

module GtReq
  class Validate
    def validate(locKey, locArgs, message, actionLocKey, launchImage, badge, sound, payload)
      payloadMap = getPayload(locKey, locArgs, message, actionLocKey, launchImage, badge, sound, payload)
      json = JSON.generate payloadMap
      if (json.length>256)
        raise ArgumentError.new("PushInfo length over limit: #{json.length}. Allowed: 256.")
      end
    end

    def getPayload(locKey, locArgs, message, actionLocKey, launchImage, badge, sound, payload)
      apnsMap = Hash.new
      if (sound!=nil && sound.length>0)
        apnsMap["sound"] = sound
      else
        apnsMap["sound"] = "default"
      end

      alertMap = Hash.new
      if (launchImage!=nil && launchImage.length>0)
        alertMap["launch-image"] = launchImage
      end
      if (locKey!=nil && locKey.length>0)
        alertMap["loc-key"] = locKey
        if (locArgs!=nil && locArgs.length>0)
          alertMap["loc-args"] = locArgs.split(", ")
        end
      elsif (message!=nil && message.length>0)
        alertMap["body"] = message
      end
      apnsMap["alert"] = alertMap

      if (actionLocKey!=nil && actionLocKey.length>0)
        apnsMap["action-loc-key"] = actionLocKey
      end
      apnsMap["badge"] = badge

      h = Hash.new
      h["aps"] = apnsMap
      if (payload!=nil && payload.length>0)
        h["payload"] = payload
      end

      return h
    end
  end
end