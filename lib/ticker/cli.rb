# frozen_string_literal: true

require "rubygems"
require "thor"

require_relative "./app"

# Defines CLI commands. This class is used in `exe/ticker` file.
module Ticker
  class CLI < Thor
    desc "q [SYMBOLS]", "Print stock prices for the specified symbols separated by comma or space"
    def q(*symbols)
      symbols = symbols.join(",") if symbols.is_a?(Array)
      if symbols.to_s.length.zero?
        puts "Please specify at leas one ticker symbols"
        invoke :help, ["q"]
      else
        puts ::Ticker::App.query_and_format(symbols)
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
