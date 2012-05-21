# Copyright (c) 2012 Fabio Angelo Pelosin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'pty'
require 'rubygems'
require 'colored'
require 'rb-fsevent'
require 'fileutils'

class Live
  def initialize
    @buffered_output = ''
  end

  def run
    create_scratch_pad_if_needed
    # TODO: running rake inside rake is very lame,
    # need to do something about it.
    PTY.spawn("rake", 'simulator') do |stdout, stdin, pid|
      @stdout, @stdin = stdout, stdin
      console_attach
      welcome "Welcome to Live"
      print console_self
      start_watching
    end
  rescue PTY::ChildExited
    adieu "[LIVE] Terminating as the simulator quitted"
  # TODO: need to trap interrupt to exit gracefully.
  # rescue Interrupt
  #   adieu "Bye Bye"
  end

  def start_watching
    fsevent = FSEvent.new
    fsevent.watch Dir.pwd do |dirs|
      send_changes
    end
    fsevent.run
  end

  def send_changes
    code = find_changed_lines
    return if code.empty?
    puts "\n\n#{code.join("\n")}\n".magenta
    print console_self
    code.each { |l| console_put l }
    wait_console_result
    puts "\n\n Changes processed \n\n".reversed
    print console_self
  end

  def find_changed_lines
    new = scratch_pad
    if @old_code && !new.include?('#nodiff')
      delta = new.split("\n") - @old_code.split("\n")
    else
      delta = new.split("\n")
    end
    @old_code = new
    # reject comments
    delta.reject{ |l| l =~ /^\s*$/ || l =~ /^\s*#/ }
  end

  ### Helpers

  def create_scratch_pad_if_needed
    FileUtils.touch(scratchpad_file) unless File.exist?(scratchpad_file)
  end

  def scratch_pad
    File.read(scratchpad_file)
  end

  def scratchpad_file
    'LiveScratchpad.rb'
  end

  def dirs
    Dir.pwd
  end

  ### Interactions with the ruby motion REPL

  def console_self
    wait_console
    @buffered_output[/\(.*\)>/] + ' '
  end

  def console_put(input)
    wait_console
    @stdin.puts input
    @buffered_output = ''
    wait_console
  end

  def wait_console
    until @buffered_output =~ /\(.*\)[>,?]/
      # Wait
    end
  end

  def wait_console_result
    until @buffered_output =~ /=> .*/
      # Wait
    end
  end

  def console_attach
    Thread.new do
      loop do
        buffer = ''
        @stdout.readpartial(4096, buffer)
        @buffered_output << buffer
        print colorize_console_output(buffer)
        STDOUT.flush
      end
    end
    wait_console
  end

  def colorize_console_output(string)
    color = string.include?('Error') ? :yellow : :green
    string.gsub(/\n*(=> .*)/,"\n" + '\1'.send(color))
  end

  ### Custom output

  def welcome(string)
    puts
    puts
    puts "-> #{string}".green
    puts
  end

  def  adieu(string)
    puts
    puts string.yellow
    puts
  end
end

desc "Live code"
task :live do
  Live.new.run
end
