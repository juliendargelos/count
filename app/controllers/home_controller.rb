class HomeController < ApplicationController
  def index
    missions = Mission.unscoped.ended.chronological by: :ending
    @months = {}

    if missions.any?
      newer_date = missions.first.ending_date.only(:year, :month) + 1.month - 1.day
      older_date = missions.last.ending_date.only :year, :month

      months = ((newer_date - older_date).to_f/1.month.to_f).to_i + 1

      months.times do |n|
        starting_date = older_date + n.months
        endind_date = starting_date + 1.month
        missions_for_month = missions.ended(after: starting_date, before: endind_date)
        @months[starting_date] = missions_for_month if missions_for_month.any?
      end
    end
  end
end
