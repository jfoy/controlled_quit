require "controlled_quit/version"

module ControlledQuit
  class Quitter
    def register
      @prev = Signal.trap('INT') { @quit_requested = true }
    end

    def unregister
      Signal.trap('INT', @prev) if @prev
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

  def self.protect
    q = Quitter.new
    q.register
    yield q
    q.unregister
  end

end
