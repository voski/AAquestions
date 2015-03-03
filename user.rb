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

  def self.find_by_name(fname, lname)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
      SQL
    User.new(raw_data[0])
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end
end
