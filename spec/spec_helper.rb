
# from http://stackoverflow.com/questions/4459330/how-do-i-temporarily-redirect-stderr-in-ruby
require "stringio"
def capture_stderr
  previous_stderr, $stderr = $stderr, StringIO.new
  yield
  $stderr.string
ensure
  $stderr = previous_stderr
end

class Waiter
  attr_accessor :timeout, :increment

  def initialize( opts = {} )
    @timeout = opts[:timeout] || 1
    @increment = opts[:increment] || 0.01
  end

  def timed_out(start)
    Time.now > start + timeout
  end

  def wait_for
    start = Time.now

    while true do
      return if (yield or timed_out(start))
      sleep increment
    end
  end
end


