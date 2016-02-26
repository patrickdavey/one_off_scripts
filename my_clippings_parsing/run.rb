require 'pry'
require 'kindleclippings'
require 'fileutils'
require 'active_support/inflector'

parser = KindleClippings::Parser.new

clippings = parser.parse_file('My Clippings.txt')
FileUtils.rm(Dir.glob("*.md"))

def formatted_content(content)
  lines = []
  while index = content.index(/\s/, 70) do
    shorter_line = content.slice!(0..(index -1))
    lines << "> #{shorter_line.strip}"
  end
  lines << "> #{content.strip}"
  lines.join("\n")
end

def write_title(filename, title)
  File.open(filename,  "w") do |file|
    file.write("## Selected quotes from #{title}")
  end
end

def save_highlight_to_file(highlight)
  filename = "#{highlight.book_title.parameterize}.md"
  write_title(filename, highlight.book_title) unless File.exist?(filename)
  File.open(filename,  "a+") do |file|
    file.write("\n\n")
    file.write(formatted_content(highlight.content))
  end
end

clippings.highlights.each do |highlight|
  save_highlight_to_file(highlight)
end

