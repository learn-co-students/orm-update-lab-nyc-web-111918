require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute('
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        );')
  end

  def self.drop_table
    DB[:conn].execute('
      DROP TABLE students;'
    )
  end

  def save
    if @id = self.id
      self.update
    else
      DB[:conn].execute('
      INSERT INTO students (name, grade)
      VALUES (?, ?)', name, grade
    )
    @id = DB[:conn].execute(
      'SELECT last_insert_rowid()
      FROM students')[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    student = DB[:conn].execute(
      'SELECT *
      FROM students WHERE name = ?', name)[0]
    self.new_from_db(student)
  end

  def update
    DB[:conn].execute('
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?', self.name, self.grade, self.id)
  end

end #end of class

# binding.pry
#
# "last thing"
