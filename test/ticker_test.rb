# frozen_string_literal: true

require "test_helper"

class TickerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ticker::VERSION
  end

  describe ".query" do
    it "returns an array of five-element tuples" do
      assert_equal [["SPY", 369.33, -0.74002075, -0.19996777, "*"]], Ticker.query("SPY", QueryApiStub)
    end
  end

  describe ".format" do
    it "returns an array of five-element tuples" do
      assert_equal "SPY         369.33     -0.74    (-0.20%) *\n",
                   Ticker.format([["SPY", 369.33, -0.74002075, -0.19996777, "*"]])
    end
  end

  class QueryApiStub
    def self.call(_symbols)
      [{ "language" => "en-US", "region" => "US", "quoteType" => "ETF", "triggerable" => true,
         "quoteSourceName" => "Delayed Quote", "currency" => "USD", "shortName" => "SPDR S&P 500",
         "regularMarketPrice" => 370.07, "regularMarketTime" => 1_611_954_001, "regularMarketChange" => -7.56,
         "regularMarketOpen" => 375.63, "regularMarketDayHigh" => 376.67, "regularMarketDayLow" => 368.27,
         "regularMarketVolume" => 126_765_121, "exchange" => "PCX", "market" => "us_market", "tradeable" => false,
         "priceHint" => 2, "marketState" => "POSTPOST", "postMarketChangePercent" => -0.19996777,
         "postMarketTime" => 1_611_968_399, "postMarketPrice" => 369.33, "postMarketChange" => -0.74002075,
         "regularMarketChangePercent" => -2.00196, "regularMarketDayRange" => "368.27 - 376.67",
         "regularMarketPreviousClose" => 377.63, "bid" => 369.33, "ask" => 369.92, "bidSize" => 29, "askSize" => 13,
         "messageBoardId" => "finmb_6160262", "fullExchangeName" => "NYSEArca", "longName" => "SPDR S&P 500 ETF Trust",
         "financialCurrency" => "USD", "averageDailyVolume3Month" => 70_433_169,
         "averageDailyVolume10Day" => 68_062_775, "fiftyTwoWeekLowChange" => 151.81001,
         "fiftyTwoWeekLowChangePercent" => 0.6955467, "fiftyTwoWeekRange" => "218.26 - 385.85",
         "fiftyTwoWeekHighChange" => -15.779999, "fiftyTwoWeekHighChangePercent" => -0.040896717,
         "fiftyTwoWeekLow" => 218.26, "fiftyTwoWeekHigh" => 385.85, "ytdReturn" => 18.4,
         "trailingThreeMonthReturns" => 12.12, "trailingThreeMonthNavReturns" => 12.1,
         "sharesOutstanding" => 917_782_016, "fiftyDayAverage" => 374.40485, "fiftyDayAverageChange" => -4.334839,
         "fiftyDayAverageChangePercent" => -0.011577945, "twoHundredDayAverage" => 349.13202,
         "twoHundredDayAverageChange" => 20.937988, "twoHundredDayAverageChangePercent" => 0.05997155,
         "marketCap" => 339_643_596_800, "sourceInterval" => 15, "exchangeTimezoneName" => "America/New_York",
         "exchangeTimezoneShortName" => "EST", "gmtOffSetMilliseconds" => -18_000_000, "esgPopulated" => false,
         "exchangeDataDelayedBy" => 0, "symbol" => "SPY" }]
    end
  end
end
