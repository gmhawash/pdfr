require 'rubygems'
require 'bundler'
require 'pdf_forms'
Bundler.require

fdf = PdfForms.new '/usr/local/bin/pdftk', :flatten => true
fields = fdf.get_field_names 'pdfform.pdf'

filled_fields = Hash[fields.map {|x| [x, 'Yes']}]
p filled_fields
fdf.fill_form 'pdfform.pdf', 'filledform.pdf', filled_fields


fdf = PdfForms::Fdf.new :key => 'value', :other_key => 'other value'

puts fdf.to_fdf

fdf.save_to 'fdf_file.fdf'
