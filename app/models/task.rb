class Task
  include MongoMapper::Document

  key :name,        String
  key :start,       String
  key :finish,      String
  key :duration,    String
  key :priority,    Integer
  key :project,     Integer
  key :description, String

  many :points
  many :plots
end

class Point
  include MongoMapper::EmbeddedDocument

  key :time,      String
  key :priority,  Integer

  belongs_to :task
end

class Plot
  include MongoMapper::EmbeddedDocument

  key :time,      String
  key :priority,  Integer

  belongs_to :task
end