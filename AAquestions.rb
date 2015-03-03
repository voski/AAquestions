require 'sqlite3'
require 'singleton'
require_relative 'user.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_likes.rb'
require_relative 'question_follows.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end
