# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'byebug'

def scrapper
  url = 'https://www.wattpad.com/stories/werewolf'
  unparsed_page = HTTParty.get(url) # get raw html file
  parsed_page = Nokogiri::HTML(unparsed_page) # parse the html file
  books = []
  books_list = parsed_page.css('div.browse-story-item') # 20 books
  page = 1
  per_page = books_list.count # 20
  total = parsed_page.css('div.panel-heading').text.split(' ')[0][0..-2].gsub(',', '').to_f.to_i * 1000 + 200
  last_page = (total / per_page).round # 61

  while page <= last_page
    pagination_url = 'https://www.wattpad.com/stories/werewolf'
    puts pagination_url
    puts "Page #{page}"
    puts ''
    pagination_unparsed_page = HTTParty.get(pagination_url) # get raw html file
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page) # parse the html file
    pagination_books_list = pagination_parsed_page.css('div.browse-story-item')
    pagination_books_list.each do |book_list|
      book = {
        title: book_list.css('a.title').text,
        author: book_list.css('a.username').text,
        description: book_list.css('div.description').text,
        rating: book_list.css('div.social-meta').text,
        url: book_list.css('a')[0].attributes['href'].value
      }
      books << book
      puts " Added the  #{book[:title]}"
    end
    page += 1
  end
  byebug
end
scrapper
