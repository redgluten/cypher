#!/usr/bin/env ruby

# Gems
require 'rubygems'
require 'bundler/setup'
require 'json'
require 'thor'

class Cypher < Thor

  no_commands {
    # Get the code_words list from Json
    def parse_codes
      file     = File::open("wordlist.json")
      contents = file.read
      return JSON.parse(contents)
    end

    # Save the jibberish to a new file
    def save(idea)
      print "File encoded. Please enter a name for this idea: "
      idea_name = $stdin.gets.strip
      File::open( "idea-" + idea_name + ".md", "w" ) do |f|
        f << idea
      end
    end
  }

  # CLI Methods
  # ===========

  desc "new", "Get evil ideas and swap in code words"
  def new_idea
    print "Enter your new idea: "
    idea = $stdin.gets

    code_words = parse_codes

    # Substitute words with code_words list
    code_words.each do |word, substitution|
      idea.gsub!( word, substitution )
    end

    save(idea)
  end

  desc "show", "Print each idea out with the words fixed"
  def show_ideas
    Dir['idea-*.md'].each do |file_name|
      idea = File.read( file_name )

      code_words = parse_codes

      code_words.each do |real, code|
        idea.gsub!( code, real)
      end
      puts idea
    end
  end

  # Start the CLI
  Cypher.start

end