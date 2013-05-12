class Task
  include MongoMapper::Document

  key :name, String
  key :start,  Integer
  key :duration,  Integer
  key :priority,  Integer
  key :description,  String
  key :points,  Array
end