class Reply
  attr_accessor :id, :question_id, :parent_id, :author_id, :body

  def initialize(params = {})
    self.id = params["id"]
    self.question_id = params["question_id"]
    self.parent_id = params["parent_id"]
    self.author_id = params["author_id"]
    self.body = params["body"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
      SQL
    Reply.new(raw_data[0])
  end

  def self.find_by_user_id(author_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = :id
      SQL
    Reply.new(raw_data[0])
  end
end
