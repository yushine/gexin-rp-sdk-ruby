# -*- encoding: utf-8 -*-
require_relative 'abstract_template.rb'

module GtReq
  class NotificationTemplate < AbstractTemplate
    # 设置透传消息类型：1-收到通知立即启动应用， 2－收到通知不启动应用
    attr_writer :transmissionType
    attr_accessor :text
    attr_accessor :title
    attr_accessor :logo
    attr_accessor :logoURL
    attr_accessor :transmissionType
    attr_accessor :transmissionContent
    attr_accessor :isRing
    attr_accessor :isVibrate
    attr_accessor :isClearable

    def getActionChain()
      # set actionchain
      actionChain1 = GtReq::ActionChain.new
      actionChain1.actionId = 1
      actionChain1.type = GtReq::ActionChain::Type::Goto
      actionChain1.next = 10000

      # notification
      actionChain2 = GtReq::ActionChain.new
      actionChain2.actionId = 10000
      actionChain2.type = GtReq::ActionChain::Type::Notification
      actionChain2.title = @title
      actionChain2.text = @text
      actionChain2.logo = @logo
      actionChain2.logoURL = @logoURL
      actionChain2.ring = @ring
      actionChain2.clearable = @isClearable
      actionChain2.buzz = @buzz
      actionChain2.next = 10010

      # goto
      actionChain3 = GtReq::ActionChain.new
      actionChain3.actionId = 10010
      actionChain3.type = GtReq::ActionChain::Type::Goto
      actionChain3.next = 10030

      # appStartUp
      appStartUp = GtReq::AppStartUp.new(:android => '', :symbia => '', :ios => '')

      actionChain4 = GtReq::ActionChain.new
      actionChain4.actionId = 10030
      actionChain4.type = GtReq::ActionChain::Type::Startapp
      actionChain4.appid = ''
      actionChain4.autostart = (1==@transmissionType ? true : false)
      actionChain4.appstartupid = appStartUp
      actionChain4.failedAction = 100
      actionChain4.next = 100

      # end

      actionChain5 = GtReq::ActionChain.new
      actionChain5.actionId = 100
      actionChain5.type = GtReq::ActionChain::Type::Eoa

      return [actionChain1, actionChain2, actionChain3, actionChain4, actionChain5]
    end

    def getPushType()
      return "NotifyMsg"
    end
  end
end