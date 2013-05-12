class Task
  include MongoMapper::Document

  key :name,        String
  key :start,       String
  key :finish,      String
  key :duration,    String
  key :priority,    Integer
  key :project,     Integer
  key :description, String

  #many :points
end

class Points
  include MongoMapper::EmbeddedDocument

  key :time,      String
  key :priority,  Integer
end