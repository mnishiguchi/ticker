# Ticker

Check stock prices in a terminal. The data is fetched from [Yahoo Finance API](https://query1.finance.yahoo.com/v7/finance/quote?symbols=AMZN).

## Usage

Clone the project

    $ git clone git@github.com:mnishiguchi/ticker.git

Change to the project directory

    $ cd ticker

And then set up the command

    $ bin/setup

Get the stock prices of Amazon and Apple by specifying ticker sybmols to the `ticker q` command

    $ ticker q AMZN,AAPL
    $ ticker q AMZN AAPL

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mnishiguchi/ticker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mnishiguchi/ticker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ticker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mnishiguchi/ticker/blob/master/CODE_OF_CONDUCT.md).
