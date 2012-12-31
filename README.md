# formatted-money

For all Rubyist that use Integer for storing money values as cents. This is a dead simple gem for converting money from user inputs to Integer values for storing and fast precise calculations (and back). Does everything you need and nothing else. Well tested.

## Installation and Requirements

Install the gem and require it:
```
$ gem install formatted-money
```
```ruby
require 'formatted-money'
```
formatted-money requires Ruby 1.9.2. Don't use it with 1.8.x, 1.9.x should work though.
## Usage

Formatted float to cents:
```ruby
FormattedMoney.cents('1.394.000,56') => 139400056 
FormattedMoney.cents('7.899.994.000,56') => 789999400056
```
Cents to formatted float:
```ruby
FormattedMoney.amount(Integer(13820000)) => "138.200,00" 
```
European and American submodules are available:
```ruby
FormattedMoney::European.cents('4.000,56')  => 400056 
```
To change the defaul behaviour:
```ruby
FormattedMoney.delimiter = ' '
FormattedMoney.cents_separator = FormattedMoney::American::CENTS_SEPARATOR
FormattedMoney.amount(Integer(13820000)) => "138 200,00" 
```