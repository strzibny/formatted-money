# FormattedMoney

For all Rubyist that use Integer for storing money values as cents. This is a dead simple gem for converting money from user inputs to Integer values for storing and fast precise calculations (and back). Does everything you need and nothing else. Well tested.

## Installation and requirements

Install the gem and require it:
```
$ gem install formatted-money
```
```ruby
require 'formatted-money'
```

FormattedMoney is built for Ruby 2.2.0 and higher.

## Object scope and limitations

FormattedMoney provides a simple way to present stored Integer money values saved as cents and a way to parse it back from user input.

Unfortunatelly support for custom number of *cents* nor Indian formatting is not supported ATM.

## Usage

First you create a formatter depending on the country style you would like, then simply call either `amount` or `cents` methods.

Available styles:

```ruby
> FormattedMoney::STYLES.keys
=> [:archentine, :armenian, :arubanian, :australian, :austrian, :bahamian, :batswanan, :bangladeshian, :belgian, :belizean, :bermudian, :bolivian, :bosnian, :brazilian, :british, :bruneian, :canadian, :cayman, :chinesian, :colombian, :costarican, :croatian, :cuban, :cypriot, :czech, :danish, :dutch, :dominican, :egyptian, :filipino, :finnish, :french, :german, :gibraltarian, :greek, :ghanaian, :guatemalan, :hondurican, :hk, :indonesian, :iranian, :irish, :israelian, :italian, :jamaikan, :kenyan, :latvian, :luxembourgian, :macedonian, :malaysian, :maltesian, :mozambican, :mexican, :norwegian, :nepalesian, :pakistani, :peruan, :portuguese, :romanian, :russian, :uae, :uruguayan, :us, :saudian, :singaporean, :spanish, :slovenian, :tanzanian, :turkish, :thai, :tongan, :venezuelan, :zealandian]
```

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
