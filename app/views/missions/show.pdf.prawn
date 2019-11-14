mission = @mission
quotation = @quotation
invoice = @invoice
view = self
color_primary = '42f4ce'
color_secondary = 'bbbbbb'
color_tertiary = 'dddddd'
color_background = 'ffffff'
color_foreground = '000000'

pdf do
  lib_font :texta, style: :black
  font_size 9

  # Header
  fill_color color_primary
  fill_rectangle [-margin_left, height], width, 140

  fill_color color_background
  text_transform spaced: true, upcase: true do
    title = quotation ? 'Devis' : 'Facture'
    float do
      font_size(14) { text title }
    end
    move_down 3
    indent width_of(transformed_text(title), size: 14) + 4 do
      transparent 0.9 do
        font_size(7) { text " • #{view.l mission.created_at.to_date, format: :long}" }
      end
    end
    move_down 1

    font_size 7 do
      transparent(0.9) { text "#{mission.company} / #{mission.project} / #{mission}" }
      move_cursor_to inner_height - 3
      text mission.user.full_name, align: :right
      transparent(0.9) { text "#{mission.user.phone} • #{mission.user.email}", align: :right }
    end
  end

  # Pricings table
  pricings_table_height = 76 + [mission.pricings.used.count, 1].max*32
  transparent(0.02) do
    fill_color color_foreground
    fill_rounded_rectangle [-22, inner_height - 40 + 2], inner_width/2 + 14, pricings_table_height + 4, 8
  end

  fill_color color_background
  fill_rounded_rectangle [-20, inner_height - 40], inner_width/2 + 10, pricings_table_height, 6.5

  lib_font :texta, style: :black
  fill_color color_primary
  span (inner_width - 60.0)/2 do
    text_transform spaced: true, upcase: true do
      move_cursor_to inner_height - 60
      text :tarifications
      fill_color color_tertiary
      move_up 2
      font_size(5) { text :jour_homme }
      fill_color color_secondary

      lib_font :texta, style: :bold
      table([
        ['Nom','Tarif HT','Tarif TTC'],
        *(mission.pricings.used.empty? ? [['Aucune tarification']] : []),
        *(mission.pricings.used.map{|p| [p.name + '   ', '   ' + p.man_day_price, '   ' + p.taxed_man_day_price]})
      ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: color_tertiary, border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
    end

    stroke_color color_background
    line_width 2
    fill_and_stroke { horizontal_line(0, inner_width) }
  end

  # Taxes table
  taxes_table_height = 76 + [mission.taxes.count, 1].max*32
  transparent(0.02) do
    fill_color color_foreground
    fill_rounded_rectangle [inner_width/2 + 8, inner_height - 40 + 2], inner_width/2 + 14, taxes_table_height + 4, 8
  end

  fill_color color_background
  fill_rounded_rectangle [inner_width/2 + 10, inner_height - 40], inner_width/2 + 10, taxes_table_height, 6.5

  lib_font :texta, style: :black
  fill_color color_primary
  span (inner_width - 60.0)/2, position: :right do
    text_transform spaced: true, upcase: true do
      move_cursor_to inner_height - 60
      text 'pondérations'
      fill_color color_tertiary
      move_up 2
      font_size(5) { text 'taxes_&_ajustements' }
      fill_color color_secondary

      lib_font :texta, style: :bold
      table([
        ['Nom','Pourcentage','Tarif (mission)'],
        *(mission.taxes.empty? ? [['Aucune pondération']] : []),
        *(mission.taxes.map{|t| [t.name + '   ', '   ' + t.percentage, '   ' + t.price]})
      ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: color_tertiary, border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
    end

    stroke_color color_background
    line_width 2
    fill_and_stroke { horizontal_line(0, inner_width) }
  end

  # Information box
  information_box_top = [pricings_table_height, taxes_table_height, 76].max + 54

  # Duration
  lib_font :texta, style: :black
  fill_color color_primary
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3 do
    text_transform spaced: true, upcase: true do
      text 'Durée de la mission'
      fill_color color_tertiary
      move_up 2
      font_size(5) { text 'durée totale avant livraison' }
      fill_color color_secondary
    end

    fill_color color_secondary
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.rounded_actual_duration }
  end

  # Price exct
  lib_font :texta, style: :black
  fill_color color_secondary
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3, position: :center do
    text_transform spaced: true, upcase: true do
      text 'Total', align: :right
      fill_color color_tertiary
      move_up 2
      font_size(5) { text 'Hors-taxe', align: :right }
      fill_color color_secondary
    end

    fill_color color_secondary
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.price, align: :right }
  end

  # Price
  lib_font :texta, style: :black
  fill_color color_primary
  move_cursor_to inner_height - information_box_top - 20
  span (inner_width - 60.0)/3, position: :right do
    text_transform spaced: true, upcase: true do
      text 'Total', align: :right
      fill_color color_tertiary
      move_up 2
      font_size(5) { text 'Toute taxe comprise', align: :right }
      fill_color color_secondary
    end

    fill_color color_secondary
    lib_font :texta, style: :bold
    move_down 7
    font_size(13) { text mission.taxed_price, align: :right }
  end

  # Tasks table
  tasks_table_top = information_box_top + 60
  move_cursor_to inner_height - tasks_table_top
  lib_font :texta, style: :black
  fill_color color_primary
  text_transform spaced: true, upcase: true do
    move_down 30
    text :prestations
    fill_color color_secondary

    lib_font :texta, style: :bold
    table([
      ['Tâche','Tarification', 'Durée', 'Tarif HT', 'Tarif TTC'],
      *(mission.tasks.map{|t| [t.name + '   ', '   ' + t.pricing.name, '   ' + t.duration, '   ' + t.price, '   ' + t.taxed_price]})
    ], header: true, width: inner_width, cell_style: { borders: [:bottom], border_colors: color_tertiary, border_widths: [0.5, 0.5, 0.5, 0.5], padding: [10, 0] })
  end

  stroke_color color_background
  line_width 2
  fill_and_stroke { horizontal_line(0, inner_width) }

  page_count.times do |i|
    go_to_page i + 1
    bounding_box [bounds.left, bounds.bottom + 21], width: inner_width do

      stroke_color color_background
      line_width 11
      fill_and_stroke { horizontal_line(0, inner_width) }

      move_down 6

      lib_font :texta, style: :black
      font_size 6
      text_transform spaced: true, upcase: true do

        if invoice
          fill_color color_primary
          invoice_number = "Facture ##{'%04d' % mission.id}"

          float do
            text invoice_number
          end

          indent width_of(transformed_text(invoice_number)) + 4 do
            text " • Pour #{mission.company}, #{mission.referent.full_address}"
          end

          float do
            fill_color color_tertiary
            text "#{mission.user.siret.present? ? "Siret #{mission.user.siret} • " : ''} TVA non applicable, art. 293 B du CGI"
          end
        else
          text ' '
        end

        text "#{i + 1} / #{page_count}", align: :right
      end
    end
  end
end
