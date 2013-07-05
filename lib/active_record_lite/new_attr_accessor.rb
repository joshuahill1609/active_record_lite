class Object
  def new_attr_accessor(*symbols)
    symbols.each do |symbol|
      define_method(symbol) do
        instance_variable_get("@#{symbol}")
      end

      define_method("#{symbol}=") do |value|
        instance_variable_set("@#{symbol}", value)
      end
    end
  end
end


class Dog
  new_attr_accessor :name, :color

  def initialize(name, color)

    @name = name
    @color = color
  end
end