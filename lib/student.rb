require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end


  def self.create_table

    sql = <<-SQL
    CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)

      SQL

      DB[:conn].execute(sql)
  end

  def self.drop_table

    DB[:conn].execute("DROP TABLE students;")

  end

  def save

    if self.id
      self.update

    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)

        SQL

        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
  end

  def update

    DB[:conn].execute("UPDATE students SET name = ?, grade =? WHERE id =? ", self.name, self.grade, self.id)

  end

  def self.create (name, grade)
    Student.new(name, grade).save
  end

  def self.new_from_db (row)

    Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    db_row = DB[:conn].execute("SELECT * FROM students WHERE name = '#{name}'")[0]
    Student.new_from_db(db_row)
  end

end
