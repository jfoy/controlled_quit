#!/usr/bin/env rspec

require 'spec_helper'
require 'controlled_quit'

# ControlledQuit.protect do |quitter|
#   units_of_work.each do |unit|
#     unit.do_work_and_serialize
#     quitter.quit_if_requested
#   end
# end

describe ControlledQuit do
  before(:each) do
    @waiter = Waiter.new

    @fallback_called = false
    @outer_handler = Signal.trap('INT') { @fallback_called = true }
  end

  after(:each) do
    Signal.trap('INT', @outer_handler)
  end

  it 'catches SIGINT to register a quit request' do
    requested = false
    ControlledQuit.protect do |quitter|
      Process.kill('INT', $$)
      @waiter.wait_for { quitter.quit_requested? } # Handle signal race condition
      requested = quitter.quit_requested?
    end
    @fallback_called.should be_false
    requested.should be_true
  end

  it 'cleanly unregisters itself when it leaves scope' do
    ControlledQuit.protect { |q| }

    Process.kill('INT', $$)
    @waiter.wait_for { @fallback_called } # Handle signal race condition
    @fallback_called.should be_true
  end

  context 'the client yields control through allow_quit' do
    context 'the user has not sent a quit request' do
      it 'returns control to the client' do
        ControlledQuit.protect do |quitter|
          quitter.quit_if_requested
          quitter.should_not_receive(:quit!)
        end
      end
    end

    context 'the user has sent a quit request' do
      it 'shuts down the process' do
        ControlledQuit.protect do |quitter|
          Process.kill('INT', $$)
          @waiter.wait_for { quitter.quit_requested? } # Handle signal race condition
          expect { quitter.quit_if_requested }.to raise_error(SystemExit)
        end
      end
    end
  end
end
