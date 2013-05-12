class Task
  include MongoMapper::Document

  key :name, String
  key :start,  String
  key :duration,  String
  key :priority,  Integer
  key :project,  Integer
  key :description,  String
  key :points,  Array
end