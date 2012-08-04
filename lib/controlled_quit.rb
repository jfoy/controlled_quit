require "controlled_quit/version"

module ControlledQuit
  class Quitter
    attr_accessor :message
    def initialize( opts = {} )
      @message = opts[:message] || 'Received shutdown request'
      @message_shown = false
    end

    def register
      @prev = Signal.trap('INT') { handler }
    end

    def unregister
      Signal.trap('INT', @prev) if @prev
    end

    def handler
      unless @message_shown
        $stderr.puts(@message) if @message
        @message_shown = true
      end
      @quit_requested = true
    end

    def quit_requested?
      @quit_requested
    end

    def quit_if_requested
      quit! if quit_requested?
    end

    def quit!
      exit
    end
  end

  def self.protect(opts = {})
    q = Quitter.new(opts)
    q.register
    yield q
    q.unregister
  end

end
