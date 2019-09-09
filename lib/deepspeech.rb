# Set encoding to utf-8
# encoding: UTF-8

#
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
#
# Copyright (c) 2019 BigBlueButton Inc. and by respective authors (see below).
#

#path = File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
#$LOAD_PATH << path

require_relative './deepspeech/mozilla_deepspeech_worker'

module Deepspeech
  def self.logger=(log)
    @logger = log
  end

  def self.logger
    return @logger if @logger
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    @logger = logger
  end
end
