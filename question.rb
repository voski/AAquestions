class Question
  attr_accessor :id, :title, :body, :author_id

  def initialize(params = {})
    self.id = params["id"]
    self.title = params["title"]
    self.body = params["body"]
    self.author_id = params["author_id"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
      SQL
    Question.new(raw_data[0])
  end

  def self.find_by_author_id(author_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = :id
      SQL
    raw_data.map do |question|
      Question.new(question)
    end
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end
end
