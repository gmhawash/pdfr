require 'rubygems'
require 'bundler'

Bundler.require


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

  filename = "filledform.pdf"
  Prawn::Example.generate("prawn_test.pdf", :template => filename) do
    start_new_page
    image "Steamboat-willie.jpg", :width => 200
  end
end

def ask
  %x(open prawn_test.pdf)
  puts "hit a key"
  gets
end

show_text
ask
show_image
ask
show_image(:width => 100)
ask
start_from_a_template
ask
