require 'active_support/core_ext/string'

module Save
  def save
    if id.nil?
      insert_db
    else
      update_db
    end
    true
  end

  private
    def table_name
      self.class.to_s.downcase.pluralize
    end

    def col_names
      instance_vars_no_id.map {|el| el[1..-1]}.join(', ')
    end

    def instance_vars_no_id
      self.instance_variables[1..-1]
    end

    def new_values
      instance_vars_no_id.map do |el|
        value = self.instance_variable_get(el)
        if value.is_a?(Integer)
          "#{value}"
        elsif value.nil?
          "null"
        else
          "'#{value}'"
        end
      end.join(', ')
    end

    def set_values
      instance_vars_no_id.map do |inst|
        value = self.instance_variable_get(inst)
        if value.is_a?(Integer)
          "#{inst[1..-1]} = #{value}"
        elsif value.nil?
          "#{inst[1..-1]} = null"
        else
          "#{inst[1..-1]} = '#{value}'"
        end
      end.join(', ')
    end

    def update_db
      QuestionsDatabase.instance.execute(<<-SQL, id: id)
        UPDATE
          #{table_name}
        SET
          #{set_values}
        WHERE
          id = :id
        SQL
    end

    def insert_db
      QuestionsDatabase.instance.execute(<<-SQL)
        INSERT INTO
          #{table_name}(#{col_names})
        VALUES
          (#{new_values})
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

end
