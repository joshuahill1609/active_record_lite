class Object

  def new_attr_accessor(*accessors)
    #access any atributes that belong to self
    accessors.each do |symbol|
      define_method(symbol) do
        puts symbol
      end
    end

  end



end