class QuestionFollows < ActiveRecordLite
  attr_accessor :id, :question_id, :follower_id

  def initialize(params = {})
    self.id = params["id"]
    self.question_id = params["question_id"]
    self.follower_id = params["follower_id"]
  end

  def self.followers_for_question_id(question_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      JOIN
        users ON users.id = question_follows.follower_id
      WHERE
        questions.id = :question_id
      SQL
    raw_data.map do |user|
      User.new(user)
    end
  end

  def self.followed_questions_for_user_id(user_id)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      JOIN
        users ON question_follows.follower_id = users.id
      WHERE
        users.id = :user_id
      SQL
    raw_data.map do |question|
      Question.new(question)
    end
  end

  def self.most_followed_questions(n)
    raw_data = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT :n
      SQL

    raw_data.map do |question|
      Question.new(question)
    end
  end
end
