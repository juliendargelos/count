module TimeSliceable
  def only(*components)
    except [:year, :month, :day, :hour, :min, :sec] - components.flatten.map { |component| :"#{component}" }
  end

  def except(*components)
    change components.flatten.map { |component| [component, component.to_s.to_sym.in?([:month, :day]) ? 1 : 0] }.to_h
  end
end
