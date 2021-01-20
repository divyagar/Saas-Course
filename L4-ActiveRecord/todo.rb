require 'active_record'
require 'date'
require './connect_db'
# connect_db!
class Todo < ActiveRecord::Base
  def self.show_list
    overdues = Todo.where("due_date < ?",Date.today)
    dues_today = Todo.where(due_date: Date.today)
    dues_later = Todo.where("due_date > ?", Date.today)
    puts "My Todo-list\n\n\n"
    puts "Overdue\n"
    Todo.printTodos(overdues)
    puts "Due Today\n"
    Todo.printTodos(dues_today)
    puts "Due Later\n"
    Todo.printTodos(dues_later)
  end

  def self.printTodos(todos)
    todos.each do |todo|
      id = todo.id
      due_date = Date.today == todo.due_date ? nil : todo.due_date
      puts "#{id}. #{todo.to_displayable_string} #{due_date} \n"
    end
    puts "\n\n"
  end

  def to_displayable_string
    marker = completed ? '[X]' : '[ ]'
    "#{marker} #{todo_text}"
  end

  def self.add_task(h)
    puts h
    Todo.create!(todo_text: h[:todo_text], due_date: (Date.today + h[:due_in_days]), completed: false)
    Todo.all.last
  end

  def self.mark_as_complete!(todo_id)
    @todo = Todo.find(todo_id)
    @todo.completed = true
    @todo.save
    @todo
  end
end
