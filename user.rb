require_relative 'save.rb'

class User
  attr_accessor :id, :fname, :lname

  include Save

  def initialize(params = {})
    self.id = params["id"]
    self.fname = params["fname"]
    self.lname = params["lname"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
      SQL
    User.new(raw_data)
  end

  # BONUS DIRECTIONS FOR ACTIVE RECORD LITE
  # User.find_by_fname('David')
  # User.find_by(fname: 'David', lname: 'Runger')

  def self.find_by_name(fname, lname) # http://www.rubydoc.info/github/luislavena/sqlite3-ruby/SQLite3/Database
    raw_data = QuestionsDatabase.instance.get_first_row(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
      SQL
    User.new(raw_data)
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
    QuestionsDatabase.instance.get_first_value(<<-SQL, user_id: id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS karma
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.author_id = :user_id
      SQL
  end
end
