# formatted-money

For all Rubyist that use Integer for storing money values as cents. This is a dead simple gem for converting money from user inputs to Integer values for storing and fast precise calculations (and back). Does everything you need and nothing else. Well tested.

## Installation and requirements

Install the gem and require it:
```
$ gem install formatted-money
```
```ruby
require 'formatted-money'
```
formatted-money requires Ruby 1.9.3. Don't use it with 1.8.x, 1.9.x should work though.

*Limitations:* this currently does not support custom number of *cents* nor Indian formatting.

## Usage

First you create a formatter depending on the country style you would like, then simply call either `amount` or `cents` methods.

### Czech Koruna example

```ruby
koruna_formatter = FormattedMoney.new(style: :czech)
koruna_formatter.amount(100000) # => 1.000,00
koruna_formatter.amount(-123456) # => -1.234,56
koruna_formatter.cents('1.234,56') # => 123456
```

### American Dollar example

```ruby
dollar_formatter = FormattedMoney.new(style: :us)
dollar_formatter.amount(100000) # => 1,000.00
dollar_formatter.amount(-123456) # => -1,234.56
dollar_formatter.cents('-1,234.56') # => -123456
```

### Custom style

If this library does not yet support style you need you can use the `FormattedMoney` class methods directly and provide your own settings:

```ruby
FormattedMoney.delimiter = ' '
FormattedMoney.cents_separator = ','
FormattedMoney.amount(13820000) # => "138 200,00"
FormattedMoney.cents('1 394 000,56') # => 139400056
```
