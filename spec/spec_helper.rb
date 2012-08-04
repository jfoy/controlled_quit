
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

