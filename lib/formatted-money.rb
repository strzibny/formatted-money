# encoding: utf-8

# @title FormattedMoney
# @license MIT
# @author Josef Strzibny
module FormattedMoney
  class NumberNotInFloatFormat < StandardError; end
  class NumberNotInIntegerFormat < StandardError; end

  # American defaults
  # comma for delimiter and dot for cents separator
  module American
    DELIMITER = ','
    CENTS_SEPARATOR = '.'

    def self.cents(amount, round = true)
      FormattedMoney.cents(amount, round, DELIMITER, CENTS_SEPARATOR)
    end

    def self.amount(amount, omit_cents = false)
      FormattedMoney.amount(amount, omit_cents, DELIMITER, CENTS_SEPARATOR)
    end
  end

  # European defaults
  # dot for delimiter and comma for cents separator
  module European
    DELIMITER = '.'
    CENTS_SEPARATOR = ','

    def self.cents(amount, round = true)
      FormattedMoney.cents(amount, round, DELIMITER, CENTS_SEPARATOR)
    end

    def self.amount(amount, omit_cents = false)
      FormattedMoney.amount(amount, omit_cents, DELIMITER, CENTS_SEPARATOR)
    end
  end

  @@omit_cents = false
  @@round = true
  @@delimiter = FormattedMoney::European::DELIMITER
  @@cents_separator = FormattedMoney::European::CENTS_SEPARATOR
  @@escape_chars = ['.', '^', '$', '*']

  def self.escape_chars=(chars)
    @@escape_chars = chars
  end

  def self.omit_cents=(bool)
    @@omit_cents = bool
  end

  def self.round=(bool)
    @@round = bool
  end

  def self.delimiter=(delimiter)
    @@delimiter = delimiter
  end

  def self.cents_separator=(cents_separator)
    @@cents_separator = cents_separator
  end

  # Format Integer to float number with cents
  # @return [String] amount in human-readable format
  def self.amount(amount, omit_cents = @@omit_cents, delimiter = @@delimiter, cents_separator = @@cents_separator)
    check_integer(amount) unless amount.is_a? Integer

    amount = amount.to_s
    cents = amount[-2, 2]
    cents ||= '00'
    units = amount[0..-3]

    if units.empty?
      return '0' if omit_cents

      return String('0' + cents_separator + cents)
    end

    return String(number_with_delimiter(units, delimiter)) if omit_cents

    String(number_with_delimiter(units, delimiter) + cents_separator + cents)
  end

  # Format the float-formatted input to Integer for saving or for calculation
  # @return [Integer] money as cents
  def self.cents(amount, round = @@round, delimiter = @@delimiter, cents_separator = @@cents_separator)
    delimiter_regex = self.separator_regex(delimiter)
    cents_separator_regex = self.separator_regex(cents_separator)

    # Only zeros
    return 0 if self.only_zeros?(amount, delimiter_regex, cents_separator_regex)

    # Already integer
    return add_zero_cents amount if amount.is_a? Integer

    check_float(amount)
    if amount[0] == '-'
      amount[0] = ''
      negative = true
    else
      negative = false
    end

    # No cents
    amount = amount.delete(delimiter)
    return add_zero_cents amount if /^\d+$/.match amount

    # With cents
    units = amount.gsub(/#{cents_separator_regex}\d+/, '')
    cents = amount.gsub(/#{units}#{cents_separator_regex}/, '')

    # Round the last cent
    unless cents[2].nil? && round
      last_cent = cents[1]

      last_cent = Integer(last_cent) + 1 if Integer(cents[2]) >= 5

      return Integer(units + cents[0] + String(last_cent))
    end

    if negative
      Integer('-' + units + cents)
    else
      Integer(units + cents)
    end
  end

  def self.add_zero_cents(n)
    Integer(sprintf('%d00', n))
  end

  # Check if the given number is formatted as a float -
  # numbers should contain only digits, commas or dots.
  # Only numbers like 1.000.000.000,2056 or 2,150.3 are accepted
  def self.check_float(n)
    unless /^(-){0,1}[\d\.\,]*$/.match(n.to_s)
      throw NumberNotInFloatFormat, 'Float numbers can only be made out of digits, commas (,) or dots (.). Dash (-) is accepted at the beginning for negative numbers'
    end
  end

  def self.check_integer(n)
    unless /^(-){0,1}\d*$/.match(n.to_s)
      throw NumberNotInIntegerFormat, 'Integer numbers can only be made out of digits. Dash (-) is accepted at the beginning for negative numbers'
    end
  end

  def self.number_with_delimiter(number, delimiter)
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end

  def self.trim_leading_zeros(number)
    string = number.to_s.gsub(/^[0]*(.*)/, '\\1')
    string = '0' if string.empty?

    string
  end

  def self.separator_regex(separator)
    return '\\' + "#{separator}" if @@escape_chars.include? separator

    "#{separator}"
  end

  def self.only_zeros?(number, delimiter, cents_separator)
    return false unless /^[0#{delimiter}#{cents_separator}]*$/.match(number)

    true
  end
end
