require 'active_record'
require 'date'
require './connect_db.rb'
# connect_db!
class Todo < ActiveRecord::Base
    def self.show_list
        todos = Todo.all
        overdue = "Overdue\n"
        due_today = "Due Today\n"
        due_later = "Due Later\n"
        todos.each do |todo|
            id = todo.id
            due_date =  Date.today == todo.due_date ? nil : todo.due_date
            str = "#{id}. #{todo.to_displayable_string} #{due_date} \n"

            if(todo.overdue?)
                overdue += str
            elsif(todo.due_today?)
                due_today += str
            else
                due_later += str
            end
        end

        puts "My Todo-list\n\n\n"
        puts overdue
        puts "\n\n"
        puts due_today
        puts "\n\n"
        puts due_later
    end

    def overdue?
        Date.today > due_date
    end

    def due_today?
        Date.today == due_date
    end

    def due_later?
        Date.today < due_date
    end

    def to_displayable_string
        marker = completed ? "[X]" : "[ ]"
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