require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.create_table

    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    sql = <<-SQL
    INSERT INTO students(name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.new_from_db(row)
    new = Student.new
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name=? LIMIT 1)
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end



end
