module ImportXls
  extend self

  def import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
  end
end
