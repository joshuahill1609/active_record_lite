class MassObject
  def self.set_attrs(*attributes)
    @attributes = attributes
    attributes.each do |attr_name|
      attr_accessor attr_name
    end
  end#set

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
    results.map {|result| self.new(result)}
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
     if self.class.attributes.include?(attr_name)
       self.send("#{attr_name}=", value)
     else
       raise "mass assignment to unregistered attribute #{attr_name}"
     end
   end
  end
end


class Dog < MassObject
  set_attrs :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end
