# ReviewScraper

Application to help detect overly positive reviews on the [Dealer Rater](https://www.dealerrater.com) website.

The criteria used for determining if a review is more positive than another is the overall rating given. See [here](#areas-for-improvement) for some other (more complex) strategies that this code could be modified to use.

## Running the code

To run the code follow the steps below:

- Run `mix deps.get` to fetch dependencies
- Run `MIX_ENV=prod mix escript.build` to compile the application and build an executable
- Run `./review_scraper` to execute the application

## Running the tests

You can run the tests by executing `mix test`.

Another approach to running the tests is calling the alias `mix tmwtd` (*Tell Me What To Do*). This leverages the [`mix_test_watch`](https://github.com/lpil/mix-test.watch) library with the `--seed 0 --max-failures 1` flags to show you only one error (and the same error) at a time, so you can leave it running and focus on fixing that particular error, until you get a new error or the test suite passes. 

## Areas for improvement

- Improve the review ordering logic to use more variables
  - The number of employees mentioned (a review with more employees in it should be considered more positive than a review with less employees but the same overall rating).
  - Run a sentiment analysis algorithm in the review's body.
  - The review's date (the older a review, the less relevant it usually is to users).
- Add some integration tests around the CLI.
- Add typespecs.
- Add more visibility into the executable (i.e. a verbose mode).

