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
    raw_data.map do |reply|
      Reply.new(reply)
    end
  end

  def self.find_by_question_id(question_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :id
      SQL
    raw_data.map do |reply|
      Reply.new(reply)
    end
  end

  def self.find_children_by_parent_id(parent_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, parent_id: parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = :parent_id
      SQL

      raw_data.map do |reply|
        Reply.new(reply)
      end
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    Reply.find_children_by_parent_id(id)    
  end
end
