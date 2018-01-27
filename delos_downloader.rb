#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'prawn'

BASE_URL = 'https://svdelos.com/travel-blogs/page/PAGE/?order=SORT'
PAGE_URL= 'https://svdelos.com/travel-blogs/fixing-stuff-remote-places-brian/'
FILE = 'delos-blogs.pdf'
IMAGE_SCALE= 0.5
FONT_PATH = './OpenSans-Regular.ttf'

def crawl_article url
  page = Nokogiri::HTML(open(url))

  blog_title = page.css(".entry-header").text

  blog_text = page.css(".entry-content").text

  image_links = page.css(".alignnone").collect do |tag|
    tag.attr("src")
  end
  
  return [blog_title, blog_text, image_links]
end

def create_pdf data
  Prawn::Document.generate(FILE) do
  font FONT_PATH
    data.each do |p|
      text p[0] 
      text p[1]
      p[2].each {|l| image open(l), scale: IMAGE_SCALE}
    end
  end
end

def crawl_blog_links base_url, direction
  blog_urls = Array.new
  
  range = nil
  if direction == "ASC"
    range = 1.upto(9)
  else
    range = 8.downto(1)
  end
  range.each do |page|

    this_page = base_url.gsub("PAGE", page.to_s)
    this_page.gsub!("SORT", direction)
    index_page = Nokogiri::HTML((open(this_page)))
    page_urls = index_page.css(".entry-title").collect do |blog_p_tag|
      blog_p_tag.children.first.attr("href")
    end
    #first one is always the latest
    page_urls.shift
    blog_urls << page_urls
  end
  return blog_urls.flatten
end

def get_first_10_blog_links url
  crawl_blog_links(url, "ASC")
end

def get_last_10_blog_links url
  crawl_blog_links(url, "DESC")
end

def get_blog_links url
  #ok... this is really dumb
  #The delos site has a bug where it only pays attention
  #to the last digit of the page number in the URL
  #ex: 6 = 6  16 = 6   1113426 = 6
  #Thankfully there are less than 20 pages, so we can just
  #flip the sort for now... this won't work forever
  #Gunna email Capt' Breeeyawn bout that one
  return [get_first_10_blog_links(url), get_last_10_blog_links(url)].flatten
end

if __FILE__ == $0 
  pages = get_blog_links(BASE_URL)

  page_data = pages.collect do |page|
    crawl_article(page)
  end

  create_pdf page_data
end
