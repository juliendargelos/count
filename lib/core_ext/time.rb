Time.instance_eval do
  include TimeSliceable

  def evening?
    hour.in?((18..23).to_a + (0..4).to_a)
  end
end
