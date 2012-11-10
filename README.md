# formatted-money

## Usage

Formatted float to cents:
```ruby
require 'formatted-money'

FormattedMoney.cents('1.394.000,56') => 139400056 
FormattedMoney.cents('7.899.994.000,56') => 789999400056
```
Cents to formatted float:
```ruby
require 'formatted-money'

FormattedMoney.amount(Integer(13820000)) => "138.200,00" 
```
European and American submodules are available:
```ruby
FormattedMoney::European.cents('4.000,56')  => 400056 
```
To change the defauls behaviour:
```ruby
FormattedMoney.delimiter = ' '
FormattedMoney.cents_separator = FormattedMoney::American::CENTS_SEPARATOR
FormattedMoney.amount(Integer(13820000)) => "138 200,00" 
```