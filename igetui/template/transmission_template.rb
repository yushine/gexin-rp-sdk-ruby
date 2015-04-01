# -*- encoding: utf-8 -*-
require_relative 'abstract_template.rb'

module GtReq
  class TransmissionTemplate < AbstractTemplate
    # 设置透传消息类型：1-收到通知立即启动应用， 2－收到通知不启动应用
    attr_writer :transmissionType

    def getActionChain()
      actionChain1 = GtReq::ActionChain.new
      actionChain1.actionId = 1
      actionChain1.type = GtReq::ActionChain::Type::Goto
      actionChain1.next = 10030

      appStartUp = GtReq::AppStartUp.new(:android => '', :symbia => '', :ios => '')
      actionChain2 = GtReq::ActionChain.new
      actionChain2.actionId = 10030
      actionChain2.type = GtReq::ActionChain::Type::Startapp
      actionChain2.appid = ''
      actionChain2.autostart = (1==@transmissionType ? true : false)
      actionChain2.appstartupid = appStartUp
      actionChain2.failedAction = 100
      actionChain2.next = 100

      actionChain3 = GtReq::ActionChain.new
      actionChain3.actionId = 100
      actionChain3.type = GtReq::ActionChain::Type::Eoa

      return [actionChain1, actionChain2, actionChain3]
    end

    def getPushType()
      return "TransmissionMsg"
    end

  end
end