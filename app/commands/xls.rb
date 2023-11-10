module Xls
  extend self

  def import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
  end

  def export

  end
end
