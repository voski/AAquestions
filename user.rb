class User
  attr_accessor :id, :fname, :lname

  def initialize(params = {})
    self.id = params["id"]
    self.fname = params["fname"]
    self.lname = params["lname"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
      SQL
    User.new(raw_data[0])
  end
end
