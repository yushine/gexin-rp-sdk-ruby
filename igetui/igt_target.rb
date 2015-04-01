module GtReq
  class Target
    def initialize()
      @appId = ""
      @clientId = ""
    end
    attr_accessor :appId
    attr_accessor :clientId
  end
end