require "active_support/core_ext/string"

module GovukSchemas
  module Random
    class << self
      WORDS = %w[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut suscipit at mauris non bibendum. Ut ac massa est. Aenean tempor imperdiet leo vel interdum. Nam sagittis cursus sem ultricies scelerisque. Quisque porttitor risus vel risus finibus, eu sollicitudin nisl aliquet. Sed sed lectus ac dolor molestie interdum. Nam molestie pellentesque purus ac vestibulum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse non tempor eros. Mauris eu orci hendrerit, volutpat lorem in, tristique libero. Duis a nibh nibh.].freeze

      def string_for_type(type)
        if type == 'date-time'
          time
        elsif type == 'uri'
          uri
        else
          raise "Unknown attribute type `#{type}`"
        end
      end

      def time
        seconds_ago = rand(10_000_000) - 5_000_000
        (Time.now + seconds_ago).iso8601
      end

      # TODO: make this more random with query string, optional anchor.
      def uri
        "http://example.com#{base_path}#{anchor}"
      end

      def base_path
        "/" + rand(1..5).times.map { SecureRandom.uuid }.join('/')
      end

      def string(minimum_chars = nil, maximum_chars = nil)
        minimum_chars = minimum_chars || 0
        maximum_chars = maximum_chars || 100
        WORDS.sample(rand(minimum_chars..maximum_chars)).join(' ')
      end

      def bool
        rand(2) == 1
      end

      def anchor
        "##{SecureRandom.hex}"
      end

      def string_for_regex(pattern)
        case pattern.to_s
        when '^(placeholder|placeholder_.+)$'
          ['placeholder', "placeholder_#{WORDS.sample}"].sample
        when '^[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$'
          SecureRandom.uuid
        when "^/(([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})+(/([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)*)?$"
          base_path
        when "^[1-9][0-9]{3}[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[0-1])$"
          Date.today.iso8601
        when "^[1-9][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-1])$"
          Date.today.iso8601
        when "^#.+$"
          anchor
        when "^/(([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})+(/([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)*)?(\\?([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)?(#([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)?$"
          base_path
        when '[a-z0-9\-_]'
          "#{SecureRandom.hex}-#{SecureRandom.hex}"
        else
          raise "Regex pattern not found: #{pattern.inspect}"
        end
      end
    end
  end
end
