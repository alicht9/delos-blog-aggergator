# Delos Blog Aggregator
Welcome!
## Premise
  Hi - I'm Adam, a long time member of the Delos Tribe. I, like many of you reading this have a dream of transitioning to a
full time cruising lifestyle. The idea for this was sparked by a vacation that I'm taking on a cruise (big ship... not cruiser)
across the Atlantic. Having a 6 day passage to the Azores from Florida, I was wanting to catch up on the Delos blog.

  Unfortunatly I suck at reading things on the computer or tablet. I'm old school and like things on paper. Thus this hacky script.
You'll have to excuse the terrible code here... at this point I've moved into being a chief meeting taker for the past 3 years or so and haven't really
coded in about that long.

So here's the result... A script which will pull all the text and images from each blog- minus [page 10](#what-about-page-10)  - and throws it in a PDF.
Why? Well I didn't want to print a bunch of stuff I didn't have to.

## Running this thing
  - You'll have to stick a ttf font in the directory (and change the constant if it's something different)
    - I would do this... but I'm late to get to the bar
  - You'll need to install `Nokogiri` and `Prawn`
    - `gem install $thing` will do nicely
    - you'll need ruby 2.1 or later for prawn

## What about page 10?
  Well, there's a bit of a bug on the Delos site. The page parameter in the URL only pays attention to the least signifigant digit.
  ex: `6 = 6` `16 = 6` `1232342426 = 6`
  I've shot Delos an email about this one and hacked around it for now by switching the sort order. But alas... pour one out for page 10
  
## What else?
  Don't know... late for the bar. Feel free to contributor whatever.
  
  Fair winds and following seas!
