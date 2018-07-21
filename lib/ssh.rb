
require 'net/ssh'

class Ssh
  # my remote laptop
  HOSTNAME = '192.168.100.2'
  USERNAME = 'remote'
  PASSWORD = 'remote'
  # COMMAND = 'cd Documents/sieve && cap production deploy'
  COMMAND = 'cs Documents/sieve && ls -al'

  def initialize
    @ssh = Net::SSH.start(HOSTNAME, USERNAME, :password => PASSWORD)
  end

  def deploy!
    res = @ssh.exec(COMMAND)
    close
    res
  end

  def close
    @ssh.close
  end
end