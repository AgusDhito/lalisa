require_relative 'ssh.rb'

class Deploy

  attr_accessor :username, :message
  def initialize(message)
    self.message = message
    self.username = message.chat.username
  end

  def deployer?
    ['setiadialvin', 'ediliu', 'dracius', 'agusdhito'].include? username
  end

  def execute!
    validate_deployer!

    # execute ssh here
    Ssh.new.deploy!
  end

  def validate_deployer!
    raise UnauthorizedError.new unless deployer?
  end

  class DeployError < StandardError; end
  class UnauthorizedError < DeployError
    def initialize(msg = 'Maaf, kamu bukan deployer'); super; end
  end
end
