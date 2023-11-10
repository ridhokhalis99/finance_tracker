module Xls
  extend self

  def import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
  end

  def export(headers, xls_rows)
    package = Axlsx::Package.new
    workbook = package.workbook

    header_style = workbook.styles.add_style(bg_color: "00", fg_color: "FF", b: true, border: {style: :thin, color: "00"})

    workbook.add_worksheet(name: 'Transactions') do |sheet|
      sheet.add_row headers, style: header_style
      xls_rows.each do |row|
        sheet.add_row row
      end
    end
    package.to_stream.read
  end
end
