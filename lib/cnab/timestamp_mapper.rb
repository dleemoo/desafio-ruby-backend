# frozen_string_literal: true

module Cnab
  class TimestampMapper
    def call(line)
      input = String(line)
      Time.new(
        year(input), month(input), day(input),
        hour(input), minute(input), second(input),
        "+03:00"
      )
    rescue ArgumentError, TypeError
      nil
    end

    private

    def year(input)
      numeric_component_value(input[1..4], size: 4)
    end

    def month(input)
      numeric_component_value(input[5..6])
    end

    def day(input)
      numeric_component_value(input[7..8])
    end

    def hour(input)
      numeric_component_value(input[42..43])
    end

    def minute(input)
      numeric_component_value(input[44..45])
    end

    def second(input)
      numeric_component_value(input[46..47])
    end

    def numeric_component_value(str, size: 2)
      return str if String(str).match(/\A\d{#{size}}\Z/)

      raise ArgumentError
    end
  end
end
