task default: %w[rdoc]

require "rdoc/task"
RDoc::Task.new do |doc|
    doc.main = "README.md"
    doc.rdoc_files.include "src/**/*.rb", "README.md"
    doc.rdoc_dir = "docs"
end
