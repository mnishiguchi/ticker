# frozen_string_literal: true

require "rubygems"
require "thor"

require_relative "./app"

# Defines CLI commands. This class is used in `exe/ticker` file.
module Ticker
  class CLI < Thor
    desc "query [SYMBOLS]", "Print stock prices for the specified symbols separated by comma or space"
    def query(*symbols)
      symbols = symbols.join(",") if symbols.is_a?(Array)
      raise "Please specify symbols" if symbols.size.zero?

      puts ::Ticker::App.query_and_format(symbols)
    end

    def self.exit_on_failure?
      true
    end
  end
end
