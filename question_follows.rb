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
