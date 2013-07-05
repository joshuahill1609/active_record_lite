require 'active_support/inflector'

require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'


class SQLObject < MassObject
  extend Searchable
  extend Associatable

  def self.set_table_name(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name.underscore
  end

  def self.all
    query = <<-SQL
      SELECT *
      FROM "#{@table_name}"
    SQL
    DBConnection.execute(query)
  end

  def self.find(id)
    query = <<-SQL
      SELECT *
      FROM "#{@table_name}"
      WHERE id = ?
    SQL
    result = DBConnection.execute(query, id)
    parse_all(result).first
  end

  def create
    attr_names = self.class.attributes.join(", ")
    question_marks = []
    self.class.attributes.count.times {question_marks << '?'}
    question_marks = question_marks.join(", ")
    query = <<-SQL
      INSERT INTO [#{self.class.table_name}] (#{attr_names}) VALUES (#{question_marks})
    SQL

    DBConnection.execute(query, *attribute_values)
  end

  def update
    set_line = self.class.attributes.map { |attr| "#{attr} = ?"}.join(", ")

    query = <<-SQL
      UPDATE #{self.class.table_name}
      SET #{set_line}
      WHERE id = ?
    SQL

    DBConnection.execute(query, *attribute_values, id)
  end

  def save
    if id.nil?
      create
    else
      update
    end
  end

  def attribute_values
    self.class.attributes.map { |attr| self.send(attr) }
  end
end
