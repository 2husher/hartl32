#!/usr/bin/env ruby

require 'rubygems'
require 'rack'

class HelloWorld
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello Rack!"]]
  end
end

Rack::Handler::WEBrick.run HelloWorld.new, :Port => 9292