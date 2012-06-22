require 'sanitize'

module TextSanitizer
  module ClassMethods
    def register_sanitizer op, hook=:before_validation, *opt_args
      self.class.send :define_method, "#{op}_text" do |*args|  # defines the class shorthand
        validate_and_set_text_fields_for op, hook, args
      end
      send :define_method, "#{op}_text_fields" do  # defines the instance shorthand
        attrs = self.send "text_fields_to_#{op}"
        do_for_text_fields attrs, op
      end
      unless opt_args.empty?  # if fields are given, send class shorthand
        self.send "#{op}_text", *opt_args
      end
    end

    private
      def validate_and_set_text_fields_for op, hook, args
        attr_name = "text_fields_to_#{op}"
        self.send hook, "#{op}_text_fields"  # defines the hook
        self.send :mattr_accessor, attr_name  # defines the accessor
        attributes = args.map do |attr|  # checks that the attributes exist
          raise "Can't #{op} attribute #{attr}: doesn't exist." unless
            attr.to_s.in? self.column_names
          attr
        end
        self.send "#{attr_name}=", attributes  # assigns the attributes
      end
  end

  extend ClassMethods

  def self.included base
    base.send :extend, ClassMethods
  end

  # instance methods
  private
    def do_for_text_fields text_fields, method
      return if text_fields.nil?
      text_fields.each do |text_field|
        text = self.read_attribute(text_field)
        return if text.nil?
        self.send "#{text_field}=", self.send(method.to_s, text)
      end
    end

    # helpers
    def capitalize text
      text.gsub(/\b\w+\b/){$&.capitalize}
    end

    def downcase text
      text.downcase
    end

    def sanitize html
      Sanitize.clean(
        html,
        :elements => %w(b div p i a span img u br),
        :attributes => {'a' => %w(href title)},
        :protocols => {'a' => {'href' => %w(http https mailto relative)},
                       'img' => {'src'  => %w(http https relative)} },
        :add_attributes => {'a' => {'rel' => 'nofollow'} }
      )
    end
end

ActiveRecord::Base.class_eval do
  include TextSanitizer
  register_sanitizer :capitalize
  register_sanitizer :downcase
  register_sanitizer :sanitize
end