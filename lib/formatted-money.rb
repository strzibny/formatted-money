class FormattedMoney
  class NumberNotInFloatFormat < StandardError; end
  class NumberNotInIntegerFormat < StandardError; end

  DOT_AS_DECIMAL_MARK   = { delimiter: ',', decimal_mark: '.' }.freeze
  COMMA_AS_DECIMAL_MARK = { delimiter: '.', decimal_mark: ',' }.freeze

  STYLES = {
    archentine: COMMA_AS_DECIMAL_MARK,
    armenian: DOT_AS_DECIMAL_MARK,
    arubanian: DOT_AS_DECIMAL_MARK,
    australian: DOT_AS_DECIMAL_MARK,
    austrian: COMMA_AS_DECIMAL_MARK,
    bahamian: DOT_AS_DECIMAL_MARK,
    batswanan: DOT_AS_DECIMAL_MARK,
    bangladeshian: DOT_AS_DECIMAL_MARK,
    belgian: COMMA_AS_DECIMAL_MARK,
    belizean: DOT_AS_DECIMAL_MARK,
    bermudian: DOT_AS_DECIMAL_MARK,
    bolivian: DOT_AS_DECIMAL_MARK,
    bosnian: DOT_AS_DECIMAL_MARK,
    brazilian: COMMA_AS_DECIMAL_MARK,
    british: DOT_AS_DECIMAL_MARK,
    bruneian: DOT_AS_DECIMAL_MARK,
    canadian: DOT_AS_DECIMAL_MARK,
    cayman: DOT_AS_DECIMAL_MARK,
    chinesian: DOT_AS_DECIMAL_MARK,
    colombian: COMMA_AS_DECIMAL_MARK,
    costarican: COMMA_AS_DECIMAL_MARK,
    croatian: COMMA_AS_DECIMAL_MARK,
    cuban: DOT_AS_DECIMAL_MARK,
    cypriot: COMMA_AS_DECIMAL_MARK,
    czech: COMMA_AS_DECIMAL_MARK,
    danish: COMMA_AS_DECIMAL_MARK,
    dutch: COMMA_AS_DECIMAL_MARK,
    dominican: DOT_AS_DECIMAL_MARK,
    egyptian: DOT_AS_DECIMAL_MARK,
    filipino: DOT_AS_DECIMAL_MARK,
    finnish: { delimiter: ' ', decimal_mark: ',' },
    french: { delimiter: ' ', decimal_mark: ',' },
    german: COMMA_AS_DECIMAL_MARK,
    gibraltarian: DOT_AS_DECIMAL_MARK,
    greek: COMMA_AS_DECIMAL_MARK,
    ghanaian: DOT_AS_DECIMAL_MARK,
    guatemalan: DOT_AS_DECIMAL_MARK,
    hondurican: DOT_AS_DECIMAL_MARK,
    hk: DOT_AS_DECIMAL_MARK,
    indonesian: COMMA_AS_DECIMAL_MARK,
    iranian: DOT_AS_DECIMAL_MARK,
    irish: DOT_AS_DECIMAL_MARK,
    israelian: DOT_AS_DECIMAL_MARK,
    italian: COMMA_AS_DECIMAL_MARK,
    jamaikan: DOT_AS_DECIMAL_MARK,
    kenyan: DOT_AS_DECIMAL_MARK,
    latvian: DOT_AS_DECIMAL_MARK,
    luxembourgian: COMMA_AS_DECIMAL_MARK,
    macedonian: DOT_AS_DECIMAL_MARK,
    malaysian: DOT_AS_DECIMAL_MARK,
    maltesian: DOT_AS_DECIMAL_MARK,
    mozambican: COMMA_AS_DECIMAL_MARK,
    mexican: DOT_AS_DECIMAL_MARK,
    norwegian: COMMA_AS_DECIMAL_MARK,
    nepalesian: DOT_AS_DECIMAL_MARK,
    pakistani: DOT_AS_DECIMAL_MARK,
    peruan: DOT_AS_DECIMAL_MARK,
    portuguese: { delimiter: ' ', decimal_mark: ',' },
    romanian: COMMA_AS_DECIMAL_MARK,
    russian: COMMA_AS_DECIMAL_MARK,
    uae: DOT_AS_DECIMAL_MARK,
    uruguayan: COMMA_AS_DECIMAL_MARK,
    us: DOT_AS_DECIMAL_MARK,
    saudian: DOT_AS_DECIMAL_MARK,
    singaporean: DOT_AS_DECIMAL_MARK,
    spanish: COMMA_AS_DECIMAL_MARK,
    slovenian: COMMA_AS_DECIMAL_MARK,
    tanzanian: DOT_AS_DECIMAL_MARK,
    turkish: DOT_AS_DECIMAL_MARK,
    thai: DOT_AS_DECIMAL_MARK,
    tongan: DOT_AS_DECIMAL_MARK,
    venezuelan: COMMA_AS_DECIMAL_MARK,
    zealandian: DOT_AS_DECIMAL_MARK
  }

  @@omit_cents = false
  @@round = true
  @@delimiter = '.'
  @@cents_separator = ','
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
  def self.amount(amount, omit_cents: @@omit_cents, delimiter: @@delimiter, cents_separator: @@cents_separator)
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
  def self.cents(amount, round: @@round, delimiter: @@delimiter, cents_separator: @@cents_separator)
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

  def initialize(style:, omit_cents: @@omit_cents, round: @@round)
    @style           = style
    @omit_cents      = omit_cents
    @round           = round
    @delimiter       = STYLES[@style.to_sym][:delimiter]
    @cents_separator = STYLES[@style.to_sym][:decimal_mark]
  end

  def amount(amount)
    FormattedMoney.amount(amount, omit_cents: @omit_cents, delimiter: @delimiter, cents_separator: @cents_separator)
  end

  def cents(amount)
    FormattedMoney.cents(amount, round: @round, delimiter: @delimiter, cents_separator: @cents_separator)
  end
end
