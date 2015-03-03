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

  def followers
    QuestionFollows.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    QuestionLikes.likers_for_question_id(id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(id)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def save
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, title: title, body: body, author_id: author_id)
        INSERT INTO
          questions(title, body, author_id)
        VALUES
          (:title, :body, :author_id)
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, title: title, body: body, author_id: author_id, id: id)
        UPDATE
          questions
        SET
          title = :title, body = :body, author_id = :author_id
        WHERE
          id = :id
        SQL
    end
  end
end
