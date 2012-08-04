#!/usr/bin/env rspec

require 'spec_helper'
require 'controlled_quit'

# ControlledQuit.protect do |q|
#   units_of_work.each do |unit|
#     unit.do_work_and_serialize
#     q.quit_if_requested
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

  it 'shows a requested message on receiving a shutdown request' do
    message = 'Foo'
    output = capture_stderr do
      ControlledQuit.protect(:message => message) do |q|
        Process.kill('INT', $$)
        @waiter.wait_for { q.quit_requested? } # Handle signal race condition
      end
    end
    output.chomp.should == message
  end

  it 'catches SIGINT to register a quit request' do
    requested = false
    ControlledQuit.protect do |q|
      q.message = nil
      Process.kill('INT', $$)
      @waiter.wait_for { q.quit_requested? } # Handle signal race condition
      requested = q.quit_requested?
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

  context 'the client yields control through allow_quit without a cleanup block' do
    context 'the user has not sent a quit request' do
      it 'returns control to the client' do
        ControlledQuit.protect do |q|
          q.message = nil
          q.quit_if_requested
          q.should_not_receive(:quit!)
        end
      end
    end

    context 'the user has sent a quit request' do
      it 'shuts down the process' do
        ControlledQuit.protect do |q|
          q.message = nil
          Process.kill('INT', $$)
          @waiter.wait_for { q.quit_requested? } # Handle signal race condition
          expect { q.quit_if_requested }.to raise_error(SystemExit)
        end
      end
    end
  end
end
