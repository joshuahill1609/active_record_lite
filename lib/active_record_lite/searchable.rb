require_relative './db_connection'

module Searchable
  def where(params)
    condition = params.map {|key, value| "#{key} = ?"}.join(" AND ")

    query = <<-SQL
    SELECT *
    FROM #{self.table_name}
    WHERE #{condition}
    SQL

    DBConnection.execute(query, *params.values)
  end
end
