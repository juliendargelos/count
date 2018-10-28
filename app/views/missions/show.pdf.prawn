mission = @mission
view = self

pdf do
  lib_font :texta, style: :black
  font_size 9

  # Header
  fill_color '42f4ce'
  fill_rectangle [-margin_left, height], width, 140

  fill_color 'ffffff'
  text_transform spaced: true, upcase: true do
    font_size(14) { text :devis }
    move_up 6

    font_size 7 do
      transparent(0.9) { text "#{mission.project} • #{mission} • #{view.l(Date.today, format: :long)}" }
      move_cursor_to inner_height
      text mission.user.full_name, align: :right
      transparent(0.9) { text "#{mission.user.phone} • #{mission.user.email}", align: :right }
    end
  end

  # Pricings table
  pricings_table_height = 76 + [mission.pricings.used.count, 1].max*32
  transparent(0.01) do
    fill_color '000000'
    fill_rounded_rectangle [-22, inner_height - 40 + 2], inner_width/2 + 14, pricings_table_height + 4, 8
  end

  fill_color 'ffffff'
  fill_rounded_rectangle [-20, inner_height - 40], inner_width/2 + 10, pricings_table_height, 6.5

  lib_font :texta, style: :black
  fill_color '42f4ce'
  span (inner_width - 60.0)/2 do
    text_transform spaced: true, upcase: true do
      move_cursor_to inner_height - 60
      text :tarifications
      fill_color 'eeeeee'
      move_up 2
      font_size(5) { text :jour_homme }
      fill_color 'cccccc'

      lib_font :texta, style: :bold
      table([
        ['Nom','Tarif HT','Tarif TTC'],
        *(mission.pricings.used.empty? ? [['Aucune tarification']] : []),
        *(mission.pricings.used.map{|p| [p.name + '   ', '   ' + p.man_day_price, '   ' + p.taxed_man_day_price]})
      ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: 'eeeeee', border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
    end

    stroke_color 'ffffff'
    line_width 2
    fill_and_stroke { horizontal_line(0, inner_width) }
  end

  # Taxes table
  taxes_table_height = 76 + [mission.taxes.count, 1].max*32
  transparent(0.01) do
    fill_color '000000'
    fill_rounded_rectangle [inner_width/2 + 8, inner_height - 40 + 2], inner_width/2 + 14, taxes_table_height + 4, 8
  end

  fill_color 'ffffff'
  fill_rounded_rectangle [inner_width/2 + 10, inner_height - 40], inner_width/2 + 10, taxes_table_height, 6.5

  lib_font :texta, style: :black
  fill_color '42f4ce'
  span (inner_width - 60.0)/2, position: :right do
    text_transform spaced: true, upcase: true do
      move_cursor_to inner_height - 60
      text 'pondérations'
      fill_color 'eeeeee'
      move_up 2
      font_size(5) { text 'taxes_&_ajustements' }
      fill_color 'cccccc'

      lib_font :texta, style: :bold
      table([
        ['Nom','Pourcentage','Tarif (mission)'],
        *(mission.taxes.empty? ? [['Aucune pondération']] : []),
        *(mission.taxes.map{|t| [t.name + '   ', '   ' + t.percentage, '   ' + t.price]})
      ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: 'eeeeee', border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
    end

    stroke_color 'ffffff'
    line_width 2
    fill_and_stroke { horizontal_line(0, inner_width) }
  end

  # Information box
  information_box_top = [pricings_table_height, taxes_table_height, 76].max + 54

  # Duration
  lib_font :texta, style: :black
  fill_color '42f4ce'
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3 do
    text_transform spaced: true, upcase: true do
      text 'Durée de la mission'
      fill_color 'eeeeee'
      move_up 2
      font_size(5) { text 'durée totale avant livraison' }
      fill_color 'cccccc'
    end

    fill_color 'cccccc'
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.rounded_actual_duration }
  end

  # Price exct
  lib_font :texta, style: :black
  fill_color 'cccccc'
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3, position: :center do
    text_transform spaced: true, upcase: true do
      text 'Total', align: :right
      fill_color 'eeeeee'
      move_up 2
      font_size(5) { text 'Hors-taxe', align: :right }
      fill_color 'cccccc'
    end

    fill_color 'cccccc'
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.price, align: :right }
  end

  # Price
  lib_font :texta, style: :black
  fill_color '42f4ce'
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3, position: :right do
    text_transform spaced: true, upcase: true do
      text 'Total', align: :right
      fill_color 'eeeeee'
      move_up 2
      font_size(5) { text 'Toute taxe comprise', align: :right }
      fill_color 'cccccc'
    end

    fill_color 'cccccc'
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.taxed_price, align: :right }
  end

  # Tasks table
  tasks_table_top = information_box_top + 60
  move_cursor_to inner_height - tasks_table_top
  lib_font :texta, style: :black
  fill_color '42f4ce'
  text_transform spaced: true, upcase: true do
    move_down 30
    text :prestations
    fill_color 'cccccc'

    lib_font :texta, style: :bold
    table([
      ['Tâche','Tarification', 'Durée', 'Tarif HT', 'Tarif TTC'],
      *(mission.tasks.map{|t| [t.name + '   ', '   ' + t.pricing.name, '   ' + t.duration, '   ' + t.price, '   ' + t.taxed_price]})
    ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: 'eeeeee', border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
  end

  stroke_color 'ffffff'
  line_width 2
  fill_and_stroke { horizontal_line(0, inner_width) }
end
