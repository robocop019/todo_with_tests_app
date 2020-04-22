require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#complete_all_tasks!' do
    it 'should mark all tasks complete from the list' do
      list = List.create(name: 'My favs')
      Task.create(complete: false, list_id: list.id)
      Task.create(complete: false, list_id: list.id)

      list.complete_all_tasks!

      list.tasks.each do |task|
        expect(task.complete).to eq(true)
      end
    end
  end

  describe '#snooze_all_tasks!' do
    it 'should add 1 hour to the deadline on all tasks in a list' do
      time = Time.now
      list = List.create(name: 'List 1')
      5.times do 
        Task.create(deadline: time, list_id: list.id)
      end

      list.snooze_all_tasks!

      list.tasks.each do |task|
        expect(task.deadline).to eq(time + 1.hour)
      end
    end
  end

  describe '#total_duration' do
    it 'should return the total amount of time all the tasks in a list will take' do 

      time = 5
      list = List.create(name: 'Test List')
      5.times do 
        Task.create(duration: time, list_id: list.id)
        time += 5
      end

      expect(list.total_duration).to eq(75)
    end 
  end

  describe '#incomplete_tasks' do
    it 'should return an array of all incomplete tasks in a list' do 
      list = List.create(name: 'Test List')
      Task.create(name: 'Task 1', complete: false, list_id: list.id)
      Task.create(name: 'Task 2', complete: true, list_id: list.id)
      Task.create(name: 'Task 3', complete: false, list_id: list.id)

      expect(list.incomplete_tasks.pluck('name')).to match_array(['Task 1', 'Task 3'])
    end
  end

  describe '#favorite_tasks' do
    it 'should return an array of all the favorite tasks in a list' do 
      list = List.create(name: 'Test List')
      Task.create(name: 'Task 1', favorite: false, list_id: list.id)
      Task.create(name: 'Task 2', favorite: true, list_id: list.id)
      Task.create(name: 'Task 3', favorite: true, list_id: list.id)

      expect(list.favorite_tasks.pluck('name')).to match_array(['Task 2', 'Task 3'])
    end
  end
end
