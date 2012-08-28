require 'rubygems'
require 'bundler'
require 'pdf_forms'
Bundler.require

InputFile = 'pdfform.pdf'
OutputFile = 'outputfile.pdf'

def ask(question, file=OutputFile)
  %x(open #{file})
  puts question || "hit a key"
  gets
end

#ask('start from a fillable form', InputFile)

def read_fields(path)
  fdf = PdfForms.new '/usr/local/bin/pdftk', :flatten => true
  field_output = fdf.call_pdftk path, 'dump_data_fields'
  @fields = field_output.split(/^---\n/).map do |field_text|
    hash = {}
    if field_text =~ /^FieldName: (\w+)$/
      hash[:field_name] = $1
    end
    if field_text =~ /^FieldType: (\w+)$/
      hash[:field_type] = $1
    end
    hash
  end.compact.uniq
end

fields = read_fields(InputFile).reject(&:empty?)

fdf = PdfForms.new '/usr/local/bin/pdftk', :flatten => true

filled_fields = {}.tap do |hash|
  fields.each do |f|
    button = f[:field_type] =~ /Button/i
    hash[f[:field_name]] = button ? 'Yes' : f[:field_name]
  end
end

p filled_fields
fdf.fill_form InputFile, OutputFile, filled_fields

ask("you're looking at a filled out form")

def show_text
  Prawn::Document.generate("prawn_test.pdf") do
    text "What is up Doc?"

    font "Times-Roman"
    text "Written in Times.", :color => "FF0000", :align => :center

    font "Courier", :size => 20, :style => :bold_italic do
      text "Written in<color rgb='ff0000'> Courier.</color>", :color => "0000FF", :inline_format => true
    end
  end
end

def show_image(opts = {})
  Prawn::Document.generate("prawn_test.pdf") do
    image "Steamboat-willie.jpg", opts
  end
end

def start_from_a_template
  require_relative './prawn/manual/example_helper'

  filename = OutputFile
  Prawn::Example.generate("prawn_test.pdf", :template => filename) do
    start_new_page
    image "Steamboat-willie.jpg", :width => 200
  end
end

start_from_a_template
ask("With pictures too", "prawn_test.pdf")
