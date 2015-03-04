class QuestionLikes
  attr_accessor :id, :question_id, :user_id

  def initialize(params = {})
    self.id = params["id"]
    self.question_id = params["question_id"]
    self.user_id = params["user_id"]
  end

  def self.find_by_id(id)
    raw_data = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
      SQL
    QuestionLikes.new(raw_data)
  end

  def self.likers_for_question_id(question_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes on users.id = question_likes.user_id
      WHERE
        question_likes.question_id = :id
      SQL

    raw_data.map do |user|
      User.new(user)
    end
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.get_first_value(<<-SQL, id: question_id)
      SELECT
        COUNT(*) AS likes
      FROM
        question_likes
      WHERE
        question_likes.question_id = :id
      SQL
  end

  def self.liked_questions_for_user_id(user_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = :user_id
      SQL

    raw_data.map do |question|
      Question.new(question)
    end
  end

  def self.most_liked_questions(n)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        :n
      SQL

    raw_data.map do |question|
      Question.new(question)
    end
  end
end
