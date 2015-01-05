module Contexts
  module Extensions
    module Text

      # Transform the string from using the underscore notation to using spaces
      # and an uppercase letter on each word.
      #
      # @param text [String]
      #
      # @return [String]
      def titlecase(text)
        text = text.to_s.dup
        text.gsub!("_", " ")
        text.gsub!(/\b(\w)/, &:upcase)
        text
      end

    end
  end
end
