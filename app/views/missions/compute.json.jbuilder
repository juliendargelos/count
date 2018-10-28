json.(@mission, :actual_duration, :price, :taxed_price)
json.estimated_ending_date l(@mission.estimated_ending_date, format: :long)
json.task @task, :duration, :price
