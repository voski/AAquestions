require_relative 'save.rb'

class ActiveRecordLite
  include Save

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{self.to_s.downcase.pluralize}
      WHERE
        id = :id
      SQL
    self.new(raw_data)
  end
end
