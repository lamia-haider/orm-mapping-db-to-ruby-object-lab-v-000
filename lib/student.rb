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


end
