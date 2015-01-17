#!/usr/bin/env ruby

# Gems
require 'rubygems'
require 'bundler/setup'
require 'json'
require 'thor'

class Cypher < Thor

  desc "init", "Get the code_words list from Json"
  def init
    file       = File::open("wordlist.json")
    contents   = file.read

    return JSON.parse(contents)
  end


  desc "New ideas", "Get evil ideas and swap in code words"
  def new_idea(code_words)
    print "Enter your new idea: "
    idea = gets

    # Substitute words with code_words list
    code_words.each do |word, substitution|
      idea.gsub!( word, substitution )
    end

    save(idea)
  end

  desc "Save idea", "Save the jibberish to a new file"
  def save(idea)
    print "File encoded. Please enter a name for this idea: "
    idea_name = gets.strip
    File::open( "idea-" + idea_name + ".md", "w" ) do |f|
      f << idea
    end
  end

  desc "Show ideas", "Print each idea out with the words fixed"
  def show_ideas
    Dir['idea-*.txt'].each do |file_name|
      idea = File.read( file_name )
      code_words.each do |real, code|
        idea.gsub!( code, real)
      end
      puts idea
    end
  end

  # Start the CLI
  Cypher.start

end