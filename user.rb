require_relative 'save_module.rb'

class User
  attr_accessor :id, :fname, :lname

  include Save

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

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(id)
  end

  def average_karma
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS karma
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.author_id = :user_id
      SQL
    raw_data[0]["karma"]
  end
end
