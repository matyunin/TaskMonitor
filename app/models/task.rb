class Task
  include MongoMapper::Document

  key :name,        String
  key :start,       String
  key :finish,      String
  key :duration,    String
  key :priority,    Integer
  key :project,     Integer
  key :description, String

  many :points, :dependent => :destroy
  many :plots, :dependent => :destroy
end

class Point
  include MongoMapper::Document

  key :time,      String
  key :priority,  Integer

  belongs_to :task, :dependent => :destroy
end

class Plot
  include MongoMapper::Document

  key :time,      String
  key :priority,  Integer

  belongs_to :task, :dependent => :destroy
end