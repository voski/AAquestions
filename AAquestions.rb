require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

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
end

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

class QuestionFollows
  attr_accessor :id, :question_id, :follower_id

  def initialize(params = {})
    self.id = params["id"]
    self.question_id = params["question_id"]
    self.follower_id = params["follower_id"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
      SQL
    QuestionFollows.new(raw_data[0])
  end
end

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
end

class QuestionLikes
  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    self.id = params["id"]
    self.question_id = params["question_id"]
    self.user_id = params["user_id"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
      SQL
    QuestionLikes.new(raw_data[0])
  end
end
