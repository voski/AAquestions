module Save
  def save
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL)
        INSERT INTO
          #{self.class.to_s.downcase.pluralize}(#{self.instance_variables[1..-1].map {|el| el[1..-1]}.join(', ')})
        VALUES
          (#{self.instance_variables[1..-1].map { |el| "'#{self.instance_variable_get(el)}'" }.join(', ') })
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, id: id)
        UPDATE
          #{self.class.to_s.downcase.pluralize}
        SET
          #{self.instance_variables[1..-1].map{ |inst| "#{inst[1..-1]} = '#{self.instance_variable_get(inst)}'"}.join(', ')}
        WHERE
          id = :id
        SQL
    end
  end
end
