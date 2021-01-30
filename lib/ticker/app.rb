# frozen_string_literal: true

require "net/http"
require "json"

# Checks stock prices using Yahoo Finance API.
# * the symbols param is required. e.g. "AAPL,MSFT,GOOG,BTC-USD"
# * example URL: https://query1.finance.yahoo.com/v7/finance/quote?symbols=AMZN
#
# ## Examples
#
#     >> puts Ticker::App.query_and_format("AAPL,MSFT,GOOG,BTC-USD")
#     AAPL        131.78     -0.18    (-0.14%) *
#     MSFT        231.80     -0.16    (-0.07%) *
#     GOOG       1833.50     -2.24    (-0.12%) *
#     BTC-USD   34237.10  -1973.29    (-5.45%)
#
module Ticker
  class App
    class Error < StandardError; end

    # Accepts comma-separaged symbols.
    def self.query_and_format(symbols)
      format(query(symbols))
    end

    def self.query(symbols, api = QuoteApi)
      result_list = api.call(symbols)
      return [] unless result_list.size.positive?

      result_list.map { |result_entry| ResultParser.call(result_entry) }
    end

    def self.format(parsed_result)
      if parsed_result.size.positive?
        parsed_result.map { |parsed_result_entry| ResultFormatter.call(*parsed_result_entry) }.join("")
      else
        "No results"
      end
    end
  end

  # Represents a quote API endpoint.
  class QuoteApi
    class Error < StandardError; end

    BASE_URL = "https://query1.finance.yahoo.com/v7/finance/quote"
    QUERY_STRING = ->(symbols) { "symbols=#{symbols}" }
    ENDPOINT = ->(symbols) { URI("#{BASE_URL}?#{QUERY_STRING[symbols]}") }

    def self.call(symbols)
      response = Net::HTTP.get_response(ENDPOINT[symbols])
      if response.code == "200"
        JSON.parse(response.body).dig("quoteResponse", "result")
      else
        []
      end
    rescue StandardError => e
      raise Error, e.message
    end
  end

  # Formats a result entry.
  class ResultFormatter
    class Error < StandardError; end

    RED = "\e[31m"
    GREEN = "\e[32m"
    CLEAR = "\e[0m"
    FMT_SYMBOL = "%<symbol>-10s"
    FMT_PRICE = "%<price>8.2f"
    FMT_DIFF = "%<diff>10.2f"
    FMT_PERCENT = "(%<percent>.2f%%)"
    FMT_SIGN = "%<non_regular_market_sign>s"

    def self.call(symbol, price, diff, percent, non_regular_market_sign)
      format("#{FMT_SYMBOL}#{FMT_PRICE}#{diff_color(diff)}#{FMT_DIFF}    #{FMT_PERCENT}#{CLEAR} #{FMT_SIGN}\n",
             symbol: symbol,
             price: price,
             diff: diff,
             percent: percent,
             non_regular_market_sign: non_regular_market_sign)
    rescue StandardError => e
      raise Error, e.message
    end

    def self.diff_color(diff)
      return "" if diff.zero?

      diff.negative? ? RED : GREEN
    end
  end

  # Extracts necessary info from raw result entry.
  class ResultParser
    class Error < StandardError; end

    # Returns an array of symbol, price, diff, percent and non_regular_market_sign.
    def self.call(result_entry)
      new(result_entry).call
    end

    attr_reader :result_entry

    def initialize(result_entry)
      @result_entry = result_entry
    end

    def call
      return  pre_market_values if pre_market?
      return  post_market_values if post_market?

      regular_market_values
    rescue StandardError => e
      raise Error, e.message
    end

    def pre_market?
      market_state, pre_market_change = result_entry.values_at("marketState", "preMarketChange")
      market_state == "PRE" && !pre_market_change.nil? && !pre_market_change.zero?
    end

    def post_market?
      market_state, post_market_change = result_entry.values_at("marketState", "postMarketChange")
      market_state != "REGULAR" && !post_market_change.nil? && !post_market_change.zero?
    end

    def pre_market_values
      result_entry.values_at("symbol", "preMarketPrice", "preMarketChange", "preMarketChangePercent") << "*"
    end

    def post_market_values
      result_entry.values_at("symbol", "postMarketPrice", "postMarketChange", "postMarketChangePercent") << "*"
    end

    def regular_market_values
      result_entry.values_at("symbol", "regularMarketPrice", "regularMarketChange", "regularMarketChangePercent") << ""
    end
  end
end
