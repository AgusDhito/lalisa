require 'telegram/bot'
require 'pry'
require_relative 'lib/deploy.rb'

token = '647620797:AAGUWc0x1p4nEQ8izzE2LO0XiYwxUZi6sNg'

class Lalisa
  attr_accessor :bot
  def initialize(bot_token)
    @bot_token = bot_token
  end

  def perform
    Telegram::Bot::Client.run(@bot_token) do |bot|
      @bot = bot unless @bot
      begin
        bot.listen do |message|
          @deploy = Deploy.new(message)
          case message.text
          when '/start'
            send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
            puts '/start replied successfully'
          when '/stop'
            send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
            puts '/stop replied successfully'
          when '/deploy'
            res = @deploy.execute!
            send_message(chat_id: message.chat.id, text: 'Horee! Deploy kamu berhasil')
            puts "/deploy replied successfully, res = #{res}"
          end
        end
      rescue Deploy::DeployError => e
        send_message(chat_id: @deploy.message.chat.id, text: e.message)
        puts 'Error replied successfully'
      # rescue StandardError => e
      #   binding.pry
      #   retry
      end
    end
  end

  def send_message(chat_id:, text:)
    self.bot.api.send_message(chat_id: chat_id, text: text)
  end
end

Lalisa.new(token).perform