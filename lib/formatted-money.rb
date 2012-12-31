# encoding: utf-8

# @title FormattedMoney
# @license MIT
# @author Josef Strzibny
module FormattedMoney
  class NumberNotInFloatFormat < StandardError; end;
  class NumberNotInIntegerFormat < StandardError; end;

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
	  unless amount.is_a? Integer; self.check_integer(amount); end
	  
	  amount = amount.to_s
	  cents = amount[-2,2]
	  cents ||= '00'
	  units = amount[0..-3]
	  
	  if units.empty?
	    if omit_cents; return '0'; end

	    return String('0' + cents_separator + cents)
	  end

	  if omit_cents; return String(self.number_with_delimiter(units, delimiter)); end

	  String(self.number_with_delimiter(units, delimiter) + cents_separator + cents)
	end

	# Format the float-formatted input to Integer for saving or for calculation
	# @return [Integer] money as cents
	def self.cents(amount, round = @@round, delimiter = @@delimiter, cents_separator = @@cents_separator)
	  delimiter_regex = self.separator_regex(delimiter)
	  cents_separator_regex = self.separator_regex(cents_separator)
	  
	  # Only zeros
	  if self.only_zeros?(amount, delimiter_regex, cents_separator_regex); return 0; end;
	  
	  # Already integer
	  if amount.is_a? Integer; return self.add_zero_cents amount; end;
	  
	  self.check_float(amount)
    
    # No cents
    amount = amount.delete(delimiter)
		if /^\d+$/.match amount; return self.add_zero_cents amount; end;
    
		# With cents
		units = amount.gsub(/#{cents_separator_regex}\d+/,'')
		cents = amount.gsub(/#{units}#{cents_separator_regex}/,'')

		# Round the last cent
		unless cents[2].nil? and round
		  last_cent = cents[1]
		  
		  if Integer(cents[2]) >= 5; last_cent = Integer(last_cent) + 1; end
		  
		  return Integer(units + cents[0] + String(last_cent))
		end
		
		Integer(units + cents)
	end
	
	def self.add_zero_cents(n)
	  Integer(sprintf("%d00", n))
	end
	
	# Check if the given number is formatted as a float - 
	# numbers should contain only digits, commas or dots.
	# Only numbers like 1.000.000.000,2056 or 2,150.3 are accepted
	def self.check_float(n)
	  unless /^[\d\.\,]*$/.match(n.to_s)
	    throw NumberNotInFloatFormat, 'Float numbers can only be made out of digits, commas (,) or dots (.).'
	  end
	end
	
	def self.check_integer(n)
	  unless /^\d*$/.match(n.to_s)
	    throw NumberNotInIntegerFormat, 'Integer numbers can only be made out of digits.'
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
		if @@escape_chars.include? separator
		  return "\\" + "#{separator}"
		end
	
		return "#{separator}"
	end
  
  def self.only_zeros?(number, delimiter, cents_separator)   
    unless /^[0#{delimiter}#{cents_separator}]*$/.match(number) 
      return false;
    end
    
    return true;
  end
end