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
