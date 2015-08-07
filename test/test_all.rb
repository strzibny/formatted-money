# encoding: utf-8

require 'minitest/autorun'
require 'formatted-money'

class TestFormattedMoney < Minitest::Test

  # Defaults to European style
  def test_conversion_to_cents
    assert_equal Integer(0), FormattedMoney.cents('0')
    assert_equal Integer(0), FormattedMoney.cents('0,00')
    assert_equal Integer(400056), FormattedMoney.cents('4.000,56')
    assert_equal Integer(4200056), FormattedMoney.cents('42.000,56')
    assert_equal Integer(139400056), FormattedMoney.cents('1.394.000,56')
    assert_equal Integer(789999400056), FormattedMoney.cents('7.899.994.000,56')
  end

  def test_european_conversion_to_cents
    assert_equal Integer(0), FormattedMoney::European.cents('0')
    assert_equal Integer(0), FormattedMoney::European.cents('0,00')
    assert_equal Integer(400056), FormattedMoney::European.cents('4.000,56')
    assert_equal Integer(4200056), FormattedMoney::European.cents('42.000,56')
    assert_equal Integer(139400056), FormattedMoney::European.cents('1.394.000,56')
    assert_equal Integer(789999400056), FormattedMoney::European.cents('7.899.994.000,56')
  end

  def test_american_conversion_to_cents
    assert_equal Integer(0), FormattedMoney::American.cents('0')
    assert_equal Integer(0), FormattedMoney::American.cents('0.00')
    assert_equal Integer(400056), FormattedMoney::American.cents('4,000.56')
    assert_equal Integer(4200056), FormattedMoney::American.cents('42,000.56')
    assert_equal Integer(139400056), FormattedMoney::American.cents('1,394,000.56')
    assert_equal Integer(789999400056), FormattedMoney::American.cents('7,899,994,000.56')
  end

  # Defaults to European style
  def test_formatted_amount
    assert_equal '0,00', FormattedMoney.amount(Integer(0))
    assert_equal '0,00', FormattedMoney.amount(Integer(00))
    assert_equal '1.000,00', FormattedMoney.amount(Integer(100000))
    assert_equal '1.234,56', FormattedMoney.amount(Integer(123456))
    assert_equal '138.200,00', FormattedMoney.amount(Integer(13820000))
    assert_equal '138.555.200,00', FormattedMoney.amount(Integer(13855520000))
    assert_equal '26.897.200,00', FormattedMoney.amount(Integer(2689720000))
  end

  # Strings containing only numbers should be fine as well
  def test_formatted_amount_from_string
    assert_equal '0,00', FormattedMoney.amount(String('0'))
    assert_equal '0,00', FormattedMoney.amount(String('00'))
    assert_equal '138.555.200,00', FormattedMoney.amount('13855520000')
  end

  def test_europen_formatted_amount
    assert_equal '0,00', FormattedMoney::European.amount(Integer(0))
    assert_equal '0,00', FormattedMoney::European.amount(Integer(00))
    assert_equal '1.000,00', FormattedMoney::European.amount(Integer(100000))
    assert_equal '1.234,56', FormattedMoney::European.amount(Integer(123456))
    assert_equal '138.200,00', FormattedMoney::European.amount(Integer(13820000))
    assert_equal '138.555.200,00', FormattedMoney::European.amount(Integer(13855520000))
    assert_equal '26.897.200,00', FormattedMoney::European.amount(Integer(2689720000))
  end

  def test_american_formatted_amount
    assert_equal '0.00', FormattedMoney::American.amount(Integer(0))
    assert_equal '0.00', FormattedMoney::American.amount(Integer(00))
    assert_equal '1,000.00', FormattedMoney::American.amount(Integer(100000))
    assert_equal '1,234.56', FormattedMoney::American.amount(Integer(123456))
    assert_equal '138,200.00', FormattedMoney::American.amount(Integer(13820000))
    assert_equal '138,555,200.00', FormattedMoney::American.amount(Integer(13855520000))
    assert_equal '26,897,200.00', FormattedMoney::American.amount(Integer(2689720000))
  end

  def test_check_float
    FormattedMoney.check_float('123,254')
    FormattedMoney.check_float('3,254.456')

	  assert_raises (ArgumentError) {
      FormattedMoney.check_float('123254d')
    }
	end

	def test_check_integer
	  FormattedMoney.check_integer('123254')
	  FormattedMoney.check_integer(123254)

	  assert_raises (ArgumentError) {
       FormattedMoney.check_integer('123254d')
    }
	end

  def test_number_with_delimiter
    assert_equal '1.000.000', FormattedMoney.number_with_delimiter('1000000','.')
    assert_equal '400|000', FormattedMoney.number_with_delimiter('400000','|')
    assert_equal '21,000,000,156', FormattedMoney.number_with_delimiter('21000000156',',')

    assert_equal '1 000 000', FormattedMoney.number_with_delimiter('1000000',' ')
    assert_equal '400 000', FormattedMoney.number_with_delimiter('400000',' ')
    assert_equal '21 000 000 156', FormattedMoney.number_with_delimiter('21000000156',' ')

    assert_equal '1.000.000', FormattedMoney.number_with_delimiter(1000000,'.')
    assert_equal '400|000', FormattedMoney.number_with_delimiter(400000,'|')
    assert_equal '21,000,000,156', FormattedMoney.number_with_delimiter(21000000156,',')
  end

  def test_trim_leading_zeros
    assert_equal '0', FormattedMoney.trim_leading_zeros('0')
    assert_equal '525', FormattedMoney.trim_leading_zeros('0525')
    assert_equal '2', FormattedMoney.trim_leading_zeros('0002')
    assert_equal '300', FormattedMoney.trim_leading_zeros('0300')
  end

  def test_separator_regex
    FormattedMoney.escape_chars = ['.', '^', '$', '*']

    assert_equal '\\.', FormattedMoney.separator_regex('.')
    assert_equal ',', FormattedMoney.separator_regex(',')

    FormattedMoney.escape_chars = []

    assert_equal '.', FormattedMoney.separator_regex('.')
  end

  def test_only_zeros
    delimiter = '\.'
    cents_separator = ','

    assert_equal true, FormattedMoney.only_zeros?('0', delimiter, cents_separator)
    assert_equal true, FormattedMoney.only_zeros?('0,0', delimiter, cents_separator)
    assert_equal true, FormattedMoney.only_zeros?('0,00', delimiter, cents_separator)
    assert_equal true, FormattedMoney.only_zeros?('0.00', delimiter, cents_separator)
    assert_equal true, FormattedMoney.only_zeros?('0.000,0', delimiter, cents_separator)
    assert_equal true, FormattedMoney.only_zeros?(',0', delimiter, cents_separator)
    assert_equal false, FormattedMoney.only_zeros?('01', delimiter, cents_separator)
    assert_equal false, FormattedMoney.only_zeros?('0|0', delimiter, cents_separator)
    assert_equal false, FormattedMoney.only_zeros?('000500', delimiter, cents_separator)
  end
end
