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

  def self.find_by(hash)
    query = <<-SQL
      SELECT
        *
      FROM
        #{self.to_s.downcase.pluralize}
      WHERE
        #{self.non_empty_pairs(hash).map { |key, value| self.input(key, value) }.join(' AND ')}
    SQL
    raw_data = QuestionsDatabase.instance.execute(query, hash)
    raw_data.map do |row|
      self.new(row)
    end

  end

  def self.non_empty_pairs(hash)
    hash.select { |k, v| !v.nil? }
  end

  def self.input(key, value)
    "#{key} = :#{key}"
  end
end
