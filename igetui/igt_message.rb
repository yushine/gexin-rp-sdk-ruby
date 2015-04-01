# -*- encoding: utf-8 -*-
require '../igetui/template/abstract_template'
module GtReq
  class IGtMessage
    def initialize()
      @isOffline = false
      @offlineExpireTime = 0
      @data = AbstractTemplate.new
    end

    attr_accessor :isOffline
    attr_accessor :offlineExpireTime
    attr_accessor :data

  end

  class SingleMessage < IGtMessage
    def initialize()
      super
    end
  end

  class ListMessage < IGtMessage
    def initialize()
      super
    end
  end

  class AppMessage < IGtMessage
    def initialize()
      @appIdList = []
      @phoneTypeList = []
      @provinceList = []
      @tagList = []
    end

    attr_accessor :appIdList
    attr_accessor :phoneTypeList
    attr_accessor :provinceList
    attr_accessor :tagList
  end
end